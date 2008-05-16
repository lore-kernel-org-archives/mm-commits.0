From: akpm@linux-foundation.org
Subject: - fix-lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz.patch removed from -mm tree
Date: Fri, 16 May 2008 15:52:33 -0700
Message-ID: <200805162252.m4GMqXk4003051@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756911AbYEPWxO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 May 2008 18:53:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JRottmann@LiPPERT-AT.de, dilinger@debian.org, jordan.crouse@amd.com, mm-commits@vger.kernel.org


The patch titled
     fix "lxfb: extend PLL table to support dotclocks below 25 MHz"
has been removed from the -mm tree.  Its filename was
     fix-lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix "lxfb: extend PLL table to support dotclocks below 25 MHz"
From: Jens Rottmann <JRottmann@LiPPERT-AT.de>

The following patch caused a regression with OLPC panels:

 commit 3888d4639e78802c4ec1086127124e890461b9e4
    lxfb: extend PLL table to support dotclocks below 25 MHz

    Extends the PLL frequency table of the AMD Geode-LX frame buffer driver to
    make use of the DIV4 bit, thus adding support for dotclocks between 6 and 25
    MHz.  These are needed for small LCDs (e.g.  320x240).  Also inserts some
    intermediate steps between pre-existing frequencies.

The problem was the insertion of intermediate steps into the frequency
table; they would cause the wrong frequency to be matched.  This patch
drops those intermediate frequencies while keeping the sub-25MHz
frequencies.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Signed-off-by: Jens Rottmann <JRottmann@LiPPERT-AT.de>
Tested-by: Andres Salomon <dilinger@debian.org>
Acked-by: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/lxfb_ops.c |   22 ----------------------
 1 file changed, 22 deletions(-)

diff -puN drivers/video/geode/lxfb_ops.c~fix-lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz drivers/video/geode/lxfb_ops.c
--- a/drivers/video/geode/lxfb_ops.c~fix-lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz
+++ a/drivers/video/geode/lxfb_ops.c
@@ -63,54 +63,32 @@ static const struct {
   { 0x00014284,  19688 },
   { 0x00011104,  20400 },
   { 0x00016363,  23625 },
-  { 0x00015303,  24380 },
   { 0x000031AC,  24923 },
   { 0x0000215D,  25175 },
   { 0x00001087,  27000 },
   { 0x0000216C,  28322 },
   { 0x0000218D,  28560 },
-  { 0x00010041,  29913 },
   { 0x000010C9,  31200 },
   { 0x00003147,  31500 },
-  { 0x000141A1,  32400 },
   { 0x000010A7,  33032 },
-  { 0x00012182,  33375 },
-  { 0x000141B1,  33750 },
   { 0x00002159,  35112 },
   { 0x00004249,  35500 },
   { 0x00000057,  36000 },
-  { 0x000141E1,  37125 },
   { 0x0000219A,  37889 },
   { 0x00002158,  39168 },
   { 0x00000045,  40000 },
-  { 0x000131A1,  40500 },
-  { 0x00010061,  42301 },
   { 0x00000089,  43163 },
-  { 0x00012151,  43875 },
   { 0x000010E7,  44900 },
   { 0x00002136,  45720 },
-  { 0x000152E1,  47250 },
-  { 0x00010071,  48000 },
   { 0x00003207,  49500 },
   { 0x00002187,  50000 },
-  { 0x00014291,  50625 },
-  { 0x00011101,  51188 },
-  { 0x00017481,  54563 },
   { 0x00004286,  56250 },
-  { 0x00014170,  57375 },
-  { 0x00016210,  58500 },
   { 0x000010E5,  60065 },
-  { 0x00013140,  62796 },
   { 0x00004214,  65000 },
-  { 0x00016250,  65250 },
   { 0x00001105,  68179 },
-  { 0x000141C0,  69600 },
-  { 0x00015220,  70160 },
-  { 0x00010050,  72000 },
   { 0x000031E4,  74250 },
   { 0x00003183,  75000 },
   { 0x00004284,  78750 },
-  { 0x00012130,  80052 },
   { 0x00001104,  81600 },
   { 0x00006363,  94500 },
   { 0x00005303,  97520 },
_

Patches currently in -mm which might be from JRottmann@LiPPERT-AT.de are

origin.patch

