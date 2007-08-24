From: akpm@linux-foundation.org
Subject: - drivers-mmc-core-mmc_opsc-kmalloc-memset-conversion-to-kzalloc.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:57:46 -0700
Message-ID: <200708242057.l7OKvkRZ014248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44995 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760253AbXHXVIp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, drzeus-list@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     drivers/mmc/core/mmc_ops.c: kmalloc + memset conversion to kzalloc
has been removed from the -mm tree.  Its filename was
     drivers-mmc-core-mmc_opsc-kmalloc-memset-conversion-to-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/mmc/core/mmc_ops.c: kmalloc + memset conversion to kzalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/mmc/core/mmc_ops.c | 7957 -> 7924 (-33 bytes)
 drivers/mmc/core/mmc_ops.o | 101732 -> 101744 (+12 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/mmc_ops.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/mmc/core/mmc_ops.c~drivers-mmc-core-mmc_opsc-kmalloc-memset-conversion-to-kzalloc drivers/mmc/core/mmc_ops.c
--- a/drivers/mmc/core/mmc_ops.c~drivers-mmc-core-mmc_opsc-kmalloc-memset-conversion-to-kzalloc
+++ a/drivers/mmc/core/mmc_ops.c
@@ -395,10 +395,9 @@ int mmc_lock_unlock(struct mmc_card *car
 		data_size = 2 + mpayload->datalen;
 	}
 
-	data_buf = kmalloc(data_size, GFP_KERNEL);
+	data_buf = kzalloc(data_size, GFP_KERNEL);
 	if (!data_buf)
 		return -ENOMEM;
-	memset(data_buf, 0, data_size);
 
 	data_buf[0] |= mode;
 	if (mode & MMC_LOCK_MODE_UNLOCK)
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
