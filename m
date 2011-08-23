From: akpm@linux-foundation.org
Subject: + drivers-misc-fsa9480-fix-a-leak-of-the-irq-during-init-failure.patch added to -mm tree
Date: Tue, 23 Aug 2011 13:30:38 -0700
Message-ID: <201108232030.p7NKUcEi004832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42986 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752130Ab1HWUbN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Aug 2011 16:31:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, dg77.kim@samsung.com, kyungmin.park@samsung.com, mk7.kang@samsung.com


The patch titled
     drivers/misc/fsa9480.c: fix a leak of the IRQ during init failure
has been added to the -mm tree.  Its filename is
     drivers-misc-fsa9480-fix-a-leak-of-the-irq-during-init-failure.patch

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
Subject: drivers/misc/fsa9480.c: fix a leak of the IRQ during init failure
From: Axel Lin <axel.lin@gmail.com>

Make sure we are passing the same cookie in all calls to
request_threaded_irq() and free_irq().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Donggeun Kim <dg77.kim@samsung.com>
Cc: Minkyu Kang <mk7.kang@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/fsa9480.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/misc/fsa9480.c~drivers-misc-fsa9480-fix-a-leak-of-the-irq-during-init-failure drivers/misc/fsa9480.c
--- a/drivers/misc/fsa9480.c~drivers-misc-fsa9480-fix-a-leak-of-the-irq-during-init-failure
+++ a/drivers/misc/fsa9480.c
@@ -455,7 +455,7 @@ static int __devinit fsa9480_probe(struc
 
 fail2:
 	if (client->irq)
-		free_irq(client->irq, NULL);
+		free_irq(client->irq, usbsw);
 fail1:
 	i2c_set_clientdata(client, NULL);
 	kfree(usbsw);
@@ -466,7 +466,7 @@ static int __devexit fsa9480_remove(stru
 {
 	struct fsa9480_usbsw *usbsw = i2c_get_clientdata(client);
 	if (client->irq)
-		free_irq(client->irq, NULL);
+		free_irq(client->irq, usbsw);
 	i2c_set_clientdata(client, NULL);
 
 	sysfs_remove_group(&client->dev.kobj, &fsa9480_group);
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
drivers-video-backlight-ep93xx_blc-add-missing-include-of-linux-moduleh.patch
leds-add-missing-include-of-linux-moduleh.patch
backlight-fix-module-alias-prefix-for-adp8870_bl.patch
drivers-misc-fsa9480-fix-a-leak-of-the-irq-during-init-failure.patch
linux-next.patch
leds-renesas-tpu-led-driver-v2-fix.patch

