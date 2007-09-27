From: akpm@linux-foundation.org
Subject: + fs-correct-sus-compliance-for-open-of-large-file-without.patch added to -mm tree
Date: Thu, 27 Sep 2007 15:14:55 -0700
Message-ID: <200709272214.l8RMEtsw030510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58598 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755805AbXI0WPf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Sep 2007 18:15:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, arjan@infradead.org, jens.axboe@oracle.com, tytso@mit.edu


The patch titled
     fs: correct SuS compliance for open of large file without options
has been added to the -mm tree.  Its filename is
     fs-correct-sus-compliance-for-open-of-large-file-without.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs: correct SuS compliance for open of large file without options
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

The early LFS work that Linux uses favours EFBIG in various places. SuSv3
specifically uses EOVERFLOW for this as noted by Michael (Bug 7253)

[EOVERFLOW]
    The named file is a regular file and the size of the file cannot be
represented correctly in an object of type off_t. We should therefore
transition to the proper error return code

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Theodore Tso <tytso@mit.edu>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/gfs2/ops_file.c~fs-correct-sus-compliance-for-open-of-large-file-without fs/gfs2/ops_file.c
--- a/fs/gfs2/ops_file.c~fs-correct-sus-compliance-for-open-of-large-file-without
+++ a/fs/gfs2/ops_file.c
@@ -406,7 +406,7 @@ static int gfs2_open(struct inode *inode
 
 		if (!(file->f_flags & O_LARGEFILE) &&
 		    ip->i_di.di_size > MAX_NON_LFS) {
-			error = -EFBIG;
+			error = -EOVERFLOW;
 			goto fail_gunlock;
 		}
 
diff -puN fs/ntfs/file.c~fs-correct-sus-compliance-for-open-of-large-file-without fs/ntfs/file.c
--- a/fs/ntfs/file.c~fs-correct-sus-compliance-for-open-of-large-file-without
+++ a/fs/ntfs/file.c
@@ -61,7 +61,7 @@ static int ntfs_file_open(struct inode *
 {
 	if (sizeof(unsigned long) < 8) {
 		if (i_size_read(vi) > MAX_LFS_FILESIZE)
-			return -EFBIG;
+			return -EOVERFLOW;
 	}
 	return generic_file_open(vi, filp);
 }
diff -puN fs/open.c~fs-correct-sus-compliance-for-open-of-large-file-without fs/open.c
--- a/fs/open.c~fs-correct-sus-compliance-for-open-of-large-file-without
+++ a/fs/open.c
@@ -1178,7 +1178,7 @@ asmlinkage long sys_vhangup(void)
 int generic_file_open(struct inode * inode, struct file * filp)
 {
 	if (!(filp->f_flags & O_LARGEFILE) && i_size_read(inode) > MAX_NON_LFS)
-		return -EFBIG;
+		return -EOVERFLOW;
 	return 0;
 }
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
pata_acpi-use-ata_sff_port_start.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-add-a-drivers-ide-style-dma-disable.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
drivers-ata-pata_ixp4xx_cfc-ioremap-return-code-check.patch
libata-add-a-horkage-entry-for-drq-mishandling-atapi.patch
pata_pdc202xx_old-fix-timings.patch
pata_ns87415-initial-cut-at-87415-87560-ide-support.patch
fix-hpa-handling-regression.patch
libata_scsi-fix-transfer-lengths.patch
pata_atiixp-audit-notes-on-locking.patch
pata_hpt3x2n-clean-up-dpll-stuff.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
introduce-dma_mask_none-as-a-signal-for-unable-to-do.patch
pcmcia-use-dma_mask_none-for-the-default-for-all.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
8250_pci-autodetect-mainpine-cards-fix.patch
wake-up-from-a-serial-port.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
git-scsi-misc.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
tty-bring-the-old-cris-driver-back-somewhere-into-the.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
codingstyle-relax-the-80-cole-rule.patch
add-config_vt_unicode.patch
keys-missing-word-in-documentation.patch
ide-cd-is-unmaintained.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-fix.patch
fs-correct-sus-compliance-for-open-of-large-file-without.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
usb_serial-stop-passing-null-to-functions-that-expect-data.patch
ark3116-update-termios-handling.patch
usb-serial-kill-another-case-we-pass-null-and-shouldnt.patch
ch341-fix-termios-handling.patch
digi_acceleport-fix-termios-and-also-readability-a-bit.patch
empeg-clean-up-and-handle-speeds.patch
funsoft-fix-termios.patch
ir_usb-termios-handling.patch
keyspan-termios-tidy.patch
kobil_sct-termios-encoding-fixups.patch
option-termios-handling.patch
sierra-termios.patch
usb-serial-handle-null-termios-methods-as-no-hardware-changing-support.patch
visor-termios-bits.patch
