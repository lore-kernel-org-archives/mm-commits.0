From: akpm@linux-foundation.org
Subject: + ide-cd-use-bcd2bin-bin2bcd.patch added to -mm tree
Date: Fri, 08 Aug 2008 14:39:59 -0700
Message-ID: <200808082139.m78LdxrB029813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758545AbYHHVkJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 17:40:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, bzolnier@gmail.com, petkovbb@gmail.com


The patch titled
     ide-cd: use bcd2bin/bin2bcd
has been added to the -mm tree.  Its filename is
     ide-cd-use-bcd2bin-bin2bcd.patch

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
Subject: ide-cd: use bcd2bin/bin2bcd
From: Adrian Bunk <bunk@kernel.org>

Change ide-cd to use the new bcd2bin/bin2bcd functions instead of the
obsolete BCD2BIN/BIN2BCD macros.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Acked-by: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/ide-cd.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/ide/ide-cd.c~ide-cd-use-bcd2bin-bin2bcd drivers/ide/ide-cd.c
--- a/drivers/ide/ide-cd.c~ide-cd-use-bcd2bin-bin2bcd
+++ a/drivers/ide/ide-cd.c
@@ -1268,9 +1268,9 @@ static ide_startstop_t ide_cd_do_request
  */
 static void msf_from_bcd(struct atapi_msf *msf)
 {
-	msf->minute = BCD2BIN(msf->minute);
-	msf->second = BCD2BIN(msf->second);
-	msf->frame  = BCD2BIN(msf->frame);
+	msf->minute = bcd2bin(msf->minute);
+	msf->second = bcd2bin(msf->second);
+	msf->frame  = bcd2bin(msf->frame);
 }
 
 int cdrom_check_status(ide_drive_t *drive, struct request_sense *sense)
@@ -1411,8 +1411,8 @@ int ide_cd_read_toc(ide_drive_t *drive, 
 		return stat;
 
 	if (drive->atapi_flags & IDE_AFLAG_TOCTRACKS_AS_BCD) {
-		toc->hdr.first_track = BCD2BIN(toc->hdr.first_track);
-		toc->hdr.last_track  = BCD2BIN(toc->hdr.last_track);
+		toc->hdr.first_track = bcd2bin(toc->hdr.first_track);
+		toc->hdr.last_track  = bcd2bin(toc->hdr.last_track);
 	}
 
 	ntracks = toc->hdr.last_track - toc->hdr.first_track + 1;
@@ -1452,8 +1452,8 @@ int ide_cd_read_toc(ide_drive_t *drive, 
 			return stat;
 
 		if (drive->atapi_flags & IDE_AFLAG_TOCTRACKS_AS_BCD) {
-			toc->hdr.first_track = (u8)BIN2BCD(CDROM_LEADOUT);
-			toc->hdr.last_track = (u8)BIN2BCD(CDROM_LEADOUT);
+			toc->hdr.first_track = (u8)bin2bcd(CDROM_LEADOUT);
+			toc->hdr.last_track = (u8)bin2bcd(CDROM_LEADOUT);
 		} else {
 			toc->hdr.first_track = CDROM_LEADOUT;
 			toc->hdr.last_track = CDROM_LEADOUT;
@@ -1466,14 +1466,14 @@ int ide_cd_read_toc(ide_drive_t *drive, 
 	toc->hdr.toc_length = be16_to_cpu(toc->hdr.toc_length);
 
 	if (drive->atapi_flags & IDE_AFLAG_TOCTRACKS_AS_BCD) {
-		toc->hdr.first_track = BCD2BIN(toc->hdr.first_track);
-		toc->hdr.last_track  = BCD2BIN(toc->hdr.last_track);
+		toc->hdr.first_track = bcd2bin(toc->hdr.first_track);
+		toc->hdr.last_track  = bcd2bin(toc->hdr.last_track);
 	}
 
 	for (i = 0; i <= ntracks; i++) {
 		if (drive->atapi_flags & IDE_AFLAG_TOCADDR_AS_BCD) {
 			if (drive->atapi_flags & IDE_AFLAG_TOCTRACKS_AS_BCD)
-				toc->ent[i].track = BCD2BIN(toc->ent[i].track);
+				toc->ent[i].track = bcd2bin(toc->ent[i].track);
 			msf_from_bcd(&toc->ent[i].addr.msf);
 		}
 		toc->ent[i].addr.lba = msf_to_lba(toc->ent[i].addr.msf.minute,
_

Patches currently in -mm which might be from bunk@kernel.org are

feature-removal-scheduletxt-remove-the-ncr53c9x-entry.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
m32r-dont-offer-config_isa.patch
m32r-export-empty_zero_page.patch
m32r-export-__ndelay.patch
m32r-kernel-cleanups.patch
the-overdue-eepro100-removal.patch
ntfs-update-homepage.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
if-0-ses_match_host.patch
scsi-remove-the-unused-scsi_qlogic_fc_firmware-option.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
git-block.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
git-xtensa.patch
drivers-net-atl1e-atl1e_mainc-uninline-atl1e_setup_mac_ctrl.patch
asm-h8300-mdh-remove-cvs-keyword.patch
alpha-miata-remove-dead-url.patch
uml-remove-the-dead-tty_log-code.patch
include-linux-kernelh-userspace-header-cleanup.patch
maintainers-remove-zf-machz-watchdog-entry.patch
maintainers-remove-hga-framebuffer-driver-entry.patch
include-linux-mounth-remove-cvs-keyword.patch
kernel-dmac-remove-a-cvs-keyword.patch
binfmt_somc-add-module_license.patch
the-scheduled-serial_coldfire-removal.patch
make-probe_serial_gsc-static.patch
pnp-remove-printk-with-outdated-version.patch
telephony-remove-cvs-keywords.patch
reiserfs-procfsc-remove-cvs-keywords.patch
quota-remove-cvs-keywords.patch
make-ptrace_untrace-static.patch
fs-partitions-acornc-remove-dead-code.patch
parport-remove-cvs-keywords.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-firmware-iscsi_ibftc-make-3-functions-static.patch
acpi-use-bcd2bin-bin2bcd.patch
alpha-use-bcd2bin-bin2bcd.patch
arm-use-bcd2bin-bin2bcd.patch
cris-use-bcd2bin-bin2bcd.patch
drivers-rtc-use-bcd2bin-bin2bcd.patch
rtc-use-bcd2bin-bin2bcd.patch
ia64-use-bcd2bin-bin2bcd.patch
ide-cd-use-bcd2bin-bin2bcd.patch
m68k-use-bcd2bin-bin2bcd.patch
mips-use-bcd2bin-bin2bcd.patch
mn10300-use-bcd2bin-bin2bcd.patch
powerpc-use-bcd2bin-bin2bcd.patch
i2c-use-bcd2bin-bin2bcd.patch
drivers-scsi-sr_vendorc-use-bcd2bin.patch
sparc64-use-bcd2bin-bin2bcd.patch
remove-the-obsolete-bcdbin-binbcd-macros.patch
include-linux-bcdh-remove-comments.patch
reiser4.patch

