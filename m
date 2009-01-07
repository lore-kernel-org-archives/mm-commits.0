From: akpm@linux-foundation.org
Subject: - drivers-rtc-correct-an-error-test.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:19:28 -0800
Message-ID: <200901072219.n07MJSRE018766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760872AbZAGWUf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:20:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, a.zummo@towertech.it, bryan.wu@analog.com, david-b@pacbell.net, michael.frysinger@analog.com, mm-commits@vger.kernel.org


The patch titled
     drivers/rtc: correct an error test
has been removed from the -mm tree.  Its filename was
     drivers-rtc-correct-an-error-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc: correct an error test
From: Julia Lawall <julia@diku.dk>

rtc is clearly does not satisfy IS_ERR at the point where it is tested, so
I have changed the test to consider the just initialized rtc->rtc_dev.

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@match exists@
expression x, E;
identifier fld;
position p1,p2;
@@

(
x = E;
|
x = E
|
x@p1->fld
... when != x = E
IS_ERR(x@p2)
... when any
)

@other_match exists@
expression match.x, E1, E2;
position match.p1,match.p2;
@@

x = E1
... when != x = E2
    when != x@p1
x@p2

@ script:python depends on !other_match@
p1 << match.p1;
p2 << match.p2;
@@

print "* file %s dereference %s test %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Bryan Wu <bryan.wu@analog.com>
Cc: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bfin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-bfin.c~drivers-rtc-correct-an-error-test drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~drivers-rtc-correct-an-error-test
+++ a/drivers/rtc/rtc-bfin.c
@@ -390,7 +390,7 @@ static int __devinit bfin_rtc_probe(stru
 
 	/* Register our RTC with the RTC framework */
 	rtc->rtc_dev = rtc_device_register(pdev->name, dev, &bfin_rtc_ops, THIS_MODULE);
-	if (unlikely(IS_ERR(rtc))) {
+	if (unlikely(IS_ERR(rtc->rtc_dev))) {
 		ret = PTR_ERR(rtc->rtc_dev);
 		goto err_irq;
 	}
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
powerpc-powermac-add-missing-of_node_put.patch
net-tipc-bcasth-use-array_size.patch
net-bridge-netfilter-move-a-dereference-below-a-null-test.patch
drivers-isdn-hardware-misdn-move-a-dereference-below-a-null-test.patch
drivers-net-hamradio-6packc-move-a-dereference-below-a-null-test.patch
drivers-net-wireless-libertas-move-a-dereference-below-a-null-test.patch

