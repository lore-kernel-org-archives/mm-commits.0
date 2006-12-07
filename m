From: akpm@osdl.org
Subject: - remove-nfsd_optimize_space.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:16:31 -0800
Message-ID: <200612072316.kB7NGV8T030840@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54137 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163969AbWLGXTs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:19:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     remove NFSD_OPTIMIZE_SPACE
has been removed from the -mm tree.  Its filename was
     remove-nfsd_optimize_space.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove NFSD_OPTIMIZE_SPACE
From: Adrian Bunk <bunk@stusta.de>

This patch removes the unused NFSD_OPTIMIZE_SPACE.

Additionally, it does differently what NFSD_OPTIMIZE_SPACE was supposed to do:

Nowadays, gcc knows best when to inline code, and CONFIG_CC_OPTIMIZE_FOR_SIZE
even tells gcc globally whether to optimize for size or for speed.  Therefore,
this patch also removes all inline's from these files.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfsd/nfs3xdr.c |   24 ++++++++++--------------
 fs/nfsd/nfsxdr.c  |   13 ++++---------
 2 files changed, 14 insertions(+), 23 deletions(-)

diff -puN fs/nfsd/nfs3xdr.c~remove-nfsd_optimize_space fs/nfsd/nfs3xdr.c
--- a/fs/nfsd/nfs3xdr.c~remove-nfsd_optimize_space
+++ a/fs/nfsd/nfs3xdr.c
@@ -24,10 +24,6 @@
 
 #define NFSDDBG_FACILITY		NFSDDBG_XDR
 
-#ifdef NFSD_OPTIMIZE_SPACE
-# define inline
-#endif
-
 
 /*
  * Mapping of S_IF* types to NFS file types
@@ -42,14 +38,14 @@ static u32	nfs3_ftypes[] = {
 /*
  * XDR functions for basic NFS types
  */
-static inline __be32 *
+static __be32 *
 encode_time3(__be32 *p, struct timespec *time)
 {
 	*p++ = htonl((u32) time->tv_sec); *p++ = htonl(time->tv_nsec);
 	return p;
 }
 
-static inline __be32 *
+static __be32 *
 decode_time3(__be32 *p, struct timespec *time)
 {
 	time->tv_sec = ntohl(*p++);
@@ -57,7 +53,7 @@ decode_time3(__be32 *p, struct timespec 
 	return p;
 }
 
-static inline __be32 *
+static __be32 *
 decode_fh(__be32 *p, struct svc_fh *fhp)
 {
 	unsigned int size;
@@ -77,7 +73,7 @@ __be32 *nfs3svc_decode_fh(__be32 *p, str
 	return decode_fh(p, fhp);
 }
 
-static inline __be32 *
+static __be32 *
 encode_fh(__be32 *p, struct svc_fh *fhp)
 {
 	unsigned int size = fhp->fh_handle.fh_size;
@@ -91,7 +87,7 @@ encode_fh(__be32 *p, struct svc_fh *fhp)
  * Decode a file name and make sure that the path contains
  * no slashes or null bytes.
  */
-static inline __be32 *
+static __be32 *
 decode_filename(__be32 *p, char **namp, int *lenp)
 {
 	char		*name;
@@ -107,7 +103,7 @@ decode_filename(__be32 *p, char **namp, 
 	return p;
 }
 
-static inline __be32 *
+static __be32 *
 decode_sattr3(__be32 *p, struct iattr *iap)
 {
 	u32	tmp;
@@ -153,7 +149,7 @@ decode_sattr3(__be32 *p, struct iattr *i
 	return p;
 }
 
-static inline __be32 *
+static __be32 *
 encode_fattr3(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp,
 	      struct kstat *stat)
 {
@@ -186,7 +182,7 @@ encode_fattr3(struct svc_rqst *rqstp, __
 	return p;
 }
 
-static inline __be32 *
+static __be32 *
 encode_saved_post_attr(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp)
 {
 	struct inode	*inode = fhp->fh_dentry->d_inode;
@@ -776,7 +772,7 @@ nfs3svc_encode_readdirres(struct svc_rqs
 		return xdr_ressize_check(rqstp, p);
 }
 
-static inline __be32 *
+static __be32 *
 encode_entry_baggage(struct nfsd3_readdirres *cd, __be32 *p, const char *name,
 	     int namlen, ino_t ino)
 {
@@ -790,7 +786,7 @@ encode_entry_baggage(struct nfsd3_readdi
 	return p;
 }
 
-static inline __be32 *
+static __be32 *
 encode_entryplus_baggage(struct nfsd3_readdirres *cd, __be32 *p,
 		struct svc_fh *fhp)
 {
diff -puN fs/nfsd/nfsxdr.c~remove-nfsd_optimize_space fs/nfsd/nfsxdr.c
--- a/fs/nfsd/nfsxdr.c~remove-nfsd_optimize_space
+++ a/fs/nfsd/nfsxdr.c
@@ -18,11 +18,6 @@
 
 #define NFSDDBG_FACILITY		NFSDDBG_XDR
 
-
-#ifdef NFSD_OPTIMIZE_SPACE
-# define inline
-#endif
-
 /*
  * Mapping of S_IF* types to NFS file types
  */
@@ -55,7 +50,7 @@ __be32 *nfs2svc_decode_fh(__be32 *p, str
 	return decode_fh(p, fhp);
 }
 
-static inline __be32 *
+static __be32 *
 encode_fh(__be32 *p, struct svc_fh *fhp)
 {
 	memcpy(p, &fhp->fh_handle.fh_base, NFS_FHSIZE);
@@ -66,7 +61,7 @@ encode_fh(__be32 *p, struct svc_fh *fhp)
  * Decode a file name and make sure that the path contains
  * no slashes or null bytes.
  */
-static inline __be32 *
+static __be32 *
 decode_filename(__be32 *p, char **namp, int *lenp)
 {
 	char		*name;
@@ -82,7 +77,7 @@ decode_filename(__be32 *p, char **namp, 
 	return p;
 }
 
-static inline __be32 *
+static __be32 *
 decode_pathname(__be32 *p, char **namp, int *lenp)
 {
 	char		*name;
@@ -98,7 +93,7 @@ decode_pathname(__be32 *p, char **namp, 
 	return p;
 }
 
-static inline __be32 *
+static __be32 *
 decode_sattr(__be32 *p, struct iattr *iap)
 {
 	u32	tmp, tmp1;
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
make-drivers-acpi-eccec_ecdt-static.patch
drivers-acpi-oslc-fix-a-null-check.patch
git-alsa.patch
git-dvb.patch
fs-dlm-lowcomms-tcpc-remove-2-functions.patch
git-mtd.patch
remove-mtd-jffs2-userh.patch
net-uninline-skb_put-fix.patch
dont-export-device-ids-to-userspace.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
make-qla2x00_reg_remote_port-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
drivers-edac-make-code-static.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
make-ext2_get_blocks-static.patch
generic-bug-implementation-include-linux-bugh-must-always-include-linux-moduleh.patch
fsstack-introduce-fsstack_copy_attrinode_-fs-stackc-should-include-linux-fs_stackh.patch
i4l-remove-the-broken-hisax_amd7930-option.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
make-drivers-md-dm-snapcksnapd-static.patch
gtod-persistent-clock-support-core-remove-kernel-timercwall_jiffies.patch
gtod-persistent-clock-support-i386-i386-unexport-read_persistent_clock.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-make-kernel-timerc__next_timer_interrupt-static.patch
updated-i386-convert-to-clock-event-devices-arch-i386-kernel-apicc-make-a-function-static.patch
updated-i386-convert-to-clock-event-devices-remove-arch-i386-kernel-time_hpetchpet_reenable.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slab-cache-shrinker-statistics.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

