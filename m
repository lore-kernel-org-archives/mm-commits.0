From: akpm@linux-foundation.org
Subject: - nvidiafb-fix-reversed-ddc-port.patch removed from -mm tree
Date: Tue, 08 May 2007 19:59:56 -0700
Message-ID: <200705090259.l492xu5q010473@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032773AbXEIDAI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:00:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vandrove@vc.cvut.cz, adaplas@gmail.com, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     nvidiafb: Fix reversed DDC port
has been removed from the -mm tree.  Its filename was
     nvidiafb-fix-reversed-ddc-port.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nvidiafb: Fix reversed DDC port
From: Petr Vandrovec <vandrove@vc.cvut.cz>

After I added some debugging printks I've found that code became a bit
confused because it believed that primary monitor is 1920x540, but later it
found in CRTC0's registers that panel size is 1920x1200 (Windows also agree
that 1920x1200 is primary monitor, and 1920x1080i secondary one).

When I applied attached patch then my monitor became as happy as it was
before I connected HDMI cable to secondary output.

Signed-off-by: Petr Vandrovec <vandrove@vc.cvut.cz>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nv_i2c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/nvidia/nv_i2c.c~nvidiafb-fix-reversed-ddc-port drivers/video/nvidia/nv_i2c.c
--- a/drivers/video/nvidia/nv_i2c.c~nvidiafb-fix-reversed-ddc-port
+++ a/drivers/video/nvidia/nv_i2c.c
@@ -131,10 +131,10 @@ void nvidia_create_i2c_busses(struct nvi
 	par->chan[1].par = par;
 	par->chan[2].par = par;
 
-	par->chan[0].ddc_base = 0x3e;
+	par->chan[0].ddc_base = 0x36;
 	nvidia_setup_i2c_bus(&par->chan[0], "nvidia #0");
 
-	par->chan[1].ddc_base = 0x36;
+	par->chan[1].ddc_base = 0x3e;
 	nvidia_setup_i2c_bus(&par->chan[1], "nvidia #1");
 
 	par->chan[2].ddc_base = 0x50;
_

Patches currently in -mm which might be from vandrove@vc.cvut.cz are

origin.patch
