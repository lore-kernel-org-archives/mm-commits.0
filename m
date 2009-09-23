From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-introduce-missing-kfree.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:59:15 -0700
Message-ID: <200909231959.n8NJxFu3010599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753541AbZIWT7a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:59:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     drivers/rtc: introduce missing kfree
has been removed from the -mm tree.  Its filename was
     drivers-rtc-introduce-missing-kfree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
drivers-md-introduce-missing-kfree.patch
edac-fix-resource-size-calculation.patch
fs-romfs-correct-error-handling-code.patch
drivers-vlynq-vlynqc-fix-resource-size-off-by-1-error.patch

