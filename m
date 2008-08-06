From: akpm@linux-foundation.org
Subject: - drivers-video-fsl-diu-fbc-add-missing-of_node_put.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:56:57 -0700
Message-ID: <200808062056.m76KuvCT014721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754745AbYHFVBA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 17:01:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, krzysztof.h1@wp.pl, timur@freescale.com, yorksun@freescale.com, mm-commits@vger.kernel.org


The patch titled
     drivers/video/fsl-diu-fb.c: add missing of_node_put
has been removed from the -mm tree.  Its filename was
     drivers-video-fsl-diu-fbc-add-missing-of_node_put.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/fsl-diu-fb.c: add missing of_node_put
From: Julia Lawall <julia@diku.dk>

of_node_put is needed before discarding a value received from
of_find_node_by_type, eg in error handling code.

The semantic patch that makes the change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
struct device_node *n;
struct device_node *n1;
struct device_node *n2;
statement S;
identifier f1,f2;
expression E1,E2;
constant C;
@@

n = of_find_node_by_type(...)
...
if (!n) S
... when != of_node_put(n)
    when != n1 = f1(n,...)
    when != E1 = n
    when any
    when strict
(
+ of_node_put(n);
  return -C;
|
  of_node_put(n);
|
  n2 = f2(n,...)
|
  E2 = n
|
  return ...;
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Timur Tabi <timur@freescale.com>
Cc: York Sun <yorksun@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fsl-diu-fb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/video/fsl-diu-fb.c~drivers-video-fsl-diu-fbc-add-missing-of_node_put drivers/video/fsl-diu-fb.c
--- a/drivers/video/fsl-diu-fb.c~drivers-video-fsl-diu-fbc-add-missing-of_node_put
+++ a/drivers/video/fsl-diu-fb.c
@@ -1649,8 +1649,10 @@ static int __init fsl_diu_init(void)
 	}
 
 	prop = of_get_property(np, "d-cache-size", NULL);
-	if (prop == NULL)
+	if (prop == NULL) {
+		of_node_put(np);
 		return -ENODEV;
+	}
 
 	/* Freescale PLRU requires 13/8 times the cache size to do a proper
 	   displacement flush
@@ -1659,8 +1661,10 @@ static int __init fsl_diu_init(void)
 	coherence_data_size /= 8;
 
 	prop = of_get_property(np, "d-cache-line-size", NULL);
-	if (prop == NULL)
+	if (prop == NULL) {
+		of_node_put(np);
 		return -ENODEV;
+	}
 	d_cache_line_size = *prop;
 
 	of_node_put(np);
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
net-ieee80211-adjust-error-handling.patch

