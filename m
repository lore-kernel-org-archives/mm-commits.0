From: akpm@linux-foundation.org
Subject: + atyfb-fix-a-cast.patch added to -mm tree
Date: Wed, 04 Jun 2008 16:45:23 -0700
Message-ID: <200806042345.m54NjN85015327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758877AbYFDXp7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 19:45:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: syrjala@sci.fi, adaplas@pol.net, krzysztof.h1@poczta.fm


The patch titled
     atyfb: fix a cast
has been added to the -mm tree.  Its filename is
     atyfb-fix-a-cast.patch

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
Subject: atyfb: fix a cast
From: Ville Syrjala <syrjala@sci.fi>

The argument to iounmap() is void __iomem *. Fix the cast.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/atyfb_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/aty/atyfb_base.c~atyfb-fix-a-cast drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~atyfb-fix-a-cast
+++ a/drivers/video/aty/atyfb_base.c
@@ -3335,7 +3335,7 @@ static int __devinit init_from_bios(stru
 		PRINTKE("no BIOS frequency table found, use parameters\n");
 		ret = -ENXIO;
 	}
-	iounmap((void* __iomem )bios_base);
+	iounmap((void __iomem *)bios_base);
 
 	return ret;
 }
_

Patches currently in -mm which might be from syrjala@sci.fi are

fbdev-width-and-height-are-unsigned.patch
fbdev-xoffset-yoffset-and-yres-are-unsigned.patch
atyfb-remove-dead-code.patch
atyfb-correct_chipset-can-fail.patch
atyfb-use-a-pci-device-id-table.patch
atyfb-report-probe-errors.patch
atyfb-fix-a-cast.patch

