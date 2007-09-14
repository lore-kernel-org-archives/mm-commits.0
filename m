From: akpm@linux-foundation.org
Subject: + try-to-reap-reiserfs-pages-left-around-by-invalidatepage.patch added to -mm tree
Date: Fri, 14 Sep 2007 15:03:00 -0700
Message-ID: <200709142203.l8EM30T4026519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46321 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753193AbXINWEP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 18:04:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chris.mason@oracle.com, jeffm@suse.com, vs@namesys.com


The patch titled
     try to reap reiserfs pages left around by invalidatepage
has been added to the -mm tree.  Its filename is
     try-to-reap-reiserfs-pages-left-around-by-invalidatepage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: try to reap reiserfs pages left around by invalidatepage
From: Chris Mason <chris.mason@oracle.com>

reiserfs_invalidatepage will refuse to free pages if they have been logged
in data=journal mode, or were pinned down by a data=ordered operation.  For
data=journal, this is fairly easy to trigger just with fsx-linux, and it
results in a large number of pages hanging around on the LRUs with
page->mapping == NULL.

Calling try_to_free_buffers when reiserfs decides it is done with the page
allows it to be freed earlier, and with much less VM thrashing.  Lock
ordering rules mean that reiserfs can't call lock_page when it is releasing
the buffers, so TestSetPageLocked is used instead.  Contention on these
pages should be rare, so it should be sufficient most of the time.

Signed-off-by: Chris Mason <chris.mason@oracle.com>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/journal.c |   42 ++++++++++++++++++++++++++++++----------
 1 files changed, 32 insertions(+), 10 deletions(-)

diff -puN fs/reiserfs/journal.c~try-to-reap-reiserfs-pages-left-around-by-invalidatepage fs/reiserfs/journal.c
--- a/fs/reiserfs/journal.c~try-to-reap-reiserfs-pages-left-around-by-invalidatepage
+++ a/fs/reiserfs/journal.c
@@ -615,6 +615,31 @@ static int journal_list_still_alive(stru
 	return 0;
 }
 
+/*
+ * If page->mapping was null, we failed to truncate this page for
+ * some reason.  Most likely because it was truncated after being
+ * logged via data=journal.
+ *
+ * This does a check to see if the buffer belongs to one of these
+ * lost pages before doing the final put_bh.  If page->mapping was
+ * null, it tries to free buffers on the page, which should make the
+ * final page_cache_release drop the page from the lru.
+ */
+static void release_buffer_page(struct buffer_head *bh)
+{
+	struct page *page = bh->b_page;
+	if (!page->mapping && !TestSetPageLocked(page)) {
+		page_cache_get(page);
+		put_bh(bh);
+		if (!page->mapping)
+			try_to_free_buffers(page);
+		unlock_page(page);
+		page_cache_release(page);
+	} else {
+		put_bh(bh);
+	}
+}
+
 static void reiserfs_end_buffer_io_sync(struct buffer_head *bh, int uptodate)
 {
 	char b[BDEVNAME_SIZE];
@@ -628,8 +653,9 @@ static void reiserfs_end_buffer_io_sync(
 		set_buffer_uptodate(bh);
 	else
 		clear_buffer_uptodate(bh);
+
 	unlock_buffer(bh);
-	put_bh(bh);
+	release_buffer_page(bh);
 }
 
 static void reiserfs_end_ordered_io(struct buffer_head *bh, int uptodate)
@@ -1546,9 +1572,10 @@ static int flush_journal_list(struct sup
 				BUG_ON(!test_clear_buffer_journal_dirty
 				       (cn->bh));
 
-				/* undo the inc from journal_mark_dirty */
+				/* drop one ref for us */
 				put_bh(cn->bh);
-				brelse(cn->bh);
+				/* drop one ref for journal_mark_dirty */
+				release_buffer_page(cn->bh);
 			}
 			cn = cn->next;
 		}
@@ -3708,13 +3735,8 @@ int journal_mark_freed(struct reiserfs_t
 		}
 	}
 
-	if (bh) {
-		put_bh(bh);	/* get_hash grabs the buffer */
-		if (atomic_read(&(bh->b_count)) < 0) {
-			reiserfs_warning(p_s_sb,
-					 "journal-2165: bh->b_count < 0");
-		}
-	}
+	if (bh)
+		release_buffer_page(bh); /* get_hash grabs the buffer */
 	return 0;
 }
 
_

Patches currently in -mm which might be from chris.mason@oracle.com are

try-to-reap-reiserfs-pages-left-around-by-invalidatepage.patch
