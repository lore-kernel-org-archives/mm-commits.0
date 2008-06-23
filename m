From: akpm@linux-foundation.org
Subject: + coda-remove-coda_fs_old_api.patch added to -mm tree
Date: Mon, 23 Jun 2008 16:53:16 -0700
Message-ID: <200806232353.m5NNrGex022760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810AbYFWXyU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 19:54:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, jaharkes@cs.cmu.edu


The patch titled
     coda: remove CODA_FS_OLD_API
has been added to the -mm tree.  Its filename is
     coda-remove-coda_fs_old_api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coda: remove CODA_FS_OLD_API
From: Adrian Bunk <bunk@kernel.org>

While fixing CONFIG_ leakages to the userspace kernel headers I ran into
CODA_FS_OLD_API.

After five years, are there still people using the old API left? 
Especially considering that you have to choose at compile time which API
to support in the kernel (and distributions tend to offer the new API for
some time).

Jan: "The old API can definitely go.  Around the time the new
      interface went in there were some non-Coda userspace file system
      implementations that took a while longer to convert to the new API,
      but by now they all switched to the new interface or in some cases
      to a FUSE-based solution."

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig           |   14 -------------
 fs/coda/coda_linux.c |    6 +----
 fs/coda/psdev.c      |    4 ---
 fs/coda/upcall.c     |   15 --------------
 include/linux/coda.h |   43 -----------------------------------------
 5 files changed, 3 insertions(+), 79 deletions(-)

diff -puN fs/Kconfig~coda-remove-coda_fs_old_api fs/Kconfig
--- a/fs/Kconfig~coda-remove-coda_fs_old_api
+++ a/fs/Kconfig
@@ -2160,20 +2160,6 @@ config CODA_FS
 	  To compile the coda client support as a module, choose M here: the
 	  module will be called coda.
 
-config CODA_FS_OLD_API
-	bool "Use 96-bit Coda file identifiers"
-	depends on CODA_FS
-	help
-	  A new kernel-userspace API had to be introduced for Coda v6.0
-	  to support larger 128-bit file identifiers as needed by the
-	  new realms implementation.
-
-	  However this new API is not backward compatible with older
-	  clients. If you really need to run the old Coda userspace
-	  cache manager then say Y.
-
-	  For most cases you probably want to say N.
-
 config AFS_FS
 	tristate "Andrew File System support (AFS) (EXPERIMENTAL)"
 	depends on INET && EXPERIMENTAL
diff -puN fs/coda/coda_linux.c~coda-remove-coda_fs_old_api fs/coda/coda_linux.c
--- a/fs/coda/coda_linux.c~coda-remove-coda_fs_old_api
+++ a/fs/coda/coda_linux.c
@@ -28,11 +28,9 @@ int coda_fake_statfs;
 char * coda_f2s(struct CodaFid *f)
 {
 	static char s[60];
-#ifdef CONFIG_CODA_FS_OLD_API
- 	sprintf(s, "(%08x.%08x.%08x)", f->opaque[0], f->opaque[1], f->opaque[2]);
-#else
+
  	sprintf(s, "(%08x.%08x.%08x.%08x)", f->opaque[0], f->opaque[1], f->opaque[2], f->opaque[3]);
-#endif
+
 	return s;
 }
 
diff -puN fs/coda/psdev.c~coda-remove-coda_fs_old_api fs/coda/psdev.c
--- a/fs/coda/psdev.c~coda-remove-coda_fs_old_api
+++ a/fs/coda/psdev.c
@@ -378,11 +378,7 @@ MODULE_AUTHOR("Jan Harkes, Peter J. Braa
 MODULE_DESCRIPTION("Coda Distributed File System VFS interface");
 MODULE_ALIAS_CHARDEV_MAJOR(CODA_PSDEV_MAJOR);
 MODULE_LICENSE("GPL");
-#ifdef CONFIG_CODA_FS_OLD_API
-MODULE_VERSION("5.3.21");
-#else
 MODULE_VERSION("6.6");
-#endif
 
 static int __init init_coda(void)
 {
diff -puN fs/coda/upcall.c~coda-remove-coda_fs_old_api fs/coda/upcall.c
--- a/fs/coda/upcall.c~coda-remove-coda_fs_old_api
+++ a/fs/coda/upcall.c
@@ -52,12 +52,8 @@ static void *alloc_upcall(int opcode, in
         inp->ih.opcode = opcode;
 	inp->ih.pid = current->pid;
 	inp->ih.pgid = task_pgrp_nr(current);
-#ifdef CONFIG_CODA_FS_OLD_API
-	memset(&inp->ih.cred, 0, sizeof(struct coda_cred));
-	inp->ih.cred.cr_fsuid = current->fsuid;
-#else
 	inp->ih.uid = current->fsuid;
-#endif
+
 	return (void*)inp;
 }
 
@@ -166,20 +162,11 @@ int venus_close(struct super_block *sb, 
 	union inputArgs *inp;
 	union outputArgs *outp;
 	int insize, outsize, error;
-#ifdef CONFIG_CODA_FS_OLD_API
-	struct coda_cred cred = { 0, };
-	cred.cr_fsuid = uid;
-#endif
 	
 	insize = SIZE(release);
 	UPARG(CODA_CLOSE);
 	
-#ifdef CONFIG_CODA_FS_OLD_API
-	memcpy(&(inp->ih.cred), &cred, sizeof(cred));
-#else
 	inp->ih.uid = uid;
-#endif
-	
         inp->coda_close.VFid = *fid;
         inp->coda_close.flags = flags;
 
diff -puN include/linux/coda.h~coda-remove-coda_fs_old_api include/linux/coda.h
--- a/include/linux/coda.h~coda-remove-coda_fs_old_api
+++ a/include/linux/coda.h
@@ -199,28 +199,6 @@ typedef u_int32_t vuid_t;
 typedef u_int32_t vgid_t;
 #endif /*_VUID_T_ */
 
-#ifdef CONFIG_CODA_FS_OLD_API
-struct CodaFid {
-	u_int32_t opaque[3];
-};
-
-static __inline__ ino_t  coda_f2i(struct CodaFid *fid)
-{
-	if ( ! fid ) 
-		return 0; 
-	if (fid->opaque[1] == 0xfffffffe || fid->opaque[1] == 0xffffffff)
-		return ((fid->opaque[0] << 20) | (fid->opaque[2] & 0xfffff));
-	else
-		return (fid->opaque[2] + (fid->opaque[1]<<10) + (fid->opaque[0]<<20));
-}
-
-struct coda_cred {
-    vuid_t cr_uid, cr_euid, cr_suid, cr_fsuid; /* Real, efftve, set, fs uid*/
-    vgid_t cr_groupid, cr_egid, cr_sgid, cr_fsgid; /* same for groups */
-};
-
-#else /* not defined(CONFIG_CODA_FS_OLD_API) */
-
 struct CodaFid {
 	u_int32_t opaque[4];
 };
@@ -228,8 +206,6 @@ struct CodaFid {
 #define coda_f2i(fid)\
 	(fid ? (fid->opaque[3] ^ (fid->opaque[2]<<10) ^ (fid->opaque[1]<<20) ^ fid->opaque[0]) : 0)
 
-#endif
-
 #ifndef _VENUS_VATTR_T_
 #define _VENUS_VATTR_T_
 /*
@@ -313,15 +289,7 @@ struct coda_statfs {
 
 #define CIOC_KERNEL_VERSION _IOWR('c', 10, size_t)
 
-#if 0
-#define CODA_KERNEL_VERSION 0 /* don't care about kernel version number */
-#define CODA_KERNEL_VERSION 1 /* The old venus 4.6 compatible interface */
-#endif
-#ifdef CONFIG_CODA_FS_OLD_API
-#define CODA_KERNEL_VERSION 2 /* venus_lookup got an extra parameter */
-#else
 #define CODA_KERNEL_VERSION 3 /* 128-bit file identifiers */
-#endif
 
 /*
  *        Venus <-> Coda  RPC arguments
@@ -329,16 +297,9 @@ struct coda_statfs {
 struct coda_in_hdr {
     u_int32_t opcode;
     u_int32_t unique;	    /* Keep multiple outstanding msgs distinct */
-#ifdef CONFIG_CODA_FS_OLD_API
-    u_int16_t pid;	    /* Common to all */
-    u_int16_t pgid;	    /* Common to all */
-    u_int16_t sid;          /* Common to all */
-    struct coda_cred cred;  /* Common to all */
-#else
     pid_t pid;
     pid_t pgid;
     vuid_t uid;
-#endif
 };
 
 /* Really important that opcode and unique are 1st two fields! */
@@ -613,11 +574,7 @@ struct coda_vget_out {
 /* CODA_PURGEUSER is a venus->kernel call */
 struct coda_purgeuser_out {
     struct coda_out_hdr oh;
-#ifdef CONFIG_CODA_FS_OLD_API
-    struct coda_cred cred;
-#else
     vuid_t uid;
-#endif
 };
 
 /* coda_zapfile: */
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
remove-drivers-acorn-char-defkeymap-l7200c.patch
drm-make-drm_minors_cleanup-static.patch
if-0-ses_match_host.patch
git-xtensa.patch
mm-migratec-should-include-linux-syscallsh.patch
mm-vmstatc-proper-externs.patch
mm-hugetlbc-fix-duplicate-variable.patch
remove-include-asm-h8300-keyboardh.patch
remove-include-linux-pm_legacyh.patch
remove-the-v850-port.patch
init-do_mountsc-should-include-linux-initrdh.patch
proper-spawn_ksoftirqd-prototype.patch
build-kernel-profileo-only-when-requested.patch
build-kernel-profileo-only-when-requested-cleanups.patch
asm-generic-int-ll64h-always-provide-__su64.patch
remove-some-more-tipar-bits.patch
include-linux-kernelh-userspace-header-cleanup.patch
remove-the-oss-trident-driver.patch
config_sound_wm97xx-remove-stale-makefile-line.patch
serial-8250_gscc-add-module_license.patch
mfd-sm501c-if-0-unused-functions.patch
video-sis-remove-compat-code.patch
minix-remove-no_truncate-code.patch
coda-remove-coda_fs_old_api.patch
remove-is_tty.patch
proper-extern-for-mwave_s_mdd.patch
if-0-hpet_unregister.patch
unexport-proc_clear_tty.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proper-pidhashmap_init-prototypes.patch
unexport-uts_sem.patch
parport-sharec-proper-externs.patch
tpm_biosc-make-2-structs-static.patch
make-cgroup_seqfile_release-static.patch
make-kprobe_blacklist-static.patch
make-pnp_add_card_id-static.patch
make-parport_cs_release-static.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
reiser4.patch

