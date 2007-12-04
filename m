From: akpm@linux-foundation.org
Subject: - libata-export-xfermode--pata-timing-related-functions.patch removed from -mm tree
Date: Mon, 03 Dec 2007 23:37:51 -0800
Message-ID: <200712040737.lB47bpJj006848@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50596 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751794AbXLDHjJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 02:39:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, mm-commits@vger.kernel.org


The patch titled
     libata: export xfermode / PATA timing related functions
has been removed from the -mm tree.  Its filename was
     libata-export-xfermode--pata-timing-related-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata: export xfermode / PATA timing related functions
From: Tejun Heo <htejun@gmail.com>

Export the following xfermode related functions.

* ata_pack_xfermask()
* ata_unpack_xfermask()
* ata_xfer_mask2mode()
* ata_xfer_mode2mask()
* ata_xfer_mode2shift()
* ata_mode_string()
* ata_id_xfermask()
* ata_timing_find_mode()

These functions will be used later by LLD updates.  While at it,
change unsigned short @speed to u8 @xfer_mode in
ata_timing_find_mode() for consistency.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |   33 +++++++++++++++++++--------------
 include/linux/libata.h    |   10 ++++++++++
 2 files changed, 29 insertions(+), 14 deletions(-)

diff -puN drivers/ata/libata-core.c~libata-export-xfermode--pata-timing-related-functions drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-export-xfermode--pata-timing-related-functions
+++ a/drivers/ata/libata-core.c
@@ -445,9 +445,8 @@ int ata_build_rw_tf(struct ata_taskfile 
  *	RETURNS:
  *	Packed xfer_mask.
  */
-static unsigned int ata_pack_xfermask(unsigned int pio_mask,
-				      unsigned int mwdma_mask,
-				      unsigned int udma_mask)
+unsigned int ata_pack_xfermask(unsigned int pio_mask,
+			       unsigned int mwdma_mask, unsigned int udma_mask)
 {
 	return ((pio_mask << ATA_SHIFT_PIO) & ATA_MASK_PIO) |
 		((mwdma_mask << ATA_SHIFT_MWDMA) & ATA_MASK_MWDMA) |
@@ -464,10 +463,8 @@ static unsigned int ata_pack_xfermask(un
  *	Unpack @xfer_mask into @pio_mask, @mwdma_mask and @udma_mask.
  *	Any NULL distination masks will be ignored.
  */
-static void ata_unpack_xfermask(unsigned int xfer_mask,
-				unsigned int *pio_mask,
-				unsigned int *mwdma_mask,
-				unsigned int *udma_mask)
+void ata_unpack_xfermask(unsigned int xfer_mask, unsigned int *pio_mask,
+			 unsigned int *mwdma_mask, unsigned int *udma_mask)
 {
 	if (pio_mask)
 		*pio_mask = (xfer_mask & ATA_MASK_PIO) >> ATA_SHIFT_PIO;
@@ -500,7 +497,7 @@ static const struct ata_xfer_ent {
  *	RETURNS:
  *	Matching XFER_* value, 0 if no match found.
  */
-static u8 ata_xfer_mask2mode(unsigned int xfer_mask)
+u8 ata_xfer_mask2mode(unsigned int xfer_mask)
 {
 	int highbit = fls(xfer_mask) - 1;
 	const struct ata_xfer_ent *ent;
@@ -523,7 +520,7 @@ static u8 ata_xfer_mask2mode(unsigned in
  *	RETURNS:
  *	Matching xfer_mask, 0 if no match found.
  */
-static unsigned int ata_xfer_mode2mask(u8 xfer_mode)
+unsigned int ata_xfer_mode2mask(u8 xfer_mode)
 {
 	const struct ata_xfer_ent *ent;
 
@@ -545,7 +542,7 @@ static unsigned int ata_xfer_mode2mask(u
  *	RETURNS:
  *	Matching xfer_shift, -1 if no match found.
  */
-static int ata_xfer_mode2shift(unsigned int xfer_mode)
+int ata_xfer_mode2shift(unsigned int xfer_mode)
 {
 	const struct ata_xfer_ent *ent;
 
@@ -569,7 +566,7 @@ static int ata_xfer_mode2shift(unsigned 
  *	Constant C string representing highest speed listed in
  *	@mode_mask, or the constant C string "<n/a>".
  */
-static const char *ata_mode_string(unsigned int xfer_mask)
+const char *ata_mode_string(unsigned int xfer_mask)
 {
 	static const char * const xfer_mode_str[] = {
 		"PIO0",
@@ -1458,7 +1455,7 @@ static inline void ata_dump_id(const u16
  *	RETURNS:
  *	Computed xfermask
  */
-static unsigned int ata_id_xfermask(const u16 *id)
+unsigned int ata_id_xfermask(const u16 *id)
 {
 	unsigned int pio_mask, mwdma_mask, udma_mask;
 
@@ -2847,11 +2844,11 @@ void ata_timing_merge(const struct ata_t
 	if (what & ATA_TIMING_UDMA   ) m->udma    = max(a->udma,    b->udma);
 }
 
-static const struct ata_timing *ata_timing_find_mode(unsigned short speed)
+const struct ata_timing *ata_timing_find_mode(u8 xfer_mode)
 {
 	const struct ata_timing *t;
 
-	for (t = ata_timing; t->mode != speed; t++)
+	for (t = ata_timing; t->mode != xfer_mode; t++)
 		if (t->mode == 0xFF)
 			return NULL;
 	return t;
@@ -7587,6 +7584,13 @@ EXPORT_SYMBOL_GPL(ata_std_dev_select);
 EXPORT_SYMBOL_GPL(sata_print_link_status);
 EXPORT_SYMBOL_GPL(ata_tf_to_fis);
 EXPORT_SYMBOL_GPL(ata_tf_from_fis);
+EXPORT_SYMBOL_GPL(ata_pack_xfermask);
+EXPORT_SYMBOL_GPL(ata_unpack_xfermask);
+EXPORT_SYMBOL_GPL(ata_xfer_mask2mode);
+EXPORT_SYMBOL_GPL(ata_xfer_mode2mask);
+EXPORT_SYMBOL_GPL(ata_xfer_mode2shift);
+EXPORT_SYMBOL_GPL(ata_mode_string);
+EXPORT_SYMBOL_GPL(ata_id_xfermask);
 EXPORT_SYMBOL_GPL(ata_check_status);
 EXPORT_SYMBOL_GPL(ata_altstatus);
 EXPORT_SYMBOL_GPL(ata_exec_command);
@@ -7652,6 +7656,7 @@ EXPORT_SYMBOL_GPL(ata_id_to_dma_mode);
 EXPORT_SYMBOL_GPL(ata_scsi_simulate);
 
 EXPORT_SYMBOL_GPL(ata_pio_need_iordy);
+EXPORT_SYMBOL_GPL(ata_timing_find_mode);
 EXPORT_SYMBOL_GPL(ata_timing_compute);
 EXPORT_SYMBOL_GPL(ata_timing_merge);
 
diff -puN include/linux/libata.h~libata-export-xfermode--pata-timing-related-functions include/linux/libata.h
--- a/include/linux/libata.h~libata-export-xfermode--pata-timing-related-functions
+++ a/include/linux/libata.h
@@ -844,6 +844,15 @@ extern void ata_tf_read(struct ata_port 
 extern void ata_tf_to_fis(const struct ata_taskfile *tf,
 			  u8 pmp, int is_cmd, u8 *fis);
 extern void ata_tf_from_fis(const u8 *fis, struct ata_taskfile *tf);
+extern unsigned int ata_pack_xfermask(unsigned int pio_mask,
+			unsigned int mwdma_mask, unsigned int udma_mask);
+extern void ata_unpack_xfermask(unsigned int xfer_mask, unsigned int *pio_mask,
+			unsigned int *mwdma_mask, unsigned int *udma_mask);
+extern u8 ata_xfer_mask2mode(unsigned int xfer_mask);
+extern unsigned int ata_xfer_mode2mask(u8 xfer_mode);
+extern int ata_xfer_mode2shift(unsigned int xfer_mode);
+extern const char *ata_mode_string(unsigned int xfer_mask);
+extern unsigned int ata_id_xfermask(const u16 *id);
 extern void ata_noop_dev_select(struct ata_port *ap, unsigned int device);
 extern void ata_std_dev_select(struct ata_port *ap, unsigned int device);
 extern u8 ata_check_status(struct ata_port *ap);
@@ -913,6 +922,7 @@ extern int ata_cable_unknown(struct ata_
  */
 
 extern unsigned int ata_pio_need_iordy(const struct ata_device *);
+extern const struct ata_timing *ata_timing_find_mode(u8 xfer_mode);
 extern int ata_timing_compute(struct ata_device *, unsigned short,
 			      struct ata_timing *, int, int);
 extern void ata_timing_merge(const struct ata_timing *,
_

Patches currently in -mm which might be from htejun@gmail.com are

git-libata-all.patch
libata-xfer_mask-is-unsigned-int-not-unsigned-long.patch
libata-add-toshiba-mk1637gsx-to-spurious-command-completion-list.patch
sata_nv-dont-use-legacy-dma-in-adma-mode-v3.patch
libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock-checkpatch-fixes.patch
ata-ahci-enclosure-management-via-led.patch
libata-fix-early-use-of-port-printk-checkpatch-fixes.patch
pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-timings.patch
scsi-early-detection-of-medium-not-present-updated.patch
