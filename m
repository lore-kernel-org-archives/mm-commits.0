From: akpm@linux-foundation.org
Subject: [merged] drivers-video-ep93xx-fbc-include-linux-ioh-for-devm_ioremap.patch removed from -mm tree
Date: Mon, 25 Mar 2013 12:45:13 -0700
Message-ID: <20130325194513.7EE085A419C__22050.9138460786$1364240746$gmane$org@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:63799 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932858Ab3CYTpP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Mar 2013 15:45:15 -0400
Received: by mail-vc0-f201.google.com with SMTP id hf12so653490vcb.0
        for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2013 12:45:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, FlorianSchandinat@gmx.de, damien.cassou@lifl.fr, hsweeten@visionengravers.com, rmallon@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/ep93xx-fb.c: include <linux/io.h> for devm_ioremap()
has been removed from the -mm tree.  Its filename was
     drivers-video-ep93xx-fbc-include-linux-ioh-for-devm_ioremap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: drivers/video/ep93xx-fb.c: include <linux/io.h> for devm_ioremap()

Commit be867814 ("drivers/video/ep93xx-fb.c: use devm_ functions")
introduced a build error:

drivers/video/ep93xx-fb.c: In function 'ep93xxfb_probe':
drivers/video/ep93xx-fb.c:532: error: implicit declaration of function 'devm_ioremap'
drivers/video/ep93xx-fb.c:533: warning: assignment makes pointer from integer without a cast

Include <linux/io.h> to pickup the declaration of 'devm_ioremap'.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Acked-by: Ryan Mallon <rmallon@gmail.com>
Cc: Damien Cassou <damien.cassou@lifl.fr>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ep93xx-fb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/ep93xx-fb.c~drivers-video-ep93xx-fbc-include-linux-ioh-for-devm_ioremap drivers/video/ep93xx-fb.c
--- a/drivers/video/ep93xx-fb.c~drivers-video-ep93xx-fbc-include-linux-ioh-for-devm_ioremap
+++ a/drivers/video/ep93xx-fb.c
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <linux/clk.h>
 #include <linux/fb.h>
+#include <linux/io.h>
 
 #include <linux/platform_data/video-ep93xx.h>
 
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

linux-next.patch
video-ep93xx-fbc-fix-section-mismatch-and-use-module_platform_driver.patch

