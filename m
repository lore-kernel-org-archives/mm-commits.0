From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-fsa9480-fix-a-leak-of-the-irq-during-init-failure.patch removed from -mm tree
Date: Fri, 26 Aug 2011 12:06:57 -0700
Message-ID: <201108261903.p7QJ3f0w005713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753302Ab1HZTER (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 15:04:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, dg77.kim@samsung.com, kyungmin.park@samsung.com, mk7.kang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     drivers/misc/fsa9480.c: fix a leak of the IRQ during init failure
has been removed from the -mm tree.  Its filename was
     drivers-misc-fsa9480-fix-a-leak-of-the-irq-during-init-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch
leds-renesas-tpu-led-driver-v2-fix.patch

