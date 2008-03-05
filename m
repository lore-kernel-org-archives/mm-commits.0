From: akpm@linux-foundation.org
Subject: + afs-replace-remaining-__function__-occurrences.patch added to -mm tree
Date: Wed, 05 Mar 2008 14:20:46 -0800
Message-ID: <200803052220.m25MKkMg024040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754565AbYCEW2d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 17:28:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     afs: replace remaining __FUNCTION__ occurrences
has been added to the -mm tree.  Its filename is
     afs-replace-remaining-__function__-occurrences.patch

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
Subject: afs: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/dir.c      |    4 ++--
 fs/afs/internal.h |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/afs/dir.c~afs-replace-remaining-__function__-occurrences fs/afs/dir.c
--- a/fs/afs/dir.c~afs-replace-remaining-__function__-occurrences
+++ a/fs/afs/dir.c
@@ -140,7 +140,7 @@ static inline void afs_dir_check_page(st
 
 	if (page->index == 0 && qty != ntohs(dbuf->blocks[0].pagehdr.npages)) {
 		printk("kAFS: %s(%lu): wrong number of dir blocks %d!=%hu\n",
-		       __FUNCTION__, dir->i_ino, qty,
+		       __func__, dir->i_ino, qty,
 		       ntohs(dbuf->blocks[0].pagehdr.npages));
 		goto error;
 	}
@@ -159,7 +159,7 @@ static inline void afs_dir_check_page(st
 	for (tmp = 0; tmp < qty; tmp++) {
 		if (dbuf->blocks[tmp].pagehdr.magic != AFS_DIR_MAGIC) {
 			printk("kAFS: %s(%lu): bad magic %d/%d is %04hx\n",
-			       __FUNCTION__, dir->i_ino, tmp, qty,
+			       __func__, dir->i_ino, tmp, qty,
 			       ntohs(dbuf->blocks[tmp].pagehdr.magic));
 			goto error;
 		}
diff -puN fs/afs/internal.h~afs-replace-remaining-__function__-occurrences fs/afs/internal.h
--- a/fs/afs/internal.h~afs-replace-remaining-__function__-occurrences
+++ a/fs/afs/internal.h
@@ -758,8 +758,8 @@ void _dbprintk(const char *fmt, ...)
 {
 }
 
-#define kenter(FMT,...)	dbgprintk("==> %s("FMT")",__FUNCTION__ ,##__VA_ARGS__)
-#define kleave(FMT,...)	dbgprintk("<== %s()"FMT"",__FUNCTION__ ,##__VA_ARGS__)
+#define kenter(FMT,...)	dbgprintk("==> %s("FMT")",__func__ ,##__VA_ARGS__)
+#define kleave(FMT,...)	dbgprintk("<== %s()"FMT"",__func__ ,##__VA_ARGS__)
 #define kdebug(FMT,...)	dbgprintk("    "FMT ,##__VA_ARGS__)
 
 
@@ -792,8 +792,8 @@ do {							\
 } while (0)
 
 #else
-#define _enter(FMT,...)	_dbprintk("==> %s("FMT")",__FUNCTION__ ,##__VA_ARGS__)
-#define _leave(FMT,...)	_dbprintk("<== %s()"FMT"",__FUNCTION__ ,##__VA_ARGS__)
+#define _enter(FMT,...)	_dbprintk("==> %s("FMT")",__func__ ,##__VA_ARGS__)
+#define _leave(FMT,...)	_dbprintk("<== %s()"FMT"",__func__ ,##__VA_ARGS__)
 #define _debug(FMT,...)	_dbprintk("    "FMT ,##__VA_ARGS__)
 #endif
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

git-x86.patch
git-alsa.patch
sound-replace-remaining-__function__-occurences.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
arm-replace-remaining-__function__-occurences.patch
cifs-remove-global_extern-macro.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
ia64-remove-remaining-__function__-occurences.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
mips-replace-remaining-__function__-occurences.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
blackfin-replace-remaining-__function__-occurences.patch
git-nfsd.patch
parisc-replace-remaining-__function__-occurences.patch
sh-replace-remaining-__function__-occurences.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
kernel-add-clamp-and-clamp_t-macros.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
xen-make-blkif_getgeo-static.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
security-replace-remaining-__function__-occurences.patch
security-replace-remaining-__function__-occurences-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
ext2-replace-remaining-__function__-occurrences.patch
ext3-replace-remaining-__function__-occurrences.patch
ext4-replace-remaining-__function__-occurrences.patch
nfs-replace-remaining-__function__-occurrences.patch
xfs-replace-remaining-__function__-occurrences.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
cifs-replace-remaining-__function__-occurrences.patch
reiserfs-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch

