From: akpm@linux-foundation.org
Subject: + atari-floppy-rename-disk_type-to-atari_disk_type.patch added to -mm tree
Date: Sun, 27 Jan 2008 21:24:49 -0800
Message-ID: <200801280525.m0S5Pia2013830@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33732 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751324AbYA1FZ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 00:25:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, gregkh@suse.de, kay.sievers@vrfy.org


The patch titled
     Atari floppy: Rename disk_type to atari_disk_type
has been added to the -mm tree.  Its filename is
     atari-floppy-rename-disk_type-to-atari_disk_type.patch

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
Subject: Atari floppy: Rename disk_type to atari_disk_type
From: Geert Uytterhoeven <geert@linux-m68k.org>

Commit edfaa7c36574f1bf09c65ad602412db9da5f96bf

    Driver core: convert block from raw kobjects to core devices

    This moves the block devices to /sys/class/block. It will create a
    flat list of all block devices, with the disks and partitions in one
    directory. For compatibility /sys/block is created and contains symlinks
    to the disks.

introduced a global disk_type variable in <linux/genhd.h>, causing the
following compile error on Atari:

    drivers/block/ataflop.c:93: error: conflicting types for 'disk_type'
    include/linux/genhd.h:21: error: previous declaration of 'disk_type' was here

Rename the local disk_type variable in drivers/block/ataflop.c to
atari_disk_type, to avoid the conflict.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/ataflop.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/block/ataflop.c~atari-floppy-rename-disk_type-to-atari_disk_type drivers/block/ataflop.c
--- a/drivers/block/ataflop.c~atari-floppy-rename-disk_type-to-atari_disk_type
+++ a/drivers/block/ataflop.c
@@ -90,7 +90,7 @@ static struct atari_disk_type {
 	unsigned	blocks;		/* total number of blocks */
 	unsigned	fdc_speed;	/* fdc_speed setting */
 	unsigned 	stretch;	/* track doubling ? */
-} disk_type[] = {
+} atari_disk_type[] = {
 	{ "d360",  9, 720, 0, 0},	/*  0: 360kB diskette */
 	{ "D360",  9, 720, 0, 1},	/*  1: 360kb in 720k or 1.2MB drive */
 	{ "D720",  9,1440, 0, 0},	/*  2: 720kb in 720k or 1.2MB drive */
@@ -658,7 +658,7 @@ static int do_format(int drive, int type
 			return -EINVAL;
 		}
 		type = minor2disktype[type].index;
-		UDT = &disk_type[type];
+		UDT = &atari_disk_type[type];
 	}
 
 	if (!UDT || desc->track >= UDT->blocks/UDT->spt/2 || desc->head >= 2) {
@@ -1064,7 +1064,7 @@ static void fd_rwsec_done1(int status)
 	       searched for a non-existent sector! */
 	    !(read_track && FDC_READ(FDCREG_SECTOR) > SUDT->spt)) {
 		if (Probing) {
-			if (SUDT > disk_type) {
+			if (SUDT > atari_disk_type) {
 			    if (SUDT[-1].blocks > ReqBlock) {
 				/* try another disk type */
 				SUDT--;
@@ -1082,7 +1082,7 @@ static void fd_rwsec_done1(int status)
 		} else {	
 /* record not found, but not probing. Maybe stretch wrong ? Restart probing */
 			if (SUD.autoprobe) {
-				SUDT = disk_type + StartDiskType[DriveType];
+				SUDT = atari_disk_type + StartDiskType[DriveType];
 				set_capacity(unit[SelectedDrive].disk,
 							SUDT->blocks);
 				Probing = 1;
@@ -1421,7 +1421,7 @@ repeat:
 	if (type == 0) {
 		if (!UDT) {
 			Probing = 1;
-			UDT = disk_type + StartDiskType[DriveType];
+			UDT = atari_disk_type + StartDiskType[DriveType];
 			set_capacity(floppy->disk, UDT->blocks);
 			UD.autoprobe = 1;
 		}
@@ -1439,7 +1439,7 @@ repeat:
 			goto repeat;
 		}
 		type = minor2disktype[type].index;
-		UDT = &disk_type[type];
+		UDT = &atari_disk_type[type];
 		set_capacity(floppy->disk, UDT->blocks);
 		UD.autoprobe = 0;
 	}
@@ -1505,7 +1505,7 @@ static int fd_ioctl(struct inode *inode,
 			if (minor2disktype[type].drive_types > DriveType)
 				return -ENODEV;
 			type = minor2disktype[type].index;
-			dtp = &disk_type[type];
+			dtp = &atari_disk_type[type];
 			if (UD.flags & FTD_MSG)
 			    printk (KERN_ERR "floppy%d: found dtp %p name %s!\n",
 			        drive, dtp, dtp->name);
@@ -1576,7 +1576,7 @@ static int fd_ioctl(struct inode *inode,
 				continue;
 			}
 			setidx = minor2disktype[settype].index;
-			dtp = &disk_type[setidx];
+			dtp = &atari_disk_type[setidx];
 
 			/* found matching entry ?? */
 			if (   dtp->blocks  == setprm.size 
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
sdio-fix-module-device-table-definition-for-m68k.patch
atari-falcon-ide-add-missing-hwif-variable.patch
git-scsi-misc.patch
m68k-use-cc-cross-prefix.patch
m68k-array_size-cleanup.patch
dio-array_size-cleanup.patch
dio-array_size-cleanup-update.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
m68k-balance-ioremap-and-iounmap-in-m68k-atari-hades-pcic.patch
nubus-kill-drivers-nubus-nubus_symsc.patch
m68k-kill-arch-m68k-mac-mac_ksymsc.patch
m68k-kill-arch-m68k-hp300-ksymsc.patch
m68k-kill-arch-m68k-amiga-amiga_ksymsc.patch
m68k-kill-arch-m68k-atari-atari_ksymsc.patch
m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc.patch
mac68k-macii-adb-comment-correction.patch
mac68k-remove-dead-code.patch
mac68k-add-nubus-card-definitions-and-a-typo-fix.patch
mac68k-remove-dead-mac_adbkeycodes.patch
uml-borrow-consth-techniques.patch
remove-pointless-casts-from-void-pointers.patch
cleanup-after-apus-removal.patch
amiga-serial-driver-port_write_mutex-fixup.patch
atari-floppy-rename-disk_type-to-atari_disk_type.patch
pm2fb-big-endian-fix.patch
add-cmpxchg_local-to-m86k.patch
procfs-constify-function-pointer-tables.patch
avoid-overflows-in-kernel-timec.patch
