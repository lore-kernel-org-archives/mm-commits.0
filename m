From: akpm@linux-foundation.org
Subject: [wrecked] integrity-nfsd-imbalance-bug-fix.patch removed from -mm tree
Date: Tue, 26 May 2009 12:28:55 -0700
Message-ID: <200905261928.n4QJSt3a001707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47624 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756966AbZEZT3k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 15:29:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zohar@linux.vnet.ibm.com, hooanon05@yahoo.co.jp, hugh@veritas.com, jmorris@namei.org, neilb@suse.de, safford@watson.ibm.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     integrity: nfsd imbalance bug fix
has been removed from the -mm tree.  Its filename was
     integrity-nfsd-imbalance-bug-fix.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: integrity: nfsd imbalance bug fix
From: Mimi Zohar <zohar@linux.vnet.ibm.com>

The number of calls to ima_path_check()/ima_file_free() should be
balanced.  An extra call to fput(), indicates the file could have been
accessed without first being measured.

An nfsd exported file is opened/closed by the kernel
causing an integrity imbalance message.

- rename and export opencount_get to ima_opencount_get
- replace ima_shm_check calls with ima_opencount_get
- add call to increment opencount for files opened by nfsd.
- add call to measure exported files in nfsd_permission().
- export ima_path_check

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Cc: James Morris <jmorris@namei.org>
Cc: david safford <safford@watson.ibm.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/vfs.c                     |    9 +++++++++
 include/linux/ima.h               |    4 ++--
 ipc/shm.c                         |    4 ++--
 mm/shmem.c                        |    2 +-
 security/integrity/ima/ima_main.c |   25 ++++++++++++-------------
 5 files changed, 26 insertions(+), 18 deletions(-)

diff -puN fs/nfsd/vfs.c~integrity-nfsd-imbalance-bug-fix fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~integrity-nfsd-imbalance-bug-fix
+++ a/fs/nfsd/vfs.c
@@ -55,6 +55,7 @@
 #include <linux/security.h>
 #endif /* CONFIG_NFSD_V4 */
 #include <linux/jhash.h>
+#include <linux/ima.h>
 
 #include <asm/uaccess.h>
 
@@ -735,6 +736,8 @@ nfsd_open(struct svc_rqst *rqstp, struct
 			    flags, cred);
 	if (IS_ERR(*filp))
 		host_err = PTR_ERR(*filp);
+	else
+		ima_opencount_get(*filp);
 out_nfserr:
 	err = nfserrno(host_err);
 out:
@@ -2096,7 +2099,13 @@ nfsd_permission(struct svc_rqst *rqstp, 
 	if (err == -EACCES && S_ISREG(inode->i_mode) &&
 	    acc == (NFSD_MAY_READ | NFSD_MAY_OWNER_OVERRIDE))
 		err = inode_permission(inode, MAY_EXEC);
+	if (err)
+		goto nfsd_out;
 
+	err = ima_path_check(&exp->ex_path,
+			     acc & (MAY_READ | MAY_WRITE | MAY_EXEC));
+	return err;
+nfsd_out:
 	return err? nfserrno(err) : 0;
 }
 
diff -puN include/linux/ima.h~integrity-nfsd-imbalance-bug-fix include/linux/ima.h
--- a/include/linux/ima.h~integrity-nfsd-imbalance-bug-fix
+++ a/include/linux/ima.h
@@ -20,7 +20,7 @@ extern void ima_inode_free(struct inode 
 extern int ima_path_check(struct path *path, int mask);
 extern void ima_file_free(struct file *file);
 extern int ima_file_mmap(struct file *file, unsigned long prot);
-extern void ima_shm_check(struct file *file);
+extern void ima_opencount_get(struct file *file);
 
 #else
 static inline int ima_bprm_check(struct linux_binprm *bprm)
@@ -53,7 +53,7 @@ static inline int ima_file_mmap(struct f
 	return 0;
 }
 
-static inline void ima_shm_check(struct file *file)
+static inline void ima_opencount_get(struct file *file)
 {
 	return;
 }
diff -puN ipc/shm.c~integrity-nfsd-imbalance-bug-fix ipc/shm.c
--- a/ipc/shm.c~integrity-nfsd-imbalance-bug-fix
+++ a/ipc/shm.c
@@ -384,7 +384,7 @@ static int newseg(struct ipc_namespace *
 	error = PTR_ERR(file);
 	if (IS_ERR(file))
 		goto no_file;
-	ima_shm_check(file);
+	ima_opencount_get(file);
 
 	id = ipc_addid(&shm_ids(ns), &shp->shm_perm, ns->shm_ctlmni);
 	if (id < 0) {
@@ -891,7 +891,7 @@ long do_shmat(int shmid, char __user *sh
 	file = alloc_file(path.mnt, path.dentry, f_mode, &shm_file_operations);
 	if (!file)
 		goto out_free;
-	ima_shm_check(file);
+	ima_opencount_get(file);
 
 	file->private_data = sfd;
 	file->f_mapping = shp->shm_file->f_mapping;
diff -puN mm/shmem.c~integrity-nfsd-imbalance-bug-fix mm/shmem.c
--- a/mm/shmem.c~integrity-nfsd-imbalance-bug-fix
+++ a/mm/shmem.c
@@ -2684,7 +2684,7 @@ int shmem_zero_setup(struct vm_area_stru
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
-	ima_shm_check(file);
+	ima_opencount_get(file);
 	if (vma->vm_file)
 		fput(vma->vm_file);
 	vma->vm_file = file;
diff -puN security/integrity/ima/ima_main.c~integrity-nfsd-imbalance-bug-fix security/integrity/ima/ima_main.c
--- a/security/integrity/ima/ima_main.c~integrity-nfsd-imbalance-bug-fix
+++ a/security/integrity/ima/ima_main.c
@@ -194,6 +194,7 @@ out:
 	kref_put(&iint->refcount, iint_free);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ima_path_check);
 
 static int process_measurement(struct file *file, const unsigned char *filename,
 			       int mask, int function)
@@ -222,7 +223,16 @@ out:
 	return rc;
 }
 
-static void opencount_get(struct file *file)
+/*
+ * ima_opencount_get - incr opencount for files opened by the kernel
+ *
+ * - IPC shm and shmat create/fput a file.
+ * - nfsd opens/closes exported files.
+ *
+ * Increment the opencount for these files to prevent unnecessary
+ * imbalance messages.
+ */
+void ima_opencount_get(struct file *file)
 {
 	struct inode *inode = file->f_dentry->d_inode;
 	struct ima_iint_cache *iint;
@@ -236,6 +246,7 @@ static void opencount_get(struct file *f
 	iint->opencount++;
 	mutex_unlock(&iint->mutex);
 }
+EXPORT_SYMBOL_GPL(ima_opencount_get);
 
 /**
  * ima_file_mmap - based on policy, collect/store measurement.
@@ -260,18 +271,6 @@ int ima_file_mmap(struct file *file, uns
 	return 0;
 }
 
-/*
- * ima_shm_check - IPC shm and shmat create/fput a file
- *
- * Maintain the opencount for these files to prevent unnecessary
- * imbalance messages.
- */
-void ima_shm_check(struct file *file)
-{
-	opencount_get(file);
-	return;
-}
