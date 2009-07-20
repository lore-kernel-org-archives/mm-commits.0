From: akpm@linux-foundation.org
Subject: + drivers-video-imxfbc-fix-resource-size-off-by-1-error.patch added to -mm tree
Date: Mon, 20 Jul 2009 12:43:10 -0700
Message-ID: <200907201943.n6KJhAMr015041@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751555AbZGTToT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jul 2009 15:44:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, golbi@mat.uni.torun.pl, s.hauer@pengutronix.de


The patch titled
     drivers/video/imxfb.c: fix resource size off by 1 error
has been added to the -mm tree.  Its filename is
     drivers-video-imxfbc-fix-resource-size-off-by-1-error.patch

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
Subject: drivers/video/imxfb.c: fix resource size off by 1 error
From: Julia Lawall <julia@diku.dk>

In the first case, the change is not semantics-preserving, but
resource_size is used at the corresponding call to request_mem_region in
the same function.

In the second case, the change is semantics-preserving.

The problem was found using the following semantic patch:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
struct resource *res;
@@

- (res->end - res->start) + 1
+ resource_size(res)

@@
struct resource *res;
@@

- res->end - res->start
+ BAD(resource_size(res))
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Krzysztof Benedyczak <golbi@mat.uni.torun.pl>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/imxfb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/imxfb.c~drivers-video-imxfbc-fix-resource-size-off-by-1-error drivers/video/imxfb.c
--- a/drivers/video/imxfb.c~drivers-video-imxfbc-fix-resource-size-off-by-1-error
+++ a/drivers/video/imxfb.c
@@ -754,7 +754,7 @@ failed_map:
 failed_getclock:
 	iounmap(fbi->regs);
 failed_ioremap:
-	release_mem_region(res->start, res->end - res->start);
+	release_mem_region(res->start, resource_size(res));
 failed_req:
 	kfree(info->pseudo_palette);
 failed_init:
@@ -785,7 +785,7 @@ static int __devexit imxfb_remove(struct
 	framebuffer_release(info);
 
 	iounmap(fbi->regs);
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 	clk_disable(fbi->clk);
 	clk_put(fbi->clk);
 
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-video-imxfbc-fix-resource-size-off-by-1-error.patch
edac-fix-resource-size-calculation.patch

