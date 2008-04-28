From: akpm@linux-foundation.org
Subject: - lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:58:46 -0700
Message-ID: <200804282158.m3SLwkv6018516@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35806 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965403AbYD1V64 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:58:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JRottmann@LiPPERT-AT.de, adaplas@pol.net, jordan.crouse@amd.com, mm-commits@vger.kernel.org


The patch titled
     lxfb: extend PLL table to support dotclocks below 25 MHz
has been removed from the -mm tree.  Its filename was
     lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lxfb: extend PLL table to support dotclocks below 25 MHz
From: Jens Rottmann <JRottmann@LiPPERT-AT.de>

Extends the PLL frequency table of the AMD Geode-LX frame buffer driver to
make use of the DIV4 bit, thus adding support for dotclocks between 6 and 25
MHz.  These are needed for small LCDs (e.g.  320x240).  Also inserts some
intermediate steps between pre-existing frequencies.

Signed-off-by: Jens Rottmann <JRottmann@LiPPERT-AT.de>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/lxfb_ops.c |  112 ++++++++++++++++++++++---------
 1 file changed, 81 insertions(+), 31 deletions(-)

diff -puN drivers/video/geode/lxfb_ops.c~lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz drivers/video/geode/lxfb_ops.c
--- a/drivers/video/geode/lxfb_ops.c~lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz
+++ a/drivers/video/geode/lxfb_ops.c
@@ -35,35 +35,85 @@ static const struct {
   unsigned int pllval;
   unsigned int freq;
 } pll_table[] = {
-  { 0x000031AC, 24923 },
-  { 0x0000215D, 25175 },
-  { 0x00001087, 27000 },
-  { 0x0000216C, 28322 },
-  { 0x0000218D, 28560 },
-  { 0x000010C9, 31200 },
-  { 0x00003147, 31500 },
-  { 0x000010A7, 33032 },
-  { 0x00002159, 35112 },
-  { 0x00004249, 35500 },
-  { 0x00000057, 36000 },
-  { 0x0000219A, 37889 },
-  { 0x00002158, 39168 },
-  { 0x00000045, 40000 },
-  { 0x00000089, 43163 },
-  { 0x000010E7, 44900 },
-  { 0x00002136, 45720 },
-  { 0x00003207, 49500 },
-  { 0x00002187, 50000 },
-  { 0x00004286, 56250 },
-  { 0x000010E5, 60065 },
-  { 0x00004214, 65000 },
-  { 0x00001105, 68179 },
-  { 0x000031E4, 74250 },
-  { 0x00003183, 75000 },
-  { 0x00004284, 78750 },
-  { 0x00001104, 81600 },
-  { 0x00006363, 94500 },
-  { 0x00005303, 97520 },
+  { 0x000131AC,   6231 },
+  { 0x0001215D,   6294 },
+  { 0x00011087,   6750 },
+  { 0x0001216C,   7081 },
+  { 0x0001218D,   7140 },
+  { 0x000110C9,   7800 },
+  { 0x00013147,   7875 },
+  { 0x000110A7,   8258 },
+  { 0x00012159,   8778 },
+  { 0x00014249,   8875 },
+  { 0x00010057,   9000 },
+  { 0x0001219A,   9472 },
+  { 0x00012158,   9792 },
+  { 0x00010045,  10000 },
+  { 0x00010089,  10791 },
+  { 0x000110E7,  11225 },
+  { 0x00012136,  11430 },
+  { 0x00013207,  12375 },
+  { 0x00012187,  12500 },
+  { 0x00014286,  14063 },
+  { 0x000110E5,  15016 },
+  { 0x00014214,  16250 },
+  { 0x00011105,  17045 },
+  { 0x000131E4,  18563 },
+  { 0x00013183,  18750 },
+  { 0x00014284,  19688 },
+  { 0x00011104,  20400 },
+  { 0x00016363,  23625 },
+  { 0x00015303,  24380 },
+  { 0x000031AC,  24923 },
+  { 0x0000215D,  25175 },
+  { 0x00001087,  27000 },
+  { 0x0000216C,  28322 },
+  { 0x0000218D,  28560 },
+  { 0x00010041,  29913 },
+  { 0x000010C9,  31200 },
+  { 0x00003147,  31500 },
+  { 0x000141A1,  32400 },
+  { 0x000010A7,  33032 },
+  { 0x00012182,  33375 },
+  { 0x000141B1,  33750 },
+  { 0x00002159,  35112 },
+  { 0x00004249,  35500 },
+  { 0x00000057,  36000 },
+  { 0x000141E1,  37125 },
+  { 0x0000219A,  37889 },
+  { 0x00002158,  39168 },
+  { 0x00000045,  40000 },
+  { 0x000131A1,  40500 },
+  { 0x00010061,  42301 },
+  { 0x00000089,  43163 },
+  { 0x00012151,  43875 },
+  { 0x000010E7,  44900 },
+  { 0x00002136,  45720 },
+  { 0x000152E1,  47250 },
+  { 0x00010071,  48000 },
+  { 0x00003207,  49500 },
+  { 0x00002187,  50000 },
+  { 0x00014291,  50625 },
+  { 0x00011101,  51188 },
+  { 0x00017481,  54563 },
+  { 0x00004286,  56250 },
+  { 0x00014170,  57375 },
+  { 0x00016210,  58500 },
+  { 0x000010E5,  60065 },
+  { 0x00013140,  62796 },
+  { 0x00004214,  65000 },
+  { 0x00016250,  65250 },
+  { 0x00001105,  68179 },
+  { 0x000141C0,  69600 },
+  { 0x00015220,  70160 },
+  { 0x00010050,  72000 },
+  { 0x000031E4,  74250 },
+  { 0x00003183,  75000 },
+  { 0x00004284,  78750 },
+  { 0x00012130,  80052 },
+  { 0x00001104,  81600 },
+  { 0x00006363,  94500 },
+  { 0x00005303,  97520 },
   { 0x00002183, 100187 },
   { 0x00002122, 101420 },
   { 0x00001081, 108000 },
@@ -138,7 +188,7 @@ static void lx_set_clock(struct fb_info 
 	unsigned int diff, min, best = 0;
 	unsigned int freq, i;
 
-	freq = (unsigned int) (0x3b9aca00 / info->var.pixclock);
+	freq = (unsigned int) (1000000000 / info->var.pixclock);
 
 	min = abs(pll_table[0].freq - freq);
 
@@ -150,7 +200,7 @@ static void lx_set_clock(struct fb_info 
 		}
 	}
 
-	lx_set_dotpll(pll_table[best].pllval & 0x7FFF);
+	lx_set_dotpll(pll_table[best].pllval & 0x00017FFF);
 }
 
 static void lx_graphics_disable(struct fb_info *info)
_

Patches currently in -mm which might be from JRottmann@LiPPERT-AT.de are

origin.patch

