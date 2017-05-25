From: akpm@linux-foundation.org
Subject: + mm-drop-wait-parameter-from-write_one_page.patch added to -mm
 tree
Date: Thu, 25 May 2017 16:10:55 -0700
Message-ID: <5927647f.jDMsFN1+Foc3JYoA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46822 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163136AbdEYXK4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2017 19:10:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, hch@lst.de, jack@suse.cz, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop "wait" parameter from write_one_page()
has been added to the -mm tree.  Its filename is
     mm-drop-wait-parameter-from-write_one_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-drop-wait-parameter-from-write_one_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-drop-wait-parameter-from-write_one_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jeff Layton <jlayton@redhat.com>
Subject: mm: drop "wait" parameter from write_one_page()

The callers all set it to 1.

Also, make it clear that this function will not set any sort of AS_*
error, and that the caller must do so if necessary.  No existing caller
uses this on normal files, so none of them need it.

Also, add __must_check here since, in general, the callers need to handle
an error here in some fashion.

Link: http://lkml.kernel.org/r/20170525103303.6524-1-jlayton@redhat.com
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Matthew Wilcox <mawilcox@microsoft.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exofs/dir.c        |    2 +-
 fs/ext2/dir.c         |    2 +-
 fs/jfs/jfs_metapage.c |    4 ++--
 fs/minix/dir.c        |    2 +-
 fs/sysv/dir.c         |    2 +-
 fs/ufs/dir.c          |    2 +-
 include/linux/mm.h    |    2 +-
 mm/page-writeback.c   |   14 +++++++-------
 8 files changed, 15 insertions(+), 15 deletions(-)

diff -puN fs/exofs/dir.c~mm-drop-wait-parameter-from-write_one_page fs/exofs/dir.c
--- a/fs/exofs/dir.c~mm-drop-wait-parameter-from-write_one_page
+++ a/fs/exofs/dir.c
@@ -72,7 +72,7 @@ static int exofs_commit_chunk(struct pag
 	set_page_dirty(page);
 
 	if (IS_DIRSYNC(dir))
-		err = write_one_page(page, 1);
+		err = write_one_page(page);
 	else
 		unlock_page(page);
 
diff -puN fs/ext2/dir.c~mm-drop-wait-parameter-from-write_one_page fs/ext2/dir.c
--- a/fs/ext2/dir.c~mm-drop-wait-parameter-from-write_one_page
+++ a/fs/ext2/dir.c
@@ -100,7 +100,7 @@ static int ext2_commit_chunk(struct page
 	}
 
 	if (IS_DIRSYNC(dir)) {
-		err = write_one_page(page, 1);
+		err = write_one_page(page);
 		if (!err)
 			err = sync_inode_metadata(dir, 1);
 	} else {
diff -puN fs/jfs/jfs_metapage.c~mm-drop-wait-parameter-from-write_one_page fs/jfs/jfs_metapage.c
--- a/fs/jfs/jfs_metapage.c~mm-drop-wait-parameter-from-write_one_page
+++ a/fs/jfs/jfs_metapage.c
@@ -711,7 +711,7 @@ void force_metapage(struct metapage *mp)
 	get_page(page);
 	lock_page(page);
 	set_page_dirty(page);
-	write_one_page(page, 1);
+	write_one_page(page);
 	clear_bit(META_forcewrite, &mp->flag);
 	put_page(page);
 }
@@ -756,7 +756,7 @@ void release_metapage(struct metapage *
 		set_page_dirty(page);
 		if (test_bit(META_sync, &mp->flag)) {
 			clear_bit(META_sync, &mp->flag);
-			write_one_page(page, 1);
+			write_one_page(page);
 			lock_page(page); /* write_one_page unlocks the page */
 		}
 	} else if (mp->lsn)	/* discard_metapage doesn't remove it */
diff -puN fs/minix/dir.c~mm-drop-wait-parameter-from-write_one_page fs/minix/dir.c
--- a/fs/minix/dir.c~mm-drop-wait-parameter-from-write_one_page
+++ a/fs/minix/dir.c
@@ -57,7 +57,7 @@ static int dir_commit_chunk(struct page
 		mark_inode_dirty(dir);
 	}
 	if (IS_DIRSYNC(dir))
-		err = write_one_page(page, 1);
+		err = write_one_page(page);
 	else
 		unlock_page(page);
 	return err;
diff -puN fs/sysv/dir.c~mm-drop-wait-parameter-from-write_one_page fs/sysv/dir.c
--- a/fs/sysv/dir.c~mm-drop-wait-parameter-from-write_one_page
+++ a/fs/sysv/dir.c
@@ -45,7 +45,7 @@ static int dir_commit_chunk(struct page
 		mark_inode_dirty(dir);
 	}
 	if (IS_DIRSYNC(dir))
-		err = write_one_page(page, 1);
+		err = write_one_page(page);
 	else
 		unlock_page(page);
 	return err;
diff -puN fs/ufs/dir.c~mm-drop-wait-parameter-from-write_one_page fs/ufs/dir.c
--- a/fs/ufs/dir.c~mm-drop-wait-parameter-from-write_one_page
+++ a/fs/ufs/dir.c
@@ -53,7 +53,7 @@ static int ufs_commit_chunk(struct page
 		mark_inode_dirty(dir);
 	}
 	if (IS_DIRSYNC(dir))
-		err = write_one_page(page, 1);
+		err = write_one_page(page);
 	else
 		unlock_page(page);
 	return err;
diff -puN include/linux/mm.h~mm-drop-wait-parameter-from-write_one_page include/linux/mm.h
--- a/include/linux/mm.h~mm-drop-wait-parameter-from-write_one_page
+++ a/include/linux/mm.h
@@ -2199,7 +2199,7 @@ extern void filemap_map_pages(struct vm_
 extern int filemap_page_mkwrite(struct vm_fault *vmf);
 
 /* mm/page-writeback.c */
-int write_one_page(struct page *page, int wait);
+int __must_check write_one_page(struct page *page);
 void task_dirty_inc(struct task_struct *tsk);
 
 /* readahead.c */
diff -puN mm/page-writeback.c~mm-drop-wait-parameter-from-write_one_page mm/page-writeback.c
--- a/mm/page-writeback.c~mm-drop-wait-parameter-from-write_one_page
+++ a/mm/page-writeback.c
@@ -2366,15 +2366,16 @@ int do_writepages(struct address_space *
 }
 
 /**
- * write_one_page - write out a single page and optionally wait on I/O
+ * write_one_page - write out a single page and wait on I/O
  * @page: the page to write
- * @wait: if true, wait on writeout
  *
  * The page must be locked by the caller and will be unlocked upon return.
  *
- * write_one_page() returns a negative error code if I/O failed.
+ * write_one_page() returns a negative error code if I/O failed. Note that
+ * the address_space is not marked for error. The caller must do this if
+ * needed.
  */
-int write_one_page(struct page *page, int wait)
+int write_one_page(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
 	int ret = 0;
@@ -2385,13 +2386,12 @@ int write_one_page(struct page *page, in
 
 	BUG_ON(!PageLocked(page));
 
-	if (wait)
-		wait_on_page_writeback(page);
+	wait_on_page_writeback(page);
 
 	if (clear_page_dirty_for_io(page)) {
 		get_page(page);
 		ret = mapping->a_ops->writepage(page, &wbc);
-		if (ret == 0 && wait) {
+		if (ret == 0) {
 			wait_on_page_writeback(page);
 			if (PageError(page))
 				ret = -EIO;
_

Patches currently in -mm which might be from jlayton@redhat.com are

mm-drop-wait-parameter-from-write_one_page.patch

