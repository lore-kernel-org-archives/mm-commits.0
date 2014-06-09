From: akpm@linux-foundation.org
Subject: [merged] fs-coda-replace-printk-by-pr_foo.patch removed from -mm
 tree
Date: Mon, 09 Jun 2014 12:31:22 -0700
Message-ID: <53960b8a.hFxny7QQKUnLrdgR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaFITbX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:31:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, jaharkes@cs.cmu.edu, fabf@skynet.be

Subject: [merged] fs-coda-replace-printk-by-pr_foo.patch removed from -mm tree
To: fabf@skynet.be,jaharkes@cs.cmu.edu,joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:31:22 -0700


The patch titled
     Subject: fs/coda: replace printk by pr_foo()
has been removed from the -mm tree.  Its filename was
     fs-coda-replace-printk-by-pr_foo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/coda: replace printk by pr_foo()

No level printk converted to pr_warn or pr_info

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/cnode.c      |    4 ++--
 fs/coda/coda_linux.h |    2 +-
 fs/coda/dir.c        |   12 ++++++------
 fs/coda/inode.c      |   29 +++++++++++++++--------------
 fs/coda/psdev.c      |   34 +++++++++++++++++-----------------
 fs/coda/upcall.c     |   14 +++++++-------
 6 files changed, 48 insertions(+), 47 deletions(-)

diff -puN fs/coda/cnode.c~fs-coda-replace-printk-by-pr_foo fs/coda/cnode.c
--- a/fs/coda/cnode.c~fs-coda-replace-printk-by-pr_foo
+++ a/fs/coda/cnode.c
@@ -101,7 +101,7 @@ struct inode *coda_cnode_make(struct Cod
 
 	inode = coda_iget(sb, fid, &attr);
 	if (IS_ERR(inode))
-		printk("coda_cnode_make: coda_iget failed\n");
+		pr_warn("coda_cnode_make: coda_iget failed\n");
 	return inode;
 }
 
@@ -137,7 +137,7 @@ struct inode *coda_fid_to_inode(struct C
 	unsigned long hash = coda_f2i(fid);
 
 	if ( !sb ) {
-		printk("coda_fid_to_inode: no sb!\n");
+		pr_warn("coda_fid_to_inode: no sb!\n");
 		return NULL;
 	}
 
diff -puN fs/coda/coda_linux.h~fs-coda-replace-printk-by-pr_foo fs/coda/coda_linux.h
--- a/fs/coda/coda_linux.h~fs-coda-replace-printk-by-pr_foo
+++ a/fs/coda/coda_linux.h
@@ -63,7 +63,7 @@ void coda_sysctl_clean(void);
     else \
         ptr = (cast)vzalloc((unsigned long) size); \
     if (!ptr) \
-        printk("kernel malloc returns 0 at %s:%d\n", __FILE__, __LINE__); \
+	pr_warn("kernel malloc returns 0 at %s:%d\n", __FILE__, __LINE__); \
 } while (0)
 
 
diff -puN fs/coda/dir.c~fs-coda-replace-printk-by-pr_foo fs/coda/dir.c
--- a/fs/coda/dir.c~fs-coda-replace-printk-by-pr_foo
+++ a/fs/coda/dir.c
@@ -102,7 +102,7 @@ static struct dentry *coda_lookup(struct
 	int type = 0;
 
 	if (length > CODA_MAXNAMLEN) {
-		printk(KERN_ERR "name too long: lookup, %s (%*s)\n",
+		pr_err("name too long: lookup, %s (%*s)\n",
 		       coda_i2s(dir), (int)length, name);
 		return ERR_PTR(-ENAMETOOLONG);
 	}
@@ -453,7 +453,7 @@ static int coda_venus_readdir(struct fil
 		ret = kernel_read(host_file, ctx->pos - 2, (char *)vdir,
 				  sizeof(*vdir));
 		if (ret < 0) {
-			printk(KERN_ERR "coda readdir: read dir %s failed %d\n",
+			pr_err("coda readdir: read dir %s failed %d\n",
 			       coda_f2s(&cii->c_fid), ret);
 			break;
 		}
@@ -461,14 +461,14 @@ static int coda_venus_readdir(struct fil
 
 		/* catch truncated reads */
 		if (ret < vdir_size || ret < vdir_size + vdir->d_namlen) {
-			printk(KERN_ERR "coda readdir: short read on %s\n",
+			pr_err("coda readdir: short read on %s\n",
 			       coda_f2s(&cii->c_fid));
 			ret = -EBADF;
 			break;
 		}
 		/* validate whether the directory file actually makes sense */
 		if (vdir->d_reclen < vdir_size + vdir->d_namlen) {
-			printk(KERN_ERR "coda readdir: invalid dir %s\n",
+			pr_err("coda readdir: invalid dir %s\n",
 			       coda_f2s(&cii->c_fid));
 			ret = -EBADF;
 			break;
@@ -589,8 +589,8 @@ int coda_revalidate_inode(struct inode *
 		coda_vattr_to_iattr(inode, &attr);
 
 		if ((old_mode & S_IFMT) != (inode->i_mode & S_IFMT)) {
-			printk("Coda: inode %ld, fid %s changed type!\n",
-			       inode->i_ino, coda_f2s(&(cii->c_fid)));
+			pr_warn("Coda: inode %ld, fid %s changed type!\n",
+				inode->i_ino, coda_f2s(&(cii->c_fid)));
 		}
 
 		/* the following can happen when a local fid is replaced 
diff -puN fs/coda/inode.c~fs-coda-replace-printk-by-pr_foo fs/coda/inode.c
--- a/fs/coda/inode.c~fs-coda-replace-printk-by-pr_foo
+++ a/fs/coda/inode.c
@@ -119,12 +119,12 @@ static int get_device_index(struct coda_
 	int idx;
 
 	if (data == NULL) {
-		printk("coda_read_super: Bad mount data\n");
+		pr_warn("coda_read_super: Bad mount data\n");
 		return -1;
 	}
 
 	if (data->version != CODA_MOUNT_VERSION) {
-		printk("coda_read_super: Bad mount version\n");
+		pr_warn("coda_read_super: Bad mount version\n");
 		return -1;
 	}
 
@@ -141,13 +141,13 @@ static int get_device_index(struct coda_
 	fdput(f);
 
 	if (idx < 0 || idx >= MAX_CODADEVS) {
-		printk("coda_read_super: Bad minor number\n");
+		pr_warn("coda_read_super: Bad minor number\n");
 		return -1;
 	}
 
 	return idx;
 Ebadf:
-	printk("coda_read_super: Bad file\n");
+	pr_warn("coda_read_super: Bad file\n");
 	return -1;
 }
 
@@ -168,19 +168,19 @@ static int coda_fill_super(struct super_
 	if(idx == -1)
 		idx = 0;
 	
-	printk(KERN_INFO "coda_read_super: device index: %i\n", idx);
+	pr_info("coda_read_super: device index: %i\n", idx);
 
 	vc = &coda_comms[idx];
 	mutex_lock(&vc->vc_mutex);
 
 	if (!vc->vc_inuse) {
-		printk("coda_read_super: No pseudo device\n");
+		pr_warn("coda_read_super: No pseudo device\n");
 		error = -EINVAL;
 		goto unlock_out;
 	}
 
 	if (vc->vc_sb) {
-		printk("coda_read_super: Device already mounted\n");
+		pr_warn("coda_read_super: Device already mounted\n");
 		error = -EBUSY;
 		goto unlock_out;
 	}
@@ -204,22 +204,23 @@ static int coda_fill_super(struct super_
 	/* get root fid from Venus: this needs the root inode */
 	error = venus_rootfid(sb, &fid);
 	if ( error ) {
-	        printk("coda_read_super: coda_get_rootfid failed with %d\n",
-		       error);
+		pr_warn("coda_read_super: coda_get_rootfid failed with %d\n",
+			error);
 		goto error;
 	}
-	printk("coda_read_super: rootfid is %s\n", coda_f2s(&fid));
+	pr_info("coda_read_super: rootfid is %s\n", coda_f2s(&fid));
 	
 	/* make root inode */
         root = coda_cnode_make(&fid, sb);
         if (IS_ERR(root)) {
 		error = PTR_ERR(root);
-		printk("Failure of coda_cnode_make for root: error %d\n", error);
+		pr_warn("Failure of coda_cnode_make for root: error %d\n",
+			error);
 		goto error;
 	} 
 
-	printk("coda_read_super: rootinode is %ld dev %s\n", 
-	       root->i_ino, root->i_sb->s_id);
+	pr_info("coda_read_super: rootinode is %ld dev %s\n",
+		root->i_ino, root->i_sb->s_id);
 	sb->s_root = d_make_root(root);
 	if (!sb->s_root) {
 		error = -EINVAL;
@@ -246,7 +247,7 @@ static void coda_put_super(struct super_
 	sb->s_fs_info = NULL;
 	mutex_unlock(&vcp->vc_mutex);
 
-	printk("Coda: Bye bye.\n");
+	pr_info("Coda: Bye bye.\n");
 }
 
 static void coda_evict_inode(struct inode *inode)
diff -puN fs/coda/psdev.c~fs-coda-replace-printk-by-pr_foo fs/coda/psdev.c
--- a/fs/coda/psdev.c~fs-coda-replace-printk-by-pr_foo
+++ a/fs/coda/psdev.c
@@ -114,14 +114,14 @@ static ssize_t coda_psdev_write(struct f
 		int size = sizeof(*dcbuf);
 
 		if  ( nbytes < sizeof(struct coda_out_hdr) ) {
-		        printk("coda_downcall opc %d uniq %d, not enough!\n",
-			       hdr.opcode, hdr.unique);
+			pr_warn("coda_downcall opc %d uniq %d, not enough!\n",
+				hdr.opcode, hdr.unique);
 			count = nbytes;
 			goto out;
 		}
 		if ( nbytes > size ) {
-		        printk("Coda: downcall opc %d, uniq %d, too much!",
-			       hdr.opcode, hdr.unique);
+			pr_warn("Coda: downcall opc %d, uniq %d, too much!",
+				hdr.opcode, hdr.unique);
 		        nbytes = size;
 		}
 		CODA_ALLOC(dcbuf, union outputArgs *, nbytes);
@@ -136,7 +136,8 @@ static ssize_t coda_psdev_write(struct f
 
 		CODA_FREE(dcbuf, nbytes);
 		if (error) {
-		        printk("psdev_write: coda_downcall error: %d\n", error);
+			pr_warn("psdev_write: coda_downcall error: %d\n",
+				error);
 			retval = error;
 			goto out;
 		}
@@ -157,7 +158,7 @@ static ssize_t coda_psdev_write(struct f
 	mutex_unlock(&vcp->vc_mutex);
 
 	if (!req) {
-		printk("psdev_write: msg (%d, %d) not found\n", 
+		pr_warn("psdev_write: msg (%d, %d) not found\n",
 			hdr.opcode, hdr.unique);
 		retval = -ESRCH;
 		goto out;
@@ -165,8 +166,8 @@ static ssize_t coda_psdev_write(struct f
 
         /* move data into response buffer. */
 	if (req->uc_outSize < nbytes) {
-                printk("psdev_write: too much cnt: %d, cnt: %ld, opc: %d, uniq: %d.\n",
-		       req->uc_outSize, (long)nbytes, hdr.opcode, hdr.unique);
+		pr_warn("psdev_write: too much cnt: %d, cnt: %ld, opc: %d, uniq: %d.\n",
+			req->uc_outSize, (long)nbytes, hdr.opcode, hdr.unique);
 		nbytes = req->uc_outSize; /* don't have more space! */
 	}
         if (copy_from_user(req->uc_data, buf, nbytes)) {
@@ -240,7 +241,7 @@ static ssize_t coda_psdev_read(struct fi
 	/* Move the input args into userspace */
 	count = req->uc_inSize;
 	if (nbytes < req->uc_inSize) {
-                printk ("psdev_read: Venus read %ld bytes of %d in message\n",
+		pr_warn("psdev_read: Venus read %ld bytes of %d in message\n",
 			(long)nbytes, req->uc_inSize);
 		count = nbytes;
         }
@@ -305,7 +306,7 @@ static int coda_psdev_release(struct ino
 	struct upc_req *req, *tmp;
 
 	if (!vcp || !vcp->vc_inuse ) {
-		printk("psdev_release: Not open.\n");
+		pr_warn("psdev_release: Not open.\n");
 		return -1;
 	}
 
@@ -354,8 +355,8 @@ static int init_coda_psdev(void)
 {
 	int i, err = 0;
 	if (register_chrdev(CODA_PSDEV_MAJOR, "coda", &coda_psdev_fops)) {
-              printk(KERN_ERR "coda_psdev: unable to get major %d\n", 
-		     CODA_PSDEV_MAJOR);
+		pr_err("coda_psdev: unable to get major %d\n",
+		       CODA_PSDEV_MAJOR);
               return -EIO;
 	}
 	coda_psdev_class = class_create(THIS_MODULE, "coda");
@@ -393,13 +394,13 @@ static int __init init_coda(void)
 		goto out2;
 	status = init_coda_psdev();
 	if ( status ) {
-		printk("Problem (%d) in init_coda_psdev\n", status);
+		pr_warn("Problem (%d) in init_coda_psdev\n", status);
 		goto out1;
 	}
 	
 	status = register_filesystem(&coda_fs_type);
 	if (status) {
-		printk("coda: failed to register filesystem!\n");
+		pr_warn("coda: failed to register filesystem!\n");
 		goto out;
 	}
 	return 0;
@@ -420,9 +421,8 @@ static void __exit exit_coda(void)
         int err, i;
 
 	err = unregister_filesystem(&coda_fs_type);
-        if ( err != 0 ) {
-                printk("coda: failed to unregister filesystem\n");
-        }
+	if (err != 0)
+		pr_warn("coda: failed to unregister filesystem\n");
 	for (i = 0; i < MAX_CODADEVS; i++)
 		device_destroy(coda_psdev_class, MKDEV(CODA_PSDEV_MAJOR, i));
 	class_destroy(coda_psdev_class);
diff -puN fs/coda/upcall.c~fs-coda-replace-printk-by-pr_foo fs/coda/upcall.c
--- a/fs/coda/upcall.c~fs-coda-replace-printk-by-pr_foo
+++ a/fs/coda/upcall.c
@@ -508,8 +508,8 @@ int venus_pioctl(struct super_block *sb,
         inp->coda_ioctl.data = (char *)(INSIZE(ioctl));
      
         /* get the data out of user space */
-        if ( copy_from_user((char*)inp + (long)inp->coda_ioctl.data,
-			    data->vi.in, data->vi.in_size) ) {
+	if (copy_from_user((char *)inp + (long)inp->coda_ioctl.data,
+			   data->vi.in, data->vi.in_size)) {
 		error = -EINVAL;
 	        goto exit;
 	}
@@ -518,8 +518,8 @@ int venus_pioctl(struct super_block *sb,
 			    &outsize, inp);
 
         if (error) {
-	        printk("coda_pioctl: Venus returns: %d for %s\n", 
-		       error, coda_f2s(fid));
+		pr_warn("coda_pioctl: Venus returns: %d for %s\n",
+			error, coda_f2s(fid));
 		goto exit; 
 	}
 
@@ -675,7 +675,7 @@ static int coda_upcall(struct venus_comm
 	mutex_lock(&vcp->vc_mutex);
 
 	if (!vcp->vc_inuse) {
-		printk(KERN_NOTICE "coda: Venus dead, not sending upcall\n");
+		pr_notice("coda: Venus dead, not sending upcall\n");
 		error = -ENXIO;
 		goto exit;
 	}
@@ -725,7 +725,7 @@ static int coda_upcall(struct venus_comm
 
 	error = -EINTR;
 	if ((req->uc_flags & CODA_REQ_ABORT) || !signal_pending(current)) {
-		printk(KERN_WARNING "coda: Unexpected interruption.\n");
+		pr_warn("coda: Unexpected interruption.\n");
 		goto exit;
 	}
 
@@ -735,7 +735,7 @@ static int coda_upcall(struct venus_comm
 
 	/* Venus saw the upcall, make sure we can send interrupt signal */
 	if (!vcp->vc_inuse) {
-		printk(KERN_INFO "coda: Venus dead, not sending signal.\n");
+		pr_info("coda: Venus dead, not sending signal.\n");
 		goto exit;
 	}
 
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

