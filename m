From: akpm@linux-foundation.org
Subject: + drivers-video-ep93xx-fbc-include-linux-ioh-for-devm_ioremap.patch added to -mm tree
Date: Wed, 20 Mar 2013 14:22:16 -0700
Message-ID: <20130320212216.7E17C5A409A@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:56943 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab3CTVWR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Mar 2013 17:22:17 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so200987vcb.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Mar 2013 14:22:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, FlorianSchandinat@gmx.de, damien.cassou@lifl.fr, hsweeten@visionengravers.com, rmallon@gmail.com, stable@vger.kernel.org


The patch titled
     Subject: drivers/video/ep93xx-fb.c: include <linux/io.h> for devm_ioremap()
has been added to the -mm tree.  Its filename is
     drivers-video-ep93xx-fbc-include-linux-ioh-for-devm_ioremap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
drivers-video-ep93xx-fbc-include-linux-ioh-for-devm_ioremap.patch

