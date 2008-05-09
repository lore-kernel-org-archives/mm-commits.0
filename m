From: akpm@linux-foundation.org
Subject: + tridentfb-improve-probe-function.patch added to -mm tree
Date: Fri, 09 May 2008 14:04:08 -0700
Message-ID: <200805092104.m49L48Qm025555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753120AbYEIVEk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 17:04:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     tridentfb: improve probe function
has been added to the -mm tree.  Its filename is
     tridentfb-improve-probe-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tridentfb: improve probe function
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Add missing release of allocated fb_info structure and move enable_mmio() to
fix error path.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-improve-probe-function drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-improve-probe-function
+++ a/drivers/video/tridentfb.c
@@ -1287,6 +1287,7 @@ static int __devinit trident_pci_probe(s
 
 	if (!request_mem_region(tridentfb_fix.mmio_start, tridentfb_fix.mmio_len, "tridentfb")) {
 		debug("request_region failed!\n");
+		framebuffer_release(info);
 		return -1;
 	}
 
@@ -1299,8 +1300,6 @@ static int __devinit trident_pci_probe(s
 		goto out_unmap1;
 	}
 
-	enable_mmio();
-
 	/* setup framebuffer memory */
 	tridentfb_fix.smem_start = pci_resource_start(dev, 0);
 	tridentfb_fix.smem_len = get_memsize(default_par);
@@ -1312,6 +1311,8 @@ static int __devinit trident_pci_probe(s
 		goto out_unmap1;
 	}
 
+	enable_mmio();
+
 	info->screen_base = ioremap_nocache(tridentfb_fix.smem_start,
 					    tridentfb_fix.smem_len);
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

tridentfb-remove-misplaced-enable_mmio.patch
tridentfb-improve-clock-setting-accuracy.patch
drivers-video-pnx4008-eliminate-double-free.patch
tridentfb-replace-macros-with-functions.patch
tridentfb-convert-fb_info-into-allocated-one.patch
tridentfb-move-global-pseudo-palette-into-structure.patch
tridentfb-move-global-chip_id-into-structure.patch
tridentfb-move-global-flat-panel-variable-into-structure.patch
tridentfb-convert-is_blade-and-is_xp-macros-into-functions.patch
tridentfb-move-global-acceleration-hooks-into-structure.patch
tridentfb-make-use-of-functions-and-constants-from-the-vgah.patch
tridentfb-fix-timing-calculations.patch
tridentfb-use-mmio-access-for-clock-setting.patch
tridentfb-fix-clock-settings-for-older-trident-96xx-chips.patch
tridentfb-improve-probe-function.patch
amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch

