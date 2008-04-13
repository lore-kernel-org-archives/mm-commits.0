From: akpm@linux-foundation.org
Subject: - xfs-replace-__inline-with-inline.patch removed from -mm tree
Date: Sat, 12 Apr 2008 19:39:18 -0700
Message-ID: <200804130239.m3D2dIUD032375@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755758AbYDMCjV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 Apr 2008 22:39:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, dgc@sgi.com, tes@sgi.com, mm-commits@vger.kernel.org


The patch titled
     xfs: replace __inline with inline
has been removed from the -mm tree.  Its filename was
     xfs-replace-__inline-with-inline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xfs: replace __inline with inline
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: David Chinner <dgc@sgi.com>
Cc: Timothy Shimmin <tes@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/xfs_cred.h  |    2 +-
 fs/xfs/linux-2.6/xfs_stats.h |    4 ++--
 fs/xfs/quota/xfs_qm_stats.h  |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/xfs/linux-2.6/xfs_cred.h~xfs-replace-__inline-with-inline fs/xfs/linux-2.6/xfs_cred.h
--- a/fs/xfs/linux-2.6/xfs_cred.h~xfs-replace-__inline-with-inline
+++ a/fs/xfs/linux-2.6/xfs_cred.h
@@ -30,7 +30,7 @@ typedef struct cred {
 extern struct cred *sys_cred;
 
 /* this is a hack.. (assumes sys_cred is the only cred_t in the system) */
-static __inline int capable_cred(cred_t *cr, int cid)
+static inline int capable_cred(cred_t *cr, int cid)
 {
 	return (cr == sys_cred) ? 1 : capable(cid);
 }
diff -puN fs/xfs/linux-2.6/xfs_stats.h~xfs-replace-__inline-with-inline fs/xfs/linux-2.6/xfs_stats.h
--- a/fs/xfs/linux-2.6/xfs_stats.h~xfs-replace-__inline-with-inline
+++ a/fs/xfs/linux-2.6/xfs_stats.h
@@ -144,8 +144,8 @@ extern void xfs_cleanup_procfs(void);
 # define XFS_STATS_DEC(count)
 # define XFS_STATS_ADD(count, inc)
 
-static __inline void xfs_init_procfs(void) { };
-static __inline void xfs_cleanup_procfs(void) { };
+static inline void xfs_init_procfs(void) { };
+static inline void xfs_cleanup_procfs(void) { };
 
 #endif	/* !CONFIG_PROC_FS */
 
diff -puN fs/xfs/quota/xfs_qm_stats.h~xfs-replace-__inline-with-inline fs/xfs/quota/xfs_qm_stats.h
--- a/fs/xfs/quota/xfs_qm_stats.h~xfs-replace-__inline-with-inline
+++ a/fs/xfs/quota/xfs_qm_stats.h
@@ -45,8 +45,8 @@ extern void xfs_qm_cleanup_procfs(void);
 
 # define XQM_STATS_INC(count)	do { } while (0)
 
-static __inline void xfs_qm_init_procfs(void) { };
-static __inline void xfs_qm_cleanup_procfs(void) { };
+static inline void xfs_qm_init_procfs(void) { };
+static inline void xfs_qm_cleanup_procfs(void) { };
 
 #endif
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

git-x86.patch
git-alsa-tiwai.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
cifs-remove-global_extern-macro.patch
git-powerpc.patch
power-replace-remaining-__function__-occurrences.patch
git-dvb.patch
v4l-common-replace-remaining-__function__-occurences.patch
v4l-dvb-replace-remaining-__function__-occurences.patch
v4l-video-replace-remaining-__function__-occurences.patch
git-dlm.patch
git-ieee1394.patch
git-infiniband.patch
input-replace-remaining-__function__-occurrences.patch
git-jfs.patch
git-libata-all.patch
git-mips.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
mtd-replace-remaining-__function__-occurrences.patch
git-net.patch
blackfin-replace-remaining-__function__-occurences.patch
git-nfsd.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
git-selinux.patch
git-s390.patch
git-scsi-misc.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
block-replace-remaining-__function__-occurrences.patch
git-watchdog.patch
mac80211-tkipcc-michaelc-use-kernel-bit-rotation-helpers.patch
mac80211-tkipc-remove-opencoded-swab16-in-tkip_s.patch
mac80211-tkipc-eliminate-the-hi16-lo16-functions.patch
mac80211-tkipc-remove-mk16-hi8-lo8-helpers.patch
mac80211-michaelc-replace-macro-with-function.patch
mac80211-michaelc-use-unaligned-byteorder-helpers.patch
mac80211-michaelc-fold-initial-xor-into-block-helper.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
alpha-replace-__inline-with-inline.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
char-make-functions-static-in-synclinkmpc.patch
spi-replace-remaining-__function__-occurrences.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
isdn-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
rtc-replace-remaining-__function__-occurrences.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
video-replace-remaining-__function__-occurrences.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
md-replace-remaining-__function__-occurrences.patch
ext2-replace-remaining-__function__-occurrences.patch
ext3-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
ufs-replace-__inline-with-inline.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
reiserfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

