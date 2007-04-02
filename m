From: akpm@linux-foundation.org
Subject: + nvidiafb-fix-reversed-ddc-port.patch added to -mm tree
Date: Sun, 01 Apr 2007 22:24:52 -0700
Message-ID: <200704020524.l325OqsO024904@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35938 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbXDBFZB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 01:25:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vandrove@vc.cvut.cz, adaplas@gmail.com, airlied@linux.ie


The patch titled
     nvidiafb: Fix reversed DDC port
has been added to the -mm tree.  Its filename is
     nvidiafb-fix-reversed-ddc-port.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

nvidiafb-fix-reversed-ddc-port.patch
