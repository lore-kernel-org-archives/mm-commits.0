From: akpm@linux-foundation.org
Subject: + isd200-sort-out-usb-ide-dependancy-mess.patch added to -mm tree
Date: Wed, 17 Oct 2007 20:51:34 -0700
Message-ID: <200710180351.l9I3pYBo023889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43010 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755352AbXJRDvz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 23:51:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     isd200: sort out USB/IDE dependancy mess
has been added to the -mm tree.  Its filename is
     isd200-sort-out-usb-ide-dependancy-mess.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: isd200: sort out USB/IDE dependancy mess
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

The ISD200 driver imports a single trivial routine from the IDE layer and
in doing so creates a mess of dependancies that drag in the entire old
IDE layer. Even more sad - it does this for a routine which is usually
(little endian) a null function!

- Copy the function into ISD200
- Rename it so it doesn't clash with the ide header prototype
- Remove all the depend constraints

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/Kconfig  |    1 
 drivers/usb/storage/isd200.c |  105 ++++++++++++++++++++++++++++++++-
 2 files changed, 104 insertions(+), 2 deletions(-)

diff -puN drivers/usb/storage/isd200.c~isd200-sort-out-usb-ide-dependancy-mess drivers/usb/storage/isd200.c
--- a/drivers/usb/storage/isd200.c~isd200-sort-out-usb-ide-dependancy-mess
+++ a/drivers/usb/storage/isd200.c
@@ -977,6 +977,109 @@ static int isd200_manual_enum(struct us_
 	return(retStatus);
 }
 
+/*
+ *	We are the last non IDE user of the legacy IDE ident structures
+ *	and we thus want to keep a private copy of this function so the
+ *	driver can be used without the obsolete drivers/ide layer
+ */
+
+static void isd200_fix_driveid (struct hd_driveid *id)
+{
+#ifndef __LITTLE_ENDIAN
+# ifdef __BIG_ENDIAN
+	int i;
+	u16 *stringcast;
+
+	id->config         = __le16_to_cpu(id->config);
+	id->cyls           = __le16_to_cpu(id->cyls);
+	id->reserved2      = __le16_to_cpu(id->reserved2);
+	id->heads          = __le16_to_cpu(id->heads);
+	id->track_bytes    = __le16_to_cpu(id->track_bytes);
+	id->sector_bytes   = __le16_to_cpu(id->sector_bytes);
+	id->sectors        = __le16_to_cpu(id->sectors);
+	id->vendor0        = __le16_to_cpu(id->vendor0);
+	id->vendor1        = __le16_to_cpu(id->vendor1);
+	id->vendor2        = __le16_to_cpu(id->vendor2);
+	stringcast = (u16 *)&id->serial_no[0];
+	for (i = 0; i < (20/2); i++)
+		stringcast[i] = __le16_to_cpu(stringcast[i]);
+	id->buf_type       = __le16_to_cpu(id->buf_type);
+	id->buf_size       = __le16_to_cpu(id->buf_size);
+	id->ecc_bytes      = __le16_to_cpu(id->ecc_bytes);
+	stringcast = (u16 *)&id->fw_rev[0];
+	for (i = 0; i < (8/2); i++)
+		stringcast[i] = __le16_to_cpu(stringcast[i]);
+	stringcast = (u16 *)&id->model[0];
+	for (i = 0; i < (40/2); i++)
+		stringcast[i] = __le16_to_cpu(stringcast[i]);
+	id->dword_io       = __le16_to_cpu(id->dword_io);
+	id->reserved50     = __le16_to_cpu(id->reserved50);
+	id->field_valid    = __le16_to_cpu(id->field_valid);
+	id->cur_cyls       = __le16_to_cpu(id->cur_cyls);
+	id->cur_heads      = __le16_to_cpu(id->cur_heads);
+	id->cur_sectors    = __le16_to_cpu(id->cur_sectors);
+	id->cur_capacity0  = __le16_to_cpu(id->cur_capacity0);
+	id->cur_capacity1  = __le16_to_cpu(id->cur_capacity1);
+	id->lba_capacity   = __le32_to_cpu(id->lba_capacity);
+	id->dma_1word      = __le16_to_cpu(id->dma_1word);
+	id->dma_mword      = __le16_to_cpu(id->dma_mword);
+	id->eide_pio_modes = __le16_to_cpu(id->eide_pio_modes);
+	id->eide_dma_min   = __le16_to_cpu(id->eide_dma_min);
+	id->eide_dma_time  = __le16_to_cpu(id->eide_dma_time);
+	id->eide_pio       = __le16_to_cpu(id->eide_pio);
+	id->eide_pio_iordy = __le16_to_cpu(id->eide_pio_iordy);
+	for (i = 0; i < 2; ++i)
+		id->words69_70[i] = __le16_to_cpu(id->words69_70[i]);
+	for (i = 0; i < 4; ++i)
+		id->words71_74[i] = __le16_to_cpu(id->words71_74[i]);
+	id->queue_depth    = __le16_to_cpu(id->queue_depth);
+	for (i = 0; i < 4; ++i)
+		id->words76_79[i] = __le16_to_cpu(id->words76_79[i]);
+	id->major_rev_num  = __le16_to_cpu(id->major_rev_num);
+	id->minor_rev_num  = __le16_to_cpu(id->minor_rev_num);
+	id->command_set_1  = __le16_to_cpu(id->command_set_1);
+	id->command_set_2  = __le16_to_cpu(id->command_set_2);
+	id->cfsse          = __le16_to_cpu(id->cfsse);
+	id->cfs_enable_1   = __le16_to_cpu(id->cfs_enable_1);
+	id->cfs_enable_2   = __le16_to_cpu(id->cfs_enable_2);
+	id->csf_default    = __le16_to_cpu(id->csf_default);
+	id->dma_ultra      = __le16_to_cpu(id->dma_ultra);
+	id->trseuc         = __le16_to_cpu(id->trseuc);
+	id->trsEuc         = __le16_to_cpu(id->trsEuc);
+	id->CurAPMvalues   = __le16_to_cpu(id->CurAPMvalues);
+	id->mprc           = __le16_to_cpu(id->mprc);
+	id->hw_config      = __le16_to_cpu(id->hw_config);
+	id->acoustic       = __le16_to_cpu(id->acoustic);
+	id->msrqs          = __le16_to_cpu(id->msrqs);
+	id->sxfert         = __le16_to_cpu(id->sxfert);
+	id->sal            = __le16_to_cpu(id->sal);
+	id->spg            = __le32_to_cpu(id->spg);
+	id->lba_capacity_2 = __le64_to_cpu(id->lba_capacity_2);
+	for (i = 0; i < 22; i++)
+		id->words104_125[i]   = __le16_to_cpu(id->words104_125[i]);
+	id->last_lun       = __le16_to_cpu(id->last_lun);
+	id->word127        = __le16_to_cpu(id->word127);
+	id->dlf            = __le16_to_cpu(id->dlf);
+	id->csfo           = __le16_to_cpu(id->csfo);
+	for (i = 0; i < 26; i++)
+		id->words130_155[i] = __le16_to_cpu(id->words130_155[i]);
+	id->word156        = __le16_to_cpu(id->word156);
+	for (i = 0; i < 3; i++)
+		id->words157_159[i] = __le16_to_cpu(id->words157_159[i]);
+	id->cfa_power      = __le16_to_cpu(id->cfa_power);
+	for (i = 0; i < 14; i++)
+		id->words161_175[i] = __le16_to_cpu(id->words161_175[i]);
+	for (i = 0; i < 31; i++)
+		id->words176_205[i] = __le16_to_cpu(id->words176_205[i]);
+	for (i = 0; i < 48; i++)
+		id->words206_254[i] = __le16_to_cpu(id->words206_254[i]);
+	id->integrity_word  = __le16_to_cpu(id->integrity_word);
+# else
+#  error "Please fix <asm/byteorder.h>"
+# endif
+#endif
+}
+
 
 /**************************************************************************
  * isd200_get_inquiry_data
@@ -1018,7 +1121,7 @@ static int isd200_get_inquiry_data( stru
 				int i;
 				__be16 *src;
 				__u16 *dest;
-				ide_fix_driveid(id);
+				isd200_fix_driveid(id);
 
 				US_DEBUGP("   Identify Data Structure:\n");
 				US_DEBUGP("      config = 0x%x\n", id->config);
diff -puN drivers/usb/storage/Kconfig~isd200-sort-out-usb-ide-dependancy-mess drivers/usb/storage/Kconfig
--- a/drivers/usb/storage/Kconfig~isd200-sort-out-usb-ide-dependancy-mess
+++ a/drivers/usb/storage/Kconfig
@@ -48,7 +48,6 @@ config USB_STORAGE_FREECOM
 config USB_STORAGE_ISD200
 	bool "ISD-200 USB/ATA Bridge support"
 	depends on USB_STORAGE
-	depends on BLK_DEV_IDE=y || BLK_DEV_IDE=USB_STORAGE
 	---help---
 	  Say Y here if you want to use USB Mass Store devices based
 	  on the In-Systems Design ISD-200 USB/ATA bridge.
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
codingstyle-relax-the-80-cole-rule.patch
add-config_vt_unicode.patch
keys-make-request_key-and-co-fundamentally-asynchronous.patch
ide-cd-is-unmaintained.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-right.patch
fs-correct-sus-compliance-for-open-of-large-file-without.patch
tty_ioctl-fix-the-baud_table-check-in-encode_baud_rate.patch
git-libata-all.patch
pata_cs5536-mwdma-fix.patch
libata-sff-correct-use-of-check_status.patch
serial-keep-the-dtr-setting-for-serial-console.patch
initio-fix-conflict-when-loading-driver.patch
initio-merge-fallout.patch
isd200-sort-out-usb-ide-dependancy-mess.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
usb_serial-stop-passing-null-to-functions-that-expect-data.patch
ark3116-update-termios-handling.patch
usb-serial-kill-another-case-we-pass-null-and-shouldnt.patch
ch341-fix-termios-handling.patch
digi_acceleport-fix-termios-and-also-readability-a-bit.patch
empeg-clean-up-and-handle-speeds.patch
ir_usb-termios-handling.patch
keyspan-termios-tidy.patch
kobil_sct-termios-encoding-fixups.patch
option-termios-handling.patch
sierra-termios.patch
usb-serial-handle-null-termios-methods-as-no-hardware-changing-support.patch
whiteheat-clean-up-cant-happen-checks-and-encode-baud.patch
cp2101-convert-to-new-termios.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
io_edgeport-cleanups-and-tty-speed-reporting.patch
tty-kill-tty_flipbuf_size.patch
