From: akpm@linux-foundation.org
Subject: + jffs2-convert-to-new-aops.patch added to -mm tree
Date: Tue, 29 May 2007 14:20:42 -0700
Message-ID: <200705292120.l4TLKgk4011820@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:39175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193AbXE2VVT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:21:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, dwmw2@infradead.org


The patch titled
     jffs2: convert to new aops
has been added to the -mm tree.  Its filename is
     jffs2-convert-to-new-aops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: jffs2: convert to new aops
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/file.c |  105 ++++++++++++++++++++++++++++------------------
 1 files changed, 66 insertions(+), 39 deletions(-)

diff -puN fs/jffs2/file.c~jffs2-convert-to-new-aops fs/jffs2/file.c
--- a/fs/jffs2/file.c~jffs2-convert-to-new-aops
+++ a/fs/jffs2/file.c
@@ -19,10 +19,12 @@
 #include <linux/jffs2.h>
 #include "nodelist.h"
 
-static int jffs2_commit_write (struct file *filp, struct page *pg,
-			       unsigned start, unsigned end);
-static int jffs2_prepare_write (struct file *filp, struct page *pg,
-				unsigned start, unsigned end);
+static int jffs2_write_end(struct file *filp, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *pg, void *fsdata);
+static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata);
 static int jffs2_readpage (struct file *filp, struct page *pg);
 
 int jffs2_fsync(struct file *filp, struct dentry *dentry, int datasync)
@@ -65,8 +67,8 @@ const struct inode_operations jffs2_file
 const struct address_space_operations jffs2_file_address_operations =
 {
 	.readpage =	jffs2_readpage,
-	.prepare_write =jffs2_prepare_write,
-	.commit_write =	jffs2_commit_write
+	.write_begin =	jffs2_write_begin,
+	.write_end =	jffs2_write_end,
 };
 
 static int jffs2_do_readpage_nolock (struct inode *inode, struct page *pg)
@@ -119,15 +121,23 @@ static int jffs2_readpage (struct file *
 	return ret;
 }
 
-static int jffs2_prepare_write (struct file *filp, struct page *pg,
-				unsigned start, unsigned end)
+static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
 {
-	struct inode *inode = pg->mapping->host;
+	struct page *pg;
+	struct inode *inode = mapping->host;
 	struct jffs2_inode_info *f = JFFS2_INODE_INFO(inode);
-	uint32_t pageofs = pg->index << PAGE_CACHE_SHIFT;
+	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
+	uint32_t pageofs = pos & (PAGE_CACHE_SIZE - 1);
 	int ret = 0;
 
-	D1(printk(KERN_DEBUG "jffs2_prepare_write()\n"));
+	pg = __grab_cache_page(mapping, index);
+	if (!pg)
+		return -ENOMEM;
+	*pagep = pg;
+
+	D1(printk(KERN_DEBUG "jffs2_write_begin()\n"));
 
 	if (pageofs > inode->i_size) {
 		/* Make new hole frag from old EOF to new page */
@@ -142,7 +152,7 @@ static int jffs2_prepare_write (struct f
 		ret = jffs2_reserve_space(c, sizeof(ri), &alloc_len,
 					  ALLOC_NORMAL, JFFS2_SUMMARY_INODE_SIZE);
 		if (ret)
-			return ret;
+			goto out_page;
 
 		down(&f->sem);
 		memset(&ri, 0, sizeof(ri));
@@ -172,7 +182,7 @@ static int jffs2_prepare_write (struct f
 			ret = PTR_ERR(fn);
 			jffs2_complete_reservation(c);
 			up(&f->sem);
-			return ret;
+			goto out_page;
 		}
 		ret = jffs2_add_full_dnode_to_inode(c, f, fn);
 		if (f->metadata) {
@@ -181,65 +191,79 @@ static int jffs2_prepare_write (struct f
 			f->metadata = NULL;
 		}
 		if (ret) {
-			D1(printk(KERN_DEBUG "Eep. add_full_dnode_to_inode() failed in prepare_write, returned %d\n", ret));
+			D1(printk(KERN_DEBUG "Eep. add_full_dnode_to_inode() failed in write_begin, returned %d\n", ret));
 			jffs2_mark_node_obsolete(c, fn->raw);
 			jffs2_free_full_dnode(fn);
 			jffs2_complete_reservation(c);
 			up(&f->sem);
-			return ret;
+			goto out_page;
 		}
 		jffs2_complete_reservation(c);
 		inode->i_size = pageofs;
 		up(&f->sem);
 	}
 
-	/* Read in the page if it wasn't already present, unless it's a whole page */
-	if (!PageUptodate(pg) && (start || end < PAGE_CACHE_SIZE)) {
+	/*
+	 * Read in the page if it wasn't already present. Cannot optimize away
+	 * the whole page write case until jffs2_write_end can handle the
+	 * case of a short-copy.
+	 */
+	if (!PageUptodate(pg)) {
 		down(&f->sem);
 		ret = jffs2_do_readpage_nolock(inode, pg);
 		up(&f->sem);
+		if (ret)
+			goto out_page;
 	}
-	D1(printk(KERN_DEBUG "end prepare_write(). pg->flags %lx\n", pg->flags));
+	D1(printk(KERN_DEBUG "end write_begin(). pg->flags %lx\n", pg->flags));
+	return ret;
+
+out_page:
+	unlock_page(pg);
+	page_cache_release(pg);
 	return ret;
 }
 
-static int jffs2_commit_write (struct file *filp, struct page *pg,
-			       unsigned start, unsigned end)
+static int jffs2_write_end(struct file *filp, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *pg, void *fsdata)
 {
 	/* Actually commit the write from the page cache page we're looking at.
 	 * For now, we write the full page out each time. It sucks, but it's simple
 	 */
-	struct inode *inode = pg->mapping->host;
+	struct inode *inode = mapping->host;
 	struct jffs2_inode_info *f = JFFS2_INODE_INFO(inode);
 	struct jffs2_sb_info *c = JFFS2_SB_INFO(inode->i_sb);
 	struct jffs2_raw_inode *ri;
+	unsigned start = pos & (PAGE_CACHE_SIZE - 1);
+	unsigned end = start + copied;
 	unsigned aligned_start = start & ~3;
 	int ret = 0;
 	uint32_t writtenlen = 0;
 
-	D1(printk(KERN_DEBUG "jffs2_commit_write(): ino #%lu, page at 0x%lx, range %d-%d, flags %lx\n",
+	D1(printk(KERN_DEBUG "jffs2_write_end(): ino #%lu, page at 0x%lx, range %d-%d, flags %lx\n",
 		  inode->i_ino, pg->index << PAGE_CACHE_SHIFT, start, end, pg->flags));
 
+	/* We need to avoid deadlock with page_cache_read() in
+	   jffs2_garbage_collect_pass(). So the page must be
+	   up to date to prevent page_cache_read() from trying
+	   to re-lock it. */
+	BUG_ON(!PageUptodate(pg));
+
 	if (end == PAGE_CACHE_SIZE) {
-		if (!start) {
-			/* We need to avoid deadlock with page_cache_read() in
-			   jffs2_garbage_collect_pass(). So we have to mark the
-			   page up to date, to prevent page_cache_read() from
-			   trying to re-lock it. */
-			SetPageUptodate(pg);
-		} else {
-			/* When writing out the end of a page, write out the 
-			   _whole_ page. This helps to reduce the number of
-			   nodes in files which have many short writes, like
-			   syslog files. */
-			start = aligned_start = 0;
-		}
+		/* When writing out the end of a page, write out the
+		   _whole_ page. This helps to reduce the number of
+		   nodes in files which have many short writes, like
+		   syslog files. */
+		start = aligned_start = 0;
 	}
 
 	ri = jffs2_alloc_raw_inode();
 
 	if (!ri) {
-		D1(printk(KERN_DEBUG "jffs2_commit_write(): Allocation of raw inode failed\n"));
+		D1(printk(KERN_DEBUG "jffs2_write_end(): Allocation of raw inode failed\n"));
+		unlock_page(pg);
+		page_cache_release(pg);
 		return -ENOMEM;
 	}
 
@@ -287,11 +311,14 @@ static int jffs2_commit_write (struct fi
 		/* generic_file_write has written more to the page cache than we've
 		   actually written to the medium. Mark the page !Uptodate so that
 		   it gets reread */
-		D1(printk(KERN_DEBUG "jffs2_commit_write(): Not all bytes written. Marking page !uptodate\n"));
+		D1(printk(KERN_DEBUG "jffs2_write_end(): Not all bytes written. Marking page !uptodate\n"));
 		SetPageError(pg);
 		ClearPageUptodate(pg);
 	}
 
-	D1(printk(KERN_DEBUG "jffs2_commit_write() returning %d\n",start+writtenlen==end?0:ret));
-	return start+writtenlen==end?0:ret;
+	D1(printk(KERN_DEBUG "jffs2_write_end() returning %d\n",
+					writtenlen > 0 ? writtenlen : ret));
+	unlock_page(pg);
+	page_cache_release(pg);
+	return writtenlen > 0 ? writtenlen : ret;
 }
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
git-arm-master.patch
slob-rework-freelist-handling.patch
slob-remove-bigblock-tracking.patch
slob-improved-alignment-handling.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch
revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch
mm-clean-up-buffered-write-code.patch
mm-debug-write-deadlocks.patch
mm-trim-more-holes.patch
mm-buffered-write-cleanup.patch
mm-write-iovec-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
mm-buffered-write-iterator.patch
fs-fix-data-loss-on-error.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
mm-restore-kernel_ds-optimisations.patch
implement-simple-fs-aops.patch
block_dev-convert-to-new-aops.patch
ext2-convert-to-new-aops.patch
ext3-convert-to-new-aops.patch
ext4-convert-to-new-aops.patch
xfs-convert-to-new-aops.patch
fs-new-cont-helpers.patch
fat-convert-to-new-aops.patch
hfs-convert-to-new-aops.patch
hfsplus-convert-to-new-aops.patch
hpfs-convert-to-new-aops.patch
bfs-convert-to-new-aops.patch
qnx4-convert-to-new-aops.patch
reiserfs-use-generic-write.patch
reiserfs-convert-to-new-aops.patch
reiserfs-use-generic_cont_expand_simple.patch
with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch
nfs-convert-to-new-aops.patch
smb-convert-to-new-aops.patch
fuse-convert-to-new-aops.patch
hostfs-convert-to-new-aops.patch
jffs2-convert-to-new-aops.patch
ufs-convert-to-new-aops.patch
udf-convert-to-new-aops.patch
sysv-convert-to-new-aops.patch
minix-convert-to-new-aops.patch
jfs-convert-to-new-aops.patch
mm-document-fault_data-and-flags.patch
fs-introduce-some-page-buffer-invariants.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
