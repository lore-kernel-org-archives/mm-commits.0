From: akpm@linux-foundation.org
Subject: + drivers-media-video-gspca-introduce-missing-kfree.patch added to -mm tree
Date: Mon, 03 Aug 2009 15:49:22 -0700
Message-ID: <200908032249.n73MnMnI025289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753067AbZHCWtg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Aug 2009 18:49:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, erik.andren@gmail.com, mchehab@infradead.org


The patch titled
     drivers/media/video/gspca: introduce missing kfree
has been added to the -mm tree.  Its filename is
     drivers-media-video-gspca-introduce-missing-kfree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/video/gspca: introduce missing kfree
From: Julia Lawall <julia@diku.dk>

Error handling code following a kmalloc should free the allocated data.

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,f1,l;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Erik Andren <erik.andren@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/gspca/m5602/m5602_s5k83a.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/media/video/gspca/m5602/m5602_s5k83a.c~drivers-media-video-gspca-introduce-missing-kfree drivers/media/video/gspca/m5602/m5602_s5k83a.c
--- a/drivers/media/video/gspca/m5602/m5602_s5k83a.c~drivers-media-video-gspca-introduce-missing-kfree
+++ a/drivers/media/video/gspca/m5602/m5602_s5k83a.c
@@ -178,8 +178,10 @@ sensor_found:
 
 	sens_priv->settings =
 	kmalloc(sizeof(s32)*ARRAY_SIZE(s5k83a_ctrls), GFP_KERNEL);
-	if (!sens_priv->settings)
+	if (!sens_priv->settings) {
+		kfree(sens_priv);
 		return -ENOMEM;
+	}
 
 	sd->gspca_dev.cam.cam_mode = s5k83a_modes;
 	sd->gspca_dev.cam.nmodes = ARRAY_SIZE(s5k83a_modes);
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-media-dvb-use-dst_type-field-instead-of-type_flags.patch
drivers-ata-use-resource_size.patch
drivers-mmc-correct-error-handling-code.patch
drivers-rtc-correct-error-handling-code.patch
drivers-video-imxfbc-fix-resource-size-off-by-1-error.patch
drivers-video-add-kmalloc-null-tests.patch
drivers-video-add-kmalloc-null-tests-fix.patch
edac-fix-resource-size-calculation.patch
fs-romfs-correct-error-handling-code.patch
drivers-vlynq-vlynqc-fix-resource-size-off-by-1-error.patch
drivers-media-video-gspca-introduce-missing-kfree.patch

