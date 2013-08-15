From: akpm@linux-foundation.org
Subject: + writeback-fix-occasional-slow-sync1.patch added to -mm tree
Date: Thu, 15 Aug 2013 15:15:42 -0700
Message-ID: <520d530e.25hCu4A4RwX2LO7d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43326 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3HOWPo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Aug 2013 18:15:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, taysom@chromium.org, fengguang.wu@intel.com, jack@suse.cz

Subject: + writeback-fix-occasional-slow-sync1.patch added to -mm tree
To: jack@suse.cz,fengguang.wu@intel.com,taysom@chromium.org
From: akpm@linux-foundation.org
Date: Thu, 15 Aug 2013 15:15:42 -0700


The patch titled
     Subject: writeback: fix occasional slow sync(1)
has been added to the -mm tree.  Its filename is
     writeback-fix-occasional-slow-sync1.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/writeback-fix-occasional-slow-sync1.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/writeback-fix-occasional-slow-sync1.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: writeback: fix occasional slow sync(1)

In case when system contains no dirty pages, wakeup_flusher_threads() will
submit WB_SYNC_NONE writeback for 0 pages so wb_writeback() exits
immediately without doing anything, even though there are dirty inodes in
the system.  Thus sync(1) will write all the dirty inodes from a
WB_SYNC_ALL writeback pass which is slow.

Fix the problem by using get_nr_dirty_pages() in wakeup_flusher_threads()
instead of calculating number of dirty pages manually.  That function also
takes number of dirty inodes into account.

Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Paul Taysom <taysom@chromium.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/fs-writeback.c~writeback-fix-occasional-slow-sync1 fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-fix-occasional-slow-sync1
+++ a/fs/fs-writeback.c
@@ -1049,10 +1049,8 @@ void wakeup_flusher_threads(long nr_page
 {
 	struct backing_dev_info *bdi;
 
-	if (!nr_pages) {
-		nr_pages = global_page_state(NR_FILE_DIRTY) +
-				global_page_state(NR_UNSTABLE_NFS);
-	}
+	if (!nr_pages)
+		nr_pages = get_nr_dirty_pages();
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list) {
_

Patches currently in -mm which might be from jack@suse.cz are

thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch
mm-cleanup-add_to_page_cache_locked.patch
thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
thp-do_huge_pmd_anonymous_page-cleanup.patch
thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch
writeback-fix-occasional-slow-sync1.patch
lib-radix-treec-make-radix_tree_node_alloc-work-correctly-within-interrupt.patch
linux-next.patch
fs-bump-inode-and-dentry-counters-to-long.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
list_lru-dynamically-adjust-node-arrays.patch

