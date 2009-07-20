From: akpm@linux-foundation.org
Subject: + drivers-vlynq-vlynqc-fix-resource-size-off-by-1-error.patch added to -mm tree
Date: Mon, 20 Jul 2009 12:44:57 -0700
Message-ID: <200907201944.n6KJivx0017818@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752738AbZGTTpQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jul 2009 15:45:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, florian@openwrt.org


The patch titled
     drivers/vlynq/vlynq.c: fix resource size off by 1 error
has been added to the -mm tree.  Its filename is
     drivers-vlynq-vlynqc-fix-resource-size-off-by-1-error.patch

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
Subject: drivers/vlynq/vlynq.c: fix resource size off by 1 error
From: Julia Lawall <julia@diku.dk>

In this case, the calls to request_mem_region, ioremap, and
release_mem_region all have a consistent length argument, len, but since
in other files (res->end - res->start) + 1, equivalent to
resource_size(res), is used for a resource-typed structure res, one could
consider whether the same should be done here.

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
Acked-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/vlynq/vlynq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/vlynq/vlynq.c~drivers-vlynq-vlynqc-fix-resource-size-off-by-1-error drivers/vlynq/vlynq.c
--- a/drivers/vlynq/vlynq.c~drivers-vlynq-vlynqc-fix-resource-size-off-by-1-error
+++ a/drivers/vlynq/vlynq.c
@@ -703,7 +703,7 @@ static int vlynq_probe(struct platform_d
 	dev->mem_start = mem_res->start;
 	dev->mem_end = mem_res->end;
 
-	len = regs_res->end - regs_res->start;
+	len = resource_size(regs_res);
 	if (!request_mem_region(regs_res->start, len, dev_name(&dev->dev))) {
 		printk(KERN_ERR "%s: Can't request vlynq registers\n",
 		       dev_name(&dev->dev));
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-video-imxfbc-fix-resource-size-off-by-1-error.patch
edac-fix-resource-size-calculation.patch
drivers-vlynq-vlynqc-fix-resource-size-off-by-1-error.patch

