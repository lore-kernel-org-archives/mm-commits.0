From: akpm@linux-foundation.org
Subject: + atyfb-correct_chipset-can-fail.patch added to -mm tree
Date: Wed, 04 Jun 2008 16:45:17 -0700
Message-ID: <200806042345.m54NjHNC015315@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51537 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755184AbYFDXpx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 19:45:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: syrjala@sci.fi, adaplas@pol.net, krzysztof.h1@poczta.fm


The patch titled
     atyfb: correct_chipset() can fail
has been added to the -mm tree.  Its filename is
     atyfb-correct_chipset-can-fail.patch

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
Subject: atyfb: correct_chipset() can fail
From: Ville Syrjala <syrjala@sci.fi>

Atari probe code relies on correct_chipset() failing if the device is not
a mach64 GX/CX.  aty_chips[] array would be indexed with -1 in that case.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/atyfb_base.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/video/aty/atyfb_base.c~atyfb-correct_chipset-can-fail drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~atyfb-correct_chipset-can-fail
+++ a/drivers/video/aty/atyfb_base.c
@@ -424,7 +424,6 @@ static struct {
 #endif /* CONFIG_FB_ATY_CT */
 };
 
-/* can not fail */
 static int __devinit correct_chipset(struct atyfb_par *par)
 {
 	u8 rev;
@@ -437,6 +436,9 @@ static int __devinit correct_chipset(str
 		if (par->pci_id == aty_chips[i].pci_id)
 			break;
 
+	if (i < 0)
+		return -ENODEV;
+
 	name = aty_chips[i].name;
 	par->pll_limits.pll_max = aty_chips[i].pll;
 	par->pll_limits.mclk = aty_chips[i].mclk;
_

Patches currently in -mm which might be from syrjala@sci.fi are

fbdev-width-and-height-are-unsigned.patch
fbdev-xoffset-yoffset-and-yres-are-unsigned.patch
atyfb-remove-dead-code.patch
atyfb-correct_chipset-can-fail.patch
atyfb-use-a-pci-device-id-table.patch
atyfb-report-probe-errors.patch
atyfb-fix-a-cast.patch

