From: akpm@linux-foundation.org
Subject: - scsi-chc-fix-sparse-shadowed-variable-warnings.patch removed from -mm tree
Date: Wed, 02 Apr 2008 12:20:33 -0700
Message-ID: <200804021920.m32JKXSk030274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48550 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759449AbYDBTVG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Apr 2008 15:21:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     scsi: ch.c fix sparse shadowed variable warnings
has been removed from the -mm tree.  Its filename was
     scsi-chc-fix-sparse-shadowed-variable-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: ch.c fix sparse shadowed variable warnings
From: Harvey Harrison <harvey.harrison@gmail.com>

Replace the global err array with ch_err.
drivers/scsi/ch.c:271:6: warning: symbol 'err' shadows an earlier one
drivers/scsi/ch.c:116:3: originally declared here

Replace the temporary cmd buffer with ch_err to avoid shadowing the cmd
function parameter.
drivers/scsi/ch.c:724:11: warning: symbol 'cmd' shadows an earlier one
drivers/scsi/ch.c:596:20: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ch.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff -puN drivers/scsi/ch.c~scsi-chc-fix-sparse-shadowed-variable-warnings drivers/scsi/ch.c
--- a/drivers/scsi/ch.c~scsi-chc-fix-sparse-shadowed-variable-warnings
+++ a/drivers/scsi/ch.c
@@ -113,7 +113,7 @@ static const struct {
 	unsigned char  asc;
 	unsigned char  ascq;
 	int	       errno;
-} err[] = {
+} ch_err[] = {
 /* Just filled in what looks right. Hav'nt checked any standard paper for
    these errno assignments, so they may be wrong... */
 	{
@@ -155,11 +155,11 @@ static int ch_find_errno(struct scsi_sen
 	/* Check to see if additional sense information is available */
 	if (scsi_sense_valid(sshdr) &&
 	    sshdr->asc != 0) {
-		for (i = 0; err[i].errno != 0; i++) {
-			if (err[i].sense == sshdr->sense_key &&
-			    err[i].asc   == sshdr->asc &&
-			    err[i].ascq  == sshdr->ascq) {
-				errno = -err[i].errno;
+		for (i = 0; ch_err[i].errno != 0; i++) {
+			if (ch_err[i].sense == sshdr->sense_key &&
+			    ch_err[i].asc   == sshdr->asc &&
+			    ch_err[i].ascq  == sshdr->ascq) {
+				errno = -ch_err[i].errno;
 				break;
 			}
 		}
@@ -721,8 +721,8 @@ static long ch_ioctl(struct file *file,
 	case CHIOGELEM:
 	{
 		struct changer_get_element cge;
-		u_char  cmd[12];
-		u_char  *buffer;
+		u_char ch_cmd[12];
+		u_char *buffer;
 		unsigned int elem;
 		int     result,i;
 
@@ -739,17 +739,18 @@ static long ch_ioctl(struct file *file,
 		mutex_lock(&ch->lock);
 
 	voltag_retry:
-		memset(cmd,0,sizeof(cmd));
-		cmd[0] = READ_ELEMENT_STATUS;
-		cmd[1] = (ch->device->lun << 5) |
+		memset(ch_cmd, 0, sizeof(ch_cmd));
+		ch_cmd[0] = READ_ELEMENT_STATUS;
+		ch_cmd[1] = (ch->device->lun << 5) |
 			(ch->voltags ? 0x10 : 0) |
 			ch_elem_to_typecode(ch,elem);
-		cmd[2] = (elem >> 8) & 0xff;
-		cmd[3] = elem        & 0xff;
-		cmd[5] = 1;
-		cmd[9] = 255;
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
git-alsa-tiwai.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
cifs-remove-global_extern-macro.patch
git-powerpc.patch
power-replace-remaining-__function__-occurrences.patch
git-dvb.patch
git-dlm.patch
git-ieee1394.patch
git-infiniband.patch
input-replace-remaining-__function__-occurrences.patch
git-jfs.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
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

