From: akpm@linux-foundation.org
Subject: [merged] radeonfb-suspend-resume-for-ati-mobility-radeon-rv350.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:44:11 -0700
Message-ID: <200904011844.n31IiBHY010343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750824AbZDAT2a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:28:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lkml@azog.de, benh@kernel.crashing.org, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     radeonfb: suspend/resume for ATI Mobility Radeon RV350
has been removed from the -mm tree.  Its filename was
     radeonfb-suspend-resume-for-ati-mobility-radeon-rv350.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radeonfb: suspend/resume for ATI Mobility Radeon RV350
From: Wolfgang Kroener <lkml@azog.de>

Add suspend/resume for the Acer Travelmate 290D/292LMi with the following
graphic-chip:

01:00.0 VGA compatible controller [0300]: ATI Technologies Inc RV350
[Mobility Radeon 9600 M10] [1002:4e50] (prog-if 00 [VGA controller])
	Subsystem: Acer Incorporated [ALI] TravelMate 290 [1025:005a]
	Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 10
	Memory at a8000000 (32-bit, prefetchable) [size=128M]
	I/O ports at c100 [size=256]
	Memory at e0010000 (32-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at a0000000 [disabled] [size=128K]
	Capabilities: [58] AGP version 2.0
	Capabilities: [50] Power Management version 2
	Kernel driver in use: radeonfb
	Kernel modules: radeonfb

Signed-off-by: Wolfgang Kroener <lkml@azog.de>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_pm.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/video/aty/radeon_pm.c~radeonfb-suspend-resume-for-ati-mobility-radeon-rv350 drivers/video/aty/radeon_pm.c
--- a/drivers/video/aty/radeon_pm.c~radeonfb-suspend-resume-for-ati-mobility-radeon-rv350
+++ a/drivers/video/aty/radeon_pm.c
@@ -89,6 +89,9 @@ static struct radeon_device_id radeon_wo
 	BUGFIX("Acer Aspire 2010",
 	       PCI_VENDOR_ID_AI, 0x0061,
 	       radeon_pm_off, radeon_reinitialize_M10),
+	BUGFIX("Acer Travelmate 290D/292LMi",
+	       PCI_VENDOR_ID_AI, 0x005a,
+	       radeon_pm_off, radeon_reinitialize_M10),
 	{ .ident = NULL }
 };
 
_

Patches currently in -mm which might be from lkml@azog.de are

origin.patch

