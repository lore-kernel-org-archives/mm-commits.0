From: akpm@linux-foundation.org
Subject: - isdn-sc-fix-longstanding-warning.patch removed from -mm tree
Date: Fri, 26 Oct 2007 11:48:44 -0700
Message-ID: <200710261848.l9QImift009165@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44155 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752186AbXJZStE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Oct 2007 14:49:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, jgarzik@redhat.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     ISDN/sc: fix longstanding warning
has been removed from the -mm tree.  Its filename was
     isdn-sc-fix-longstanding-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ISDN/sc: fix longstanding warning
From: Jeff Garzik <jeff@garzik.org>

drivers/isdn/sc/shmem.c: In function `memcpy_toshmem':
drivers/isdn/sc/shmem.c:54: warning: passing argument 1 of `memcpy_toio' makes pointer from integer without a cast

Also, remove some unneeded braces, and add some useful whitespace.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/sc/shmem.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/isdn/sc/shmem.c~isdn-sc-fix-longstanding-warning drivers/isdn/sc/shmem.c
--- a/drivers/isdn/sc/shmem.c~isdn-sc-fix-longstanding-warning
+++ a/drivers/isdn/sc/shmem.c
@@ -28,15 +28,15 @@ void memcpy_toshmem(int card, void *dest
 {
 	unsigned long flags;
 	unsigned char ch;
+	unsigned long dest_rem = ((unsigned long) dest) % 0x4000;
 
-	if(!IS_VALID_CARD(card)) {
+	if (!IS_VALID_CARD(card)) {
 		pr_debug("Invalid param: %d is not a valid card id\n", card);
 		return;
 	}
 
-	if(n > SRAM_PAGESIZE) {
+	if (n > SRAM_PAGESIZE)
 		return;
-	}
 
 	/*
 	 * determine the page to load from the address
@@ -50,8 +50,7 @@ void memcpy_toshmem(int card, void *dest
 
 	outb(((sc_adapter[card]->shmem_magic + ch * SRAM_PAGESIZE) >> 14) | 0x80,
 		sc_adapter[card]->ioport[sc_adapter[card]->shmem_pgport]);
-	memcpy_toio(sc_adapter[card]->rambase +
-		((unsigned long) dest % 0x4000), src, n);
+	memcpy_toio(sc_adapter[card]->rambase + dest_rem, src, n);
 	spin_unlock_irqrestore(&sc_adapter[card]->lock, flags);
 	pr_debug("%s: set page to %#x\n",sc_adapter[card]->devicename,
 		((sc_adapter[card]->shmem_magic + ch * SRAM_PAGESIZE)>>14)|0x80);
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
remove-bogus-default-y-for-dmar-and-net_dma.patch
acpi-sbs-fix-retval-warning.patch
git-jg-misc.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-add-helper-__ide_setup_pci_device.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop-checkpatch-fixes.patch
git-netdev-all.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
hptiop-fix-type-mismatch-warning.patch
ips-remove-ips_ha-members-that-duplicate-struct-pci_dev-members.patch
ips-trim-trailing-whitespace.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
ips-pci-api-cleanups.patch
ips-handle-scsi_add_host-failure-and-other-err-cleanups.patch
git-wireless.patch
x86-fix-config_smp-warning-in-processorc.patch
x86-fix-config_smp-warning-in-processorc-fix.patch
fix-versus-precedence-in-various-places.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
riscom8-fix-smp-brokenness.patch
riscom8-fix-smp-brokenness-fix.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
sound-oss-sb_commonc-fix-casting-warning.patch
remove-warnings-for-longstanding-conditions.patch
remove-warnings-for-longstanding-conditions-fix.patch
remove-warnings-for-longstanding-conditions-checkpatch-fixes.patch
