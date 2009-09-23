From: akpm@linux-foundation.org
Subject: [merged] viafb-choose-acceleration-engine-for-vx855.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:02:34 -0700
Message-ID: <200909232002.n8NK2Y9r017464@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753567AbZIWUDF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:03:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, corbet@lwn.net, mm-commits@vger.kernel.org


The patch titled
     viafb: choose acceleration engine for VX855
has been removed from the -mm tree.  Its filename was
     viafb-choose-acceleration-engine-for-vx855.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: choose acceleration engine for VX855
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Enable 2D hardware acceleration on VX855 for copyarea, imageblit and
fillrect by selecting the correct engine which is the same as in VX800.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/accel.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/via/accel.c~viafb-choose-acceleration-engine-for-vx855 drivers/video/via/accel.c
--- a/drivers/video/via/accel.c~viafb-choose-acceleration-engine-for-vx855
+++ a/drivers/video/via/accel.c
@@ -337,6 +337,7 @@ int viafb_init_engine(struct fb_info *in
 		viapar->shared->hw_bitblt = hw_bitblt_1;
 		break;
 	case UNICHROME_VX800:
+	case UNICHROME_VX855:
 		viapar->shared->hw_bitblt = hw_bitblt_2;
 		break;
 	default:
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

origin.patch

