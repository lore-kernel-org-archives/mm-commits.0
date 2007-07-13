From: akpm@linux-foundation.org
Subject: + coda-remove-struct-coda_sb_info.patch added to -mm tree
Date: Thu, 12 Jul 2007 22:29:44 -0700
Message-ID: <200707130529.l6D5TiRZ030826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51265 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751994AbXGMFi0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 01:38:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaharkes@cs.cmu.edu


The patch titled
     coda: remove struct coda_sb_info
has been added to the -mm tree.  Its filename is
     coda-remove-struct-coda_sb_info.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: coda: remove struct coda_sb_info
From: Jan Harkes <jaharkes@cs.cmu.edu>

The sb_info structure only contains a single pointer to the character device,
there is no need for the added indirection.

Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/cache.c            |    5 --
 fs/coda/inode.c            |   32 +++-----------
 fs/coda/upcall.c           |   79 ++++++++++++++++-------------------
 include/linux/coda_psdev.h |    9 ---
 4 files changed, 49 insertions(+), 76 deletions(-)

diff -puN fs/coda/cache.c~coda-remove-struct-coda_sb_info fs/coda/cache.c
--- a/fs/coda/cache.c~coda-remove-struct-coda_sb_info
+++ a/fs/coda/cache.c
@@ -49,11 +49,6 @@ void coda_cache_clear_inode(struct inode
 /* remove all acl caches */
 void coda_cache_clear_all(struct super_block *sb)
 {
-        struct coda_sb_info *sbi;
-
-        sbi = coda_sbp(sb);
-	BUG_ON(!sbi);
-
 	atomic_inc(&permission_epoch);
 }
 
diff -puN fs/coda/inode.c~coda-remove-struct-coda_sb_info fs/coda/inode.c
--- a/fs/coda/inode.c~coda-remove-struct-coda_sb_info
+++ a/fs/coda/inode.c
@@ -141,11 +141,10 @@ static int get_device_index(struct coda_
 
 static int coda_fill_super(struct super_block *sb, void *data, int silent)
 {
-        struct inode *root = NULL; 
-	struct coda_sb_info *sbi = NULL;
+	struct inode *root = NULL;
 	struct venus_comm *vc = NULL;
 	struct CodaFid fid;
-        int error;
+	int error;
 	int idx;
 
 	idx = get_device_index((struct coda_mount_data *) data);
@@ -167,16 +166,9 @@ static int coda_fill_super(struct super_
 		return -EBUSY;
 	}
 
-	sbi = kmalloc(sizeof(struct coda_sb_info), GFP_KERNEL);
-	if(!sbi) {
-		return -ENOMEM;
-	}
-
 	vc->vc_sb = sb;
 
-	sbi->sbi_vcomm = vc;
-
-	sb->s_fs_info = sbi;
+	sb->s_fs_info = vc;
 	sb->s_flags |= MS_NOATIME;
 	sb->s_blocksize = 4096;	/* XXXXX  what do we put here?? */
 	sb->s_blocksize_bits = 12;
@@ -207,26 +199,20 @@ static int coda_fill_super(struct super_
         return 0;
 
  error:
-	if (sbi) {
-		kfree(sbi);
-		if(vc)
-			vc->vc_sb = NULL;		
-	}
 	if (root)
-                iput(root);
+		iput(root);
+	if (vc)
+		vc->vc_sb = NULL;
 
-        return -EINVAL;
+	return -EINVAL;
 }
 
 static void coda_put_super(struct super_block *sb)
 {
-        struct coda_sb_info *sbi;
-
-	sbi = coda_sbp(sb);
-	sbi->sbi_vcomm->vc_sb = NULL;
+	coda_vcp(sb)->vc_sb = NULL;
+	sb->s_fs_info = NULL;
 
 	printk("Coda: Bye bye.\n");
-	kfree(sbi);
 }
 
 static void coda_clear_inode(struct inode *inode)
diff -puN fs/coda/upcall.c~coda-remove-struct-coda_sb_info fs/coda/upcall.c
--- a/fs/coda/upcall.c~coda-remove-struct-coda_sb_info
+++ a/fs/coda/upcall.c
@@ -37,7 +37,7 @@
 #include <linux/coda_cache.h>
 #include <linux/coda_proc.h> 
 
-static int coda_upcall(struct coda_sb_info *mntinfo, int inSize, int *outSize, 
+static int coda_upcall(struct venus_comm *vc, int inSize, int *outSize,
 		       union inputArgs *buffer);
 
 static void *alloc_upcall(int opcode, int size)
@@ -83,7 +83,7 @@ int venus_rootfid(struct super_block *sb
         insize = SIZE(root);
         UPARG(CODA_ROOT);
 
-	error = coda_upcall(coda_sbp(sb), insize, &outsize, inp);
+	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
 	if (!error)
 		*fidp = outp->coda_root.VFid;
 
@@ -102,7 +102,7 @@ int venus_getattr(struct super_block *sb
 	UPARG(CODA_GETATTR);
         inp->coda_getattr.VFid = *fid;
 
-	error = coda_upcall(coda_sbp(sb), insize, &outsize, inp);
+	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
 	if (!error)
 		*attr = outp->coda_getattr.attr;
 
@@ -123,7 +123,7 @@ int venus_setattr(struct super_block *sb
         inp->coda_setattr.VFid = *fid;
 	inp->coda_setattr.attr = *vattr;
 
-        error = coda_upcall(coda_sbp(sb), insize, &outsize, inp);
+	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
 
         CODA_FREE(inp, insize);
         return error;
@@ -149,7 +149,7 @@ int venus_lookup(struct super_block *sb,
         memcpy((char *)(inp) + offset, name, length);
         *((char *)inp + offset + length) = '\0';
 
-	error = coda_upcall(coda_sbp(sb), insize, &outsize, inp);
+	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
 	if (!error) {
 		*resfid = outp->coda_lookup.VFid;
 		*type = outp->coda_lookup.vtype;
@@ -182,7 +182,7 @@ int venus_store(struct super_block *sb, 
         inp->coda_store.VFid = *fid;
         inp->coda_store.flags = flags;
 
-        error = coda_upcall(coda_sbp(sb), insize, &outsize, inp);
+	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
 
 	CODA_FREE(inp, insize);
         return error;
@@ -200,7 +200,7 @@ int venus_release(struct super_block *sb
 	inp->coda_release.VFid = *fid;
 	inp->coda_release.flags = flags;
 
-	error = coda_upcall(coda_sbp(sb), insize, &outsize, inp);
+	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
 
 	CODA_FREE(inp, insize);
 	return error;
@@ -229,7 +229,7 @@ int venus_close(struct super_block *sb, 
         inp->coda_close.VFid = *fid;
         inp->coda_close.flags = flags;
 
-        error = coda_upcall(coda_sbp(sb), insize, &outsize, inp);
+	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
 
 	CODA_FREE(inp, insize);
         return error;
@@ -248,7 +248,7 @@ int venus_open(struct super_block *sb, s
 	inp->coda_open_by_fd.VFid = *fid;
 	inp->coda_open_by_fd.flags = flags;
 
-	error = coda_upcall(coda_sbp(sb), insize, &outsize, inp);
+	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
 	if (!error)
 		*fh = outp->coda_open_by_fd.fh;
 
@@ -276,7 +276,7 @@ int venus_mkdir(struct super_block *sb, 
         memcpy((char *)(inp) + offset, name, length);
         *((char *)inp + offset + length) = '\0';
 
-	error = coda_upcall(coda_sbp(sb), insize, &outsize, inp);
+	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
 	if (!error) {
 		*attrs = outp->coda_mkdir.attr;
 		*newfid = outp->coda_mkdir.VFid;
@@ -318,7 +318,7 @@ int venus_rename(struct super_block *sb,
         memcpy((char *)(inp) + offset, new_name, new_length);
         *((char *)inp + offset + new_length) = '\0';
 
-        error = coda_upcall(coda_sbp(sb), insize, &outsize, inp);
+	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
 
 	CODA_FREE(inp, insize);
 	return error;
@@ -347,7 +347,7 @@ int venus_create(struct super_block *sb,
         memcpy((char *)(inp) + offset, name, length);
         *((char *)inp + offset + length) = '\0';
 
-	error = coda_upcall(coda_sbp(sb), insize, &outsize, inp);
+	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
 	if (!error) {
 		*attrs = outp->coda_create.attr;
 		*newfid = outp->coda_create.VFid;
@@ -373,8 +373,8 @@ int venus_rmdir(struct super_block *sb, 
         inp->coda_rmdir.name = offset;
         memcpy((char *)(inp) + offset, name, length);
 	*((char *)inp + offset + length) = '\0';
-        
-        error = coda_upcall(coda_sbp(sb), insize, &outsize, inp);
+
+	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
 
 	CODA_FREE(inp, insize);
 	return error;
@@ -395,8 +395,8 @@ int venus_remove(struct super_block *sb,
         inp->coda_remove.name = offset;
         memcpy((char *)(inp) + offset, name, length);
 	*((char *)inp + offset + length) = '\0';
-        
-        error = coda_upcall(coda_sbp(sb), insize, &outsize, inp);
+
+	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
 
 	CODA_FREE(inp, insize);
 	return error;
@@ -417,7 +417,7 @@ int venus_readlink(struct super_block *s
 
         inp->coda_readlink.VFid = *fid;
 
-	error = coda_upcall(coda_sbp(sb), insize, &outsize, inp);
+	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
 	if (!error) {
 		retlen = outp->coda_readlink.count;
 		if ( retlen > *length )
@@ -453,8 +453,8 @@ int venus_link(struct super_block *sb, s
         /* make sure strings are null terminated */
         memcpy((char *)(inp) + offset, name, len);
         *((char *)inp + offset + len) = '\0';
-        
-        error = coda_upcall(coda_sbp(sb), insize, &outsize, inp);
+
+	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
 
 	CODA_FREE(inp, insize);
         return error;
@@ -489,7 +489,7 @@ int venus_symlink(struct super_block *sb
         memcpy((char *)(inp) + offset, name, len);
         *((char *)inp + offset + len) = '\0';
 
-	error = coda_upcall(coda_sbp(sb), insize, &outsize, inp);
+	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
 
 	CODA_FREE(inp, insize);
         return error;
@@ -504,9 +504,9 @@ int venus_fsync(struct super_block *sb, 
 	insize=SIZE(fsync);
 	UPARG(CODA_FSYNC);
 
-        inp->coda_fsync.VFid = *fid;
-        error = coda_upcall(coda_sbp(sb), sizeof(union inputArgs), 
-                            &outsize, inp);
+	inp->coda_fsync.VFid = *fid;
+	error = coda_upcall(coda_vcp(sb), sizeof(union inputArgs),
+			    &outsize, inp);
 
 	CODA_FREE(inp, insize);
 	return error;
@@ -524,7 +524,7 @@ int venus_access(struct super_block *sb,
         inp->coda_access.VFid = *fid;
         inp->coda_access.flags = mask;
 
-	error = coda_upcall(coda_sbp(sb), insize, &outsize, inp);
+	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
 
 	CODA_FREE(inp, insize);
 	return error;
@@ -573,9 +573,9 @@ int venus_pioctl(struct super_block *sb,
 	        goto exit;
 	}
 
-        error = coda_upcall(coda_sbp(sb), SIZE(ioctl) + data->vi.in_size,
-                            &outsize, inp);
-        
+	error = coda_upcall(coda_vcp(sb), SIZE(ioctl) + data->vi.in_size,
+			    &outsize, inp);
+
         if (error) {
 	        printk("coda_pioctl: Venus returns: %d for %s\n", 
 		       error, coda_f2s(fid));
@@ -615,7 +615,7 @@ int venus_statfs(struct dentry *dentry, 
 	insize = max_t(unsigned int, INSIZE(statfs), OUTSIZE(statfs));
 	UPARG(CODA_STATFS);
 
-	error = coda_upcall(coda_sbp(dentry->d_sb), insize, &outsize, inp);
+	error = coda_upcall(coda_vcp(dentry->d_sb), insize, &outsize, inp);
 	if (!error) {
 		sfs->f_blocks = outp->coda_statfs.stat.f_blocks;
 		sfs->f_bfree  = outp->coda_statfs.stat.f_bfree;
@@ -710,28 +710,25 @@ static inline void coda_waitfor_upcall(s
 }
 
 
-/* 
- * coda_upcall will return an error in the case of 
+/*
+ * coda_upcall will return an error in the case of
  * failed communication with Venus _or_ will peek at Venus
  * reply and return Venus' error.
  *
  * As venus has 2 types of errors, normal errors (positive) and internal
  * errors (negative), normal errors are negated, while internal errors
  * are all mapped to -EINTR, while showing a nice warning message. (jh)
- * 
  */
-static int coda_upcall(struct coda_sb_info *sbi,
+static int coda_upcall(struct venus_comm *vcp,
 		       int inSize, int *outSize,
 		       union inputArgs *buffer)
 {
-	struct venus_comm *vcommp;
 	union outputArgs *out;
 	union inputArgs *sig_inputArgs;
 	struct upc_req *req, *sig_req;
 	int error = 0;
 
-	vcommp = sbi->sbi_vcomm;
-	if (!vcommp->vc_inuse) {
+	if (!vcp->vc_inuse) {
 		printk(KERN_NOTICE "coda: Venus dead, not sending upcall\n");
 		return -ENXIO;
 	}
@@ -746,16 +743,16 @@ static int coda_upcall(struct coda_sb_in
 	req->uc_inSize = inSize;
 	req->uc_outSize = *outSize ? *outSize : inSize;
 	req->uc_opcode = ((union inputArgs *)buffer)->ih.opcode;
-	req->uc_unique = ++vcommp->vc_seq;
+	req->uc_unique = ++vcp->vc_seq;
 	init_waitqueue_head(&req->uc_sleep);
 
 	/* Fill in the common input args. */
 	((union inputArgs *)buffer)->ih.unique = req->uc_unique;
 
 	/* Append msg to pending queue and poke Venus. */
-	list_add_tail(&req->uc_chain, &vcommp->vc_pending);
+	list_add_tail(&req->uc_chain, &vcp->vc_pending);
 
-	wake_up_interruptible(&vcommp->vc_waitq);
+	wake_up_interruptible(&vcp->vc_waitq);
 	/* We can be interrupted while we wait for Venus to process
 	 * our request.  If the interrupt occurs before Venus has read
 	 * the request, we dequeue and return. If it occurs after the
@@ -788,7 +785,7 @@ static int coda_upcall(struct coda_sb_in
 		goto exit;
 
 	/* Venus saw the upcall, make sure we can send interrupt signal */
-	if (!vcommp->vc_inuse) {
+	if (!vcp->vc_inuse) {
 		printk(KERN_INFO "coda: Venus dead, not sending signal.\n");
 		goto exit;
 	}
@@ -815,8 +812,8 @@ static int coda_upcall(struct coda_sb_in
 	sig_req->uc_outSize = sizeof(struct coda_in_hdr);
 
 	/* insert at head of queue! */
-	list_add(&(sig_req->uc_chain), &vcommp->vc_pending);
-	wake_up_interruptible(&vcommp->vc_waitq);
+	list_add(&(sig_req->uc_chain), &vcp->vc_pending);
+	wake_up_interruptible(&vcp->vc_waitq);
 
 exit:
 	kfree(req);
diff -puN include/linux/coda_psdev.h~coda-remove-struct-coda_sb_info include/linux/coda_psdev.h
--- a/include/linux/coda_psdev.h~coda-remove-struct-coda_sb_info
+++ a/include/linux/coda_psdev.h
@@ -8,11 +8,6 @@
 
 struct kstatfs;
 
-struct coda_sb_info
-{
-	struct venus_comm *sbi_vcomm;
-};
-
 /* communication pending/processing queues */
 struct venus_comm {
 	u_long		    vc_seq;
@@ -24,9 +19,9 @@ struct venus_comm {
 };
 
 
-static inline struct coda_sb_info *coda_sbp(struct super_block *sb)
+static inline struct venus_comm *coda_vcp(struct super_block *sb)
 {
-    return ((struct coda_sb_info *)((sb)->s_fs_info));
+	return (struct venus_comm *)((sb)->s_fs_info);
 }
 
 
_

Patches currently in -mm which might be from jaharkes@cs.cmu.edu are

coda-do-not-grab-an-uninitialized-fd-when-the-open-upcall-returns-an-error.patch
coda-correctly-invalidate-cached-access-rights.patch
coda-fix-nlink-updates-for-directories.patch
coda-allow-removal-of-busy-directories.patch
coda-coda-doesnt-track-atime.patch
coda-use-ilookup5.patch
coda-cleanup-dev-cfs-open-and-close-handling.patch
coda-cleanup-for-upcall-handling-path.patch
coda-block-signals-during-upcall-processing.patch
coda-avoid-lockdep-warning-in-coda_readdir.patch
coda-replace-upc_alloc-upc_free-with-kmalloc-kfree.patch
coda-ignore-returned-values-when-upcalls-return-errors.patch
coda-cleanup-coda_lookup-use-dsplice_alias.patch
coda-cleanup-downcall-handler.patch
coda-remove-struct-coda_sb_info.patch
coda-remove-statistics-counters-from-proc-fs-coda.patch
coda-update-module-information.patch
