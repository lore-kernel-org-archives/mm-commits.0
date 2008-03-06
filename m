From: akpm@linux-foundation.org
Subject: + scsi-osstc-make-class-attributes-static.patch added to -mm tree
Date: Wed, 05 Mar 2008 16:15:50 -0800
Message-ID: <200803060015.m260FpT3029243@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758937AbYCFAQc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 19:16:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, James.Bottomley@HansenPartnership.com, osst@riede.org


The patch titled
     scsi: osst.c make class attributes static
has been added to the -mm tree.  Its filename is
     scsi-osstc-make-class-attributes-static.patch

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
Subject: scsi: osst.c make class attributes static
From: Harvey Harrison <harvey.harrison@gmail.com>

Fixes sparse warnings:
drivers/scsi/osst.c:5604:1: warning: symbol 'class_device_attr_ADR_rev' was not declared. Should it be static?
drivers/scsi/osst.c:5616:1: warning: symbol 'class_device_attr_media_version' was not declared. Should it be static?
drivers/scsi/osst.c:5628:1: warning: symbol 'class_device_attr_capacity' was not declared. Should it be static?
drivers/scsi/osst.c:5640:1: warning: symbol 'class_device_attr_BOT_frame' was not declared. Should it be static?
drivers/scsi/osst.c:5652:1: warning: symbol 'class_device_attr_EOD_frame' was not declared. Should it be static?
drivers/scsi/osst.c:5664:1: warning: symbol 'class_device_attr_file_count' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Willem Riede <osst@riede.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/osst.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/osst.c~scsi-osstc-make-class-attributes-static drivers/scsi/osst.c
--- a/drivers/scsi/osst.c~scsi-osstc-make-class-attributes-static
+++ a/drivers/scsi/osst.c
@@ -5601,7 +5601,7 @@ static ssize_t osst_adr_rev_show(struct 
 	return l;
 }
 
-CLASS_DEVICE_ATTR(ADR_rev, S_IRUGO, osst_adr_rev_show, NULL);
+static CLASS_DEVICE_ATTR(ADR_rev, S_IRUGO, osst_adr_rev_show, NULL);
 
 static ssize_t osst_linux_media_version_show(struct class_device *class_dev, char *buf)
 {
@@ -5613,7 +5613,7 @@ static ssize_t osst_linux_media_version_
 	return l;
 }
 
-CLASS_DEVICE_ATTR(media_version, S_IRUGO, osst_linux_media_version_show, NULL);
+static CLASS_DEVICE_ATTR(media_version, S_IRUGO, osst_linux_media_version_show, NULL);
 
 static ssize_t osst_capacity_show(struct class_device *class_dev, char *buf)
 {
@@ -5625,7 +5625,7 @@ static ssize_t osst_capacity_show(struct
 	return l;
 }
 
-CLASS_DEVICE_ATTR(capacity, S_IRUGO, osst_capacity_show, NULL);
+static CLASS_DEVICE_ATTR(capacity, S_IRUGO, osst_capacity_show, NULL);
 
 static ssize_t osst_first_data_ppos_show(struct class_device *class_dev, char *buf)
 {
@@ -5637,7 +5637,7 @@ static ssize_t osst_first_data_ppos_show
 	return l;
 }
 
-CLASS_DEVICE_ATTR(BOT_frame, S_IRUGO, osst_first_data_ppos_show, NULL);
+static CLASS_DEVICE_ATTR(BOT_frame, S_IRUGO, osst_first_data_ppos_show, NULL);
 
 static ssize_t osst_eod_frame_ppos_show(struct class_device *class_dev, char *buf)
 {
@@ -5649,7 +5649,7 @@ static ssize_t osst_eod_frame_ppos_show(
 	return l;
 }
 
-CLASS_DEVICE_ATTR(EOD_frame, S_IRUGO, osst_eod_frame_ppos_show, NULL);
+static CLASS_DEVICE_ATTR(EOD_frame, S_IRUGO, osst_eod_frame_ppos_show, NULL);
 
 static ssize_t osst_filemark_cnt_show(struct class_device *class_dev, char *buf)
 {
@@ -5661,7 +5661,7 @@ static ssize_t osst_filemark_cnt_show(st
 	return l;
 }
 
-CLASS_DEVICE_ATTR(file_count, S_IRUGO, osst_filemark_cnt_show, NULL);
+static CLASS_DEVICE_ATTR(file_count, S_IRUGO, osst_filemark_cnt_show, NULL);
 
 static struct class *osst_sysfs_class;
 
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

