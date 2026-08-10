Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0013B6370
	for <mm-commits@vger.kernel.org>; Mon, 10 Aug 2026 22:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786402482; cv=none; b=PUtCbwDwxIxKLsbvx/eRasNBG99RpIyINHOSDYhZ/uWGHjR/nkCkH9BafKLv3drHN2qv8VOg2wfp/zdN39tXcuhgRo2hulJ0PByRfvVPYASl419ZVMDWeMrZ2h1FziQC92s+pJ7mQu12cZ/SyTTiyJjkZr+F8j/EgK+zV4yUPb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786402482; c=relaxed/simple;
	bh=r9pkmzJGWV/IKGfqbD2WB/uGvxP4kqCSk+4bzxqtySo=;
	h=Date:To:From:Subject:Message-Id; b=t4VNLlNlgqUdL9SxewKeb6TPdaO2iOkbeE6ukdoxKML8jzSRXXnUK2oJcuopzZLihXmhwzTcZdsP+QUwOAAJqySAs36CPqcNkijKAab3y5h3Q5FLaCh+oF7Hbk39JG5O4vxG+hfX7626+JJi5bl5lXfRwVY61lqMn94UhWamdi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dfpzQ/Y3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dfpzQ/Y3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE041F000E9;
	Mon, 10 Aug 2026 22:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786402480;
	bh=oDzzNjKCfnNT+XTnQhsXyqUM3uFNYWpZ+QWsNimmFkA=;
	h=Date:To:From:Subject;
	b=dfpzQ/Y3B87M3elg1wueoI0j9Gf8inP54p15uoAOZvMohrZNEan9CoJc8K0KdpUcx
	 VIHxEYBXCuwAyulG82XvHbAi+9cYwgwUOnfycTl7vtNIbQ/lc+XY+JZZ7DQK8Jutpd
	 blrTQUUkS0sXXuLWMDY5vkcHPyVe3tdDbZcCjaa4=
Date: Mon, 10 Aug 2026 15:54:39 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,shikemeng@huaweicloud.com,sfrench@samba.org,ryncsn@gmail.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-move-swap_ops-into-file-systems-for-file-system-based-swap.patch added to mm-new branch
Message-Id: <20260810225440.5BE041F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: move swap_ops into file systems for file system-based swap
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-move-swap_ops-into-file-systems-for-file-system-based-swap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-move-swap_ops-into-file-systems-for-file-system-based-swap.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm/swap: move swap_ops into file systems for file system-based swap
Date: Thu, 23 Jul 2026 07:46:06 +0200

Currently swap to and from file systems goes through two indirect calls
between the swap ops and the swap_rw method.  Reduce this by directly
providing the swap_ops from the file system.

For this refactor swap_fs_submit into a swap_fs_prepare_rw helper that
initializes the iov_iter on the callers stack so that file systems can
call it directly, and use that to initialize file system specific ops in
the NFS and SMB clients, which then get passed to swap_fs_activate.

Link: https://lore.kernel.org/20260723054622.3460249-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Steve French <sfrench@samba.org>
Cc: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/locking.rst |    9 ---
 Documentation/filesystems/vfs.rst     |    8 ---
 fs/nfs/direct.c                       |   20 -------
 fs/nfs/file.c                         |   42 ++++++++++++++--
 fs/smb/client/file.c                  |   63 ++++++++++++++----------
 include/linux/fs.h                    |    1 
 include/linux/nfs_fs.h                |    1 
 include/linux/swap.h                  |    6 --
 include/linux/swap_ops.h              |    5 +
 mm/page_io.c                          |   34 ++----------
 10 files changed, 93 insertions(+), 96 deletions(-)

--- a/Documentation/filesystems/locking.rst~mm-swap-move-swap_ops-into-file-systems-for-file-system-based-swap
+++ a/Documentation/filesystems/locking.rst
@@ -266,7 +266,6 @@ prototypes::
 	int (*error_remove_folio)(struct address_space *, struct folio *);
 	int (*swap_activate)(struct swap_info_struct *sis, struct file *f, sector_t *span)
 	int (*swap_deactivate)(struct file *);
-	int (*swap_rw)(struct kiocb *iocb, struct iov_iter *iter);
 
 locking rules:
 	All except dirty_folio and free_folio may block
@@ -291,7 +290,6 @@ is_partially_uptodate:	yes
 error_remove_folio:	yes
 swap_activate:		no
 swap_deactivate:	no
-swap_rw:		yes, unlocks
 ======================	======================== =========	===============
 
 ->write_begin(), ->write_end() and ->read_folio() may be called from
@@ -355,15 +353,12 @@ should perform any validation and prepar
 writes can be performed with minimal memory allocation.  It should call
 add_swap_extent(), or the helper iomap_swapfile_activate(), and return
 the number of extents added.  If IO should be submitted through
-->swap_rw(), it should call swap_fs_activate, otherwise IO will be submitted
-directly to the block device ``sis->bdev``.
+the file system it should call swap_fs_activate, otherwise IO will be
+submitted directly to the block device ``sis->bdev``.
 
 ->swap_deactivate() will be called in the sys_swapoff()
 path after ->swap_activate() returned success.
 
-->swap_rw will be called for swap IO if swap_fs_activate was called by
-->swap_activate().
-
 file_lock_operations
 ====================
 
--- a/Documentation/filesystems/vfs.rst~mm-swap-move-swap_ops-into-file-systems-for-file-system-based-swap
+++ a/Documentation/filesystems/vfs.rst
@@ -776,7 +776,6 @@ cache in your filesystem.  The following
 		int (*error_remove_folio)(struct mapping *mapping, struct folio *);
 		int (*swap_activate)(struct swap_info_struct *sis, struct file *f, sector_t *span)
 		int (*swap_deactivate)(struct file *);
-		int (*swap_rw)(struct kiocb *iocb, struct iov_iter *iter);
 	};
 
 ``read_folio``
@@ -977,16 +976,13 @@ cache in your filesystem.  The following
 	can be performed with minimal memory allocation.  It should call
 	add_swap_extent(), or the helper iomap_swapfile_activate(), and
 	return the number of extents added.  If IO should be submitted
-	through ->swap_rw(), it should call swap_fs_activate, otherwise IO will
-	be submitted directly to the block device ``sis->bdev``.
+	through the file system it should call swap_fs_activate, otherwise IO
+	will be submitted directly to the block device ``sis->bdev``.
 
 ``swap_deactivate``
 	Called during swapoff on files where swap_activate was
 	successful.
 
-``swap_rw``
-	Called to read or write swap pages when swap_fs_activate was called.
-
 The File Object
 ===============
 
--- a/fs/nfs/direct.c~mm-swap-move-swap_ops-into-file-systems-for-file-system-based-swap
+++ a/fs/nfs/direct.c
@@ -145,26 +145,6 @@ static void nfs_direct_file_adjust_size_
 	}
 }
 
-/**
- * nfs_swap_rw - NFS address space operation for swap I/O
- * @iocb: target I/O control block
- * @iter: I/O buffer
- *
- * Perform IO to the swap-file.  This is much like direct IO.
- */
-int nfs_swap_rw(struct kiocb *iocb, struct iov_iter *iter)
-{
-	ssize_t ret;
-
-	if (iov_iter_rw(iter) == READ)
-		ret = nfs_file_direct_read(iocb, iter, true);
-	else
-		ret = nfs_file_direct_write(iocb, iter, true);
-	if (ret < 0)
-		return ret;
-	return 0;
-}
-
 static void nfs_direct_release_pages(struct page **pages, unsigned int npages)
 {
 	unsigned int i;
--- a/fs/nfs/file.c~mm-swap-move-swap_ops-into-file-systems-for-file-system-based-swap
+++ a/fs/nfs/file.c
@@ -29,9 +29,8 @@
 #include <linux/pagemap.h>
 #include <linux/gfp.h>
 #include <linux/rmap.h>
-#include <linux/swap.h>
 #include <linux/compaction.h>
-
+#include <linux/swap_ops.h>
 #include <linux/uaccess.h>
 #include <linux/filelock.h>
 
@@ -575,6 +574,38 @@ static int nfs_launder_folio(struct foli
 	return ret;
 }
 
+#ifdef CONFIG_SWAP
+static void nfs_swap_submit_write(struct swap_io_ctx *ctx)
+{
+	struct swap_iocb *sio = ctx->sio;
+	struct iov_iter iter;
+	int ret;
+
+	swap_fs_prepare_rw(ctx, WRITE, &iter);
+	ret = nfs_file_direct_write(&sio->iocb, &iter, true);
+	if (ret != -EIOCBQUEUED)
+		sio->iocb.ki_complete(&sio->iocb, ret);
+}
+
+static void nfs_swap_submit_read(struct swap_io_ctx *ctx)
+{
+	struct swap_iocb *sio = ctx->sio;
+	struct iov_iter iter;
+	int ret;
+
+	swap_fs_prepare_rw(ctx, READ, &iter);
+	ret = nfs_file_direct_read(&sio->iocb, &iter, true);
+	if (ret != -EIOCBQUEUED)
+		sio->iocb.ki_complete(&sio->iocb, ret);
+}
+
+static const struct swap_ops nfs_swap_ops = {
+	.flags			= SWAP_OPS_F_REQUIRE_NOFS,
+	.submit_write		= nfs_swap_submit_write,
+	.submit_read		= nfs_swap_submit_read,
+	.can_merge		= swap_fs_can_merge,
+};
+
 static int nfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 						sector_t *span)
 {
@@ -597,7 +628,7 @@ static int nfs_swap_activate(struct swap
 	ret = rpc_clnt_swap_activate(clnt);
 	if (ret)
 		return ret;
-	ret = swap_fs_activate(sis);
+	ret = swap_fs_activate(sis, &nfs_swap_ops);
 	if (ret < 0) {
 		rpc_clnt_swap_deactivate(clnt);
 		return ret;
@@ -620,6 +651,10 @@ static void nfs_swap_deactivate(struct f
 	if (cl->rpc_ops->disable_swap)
 		cl->rpc_ops->disable_swap(file_inode(file));
 }
+#else
+#define nfs_swap_activate	NULL
+#define nfs_swap_deactivate	NULL
+#endif /* CONFIG_SWAP */
 
 const struct address_space_operations nfs_file_aops = {
 	.read_folio = nfs_read_folio,
@@ -636,7 +671,6 @@ const struct address_space_operations nf
 	.error_remove_folio = generic_error_remove_folio,
 	.swap_activate = nfs_swap_activate,
 	.swap_deactivate = nfs_swap_deactivate,
-	.swap_rw = nfs_swap_rw,
 };
 
 /*
--- a/fs/smb/client/file.c~mm-swap-move-swap_ops-into-file-systems-for-file-system-based-swap
+++ a/fs/smb/client/file.c
@@ -20,7 +20,7 @@
 #include <linux/delay.h>
 #include <linux/mount.h>
 #include <linux/slab.h>
-#include <linux/swap.h>
+#include <linux/swap_ops.h>
 #include <linux/mm.h>
 #include <asm/div64.h>
 #include "cifsfs.h"
@@ -3410,6 +3410,38 @@ out:
 	cifs_done_oplock_break(cinode);
 }
 
+#ifdef CONFIG_SWAP
+static void cifs_swap_submit_write(struct swap_io_ctx *ctx)
+{
+	struct swap_iocb *sio = ctx->sio;
+	struct iov_iter iter;
+	int ret;
+
+	swap_fs_prepare_rw(ctx, WRITE, &iter);
+	ret = netfs_unbuffered_write_iter_locked(&sio->iocb, &iter, NULL);
+	if (ret != -EIOCBQUEUED)
+		sio->iocb.ki_complete(&sio->iocb, ret);
+}
+
+static void cifs_swap_submit_read(struct swap_io_ctx *ctx)
+{
+	struct swap_iocb *sio = ctx->sio;
+	struct iov_iter iter;
+	int ret;
+
+	swap_fs_prepare_rw(ctx, READ, &iter);
+	ret = netfs_unbuffered_read_iter_locked(&sio->iocb, &iter);
+	if (ret != -EIOCBQUEUED)
+		sio->iocb.ki_complete(&sio->iocb, ret);
+}
+
+static const struct swap_ops cifs_swap_ops = {
+	.flags			= SWAP_OPS_F_REQUIRE_NOFS,
+	.submit_write		= cifs_swap_submit_write,
+	.submit_read		= cifs_swap_submit_read,
+	.can_merge		= swap_fs_can_merge,
+};
+
 static int cifs_swap_activate(struct swap_info_struct *sis,
 			      struct file *swap_file, sector_t *span)
 {
@@ -3420,7 +3452,7 @@ static int cifs_swap_activate(struct swa
 
 	cifs_dbg(FYI, "swap activate\n");
 
-	if (!swap_file->f_mapping->a_ops->swap_rw)
+	if (swap_file->f_mapping->a_ops != &cifs_addr_ops)
 		/* Cannot support swap */
 		return -EINVAL;
 
@@ -3451,7 +3483,7 @@ static int cifs_swap_activate(struct swa
 	 * but we could add call to grab a byte range lock to prevent others
 	 * from reading or writing the file
 	 */
-	return swap_fs_activate(sis);
+	return swap_fs_activate(sis, &cifs_swap_ops);
 }
 
 static void cifs_swap_deactivate(struct file *file)
@@ -3467,26 +3499,10 @@ static void cifs_swap_deactivate(struct
 
 	/* do we need to unpin (or unlock) the file */
 }
-
-/**
- * cifs_swap_rw - SMB3 address space operation for swap I/O
- * @iocb: target I/O control block
- * @iter: I/O buffer
- *
- * Perform IO to the swap-file.  This is much like direct IO.
- */
-static int cifs_swap_rw(struct kiocb *iocb, struct iov_iter *iter)
-{
-	ssize_t ret;
-
-	if (iov_iter_rw(iter) == READ)
-		ret = netfs_unbuffered_read_iter_locked(iocb, iter);
-	else
-		ret = netfs_unbuffered_write_iter_locked(iocb, iter, NULL);
-	if (ret < 0)
-		return ret;
-	return 0;
-}
+#else
+#define cifs_swap_activate	NULL
+#define cifs_swap_deactivate	NULL
+#endif /* CONFIG_SWAP */
 
 const struct address_space_operations cifs_addr_ops = {
 	.read_folio	= netfs_read_folio,
@@ -3503,7 +3519,6 @@ const struct address_space_operations ci
 	 */
 	.swap_activate	= cifs_swap_activate,
 	.swap_deactivate = cifs_swap_deactivate,
-	.swap_rw = cifs_swap_rw,
 };
 
 /*
--- a/include/linux/fs.h~mm-swap-move-swap_ops-into-file-systems-for-file-system-based-swap
+++ a/include/linux/fs.h
@@ -438,7 +438,6 @@ struct address_space_operations {
 	int (*swap_activate)(struct swap_info_struct *sis, struct file *file,
 				sector_t *span);
 	void (*swap_deactivate)(struct file *file);
-	int (*swap_rw)(struct kiocb *iocb, struct iov_iter *iter);
 };
 
 extern const struct address_space_operations empty_aops;
--- a/include/linux/nfs_fs.h~mm-swap-move-swap_ops-into-file-systems-for-file-system-based-swap
+++ a/include/linux/nfs_fs.h
@@ -548,7 +548,6 @@ static inline const struct cred *nfs_fil
 /*
  * linux/fs/nfs/direct.c
  */
-int nfs_swap_rw(struct kiocb *iocb, struct iov_iter *iter);
 ssize_t nfs_file_direct_read(struct kiocb *iocb,
 			     struct iov_iter *iter, bool swap);
 ssize_t nfs_file_direct_write(struct kiocb *iocb,
--- a/include/linux/swap.h~mm-swap-move-swap_ops-into-file-systems-for-file-system-based-swap
+++ a/include/linux/swap.h
@@ -341,8 +341,6 @@ extern void __meminit kswapd_run(int nid
 extern void __meminit kswapd_stop(int nid);
 
 #ifdef CONFIG_SWAP
-
-int swap_fs_activate(struct swap_info_struct *sis);
 int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
 		unsigned long nr_pages, sector_t start_block);
 int generic_swapfile_activate(struct swap_info_struct *, struct file *,
@@ -468,10 +466,6 @@ static inline bool folio_free_swap(struc
 	return false;
 }
 
-static inline int swap_fs_activate(struct swap_info_struct *sis)
-{
-	return -EINVAL;
-}
 static inline int add_swap_extent(struct swap_info_struct *sis,
 				  unsigned long start_page,
 				  unsigned long nr_pages, sector_t start_block)
--- a/include/linux/swap_ops.h~mm-swap-move-swap_ops-into-file-systems-for-file-system-based-swap
+++ a/include/linux/swap_ops.h
@@ -36,4 +36,9 @@ struct swap_ops {
 	void (*submit_read)(struct swap_io_ctx *ctx);
 };
 
+void swap_fs_prepare_rw(struct swap_io_ctx *ctx, int rw, struct iov_iter *iter);
+bool swap_fs_can_merge(struct folio *folio, struct folio *prev_folio,
+		size_t prev_folio_size, int rw);
+int swap_fs_activate(struct swap_info_struct *sis, const struct swap_ops *ops);
+
 #endif /* _MM_SWAP_OPS_H */
--- a/mm/page_io.c~mm-swap-move-swap_ops-into-file-systems-for-file-system-based-swap
+++ a/mm/page_io.c
@@ -650,11 +650,9 @@ const struct swap_ops swap_bdev_ops = {
 	.can_merge		= swap_bdev_can_merge,
 };
 
-static void swap_fs_submit(struct swap_io_ctx *ctx, int rw)
+void swap_fs_prepare_rw(struct swap_io_ctx *ctx, int rw, struct iov_iter *iter)
 {
 	struct swap_iocb *sio = ctx->sio;
-	struct iov_iter iter;
-	int ret;
 
 	init_sync_kiocb(&sio->iocb, ctx->sis->swap_file);
 	sio->iocb.ki_pos = swap_dev_pos(bvec_folio(&sio->bvecs[0])->swap);
@@ -663,40 +661,22 @@ static void swap_fs_submit(struct swap_i
 	else
 		sio->iocb.ki_complete = swap_fs_read_complete;
 
-	iov_iter_bvec(&iter, rw == WRITE ? ITER_SOURCE : ITER_DEST,
+	iov_iter_bvec(iter, rw == WRITE ? ITER_SOURCE : ITER_DEST,
 			sio->bvecs, sio->nr_bvecs, sio->len);
-	ret = sio->iocb.ki_filp->f_mapping->a_ops->swap_rw(&sio->iocb, &iter);
-	if (ret != -EIOCBQUEUED)
-		sio->iocb.ki_complete(&sio->iocb, ret);
 }
+EXPORT_SYMBOL_GPL(swap_fs_prepare_rw);
 
-static void swap_fs_submit_write(struct swap_io_ctx *ctx)
-{
-	swap_fs_submit(ctx, WRITE);
-}
-
-static void swap_fs_submit_read(struct swap_io_ctx *ctx)
-{
-	swap_fs_submit(ctx, READ);
-}
-
-static bool swap_fs_can_merge(struct folio *folio, struct folio *prev_folio,
+bool swap_fs_can_merge(struct folio *folio, struct folio *prev_folio,
 		size_t prev_folio_size, int rw)
 {
 	return swap_dev_pos(folio->swap) ==
 		swap_dev_pos(prev_folio->swap) + prev_folio_size;
 }
+EXPORT_SYMBOL_GPL(swap_fs_can_merge);
 
-static const struct swap_ops swap_fs_ops = {
-	.flags			= SWAP_OPS_F_REQUIRE_NOFS,
-	.submit_write		= swap_fs_submit_write,
-	.submit_read		= swap_fs_submit_read,
-	.can_merge		= swap_fs_can_merge,
-};
-
-int swap_fs_activate(struct swap_info_struct *sis)
+int swap_fs_activate(struct swap_info_struct *sis, const struct swap_ops *ops)
 {
-	sis->ops = &swap_fs_ops;
+	sis->ops = ops;
 	return add_swap_extent(sis, 0, sis->max, 0);
 }
 EXPORT_SYMBOL_GPL(swap_fs_activate);
_

Patches currently in -mm which might be from hch@lst.de are

shmem-provide-a-shmem_write_folio-wrapper.patch
mm-swap-introduce-struct-swap_io_ctx.patch
mm-swap-also-use-struct-swap_iocb-for-block-i-o.patch
mm-swap-remove-count_swpout_vm_event.patch
mm-swap-use-swap_ops-to-register-swap-devices-methods.patch
mm-swap-remove-swp_fs_ops.patch
mm-vmstat-add-nrswpinout-counters.patch
mm-swap-revert-to-single-folio-writes-for-synchronous-swap-devices.patch
mm-swap-add-a-new-swap_opsh-header-to-allow-for-pluggable-swap-ops.patch
mm-swap-move-swap_ops-into-file-systems-for-file-system-based-swap.patch

