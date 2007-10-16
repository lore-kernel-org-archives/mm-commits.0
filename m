From: akpm@linux-foundation.org
Subject: - nvidiafb-correctly-assign-the-i2c-class-with-the-port-reversal.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:44:54 -0700
Message-ID: <200710162044.l9GKisYI016206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58974 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765401AbXJPU7J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:59:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     nvidiafb: Correctly assign the i2c class with the port reversal
has been removed from the -mm tree.  Its filename was
     nvidiafb-correctly-assign-the-i2c-class-with-the-port-reversal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nvidiafb: Correctly assign the i2c class with the port reversal
From: "Antonino A. Daplas" <adaplas@gmail.com>

If the i2c ports are to be reversed, I2C_CLASS_HWMON assignment must also be
reversed.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nv_i2c.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/video/nvidia/nv_i2c.c~nvidiafb-correctly-assign-the-i2c-class-with-the-port-reversal drivers/video/nvidia/nv_i2c.c
--- a/drivers/video/nvidia/nv_i2c.c~nvidiafb-correctly-assign-the-i2c-class-with-the-port-reversal
+++ a/drivers/video/nvidia/nv_i2c.c
@@ -126,10 +126,12 @@ void nvidia_create_i2c_busses(struct nvi
 	par->chan[2].par = par;
 
 	par->chan[0].ddc_base = (par->reverse_i2c) ? 0x36 : 0x3e;
- 	nvidia_setup_i2c_bus(&par->chan[0], "nvidia #0", 0);
+ 	nvidia_setup_i2c_bus(&par->chan[0], "nvidia #0",
+			     (par->reverse_i2c) ? I2C_CLASS_HWMON : 0);
 
 	par->chan[1].ddc_base = (par->reverse_i2c) ? 0x3e : 0x36;
- 	nvidia_setup_i2c_bus(&par->chan[1], "nvidia #1", I2C_CLASS_HWMON);
+ 	nvidia_setup_i2c_bus(&par->chan[1], "nvidia #1",
+			     (par->reverse_i2c) ? 0 : I2C_CLASS_HWMON);
 
 	par->chan[2].ddc_base = 0x50;
  	nvidia_setup_i2c_bus(&par->chan[2], "nvidia #2", 0);
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
fbcon-delay-the-start-of-the-cursor-timer-until-a-con_switch.patch
cyber2000fb-checkpatch-fixes.patch
