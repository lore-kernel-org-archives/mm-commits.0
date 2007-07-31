From: akpm@linux-foundation.org
Subject: - net-ipv4-ip_optionsc-kmalloc-memset-conversion-to-kzalloc.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:59:20 -0700
Message-ID: <200707312359.l6VNxKjM029642@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33596 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760071AbXHAAQQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:16:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, mm-commits@vger.kernel.org


The patch titled
     net/ipv4/ip_options.c: kmalloc + memset conversion to kzalloc
has been removed from the -mm tree.  Its filename was
     net-ipv4-ip_optionsc-kmalloc-memset-conversion-to-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: net/ipv4/ip_options.c: kmalloc + memset conversion to kzalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 net/ipv4/ip_options.c | 15425 -> 15368 (-57 bytes)
 net/ipv4/ip_options.o | 133668 -> 133588 (-80 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/ip_options.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff -puN net/ipv4/ip_options.c~net-ipv4-ip_optionsc-kmalloc-memset-conversion-to-kzalloc net/ipv4/ip_options.c
--- a/net/ipv4/ip_options.c~net-ipv4-ip_optionsc-kmalloc-memset-conversion-to-kzalloc
+++ a/net/ipv4/ip_options.c
@@ -513,11 +513,8 @@ void ip_options_undo(struct ip_options *
 
 static struct ip_options *ip_options_get_alloc(const int optlen)
 {
-	struct ip_options *opt = kmalloc(sizeof(*opt) + ((optlen + 3) & ~3),
-					 GFP_KERNEL);
-	if (opt)
-		memset(opt, 0, sizeof(*opt));
-	return opt;
+	return kzalloc(sizeof(struct ip_options) + ((optlen + 3) & ~3),
+		       GFP_KERNEL);
 }
 
 static int ip_options_get_finish(struct ip_options **optp,
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-hw-handlerc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-path-selectorc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-tablec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-targetc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-media-video-msp3400-driverc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-input-serio-gscps2c-kmalloc-memset-conversion-to-kzalloc.patch
drivers-ide-arm-icsidec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-busc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-hostc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-mmc_opsc-kmalloc-memset-conversion-to-kzalloc.patch
mtd-add-module-license-to-mtdbdi.patch
mtd-remove-redundant-dead-code-from-physmap_ofc.patch
drivers-mtd-inftlmountc-kmalloc-memset-conversion-to-kcalloc.patch
usb-remove-redundant-memset-from-amd5536udc.patch
drivers-net-wan-hdlc_frc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-net-irda-irda-usbc-mostly-kmalloc-memset-conversion-to-kalloc.patch
drivers-atm-iphasec-mostly-kmalloc-memset-conversion-to-kzalloc.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
drivers-pci-hotplug-cpqphp_ctrlc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-a4000tc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-bvme6000_scsic-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-gdthc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-ide-scsic-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-lpfc-lpfc_debugfsc-kmalloc-memset-conversion-to-kcalloc.patch
drivers-scsi-lpfc-lpfc_initc-kmalloc-memset-conversion-to-kcalloc.patch
drivers-scsi-lpfc-lpfc_scsic-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-megaraidc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-dpt_i2oc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-message-fusion-mptctlc-mostly-kmalloc-memset-conversion-to-kzalloc.patch
drivers-block-ccissc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-block-cpqarrayc-better-error-handling-and-kmalloc-memset-conversion-to-kalloc.patch
drivers-usb-misc-ftdi-elanc-kmalloc-memset-conversion-to-kzalloc.patch
arch-x86_64-kernel-io_apicc-kmalloc-memset-conversion-to-kzalloc.patch
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
