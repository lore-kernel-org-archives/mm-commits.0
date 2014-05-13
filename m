From: akpm@linux-foundation.org
Subject: + fs-coda-use-__func__.patch added to -mm tree
Date: Tue, 13 May 2014 13:58:20 -0700
Message-ID: <5372876c.Xxbn0djck+M1Nwta%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbaEMU6V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 May 2014 16:58:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, jaharkes@cs.cmu.edu, fabf@skynet.be

Subject: + fs-coda-use-__func__.patch added to -mm tree
To: fabf@skynet.be,jaharkes@cs.cmu.edu,joe@perches.com
From: akpm@linux-foundation.org
Date: Tue, 13 May 2014 13:58:20 -0700


The patch titled
     Subject: fs/coda: use __func__
has been added to the -mm tree.  Its filename is
     fs-coda-use-__func__.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-coda-use-__func__.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-coda-use-__func__.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/coda: use __func__

Replace all function names by __func__ in pr_foo()

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/cnode.c  |    4 ++--
 fs/coda/dir.c    |   12 ++++++------
 fs/coda/inode.c  |   24 ++++++++++++------------
 fs/coda/psdev.c  |   23 ++++++++++++-----------
 fs/coda/upcall.c |    4 ++--
 5 files changed, 34 insertions(+), 33 deletions(-)

diff -puN fs/coda/cnode.c~fs-coda-use-__func__ fs/coda/cnode.c
--- a/fs/coda/cnode.c~fs-coda-use-__func__
+++ a/fs/coda/cnode.c
@@ -101,7 +101,7 @@ struct inode *coda_cnode_make(struct Cod
 
 	inode = coda_iget(sb, fid, &attr);
 	if (IS_ERR(inode))
-		pr_warn("coda_cnode_make: coda_iget failed\n");
+		pr_warn("%s: coda_iget failed\n", __func__);
 	return inode;
 }
 
@@ -137,7 +137,7 @@ struct inode *coda_fid_to_inode(struct C
 	unsigned long hash = coda_f2i(fid);
 
 	if ( !sb ) {
-		pr_warn("coda_fid_to_inode: no sb!\n");
+		pr_warn("%s: no sb!\n", __func__);
 		return NULL;
 	}
 
diff -puN fs/coda/dir.c~fs-coda-use-__func__ fs/coda/dir.c
--- a/fs/coda/dir.c~fs-coda-use-__func__
+++ a/fs/coda/dir.c
@@ -453,23 +453,23 @@ static int coda_venus_readdir(struct fil
 		ret = kernel_read(host_file, ctx->pos - 2, (char *)vdir,
 				  sizeof(*vdir));
 		if (ret < 0) {
-			pr_err("coda readdir: read dir %s failed %d\n",
-			       coda_f2s(&cii->c_fid), ret);
+			pr_err("%s: read dir %s failed %d\n",
+			       __func__, coda_f2s(&cii->c_fid), ret);
 			break;
 		}
 		if (ret == 0) break; /* end of directory file reached */
 
 		/* catch truncated reads */
 		if (ret < vdir_size || ret < vdir_size + vdir->d_namlen) {
-			pr_err("coda readdir: short read on %s\n",
-			       coda_f2s(&cii->c_fid));
+			pr_err("%s: short read on %s\n",
+			       __func__, coda_f2s(&cii->c_fid));
 			ret = -EBADF;
 			break;
 		}
 		/* validate whether the directory file actually makes sense */
 		if (vdir->d_reclen < vdir_size + vdir->d_namlen) {
-			pr_err("coda readdir: invalid dir %s\n",
-			       coda_f2s(&cii->c_fid));
+			pr_err("%s: invalid dir %s\n",
+			       __func__, coda_f2s(&cii->c_fid));
 			ret = -EBADF;
 			break;
 		}
diff -puN fs/coda/inode.c~fs-coda-use-__func__ fs/coda/inode.c
--- a/fs/coda/inode.c~fs-coda-use-__func__
+++ a/fs/coda/inode.c
@@ -119,12 +119,12 @@ static int get_device_index(struct coda_
 	int idx;
 
 	if (data == NULL) {
-		pr_warn("coda_read_super: Bad mount data\n");
+		pr_warn("%s: Bad mount data\n", __func__);
 		return -1;
 	}
 
 	if (data->version != CODA_MOUNT_VERSION) {
-		pr_warn("coda_read_super: Bad mount version\n");
+		pr_warn("%s: Bad mount version\n", __func__);
 		return -1;
 	}
 
@@ -141,13 +141,13 @@ static int get_device_index(struct coda_
 	fdput(f);
 
 	if (idx < 0 || idx >= MAX_CODADEVS) {
-		pr_warn("coda_read_super: Bad minor number\n");
+		pr_warn("%s: Bad minor number\n", __func__);
 		return -1;
 	}
 
 	return idx;
 Ebadf:
-	pr_warn("coda_read_super: Bad file\n");
+	pr_warn("%s: Bad file\n", __func__);
 	return -1;
 }
 
@@ -168,19 +168,19 @@ static int coda_fill_super(struct super_
 	if(idx == -1)
 		idx = 0;
 	
-	pr_info("coda_read_super: device index: %i\n", idx);
+	pr_info("%s: device index: %i\n", __func__,  idx);
 
 	vc = &coda_comms[idx];
 	mutex_lock(&vc->vc_mutex);
 
 	if (!vc->vc_inuse) {
-		pr_warn("coda_read_super: No pseudo device\n");
+		pr_warn("%s: No pseudo device\n", __func__);
 		error = -EINVAL;
 		goto unlock_out;
 	}
 
 	if (vc->vc_sb) {
-		pr_warn("coda_read_super: Device already mounted\n");
+		pr_warn("%s: Device already mounted\n", __func__);
 		error = -EBUSY;
 		goto unlock_out;
 	}
@@ -204,11 +204,11 @@ static int coda_fill_super(struct super_
 	/* get root fid from Venus: this needs the root inode */
 	error = venus_rootfid(sb, &fid);
 	if ( error ) {
-		pr_warn("coda_read_super: coda_get_rootfid failed with %d\n",
-			error);
+		pr_warn("%s: coda_get_rootfid failed with %d\n",
+			__func__, error);
 		goto error;
 	}
-	pr_info("coda_read_super: rootfid is %s\n", coda_f2s(&fid));
+	pr_info("%s: rootfid is %s\n", __func__, coda_f2s(&fid));
 	
 	/* make root inode */
         root = coda_cnode_make(&fid, sb);
@@ -219,8 +219,8 @@ static int coda_fill_super(struct super_
 		goto error;
 	} 
 
-	pr_info("coda_read_super: rootinode is %ld dev %s\n",
-		root->i_ino, root->i_sb->s_id);
+	pr_info("%s: rootinode is %ld dev %s\n",
+		__func__, root->i_ino, root->i_sb->s_id);
 	sb->s_root = d_make_root(root);
 	if (!sb->s_root) {
 		error = -EINVAL;
diff -puN fs/coda/psdev.c~fs-coda-use-__func__ fs/coda/psdev.c
--- a/fs/coda/psdev.c~fs-coda-use-__func__
+++ a/fs/coda/psdev.c
@@ -136,8 +136,8 @@ static ssize_t coda_psdev_write(struct f
 
 		CODA_FREE(dcbuf, nbytes);
 		if (error) {
-			pr_warn("psdev_write: coda_downcall error: %d\n",
-				error);
+			pr_warn("%s: coda_downcall error: %d\n",
+				__func__, error);
 			retval = error;
 			goto out;
 		}
@@ -158,16 +158,17 @@ static ssize_t coda_psdev_write(struct f
 	mutex_unlock(&vcp->vc_mutex);
 
 	if (!req) {
-		pr_warn("psdev_write: msg (%d, %d) not found\n",
-			hdr.opcode, hdr.unique);
+		pr_warn("%s: msg (%d, %d) not found\n",
+			__func__, hdr.opcode, hdr.unique);
 		retval = -ESRCH;
 		goto out;
 	}
 
         /* move data into response buffer. */
 	if (req->uc_outSize < nbytes) {
-		pr_warn("psdev_write: too much cnt: %d, cnt: %ld, opc: %d, uniq: %d.\n",
-			req->uc_outSize, (long)nbytes, hdr.opcode, hdr.unique);
+		pr_warn("%s: too much cnt: %d, cnt: %ld, opc: %d, uniq: %d.\n",
+			__func__, req->uc_outSize, (long)nbytes,
+			hdr.opcode, hdr.unique);
 		nbytes = req->uc_outSize; /* don't have more space! */
 	}
         if (copy_from_user(req->uc_data, buf, nbytes)) {
@@ -241,8 +242,8 @@ static ssize_t coda_psdev_read(struct fi
 	/* Move the input args into userspace */
 	count = req->uc_inSize;
 	if (nbytes < req->uc_inSize) {
-		pr_warn("psdev_read: Venus read %ld bytes of %d in message\n",
-			(long)nbytes, req->uc_inSize);
+		pr_warn("%s: Venus read %ld bytes of %d in message\n",
+			__func__, (long)nbytes, req->uc_inSize);
 		count = nbytes;
         }
 
@@ -306,7 +307,7 @@ static int coda_psdev_release(struct ino
 	struct upc_req *req, *tmp;
 
 	if (!vcp || !vcp->vc_inuse ) {
-		pr_warn("psdev_release: Not open.\n");
+		pr_warn("%s: Not open.\n", __func__);
 		return -1;
 	}
 
@@ -355,8 +356,8 @@ static int init_coda_psdev(void)
 {
 	int i, err = 0;
 	if (register_chrdev(CODA_PSDEV_MAJOR, "coda", &coda_psdev_fops)) {
-		pr_err("coda_psdev: unable to get major %d\n",
-		       CODA_PSDEV_MAJOR);
+		pr_err("%s: unable to get major %d\n",
+		       __func__, CODA_PSDEV_MAJOR);
               return -EIO;
 	}
 	coda_psdev_class = class_create(THIS_MODULE, "coda");
diff -puN fs/coda/upcall.c~fs-coda-use-__func__ fs/coda/upcall.c
--- a/fs/coda/upcall.c~fs-coda-use-__func__
+++ a/fs/coda/upcall.c
@@ -518,8 +518,8 @@ int venus_pioctl(struct super_block *sb,
 			    &outsize, inp);
 
         if (error) {
-		pr_warn("coda_pioctl: Venus returns: %d for %s\n",
-			error, coda_f2s(fid));
+		pr_warn("%s: Venus returns: %d for %s\n",
+			__func__, error, coda_f2s(fid));
 		goto exit; 
 	}
 
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch
fs-cifs-remove-obsolete-__constant.patch
fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch
fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch
fs-fscache-convert-printk-to-pr_foo.patch
fs-fscache-replace-seq_printf-by-seq_puts.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-time-ntpc-convert-simple_strtol-to-kstrtol.patch
ntfs-remove-null-value-assignments.patch
fs-squashfs-squashfsh-replace-pr_warning-by-pr_warn.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix.patch
arch-unicore32-mm-ioremapc-return-null-on-invalid-pfn.patch
fs-configs-itemc-kernel-doc-fixes-clean-up.patch
fs-configfs-convert-printk-to-pr_foo.patch
fs-configfs-use-pr_fmt.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
fs-9p-kerneldoc-fixes.patch
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
mm-memory_hotplugc-use-pfn_down.patch
mm-memblockc-use-pfn_down.patch
mm-memcontrolc-remove-null-assignment-on-static.patch
mm-vmallocc-replace-seq_printf-by-seq_puts.patch
mm-mempolicyc-parameter-doc-uniformization.patch
mm-zbudc-make-size-unsigned-like-unique-callsite.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
kernel-cpuc-convert-printk-to-pr_foo.patch
kernel-backtracetestc-replace-no-level-printk-by-pr_info.patch
kernel-capabilityc-code-clean-up.patch
kernel-exec_domainc-code-clean-up.patch
kernel-latencytopc-convert-seq_printf-to-seq_puts.patch
kernel-stop_machinec-kernel-doc-warning-fix.patch
kernel-tracepointc-kernel-doc-fixes.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch
kernel-rebootc-convert-simple_strtoul-to-kstrtoint.patch
kernel-utsname_sysctlc-replace-obsolete-__initcall-by-device_initcall.patch
kernel-hung_taskc-convert-simple_strtoul-to-kstrtouint.patch
documentation-expand-clarify-debug-documentation.patch
lib-libcrc32cc-use-ptr_err_or_zero.patch
lib-vsprintfc-fix-comparison-to-bool.patch
kernel-compatc-use-sizeof-instead-of-sizeof.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-coda-replace-printk-by-pr_foo.patch
fs-coda-logging-prefix-uniformization.patch
fs-coda-use-__func__.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-reiserfs-streec-remove-obsolete-__constant.patch
kernel-kexecc-convert-printk-to-pr_foo.patch
kernel-user_namespacec-kernel-doc-checkpatch-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
kernel-profilec-convert-printk-to-pr_foo.patch
kernel-profilec-use-static-const-char-instead-of-static-char.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
fs-cachefiles-convert-printk-to-pr_foo.patch
fs-cachefiles-replace-kerror-by-pr_err.patch
fs-devpts-inodec-convert-printk-to-pr_foo.patch
kernel-seccompc-kernel-doc-warning-fix.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-rcu-treec-make-rcu-node-arrays-static-const-char-const.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
ufs-sb-mutex-merge-mutex_destroy.patch

