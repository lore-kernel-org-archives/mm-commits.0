From: akpm@linux-foundation.org
Subject: [merged] shm-wait-for-pins-to-be-released-when-sealing.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:43:39 -0700
Message-ID: <53ea6e6b.s1QiNPqCUVCytVw5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:45070 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015AbaHLTnk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:43:40 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so1921282obb.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:43:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dh.herrmann@gmail.com, desrt@desrt.ca, hughd@google.com, lennart@poettering.net, luto@amacapital.net, mtk.manpages@gmail.com, zonque@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: shm: wait for pins to be released when sealing
has been removed from the -mm tree.  Its filename was
     shm-wait-for-pins-to-be-released-when-sealing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Herrmann <dh.herrmann@gmail.com>
Subject: shm: wait for pins to be released when sealing

If we set SEAL_WRITE on a file, we must make sure there cannot be any
ongoing write-operations on the file.  For write() calls, we simply lock
the inode mutex, for mmap() we simply verify there're no writable
mappings.  However, there might be pages pinned by AIO, Direct-IO and
similar operations via GUP.  We must make sure those do not write to the
memfd file after we set SEAL_WRITE.

As there is no way to notify GUP users to drop pages or to wait for them
to be done, we implement the wait ourself: When setting SEAL_WRITE, we
check all pages for their ref-count.  If it's bigger than 1, we know
there's some user of the page.  We then mark the page and wait for up to
150ms for those ref-counts to be dropped.  If the ref-counts are not
dropped in time, we refuse the seal operation.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Ryan Lortie <desrt@desrt.ca>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Daniel Mack <zonque@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |  110 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 109 insertions(+), 1 deletion(-)

diff -puN mm/shmem.c~shm-wait-for-pins-to-be-released-when-sealing mm/shmem.c
--- a/mm/shmem.c~shm-wait-for-pins-to-be-released-when-sealing
+++ a/mm/shmem.c
@@ -1828,9 +1828,117 @@ static loff_t shmem_file_llseek(struct f
 	return offset;
 }
 
+/*
+ * We need a tag: a new tag would expand every radix_tree_node by 8 bytes,
+ * so reuse a tag which we firmly believe is never set or cleared on shmem.
+ */
+#define SHMEM_TAG_PINNED        PAGECACHE_TAG_TOWRITE
+#define LAST_SCAN               4       /* about 150ms max */
+
+static void shmem_tag_pins(struct address_space *mapping)
+{
+	struct radix_tree_iter iter;
+	void **slot;
+	pgoff_t start;
+	struct page *page;
+
+	lru_add_drain();
+	start = 0;
+	rcu_read_lock();
+
+restart:
+	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, start) {
+		page = radix_tree_deref_slot(slot);
+		if (!page || radix_tree_exception(page)) {
+			if (radix_tree_deref_retry(page))
+				goto restart;
+		} else if (page_count(page) - page_mapcount(page) > 1) {
+			spin_lock_irq(&mapping->tree_lock);
+			radix_tree_tag_set(&mapping->page_tree, iter.index,
+					   SHMEM_TAG_PINNED);
+			spin_unlock_irq(&mapping->tree_lock);
+		}
+
+		if (need_resched()) {
+			cond_resched_rcu();
+			start = iter.index + 1;
+			goto restart;
+		}
+	}
+	rcu_read_unlock();
+}
+
+/*
+ * Setting SEAL_WRITE requires us to verify there's no pending writer. However,
+ * via get_user_pages(), drivers might have some pending I/O without any active
+ * user-space mappings (eg., direct-IO, AIO). Therefore, we look at all pages
+ * and see whether it has an elevated ref-count. If so, we tag them and wait for
+ * them to be dropped.
+ * The caller must guarantee that no new user will acquire writable references
+ * to those pages to avoid races.
+ */
 static int shmem_wait_for_pins(struct address_space *mapping)
 {
-	return 0;
+	struct radix_tree_iter iter;
+	void **slot;
+	pgoff_t start;
+	struct page *page;
+	int error, scan;
+
+	shmem_tag_pins(mapping);
+
+	error = 0;
+	for (scan = 0; scan <= LAST_SCAN; scan++) {
+		if (!radix_tree_tagged(&mapping->page_tree, SHMEM_TAG_PINNED))
+			break;
+
+		if (!scan)
+			lru_add_drain_all();
+		else if (schedule_timeout_killable((HZ << scan) / 200))
+			scan = LAST_SCAN;
+
+		start = 0;
+		rcu_read_lock();
+restart:
+		radix_tree_for_each_tagged(slot, &mapping->page_tree, &iter,
+					   start, SHMEM_TAG_PINNED) {
+
+			page = radix_tree_deref_slot(slot);
+			if (radix_tree_exception(page)) {
+				if (radix_tree_deref_retry(page))
+					goto restart;
+
+				page = NULL;
+			}
+
+			if (page &&
+			    page_count(page) - page_mapcount(page) != 1) {
+				if (scan < LAST_SCAN)
+					goto continue_resched;
+
+				/*
+				 * On the last scan, we clean up all those tags
+				 * we inserted; but make a note that we still
+				 * found pages pinned.
+				 */
+				error = -EBUSY;
+			}
+
+			spin_lock_irq(&mapping->tree_lock);
+			radix_tree_tag_clear(&mapping->page_tree,
+					     iter.index, SHMEM_TAG_PINNED);
+			spin_unlock_irq(&mapping->tree_lock);
+continue_resched:
+			if (need_resched()) {
+				cond_resched_rcu();
+				start = iter.index + 1;
+				goto restart;
+			}
+		}
+		rcu_read_unlock();
+	}
+
+	return error;
 }
 
 #define F_ALL_SEALS (F_SEAL_SEAL | \
_

Patches currently in -mm which might be from dh.herrmann@gmail.com are

origin.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch

