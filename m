From: akpm@osdl.org
Subject: + mips-turbochannel-update-to-the-driver-model-fix.patch added to -mm tree
Date: Thu, 11 Jan 2007 13:40:15 -0800
Message-ID: <200701112140.l0BLeFjb003838@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36939 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbXAKVkg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 16:40:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, ralf@linux-mips.org


The patch titled
     mips: TURBOchannel resources off-by-one fix
has been added to the -mm tree.  Its filename is
     mips-turbochannel-update-to-the-driver-model-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mips: TURBOchannel resources off-by-one fix
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Fix resource reservation of TURBOchannel areas, where the end is one byte
too far.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/tc/tc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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

mips-turbochannel-update-to-the-driver-model.patch
mips-turbochannel-update-to-the-driver-model-fix.patch
mips-turbochannel-support-for-the-decstation.patch
mips-eisa-registration-with-config_eisa.patch
mips-declance-driver-model-for-the-pmad-a.patch
mips-defxx-turbochannel-support.patch
mips-pmag-ba-fb-convert-to-the-driver-model.patch
mips-pmagb-b-fb-convert-to-the-driver-model.patch
mips-dec_esp-driver-model-for-the-pmaz-a.patch
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
