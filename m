From: akpm@linux-foundation.org
Subject: + drivers-rtc-correct-an-error-test.patch added to -mm tree
Date: Thu, 11 Dec 2008 11:42:50 -0800
Message-ID: <200812111942.mBBJgogC026998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761556AbYLKTn6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Dec 2008 14:43:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, a.zummo@towertech.it, bryan.wu@analog.com, david-b@pacbell.net, michael.frysinger@analog.com


The patch titled
     drivers/rtc: correct an error test
has been added to the -mm tree.  Its filename is
     drivers-rtc-correct-an-error-test.patch

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
Cc: Alessandro Zummo <a.zummo@towertech.it>
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

linux-next.patch
arch-arm-eliminate-null-test-and-memset-after-alloc_bootmem.patch
arch-avr32-eliminate-null-test-and-memset-after-alloc_bootmem.patch
powerpc-chrp-add-missing-of_node_put-in-pcic.patch
powerpc-powermac-add-missing-of_node_put.patch
drivers-media-video-cx88-cx88-alsac-adjust-error-handling-code.patch
drivers-mtd-maps-nettelc-use-array_size.patch
net-tipc-bcasth-use-array_size.patch
fs-namespacec-drop-code-after-return.patch
mm-page_allocc-eliminate-null-test-and-memset-after-alloc_bootmem.patch
drivers-macintosh-add-missing-of_node_put-in-therm_adt746xc.patch
drivers-rtc-correct-an-error-test.patch

