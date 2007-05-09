From: akpm@linux-foundation.org
Subject: - atyfb-kill-dead-code.patch removed from -mm tree
Date: Tue, 08 May 2007 19:59:28 -0700
Message-ID: <200705090259.l492xSRQ010408@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970180AbXEIC7a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:59:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     atyfb: kill dead code
has been removed from the -mm tree.  Its filename was
     atyfb-kill-dead-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2338,6 +2338,7 @@ static int __devinit aty_init(struct fb_
 		case DAC_IBMRGB514:
 			par->dac_ops = &aty_dac_ibm514;
 			break;
+#ifdef CONFIG_ATARI
 		case DAC_ATI68860_B:
 		case DAC_ATI68860_C:
 			par->dac_ops = &aty_dac_ati68860b;
@@ -2346,6 +2347,7 @@ static int __devinit aty_init(struct fb_
 		case DAC_ATT21C498:
 			par->dac_ops = &aty_dac_att21c498;
 			break;
+#endif
 		default:
 			PRINTKI("aty_init: DAC type not implemented yet!\n");
 			par->dac_ops = &aty_dac_unsupported;
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
vt8623fb-fix-compile-warnings.patch
vt8623fb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compiler-warnings.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
svgalib-move-fb_get_caps-to-svgalib.patch
