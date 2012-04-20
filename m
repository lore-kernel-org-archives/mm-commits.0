From: akpm@linux-foundation.org
Subject: + leds-use-kcalloc-instead-of-kzalloc-to-allocate-array.patch added to -mm tree
Date: Fri, 20 Apr 2012 13:09:24 -0700
Message-ID: <20120420200924.4EC97A00AB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:55187 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab2DTUJZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Apr 2012 16:09:25 -0400
Received: by vcbfk26 with SMTP id fk26so1147290vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Apr 2012 13:09:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thomas@m3y3r.de


The patch titled
     Subject: leds: Use kcalloc instead of kzalloc to allocate array
has been added to the -mm tree.  Its filename is
     leds-use-kcalloc-instead-of-kzalloc-to-allocate-array.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thomas Meyer <thomas@m3y3r.de>
Subject: leds: Use kcalloc instead of kzalloc to allocate array

The advantage of kcalloc is that will prevent integer overflows which
could result from the multiplication of number of elements and size and it
is also a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-mc13783.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-mc13783.c~leds-use-kcalloc-instead-of-kzalloc-to-allocate-array drivers/leds/leds-mc13783.c
--- a/drivers/leds/leds-mc13783.c~leds-use-kcalloc-instead-of-kzalloc-to-allocate-array
+++ a/drivers/leds/leds-mc13783.c
@@ -280,7 +280,7 @@ static int __devinit mc13783_led_probe(s
 		return -EINVAL;
 	}
 
-	led = kzalloc(sizeof(*led) * pdata->num_leds, GFP_KERNEL);
+	led = kcalloc(pdata->num_leds, sizeof(*led), GFP_KERNEL);
 	if (led == NULL) {
 		dev_err(&pdev->dev, "failed to alloc memory\n");
 		return -ENOMEM;
_
Subject: Subject: leds: Use kcalloc instead of kzalloc to allocate array

Patches currently in -mm which might be from thomas@m3y3r.de are

linux-next.patch
mm-use-kcalloc-instead-of-kzalloc-to-allocate-array.patch
leds-use-kcalloc-instead-of-kzalloc-to-allocate-array.patch

