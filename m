From: akpm@linux-foundation.org
Subject: + atyfb-kill-dead-code.patch added to -mm tree
Date: Tue, 27 Feb 2007 13:10:16 -0800
Message-ID: <200702272110.l1RLAKeA028704@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52311 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbXB0VKY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 16:10:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     atyfb: kill dead code
has been added to the -mm tree.  Its filename is
     atyfb-kill-dead-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atyfb: kill dead code
From: "Antonino A. Daplas" <adaplas@gmail.com>

Coverity Bug 68, kill dead code.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/atyfb_base.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/video/aty/atyfb_base.c~atyfb-kill-dead-code drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~atyfb-kill-dead-code
+++ a/drivers/video/aty/atyfb_base.c
@@ -2332,6 +2332,7 @@ static int __devinit aty_init(struct fb_
 		case DAC_IBMRGB514:
 			par->dac_ops = &aty_dac_ibm514;
 			break;
+#ifdef CONFIG_ATARI
 		case DAC_ATI68860_B:
 		case DAC_ATI68860_C:
 			par->dac_ops = &aty_dac_ati68860b;
@@ -2340,6 +2341,7 @@ static int __devinit aty_init(struct fb_
 		case DAC_ATT21C498:
 			par->dac_ops = &aty_dac_att21c498;
 			break;
+#endif
 		default:
 			PRINTKI("aty_init: DAC type not implemented yet!\n");
 			par->dac_ops = &aty_dac_unsupported;
_

Patches currently in -mm which might be from adaplas@gmail.com are

patch-maintainers-update-email-address.patch
atyfb-fix-kconfig-error.patch
fbdev-add-ultrasharp-uxga-to-broken-monitor-database.patch
intelfb-fix-ring-space-calculation.patch
nvidiafb-bring-back-generic-ddc-reading.patch
fbdev-ignore-vesa-modes-if-framebuffer-is-disabled.patch
fbdev-fix-obvious-bug-in-show_pan.patch
neofb-fill-transp-msb_right-with-the-correct.patch
atyfb-kill-dead-code.patch
fbdev-mm-deferred-io-support.patch
fbdev-hecuba-framebuffer-driver.patch
