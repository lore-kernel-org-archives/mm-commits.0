From: akpm@linux-foundation.org
Subject: + atyfb-force-29mhz-xtal-on-g3-powerbooks.patch added to -mm tree
Date: Mon, 10 Sep 2007 01:33:33 -0700
Message-ID: <200709100833.l8A8XXVq015461@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48193 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755446AbXIJIdv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Sep 2007 04:33:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olaf@aepfle.de, adaplas@pol.net, akpm@linux-foundation.org, benh@kernel.crashing.org, paulus@samba.org, syrjala@sci.fi


The patch titled
     atyfb: force 29MHz xtal on G3 PowerBooks
has been added to the -mm tree.  Its filename is
     atyfb-force-29mhz-xtal-on-g3-powerbooks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atyfb: force 29MHz xtal on G3 PowerBooks
From: Olaf Hering <olaf@aepfle.de>

The atyfb does not work on my 233MHz PowerBook with Mach64 LP, when the
kernel is booted from firmware.  aty_ld_pll_ct() returns 0x22 and xtal
remains at 14.31818.  When booted from MacOS, aty_ld_pll_ct() returns 0x3c
and xtal is changed to 29.498928.  Google indicates that all 4 PowerBook
models need the higher value.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Cc: Ville Syrjala <syrjala@sci.fi>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/atyfb_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/aty/atyfb_base.c~atyfb-force-29mhz-xtal-on-g3-powerbooks drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~atyfb-force-29mhz-xtal-on-g3-powerbooks
+++ a/drivers/video/aty/atyfb_base.c
@@ -2411,7 +2411,7 @@ static int __devinit aty_init(struct fb_
 				diff1 = -diff1;
 			if (diff2 < 0)
 				diff2 = -diff2;
-			if (diff2 < diff1) {
+			if (diff2 < diff1 || (M64_HAS(G3_PB_1024x768))) {
 				par->ref_clk_per = 1000000000000ULL / 29498928;
 				xtal = "29.498928";
 			}
_

Patches currently in -mm which might be from olaf@aepfle.de are

git-powerpc.patch
git-netdev-all.patch
atyfb-force-29mhz-xtal-on-g3-powerbooks.patch
unexport-asm-shmparamh.patch
remove-consolemaph-from-header-exports.patch
include-linux-typesh-in-if_fddih.patch
keep-track-of-network-interface-renaming.patch
