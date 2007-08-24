From: akpm@linux-foundation.org
Subject: - drivers-mmc-core-busc-kmalloc-memset-conversion-to-kzalloc.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:57:42 -0700
Message-ID: <200708242057.l7OKvgmv014241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32861 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762972AbXHXVIV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, mm-commits@vger.kernel.org


The patch titled
     drivers/mmc/core/bus.c: kmalloc + memset conversion to kzalloc
has been removed from the -mm tree.  Its filename was
     drivers-mmc-core-busc-kmalloc-memset-conversion-to-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/mmc/core/bus.c: kmalloc + memset conversion to kzalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/mmc/core/bus.c | 5663 -> 5619 (-44 bytes)
 drivers/mmc/core/bus.o | 70899 -> 70731 (-168 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/bus.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/mmc/core/bus.c~drivers-mmc-core-busc-kmalloc-memset-conversion-to-kzalloc drivers/mmc/core/bus.c
--- a/drivers/mmc/core/bus.c~drivers-mmc-core-busc-kmalloc-memset-conversion-to-kzalloc
+++ a/drivers/mmc/core/bus.c
@@ -201,12 +201,10 @@ struct mmc_card *mmc_alloc_card(struct m
 {
 	struct mmc_card *card;
 
-	card = kmalloc(sizeof(struct mmc_card), GFP_KERNEL);
+	card = kzalloc(sizeof(struct mmc_card), GFP_KERNEL);
 	if (!card)
 		return ERR_PTR(-ENOMEM);
 
-	memset(card, 0, sizeof(struct mmc_card));
-
 	card->host = host;
 
 	device_initialize(&card->dev);
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
request_irq-fix-debug_shirq-handling-re-2623-rc2-mm1-rtl8139-inconsistent-lock-state.patch
git-alsa.patch
fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch
git-powerpc.patch
git-dvb.patch
drivers-input-serio-gscps2c-kmalloc-memset-conversion-to-kzalloc.patch
git-mmc.patch
git-mtd.patch
mtd-add-module-license-to-mtdbdi.patch
git-netdev-all.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
git-scsi-misc.patch
drivers-message-fusion-mptctlc-mostly-kmalloc-memset-conversion-to-kzalloc.patch
message-fusion-remove-redundant-memset.patch
git-v9fs.patch
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
