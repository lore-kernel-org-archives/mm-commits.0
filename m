From: akpm@linux-foundation.org
Subject: - drivers-scsi-a4000tc-kmalloc-memset-conversion-to-kzalloc.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:13:17 -0700
Message-ID: <200708201913.l7KJDH8f018427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58243 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757043AbXHTTVE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:21:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/a4000t.c: kmalloc + memset conversion to kzalloc
has been removed from the -mm tree.  Its filename was
     drivers-scsi-a4000tc-kmalloc-memset-conversion-to-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/scsi/a4000t.c: kmalloc + memset conversion to kzalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/a4000t.c | 3534 -> 3457 (-77 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/a4000t.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/a4000t.c~drivers-scsi-a4000tc-kmalloc-memset-conversion-to-kzalloc drivers/scsi/a4000t.c
--- a/drivers/scsi/a4000t.c~drivers-scsi-a4000tc-kmalloc-memset-conversion-to-kzalloc
+++ a/drivers/scsi/a4000t.c
@@ -37,7 +37,7 @@ static struct platform_device *a4000t_sc
 
 static int __devinit a4000t_probe(struct device *dev)
 {
-	struct Scsi_Host * host = NULL;
+	struct Scsi_Host *host;
 	struct NCR_700_Host_Parameters *hostdata;
 
 	if (!(MACH_IS_AMIGA && AMIGAHW_PRESENT(A4000_SCSI)))
@@ -47,12 +47,11 @@ static int __devinit a4000t_probe(struct
 				"A4000T builtin SCSI"))
 		goto out;
 
-	hostdata = kmalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
-	if (hostdata == NULL) {
+	hostdata = kzalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
+	if (!hostdata) {
 		printk(KERN_ERR "a4000t-scsi: Failed to allocate host data\n");
 		goto out_release;
 	}
-	memset(hostdata, 0, sizeof(struct NCR_700_Host_Parameters));
 
 	/* Fill in the required pieces of hostdata */
 	hostdata->base = (void __iomem *)ZTWO_VADDR(A4000T_SCSI_ADDR);
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
git-alsa.patch
fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch
git-powerpc.patch
git-dvb.patch
drivers-input-serio-gscps2c-kmalloc-memset-conversion-to-kzalloc.patch
git-mmc.patch
drivers-mmc-core-busc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-hostc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-mmc_opsc-kmalloc-memset-conversion-to-kzalloc.patch
git-mtd.patch
mtd-add-module-license-to-mtdbdi.patch
git-netdev-all.patch
git-scsi-misc.patch
drivers-message-fusion-mptctlc-mostly-kmalloc-memset-conversion-to-kzalloc.patch
message-fusion-remove-redundant-memset.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
include-asm-m32r-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc.patch
doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc.patch
fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc.patch
fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
