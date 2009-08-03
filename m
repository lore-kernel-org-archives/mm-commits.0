From: akpm@linux-foundation.org
Subject: + drivers-rtc-introduce-missing-kfree.patch added to -mm tree
Date: Mon, 03 Aug 2009 15:54:07 -0700
Message-ID: <200908032254.n73Ms8od000557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755056AbZHCWy0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Aug 2009 18:54:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     drivers/rtc: introduce missing kfree
has been added to the -mm tree.  Its filename is
     drivers-rtc-introduce-missing-kfree.patch

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
Subject: drivers/rtc: introduce missing kfree
From: Julia Lawall <julia@diku.dk>

Error handling code following a kzalloc should free the allocated data.

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
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ep93xx.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-ep93xx.c~drivers-rtc-introduce-missing-kfree drivers/rtc/rtc-ep93xx.c
--- a/drivers/rtc/rtc-ep93xx.c~drivers-rtc-introduce-missing-kfree
+++ a/drivers/rtc/rtc-ep93xx.c
@@ -128,12 +128,16 @@ static int __init ep93xx_rtc_probe(struc
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL)
-		return -ENXIO;
+	if (res == NULL) {
+		err = -ENXIO;
+		goto fail_free;
+	}
 
 	res = request_mem_region(res->start, resource_size(res), pdev->name);
-	if (res == NULL)
-		return -EBUSY;
+	if (res == NULL) {
+		err = -EBUSY;
+		goto fail_free;
+	}
 
 	ep93xx_rtc->mmio_base = ioremap(res->start, resource_size(res));
 	if (ep93xx_rtc->mmio_base == NULL) {
@@ -169,6 +173,8 @@ fail:
 		pdev->dev.platform_data = NULL;
 	}
 	release_mem_region(res->start, resource_size(res));
+fail_free:
+	kfree(ep93xx_rtc);
 	return err;
 }
 
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-media-dvb-use-dst_type-field-instead-of-type_flags.patch
drivers-media-video-gspca-introduce-missing-kfree.patch
drivers-ata-use-resource_size.patch
drivers-mmc-correct-error-handling-code.patch
drivers-rtc-correct-error-handling-code.patch
drivers-video-imxfbc-fix-resource-size-off-by-1-error.patch
drivers-video-add-kmalloc-null-tests.patch
drivers-video-add-kmalloc-null-tests-fix.patch
edac-fix-resource-size-calculation.patch
fs-romfs-correct-error-handling-code.patch
drivers-vlynq-vlynqc-fix-resource-size-off-by-1-error.patch
drivers-rtc-introduce-missing-kfree.patch
drivers-hid-introduce-missing-kfree.patch
drivers-md-introduce-missing-kfree.patch
drivers-ata-introduce-missing-kfree.patch

