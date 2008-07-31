From: akpm@linux-foundation.org
Subject: + drivers-video-fsl-diu-fbc-add-missing-of_node_put.patch added to -mm tree
Date: Thu, 31 Jul 2008 02:01:45 -0700
Message-ID: <200807310901.m6V91j3T014172@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752495AbYGaJCG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jul 2008 05:02:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, krzysztof.h1@wp.pl, timur@freescale.com, yorksun@freescale.com


The patch titled
     drivers/video/fsl-diu-fb.c: add missing of_node_put
has been added to the -mm tree.  Its filename is
     drivers-video-fsl-diu-fbc-add-missing-of_node_put.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
linux-next.patch
git-infiniband.patch
drivers-net-ehea-ehea_mainc-release-mutex-in-error-handling-code.patch
net-ieee80211-adjust-error-handling.patch
drivers-video-fsl-diu-fbc-add-missing-of_node_put.patch

