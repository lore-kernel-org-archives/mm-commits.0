From: akpm@linux-foundation.org
Subject: + lxfb-use-the-correct-msr-number-for-panel-support.patch added to -mm tree
Date: Thu, 01 Nov 2007 14:07:59 -0700
Message-ID: <200711012107.lA1L7xfX015517@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50973 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754054AbXKAVIs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 17:08:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jordan.crouse@amd.com, adaplas@pol.net, hpa@zytor.com


The patch titled
     LXFB: use the correct MSR number for panel support
has been added to the -mm tree.  Its filename is
     lxfb-use-the-correct-msr-number-for-panel-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: LXFB: use the correct MSR number for panel support
From: Jordan Crouse <jordan.crouse@amd.com>

A relatively recent version of the Geode LX datasheet listed the wrong
address for one of the MSRs that controls TFT panels, resulting in
breakage.  This patch corrects the MSR address.

Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/lxfb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/geode/lxfb.h~lxfb-use-the-correct-msr-number-for-panel-support drivers/video/geode/lxfb.h
--- a/drivers/video/geode/lxfb.h~lxfb-use-the-correct-msr-number-for-panel-support
+++ a/drivers/video/geode/lxfb.h
@@ -33,7 +33,7 @@ void lx_set_palette_reg(struct fb_info *
 
 #define MSR_LX_GLD_CONFIG    0x48002001
 #define MSR_LX_GLCP_DOTPLL   0x4c000015
-#define MSR_LX_DF_PADSEL     0x48000011
+#define MSR_LX_DF_PADSEL     0x48002011
 #define MSR_LX_DC_SPARE      0x80000011
 #define MSR_LX_DF_GLCONFIG   0x48002001
 
_

Patches currently in -mm which might be from jordan.crouse@amd.com are

lxfb-use-the-correct-msr-number-for-panel-support.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
