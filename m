From: akpm@linux-foundation.org
Subject: + fs-nfsd-exportc-make-3-functions-static.patch added to -mm tree
Date: Mon, 30 Jul 2007 15:06:50 -0700
Message-ID: <200707302206.l6UM6oDe000391@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34432 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968198AbXG3WHG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 18:07:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de


The patch titled
     From: Adrian Bunk <bunk@stusta.de>
has been added to the -mm tree.  Its filename is
     fs-nfsd-exportc-make-3-functions-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: From: Adrian Bunk <bunk@stusta.de>


This patch makes the following needlessly global functions static:
- exp_get_by_name()
- exp_parent()
- exp_find()

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

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
drivers-acpi-sbsc-remove-dead-code.patch
make-drivers-acpi-eventcacpi_event_seqnum-static.patch
git-alsa.patch
kernel-auditscc-fix-an-off-by-one.patch
drivers-base-power-make-2-functions-static.patch
git-drm.patch
git-dvb.patch
drivers-i2c-i2c-corec-make-code-static.patch
git-hwmon.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mmc.patch
git-mtd.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
fore200e_param_bs_queue-must-be-__devinit.patch
git-ocfs2.patch
cpqphp_ctrlc-remove-dead-code.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
git-unionfs.patch
git-v9fs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
i386-remove-maccumulate-outgoing-args.patch
arch-i386-mach-generic-probec-make-struct-apic_probe.patch
arch-i386-mach-es7000-es7000platc-cleanups.patch
i386-alternativec-really-stop-mces-during-code.patch
serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
usb_serial_suspend-buggy-code.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
maps2-add-proc-kpagemap-interface.patch
hugetlbfs-read-support-fix-2.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
remove-unsafe-from-module-struct.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
radeon_driver_vblank_do_wait-static.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
kernel-rtmutex-debugc-cleanups.patch
fs-nfsd-exportc-make-3-functions-static.patch
mm-page_allocc-make-code-static.patch
make-struct-sony_nc_ids-static.patch
make-pktgencget_ipsec_sa-static-and-non-inline.patch
make-nf_ct_ipv6_skip_exthdr-static.patch
net-unix-af_unixc-make-code-static.patch
drivers-usb-serial-sierrac-make-3-functions-static.patch
backlight-make-2-structs-static.patch
unexport-pm_power_off_prepare.patch
unexport-fb_prepare_logo.patch
