From: akpm@linux-foundation.org
Subject: + scsi-chc-fix-shadowed-variable-warnings.patch added to -mm tree
Date: Wed, 05 Mar 2008 16:15:53 -0800
Message-ID: <200803060015.m260Frgh029253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49661 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755544AbYCFAQZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 19:16:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, James.Bottomley@HansenPartnership.com


The patch titled
     scsi: ch.c fix shadowed variable warnings
has been added to the -mm tree.  Its filename is
     scsi-chc-fix-shadowed-variable-warnings.patch

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
Subject: scsi: ch.c fix shadowed variable warnings
From: Harvey Harrison <harvey.harrison@gmail.com>

err shadows the array of errors in this driver, switch to ch_err
drivers/scsi/ch.c:271:6: warning: symbol 'err' shadows an earlier one
drivers/scsi/ch.c:116:3: originally declared here

cmd shadows the argument to this function, switch to ch_cmd
drivers/scsi/ch.c:724:11: warning: symbol 'cmd' shadows an earlier one
drivers/scsi/ch.c:596:20: originally declared here

Small code cleanup as well in if() statement.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ch.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff -puN drivers/scsi/ch.c~scsi-chc-fix-shadowed-variable-warnings drivers/scsi/ch.c
--- a/drivers/scsi/ch.c~scsi-chc-fix-shadowed-variable-warnings
+++ a/drivers/scsi/ch.c
@@ -268,16 +268,16 @@ ch_read_element_status(scsi_changer *ch,
 static int
 ch_init_elem(scsi_changer *ch)
 {
-	int err;
+	int ch_err;
 	u_char cmd[6];
 
 	vprintk("INITIALIZE ELEMENT STATUS, may take some time ...\n");
 	memset(cmd,0,sizeof(cmd));
 	cmd[0] = INITIALIZE_ELEMENT_STATUS;
 	cmd[1] = ch->device->lun << 5;
-	err = ch_do_scsi(ch, cmd, NULL, 0, DMA_NONE);
+	ch_err = ch_do_scsi(ch, cmd, NULL, 0, DMA_NONE);
 	vprintk("... finished\n");
-	return err;
+	return ch_err;
 }
 
 static int
@@ -721,7 +721,7 @@ static long ch_ioctl(struct file *file,
 	case CHIOGELEM:
 	{
 		struct changer_get_element cge;
-		u_char  cmd[12];
+		u_char  ch_cmd[12];
 		u_char  *buffer;
 		unsigned int elem;
 		int     result,i;
@@ -739,17 +739,18 @@ static long ch_ioctl(struct file *file,
 		mutex_lock(&ch->lock);
 
 	voltag_retry:
-		memset(cmd,0,sizeof(cmd));
-		cmd[0] = READ_ELEMENT_STATUS;
-		cmd[1] = (ch->device->lun << 5) |
-			(ch->voltags ? 0x10 : 0) |
-			ch_elem_to_typecode(ch,elem);
-		cmd[2] = (elem >> 8) & 0xff;
-		cmd[3] = elem        & 0xff;
-		cmd[5] = 1;
-		cmd[9] = 255;
+		memset(ch_cmd,0,sizeof(ch_cmd));
+		ch_cmd[0] = READ_ELEMENT_STATUS;
+		ch_cmd[1] = (ch->device->lun << 5) |
+			    (ch->voltags ? 0x10 : 0) |
+			    ch_elem_to_typecode(ch,elem);
+		ch_cmd[2] = (elem >> 8) & 0xff;
+		ch_cmd[3] = elem        & 0xff;
+		ch_cmd[5] = 1;
+		ch_cmd[9] = 255;
 
-		if (0 == (result = ch_do_scsi(ch, cmd, buffer, 256, DMA_FROM_DEVICE))) {
+		result = ch_do_scsi(ch, ch_cmd, buffer, 256, DMA_FROM_DEVICE);
+		if (!result) {
 			cge.cge_status = buffer[18];
 			cge.cge_flags = 0;
 			if (buffer[18] & CESTATUS_EXCEPT) {
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

git-x86.patch
git-alsa.patch
sound-replace-remaining-__function__-occurences.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
arm-replace-remaining-__function__-occurences.patch
cifs-remove-global_extern-macro.patch
cifs-replace-remaining-__function__-occurrences.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
drivers-base-replace-remaining-__function__-occurrences.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
ia64-remove-remaining-__function__-occurences.patch
infiniband-replace-remaining-__function__-occurrences.patch
input-replace-remaining-__function__-occurrences.patch
jfs-replace-__inline-with-inline.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
mips-replace-remaining-__function__-occurences.patch
mips-replace-__inline-with-inline.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
net-replace-__inline-with-inline.patch
irda-replace-__inline-with-inline.patch
blackfin-replace-remaining-__function__-occurences.patch
nfs-replace-remaining-__function__-occurrences.patch
git-nfsd.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
drivers-s390-replace-remaining-__function__-occurrences.patch
sh-replace-remaining-__function__-occurences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-stc-make-class-attributes-static.patch
scsi-osstc-make-class-attributes-static.patch
scsi-chc-fix-shadowed-variable-warnings.patch
xfs-replace-remaining-__function__-occurrences.patch
xfs-replace-__inline-with-inline.patch
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
isdn-replace-remaining-__function__-occurrences.patch
isdn-replace-__inline-with-inline.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
rtc-replace-remaining-__function__-occurrences.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
video-replace-remaining-__function__-occurrences.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
ext2-replace-remaining-__function__-occurrences.patch
jbd-sparse-warnings-in-revokec-journalc.patch
ext3-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
ufs-replace-__inline-with-inline.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
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
security-replace-remaining-__function__-occurences.patch
security-replace-remaining-__function__-occurences-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

