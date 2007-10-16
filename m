From: akpm@linux-foundation.org
Subject: - fs-nfsd-exportc-make-3-functions-static.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:40:04 -0700
Message-ID: <200710162040.l9GKe46S015652@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57554 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933703AbXJPV0i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:26:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, bfields@fieldses.org, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     fs/nfsd/export.c: make 3 functions static
has been removed from the -mm tree.  Its filename was
     fs-nfsd-exportc-make-3-functions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs/nfsd/export.c: make 3 functions static
From: Adrian Bunk <bunk@stusta.de>

This patch makes the following needlessly global functions static:
- exp_get_by_name()
- exp_parent()
- exp_find()

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/export.c            |   17 ++++++++---------
 include/linux/nfsd/export.h |   11 -----------
 2 files changed, 8 insertions(+), 20 deletions(-)

diff -puN fs/nfsd/export.c~fs-nfsd-exportc-make-3-functions-static fs/nfsd/export.c
--- a/fs/nfsd/export.c~fs-nfsd-exportc-make-3-functions-static
+++ a/fs/nfsd/export.c
@@ -861,9 +861,9 @@ exp_get_fsid_key(svc_client *clp, int fs
 	return exp_find_key(clp, FSID_NUM, fsidv, NULL);
 }
 
-svc_export *
-exp_get_by_name(svc_client *clp, struct vfsmount *mnt, struct dentry *dentry,
-		struct cache_req *reqp)
+static svc_export *exp_get_by_name(svc_client *clp, struct vfsmount *mnt,
+				   struct dentry *dentry,
+				   struct cache_req *reqp)
 {
 	struct svc_export *exp, key;
 	int err;
@@ -887,9 +887,9 @@ exp_get_by_name(svc_client *clp, struct 
 /*
  * Find the export entry for a given dentry.
  */
-struct svc_export *
-exp_parent(svc_client *clp, struct vfsmount *mnt, struct dentry *dentry,
-	   struct cache_req *reqp)
+static struct svc_export *exp_parent(svc_client *clp, struct vfsmount *mnt,
+				     struct dentry *dentry,
+				     struct cache_req *reqp)
 {
 	svc_export *exp;
 
@@ -1214,9 +1214,8 @@ out:
 	return err;
 }
 
-struct svc_export *
-exp_find(struct auth_domain *clp, int fsid_type, u32 *fsidv,
-	 struct cache_req *reqp)
+static struct svc_export *exp_find(struct auth_domain *clp, int fsid_type,
+				   u32 *fsidv, struct cache_req *reqp)
 {
 	struct svc_export *exp;
 	struct svc_expkey *ek = exp_find_key(clp, fsid_type, fsidv, reqp);
diff -puN include/linux/nfsd/export.h~fs-nfsd-exportc-make-3-functions-static include/linux/nfsd/export.h
--- a/include/linux/nfsd/export.h~fs-nfsd-exportc-make-3-functions-static
+++ a/include/linux/nfsd/export.h
@@ -127,17 +127,9 @@ void			nfsd_export_shutdown(void);
 void			nfsd_export_flush(void);
 void			exp_readlock(void);
 void			exp_readunlock(void);
-struct svc_export *	exp_get_by_name(struct auth_domain *clp,
-					struct vfsmount *mnt,
-					struct dentry *dentry,
-					struct cache_req *reqp);
 struct svc_export *	rqst_exp_get_by_name(struct svc_rqst *,
 					     struct vfsmount *,
 					     struct dentry *);
-struct svc_export *	exp_parent(struct auth_domain *clp,
-				   struct vfsmount *mnt,
-				   struct dentry *dentry,
-				   struct cache_req *reqp);
 struct svc_export *	rqst_exp_parent(struct svc_rqst *,
 					struct vfsmount *mnt,
 					struct dentry *dentry);
@@ -157,9 +149,6 @@ static inline void exp_get(struct svc_ex
 {
 	cache_get(&exp->h);
 }
-extern struct svc_export *
-exp_find(struct auth_domain *clp, int fsid_type, u32 *fsidv,
-	 struct cache_req *reqp);
 struct svc_export * rqst_exp_find(struct svc_rqst *, int, u32 *);
 
 #endif /* __KERNEL__ */
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-alsa.patch
git-kvm.patch
remove-fs-jffs2-ioctlc.patch
parisc-extern-inline-static-inline.patch
nsp32_restart_autoscsi-remove-error-check.patch
git-unionfs.patch
git-ipwireless_cs.patch
maps2-add-proc-kpagemap-interface.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
fs-afs-possible-cleanups.patch
lib-ioremapc-should-include-linux-ioh.patch
ipc-shmc-make-2-functions-static.patch
unicode-diacritics-support-s390-fix.patch
script-to-check-for-undefined-kconfig-symbols.patch
drivers-block-ccissc-fix-check-after-use.patch
dontdiff-update-based-on-gitignore-updates.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
