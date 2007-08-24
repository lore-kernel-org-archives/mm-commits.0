From: akpm@linux-foundation.org
Subject: - drivers-mmc-core-hostc-kmalloc-memset-conversion-to-kzalloc.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:57:44 -0700
Message-ID: <200708242057.l7OKvi39014244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43440 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762857AbXHXVIs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, drzeus-list@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     drivers/mmc/core/host.c: kmalloc + memset conversion to kzalloc
has been removed from the -mm tree.  Its filename was
     drivers-mmc-core-hostc-kmalloc-memset-conversion-to-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/mmc/core/host.c: kmalloc + memset conversion to kzalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/mmc/core/host.c | 3509 -> 3457 (-52 bytes)
 drivers/mmc/core/host.o | 92400 -> 92136 (-264 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/host.c |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/mmc/core/host.c~drivers-mmc-core-hostc-kmalloc-memset-conversion-to-kzalloc drivers/mmc/core/host.c
--- a/drivers/mmc/core/host.c~drivers-mmc-core-hostc-kmalloc-memset-conversion-to-kzalloc
+++ a/drivers/mmc/core/host.c
@@ -58,12 +58,10 @@ struct mmc_host *mmc_alloc_host(int extr
 {
 	struct mmc_host *host;
 
-	host = kmalloc(sizeof(struct mmc_host) + extra, GFP_KERNEL);
+	host = kzalloc(sizeof(struct mmc_host) + extra, GFP_KERNEL);
 	if (!host)
 		return NULL;
 
-	memset(host, 0, sizeof(struct mmc_host) + extra);
-
 	host->parent = dev;
 	host->class_dev.parent = dev;
 	host->class_dev.class = &mmc_host_class;
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
