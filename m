From: akpm@linux-foundation.org
Subject: + afs-convert-to-new-aops.patch added to -mm tree
Date: Thu, 02 Oct 2008 15:59:09 -0700
Message-ID: <200810022259.m92Mx9M5031046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753321AbYJBW74 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Oct 2008 18:59:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, dhowells@redhat.com


The patch titled
     afs: convert to new aops
has been added to the -mm tree.  Its filename is
     afs-convert-to-new-aops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: afs: convert to new aops
From: Nick Piggin <npiggin@suse.de>

Cannot assume writes will fully complete, so this conversion goes the easy
way and always brings the page uptodate before the write.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/file.c     |    4 -
 fs/afs/internal.h |    8 ++
 fs/afs/write.c    |  131 ++++++++++++++------------------------------
 3 files changed, 51 insertions(+), 92 deletions(-)

diff -puN fs/afs/file.c~afs-convert-to-new-aops fs/afs/file.c
--- a/fs/afs/file.c~afs-convert-to-new-aops
+++ a/fs/afs/file.c
@@ -50,8 +50,8 @@ const struct address_space_operations af
 	.launder_page	= afs_launder_page,
 	.releasepage	= afs_releasepage,
 	.invalidatepage	= afs_invalidatepage,
-	.prepare_write	= afs_prepare_write,
-	.commit_write	= afs_commit_write,
+	.write_begin	= afs_write_begin,
+	.write_end	= afs_write_end,
 	.writepage	= afs_writepage,
 	.writepages	= afs_writepages,
 };
diff -puN fs/afs/internal.h~afs-convert-to-new-aops fs/afs/internal.h
--- a/fs/afs/internal.h~afs-convert-to-new-aops
+++ a/fs/afs/internal.h
@@ -728,8 +728,12 @@ extern int afs_volume_release_fileserver
  */
 extern int afs_set_page_dirty(struct page *);
 extern void afs_put_writeback(struct afs_writeback *);
-extern int afs_prepare_write(struct file *, struct page *, unsigned, unsigned);
-extern int afs_commit_write(struct file *, struct page *, unsigned, unsigned);
+extern int afs_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata);
+extern int afs_write_end(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *page, void *fsdata);
 extern int afs_writepage(struct page *, struct writeback_control *);
 extern int afs_writepages(struct address_space *, struct writeback_control *);
 extern int afs_write_inode(struct inode *, int);
diff -puN fs/afs/write.c~afs-convert-to-new-aops fs/afs/write.c
--- a/fs/afs/write.c~afs-convert-to-new-aops
+++ a/fs/afs/write.c
@@ -84,15 +84,23 @@ void afs_put_writeback(struct afs_writeb
  * partly or wholly fill a page that's under preparation for writing
  */
 static int afs_fill_page(struct afs_vnode *vnode, struct key *key,
-			 unsigned start, unsigned len, struct page *page)
+			loff_t pos, unsigned len, struct page *page)
 {
+	loff_t i_size;
+	unsigned eof;
 	int ret;
 
-	_enter(",,%u,%u", start, len);
+	_enter(",,%llu,%u", (unsigned long long)pos, len);
 
-	ASSERTCMP(start + len, <=, PAGE_SIZE);
+	ASSERTCMP(len, <=, PAGE_CACHE_SIZE);
 
-	ret = afs_vnode_fetch_data(vnode, key, start, len, page);
+	i_size = i_size_read(&vnode->vfs_inode);
+	if (pos + len > i_size)
+		eof = i_size;
+	else
+		eof = PAGE_CACHE_SIZE;
+
+	ret = afs_vnode_fetch_data(vnode, key, 0, eof, page);
 	if (ret < 0) {
 		if (ret == -ENOENT) {
 			_debug("got NOENT from server"
@@ -107,109 +115,55 @@ static int afs_fill_page(struct afs_vnod
 }
 
 /*
- * prepare a page for being written to
- */
-static int afs_prepare_page(struct afs_vnode *vnode, struct page *page,
-			    struct key *key, unsigned offset, unsigned to)
-{
-	unsigned eof, tail, start, stop, len;
-	loff_t i_size, pos;
-	void *p;
-	int ret;
-
-	_enter("");
-
-	if (offset == 0 && to == PAGE_SIZE)
-		return 0;
-
-	p = kmap_atomic(page, KM_USER0);
-
-	i_size = i_size_read(&vnode->vfs_inode);
-	pos = (loff_t) page->index << PAGE_SHIFT;
-	if (pos >= i_size) {
-		/* partial write, page beyond EOF */
-		_debug("beyond");
-		if (offset > 0)
-			memset(p, 0, offset);
-		if (to < PAGE_SIZE)
-			memset(p + to, 0, PAGE_SIZE - to);
-		kunmap_atomic(p, KM_USER0);
-		return 0;
-	}
-
-	if (i_size - pos >= PAGE_SIZE) {
-		/* partial write, page entirely before EOF */
-		_debug("before");
-		tail = eof = PAGE_SIZE;
-	} else {
-		/* partial write, page overlaps EOF */
-		eof = i_size - pos;
-		_debug("overlap %u", eof);
-		tail = max(eof, to);
-		if (tail < PAGE_SIZE)
-			memset(p + tail, 0, PAGE_SIZE - tail);
-		if (offset > eof)
-			memset(p + eof, 0, PAGE_SIZE - eof);
-	}
-
-	kunmap_atomic(p, KM_USER0);
-
-	ret = 0;
-	if (offset > 0 || eof > to) {
-		/* need to fill one or two bits that aren't going to be written
-		 * (cover both fillers in one read if there are two) */
-		start = (offset > 0) ? 0 : to;
-		stop = (eof > to) ? eof : offset;
-		len = stop - start;
-		_debug("wr=%u-%u av=0-%u rd=%u@%u",
-		       offset, to, eof, start, len);
-		ret = afs_fill_page(vnode, key, start, len, page);
-	}
-
-	_leave(" = %d", ret);
-	return ret;
-}
-
-/*
  * prepare to perform part of a write to a page
- * - the caller holds the page locked, preventing it from being written out or
- *   modified by anyone else
  */
-int afs_prepare_write(struct file *file, struct page *page,
-		      unsigned offset, unsigned to)
+int afs_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
 {
+	struct page *page;
 	struct afs_writeback *candidate, *wb;
 	struct afs_vnode *vnode = AFS_FS_I(file->f_dentry->d_inode);
 	struct key *key = file->private_data;
-	pgoff_t index;
+	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
+	unsigned from = pos & (PAGE_CACHE_SIZE - 1);
+	unsigned to = from + len;
 	int ret;
 
 	_enter("{%x:%u},{%lx},%u,%u",
-	       vnode->fid.vid, vnode->fid.vnode, page->index, offset, to);
+	       vnode->fid.vid, vnode->fid.vnode, index, from, to);
 
 	candidate = kzalloc(sizeof(*candidate), GFP_KERNEL);
 	if (!candidate)
 		return -ENOMEM;
 	candidate->vnode = vnode;
-	candidate->first = candidate->last = page->index;
-	candidate->offset_first = offset;
+	candidate->first = candidate->last = index;
+	candidate->offset_first = from;
 	candidate->to_last = to;
 	candidate->usage = 1;
 	candidate->state = AFS_WBACK_PENDING;
 	init_waitqueue_head(&candidate->waitq);
 
+	page = __grab_cache_page(mapping, index);
+	if (!page) {
+		kfree(candidate);
+		return -ENOMEM;
+	}
+	*pagep = page;
+	/* page won't leak in error case: it eventually gets cleaned off LRU */
+
 	if (!PageUptodate(page)) {
 		_debug("not up to date");
-		ret = afs_prepare_page(vnode, page, key, offset, to);
+		ret = afs_fill_page(vnode, key, pos, len, page);
 		if (ret < 0) {
 			kfree(candidate);
 			_leave(" = %d [prep]", ret);
 			return ret;
 		}
+		SetPageUptodate(page);
 	}
 
 try_again:
-	index = page->index;
 	spin_lock(&vnode->writeback_lock);
 
 	/* see if this page is already pending a writeback under a suitable key
@@ -242,8 +196,8 @@ try_again:
 subsume_in_current_wb:
 	_debug("subsume");
 	ASSERTRANGE(wb->first, <=, index, <=, wb->last);
-	if (index == wb->first && offset < wb->offset_first)
-		wb->offset_first = offset;
+	if (index == wb->first && from < wb->offset_first)
+		wb->offset_first = from;
 	if (index == wb->last && to > wb->to_last)
 		wb->to_last = to;
 	spin_unlock(&vnode->writeback_lock);
@@ -289,17 +243,17 @@ flush_conflicting_wb:
 /*
  * finalise part of a write to a page
  */
-int afs_commit_write(struct file *file, struct page *page,
-		     unsigned offset, unsigned to)
+int afs_write_end(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *page, void *fsdata)
 {
 	struct afs_vnode *vnode = AFS_FS_I(file->f_dentry->d_inode);
 	loff_t i_size, maybe_i_size;
 
-	_enter("{%x:%u},{%lx},%u,%u",
-	       vnode->fid.vid, vnode->fid.vnode, page->index, offset, to);
+	_enter("{%x:%u},{%lx}",
+	       vnode->fid.vid, vnode->fid.vnode, page->index);
 
-	maybe_i_size = (loff_t) page->index << PAGE_SHIFT;
-	maybe_i_size += to;
+	maybe_i_size = pos + copied;
 
 	i_size = i_size_read(&vnode->vfs_inode);
 	if (maybe_i_size > i_size) {
@@ -310,12 +264,13 @@ int afs_commit_write(struct file *file, 
 		spin_unlock(&vnode->writeback_lock);
 	}
 
-	SetPageUptodate(page);
 	set_page_dirty(page);
 	if (PageDirty(page))
 		_debug("dirtied");
+	unlock_page(page);
+	page_cache_release(page);
 
-	return 0;
+	return copied;
 }
 
 /*
_

Patches currently in -mm which might be from npiggin@suse.de are

inotify-fix-lock-ordering-wrt-do_page_faults-mmap_sem.patch
mm-tiny-shmem-nommu-fix.patch
git-x86.patch
git-cifs.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmstat-mlocked-pages-statistics.patch
mm-pagecache-insertion-fewer-atomics.patch
mm-unlockless-reclaim.patch
mm-page-lock-use-lock-bitops.patch
fs-buffer-lock-use-lock-bitops.patch
mm-page-allocator-minor-speedup.patch
mm-rewrite-vmap-layer.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
afs-convert-to-new-aops.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

