From: akpm@linux-foundation.org
Subject: - afs-implement-shared-writable-mmap.patch removed from -mm tree
Date: Fri, 24 Aug 2007 20:21:55 -0700
Message-ID: <200708250321.l7P3Lt1D027900@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42095 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752288AbXHYDWH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 23:22:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     AFS: implement shared-writable mmap
has been removed from the -mm tree.  Its filename was
     afs-implement-shared-writable-mmap.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: AFS: implement shared-writable mmap
From: David Howells <dhowells@redhat.com>

Implement shared-writable mmap for AFS.

The key with which to access the file is obtained from the VMA at the point
where the PTE is made writable by the page_mkwrite() VMA op and cached in the
affected page.

If there's an outstanding write on the page made with a different key, then
page_mkwrite() will flush it before attaching a record of the new key.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/file.c     |   22 ++++++++++++++++++++--
 fs/afs/internal.h |    1 +
 fs/afs/write.c    |   28 ++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+), 2 deletions(-)

diff -puN fs/afs/file.c~afs-implement-shared-writable-mmap fs/afs/file.c
--- a/fs/afs/file.c~afs-implement-shared-writable-mmap
+++ a/fs/afs/file.c
@@ -22,6 +22,7 @@ static int afs_readpage(struct file *fil
 static void afs_invalidatepage(struct page *page, unsigned long offset);
 static int afs_releasepage(struct page *page, gfp_t gfp_flags);
 static int afs_launder_page(struct page *page);
+static int afs_mmap(struct file *file, struct vm_area_struct *vma);
 
 const struct file_operations afs_file_operations = {
 	.open		= afs_open,
@@ -31,7 +32,7 @@ const struct file_operations afs_file_op
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= afs_file_write,
-	.mmap		= generic_file_readonly_mmap,
+	.mmap		= afs_mmap,
 	.sendfile	= generic_file_sendfile,
 	.fsync		= afs_fsync,
 };
@@ -54,6 +55,12 @@ const struct address_space_operations af
 	.writepages	= afs_writepages,
 };
 
+static struct vm_operations_struct afs_file_vm_ops = {
+	.nopage		= filemap_nopage,
+	.populate	= filemap_populate,
+	.page_mkwrite	= afs_page_mkwrite,
+};
+
 /*
  * open an AFS file or directory and attach a key to it
  */
@@ -266,7 +273,6 @@ static void afs_invalidatepage(struct pa
 static int afs_launder_page(struct page *page)
 {
 	_enter("{%lu}", page->index);
-
 	return 0;
 }
 
@@ -293,3 +299,15 @@ static int afs_releasepage(struct page *
 	_leave(" = 0");
 	return 0;
 }
+
+/*
+ * memory map part of an AFS file
+ */
+static int afs_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	_enter("");
+
+	file_accessed(file);
+	vma->vm_ops = &afs_file_vm_ops;
+	return 0;
+}
diff -puN fs/afs/internal.h~afs-implement-shared-writable-mmap fs/afs/internal.h
--- a/fs/afs/internal.h~afs-implement-shared-writable-mmap
+++ a/fs/afs/internal.h
@@ -709,6 +709,7 @@ extern ssize_t afs_file_write(struct kio
 			      unsigned long, loff_t);
 extern int afs_writeback_all(struct afs_vnode *);
 extern int afs_fsync(struct file *, struct dentry *, int);
+extern int afs_page_mkwrite(struct vm_area_struct *, struct page *);
 
 
 /*****************************************************************************/
diff -puN fs/afs/write.c~afs-implement-shared-writable-mmap fs/afs/write.c
--- a/fs/afs/write.c~afs-implement-shared-writable-mmap
+++ a/fs/afs/write.c
@@ -174,6 +174,8 @@ static int afs_prepare_page(struct afs_v
  * prepare to perform part of a write to a page
  * - the caller holds the page locked, preventing it from being written out or
  *   modified by anyone else
+ * - may be called from afs_page_mkwrite() to set up a page for modification
+ *   through shared-writable mmap
  */
 int afs_prepare_write(struct file *file, struct page *page,
 		      unsigned offset, unsigned to)
@@ -825,3 +827,29 @@ int afs_fsync(struct file *file, struct 
 	_leave(" = %d", ret);
 	return ret;
 }
+
+/*
+ * notification that a previously read-only page is about to become writable
+ * - if it returns an error, the caller will deliver a bus error signal
+ *
+ * we use this to make a record of the key with which the writeback should be
+ * performed and to flush any outstanding writes made with a different key
+ *
+ * the key to be used is attached to the file pinned by the VMA
+ */
+int afs_page_mkwrite(struct vm_area_struct *vma, struct page *page)
+{
+	struct afs_vnode *vnode = AFS_FS_I(vma->vm_file->f_mapping->host);
+	struct key *key = vma->vm_file->private_data;
+	int ret;
+
+	_enter("{{%x:%u},%x},{%lx}",
+	       vnode->fid.vid, vnode->fid.vnode, key_serial(key), page->index);
+
+	lock_page(page);
+	ret = afs_prepare_write(vma->vm_file, page, 0, 0);
+	unlock_page(page);
+
+	_leave(" = %d", ret);
+	return ret;
+}
_

Patches currently in -mm which might be from dhowells@redhat.com are

nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
remove-frv-usage-of-flush_tlb_pgtables.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
fs-afs-possible-cleanups.patch
binfmt_flat-warning-fixes.patch
ecryptfs-add-key-list-structure-search-keyring.patch
64-bit-i_version-afs-fixes.patch
mutex-subsystem-synchro-test-module.patch
