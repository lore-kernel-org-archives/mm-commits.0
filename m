From: akpm@linux-foundation.org
Subject: - mips-turbochannel-update-to-the-driver-model-fix.patch removed from -mm tree
Date: Fri, 09 Feb 2007 21:25:51 -0800
Message-ID: <200702100525.l1A5PpPq004620@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36940 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbXBJF3U (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 00:29:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mips: TURBOchannel resources off-by-one fix
has been removed from the -mm tree.  Its filename was
     mips-turbochannel-update-to-the-driver-model-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mips: TURBOchannel resources off-by-one fix
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Fix resource reservation of TURBOchannel areas, where the end is one byte
too far.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tc/tc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/tc/tc.c~mips-turbochannel-update-to-the-driver-model-fix drivers/tc/tc.c
--- a/drivers/tc/tc.c~mips-turbochannel-update-to-the-driver-model-fix
+++ a/drivers/tc/tc.c
@@ -160,7 +160,7 @@ static int __init tc_init(void)
 		tc_bus.resource[0].start = tc_bus.slot_base;
 		tc_bus.resource[0].end = tc_bus.slot_base +
 					 (tc_bus.info.slot_size << 20) *
-					 tc_bus.num_tcslots;
+					 tc_bus.num_tcslots - 1;
 		tc_bus.resource[0].name = tc_bus.name;
 		tc_bus.resource[0].flags = IORESOURCE_MEM;
 		if (request_resource(&iomem_resource,
@@ -172,7 +172,7 @@ static int __init tc_init(void)
 			tc_bus.resource[1].start = tc_bus.ext_slot_base;
 			tc_bus.resource[1].end = tc_bus.ext_slot_base +
 						 tc_bus.ext_slot_size *
-						 tc_bus.num_tcslots;
+						 tc_bus.num_tcslots - 1;
 			tc_bus.resource[1].name = tc_bus.name;
 			tc_bus.resource[1].flags = IORESOURCE_MEM;
 			if (request_resource(&iomem_resource,
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
tgafb-switch-to-framebuffer_alloc.patch
tgafb-fix-copying-overlapping-areas.patch
tgafb-support-the-directcolor-visual.patch
tgafb-fix-the-mode-register-setting.patch
tgafb-module-support-fixes.patch
tgafb-sync-on-green-support-fixes.patch
tgafb-fix-the-pci-id-table.patch
