From: akpm@linux-foundation.org
Subject: + drivers-spi-spic-dont-release-the-spi-device-twice.patch added to -mm tree
Date: Tue, 21 Dec 2010 14:27:23 -0800
Message-ID: <201012212227.oBLMRNiG029683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752391Ab0LUW2Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Dec 2010 17:28:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bigeasy@linutronix.de, equinox@diac24.net, grant.likely@secretlab.ca


The patch titled
     drivers/spi/spi.c: don't release the spi device twice
has been added to the -mm tree.  Its filename is
     drivers-spi-spic-dont-release-the-spi-device-twice.patch

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
Subject: drivers/spi/spi.c: don't release the spi device twice
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

This was fixed by David Lamparter in v2.6.36-rc5 3486008 ("spi: free
children in spi_unregister_master, not siblings") and broken again in
v2.6.37-rc1~2^2~4 during the merge of 2b9603a0 ("spi: enable
spi_board_info to be registered after spi_master").

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: David Lamparter <equinox@diac24.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/spi/spi.c~drivers-spi-spic-dont-release-the-spi-device-twice drivers/spi/spi.c
--- a/drivers/spi/spi.c~drivers-spi-spic-dont-release-the-spi-device-twice
+++ a/drivers/spi/spi.c
@@ -584,8 +584,7 @@ void spi_unregister_master(struct spi_ma
 	list_del(&master->list);
 	mutex_unlock(&board_lock);
 
-	dummy = device_for_each_child(master->dev.parent, &master->dev,
-					__unregister);
+	dummy = device_for_each_child(&master->dev, NULL, __unregister);
 	device_unregister(&master->dev);
 }
 EXPORT_SYMBOL_GPL(spi_unregister_master);
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

linux-next.patch
drivers-spi-spic-dont-release-the-spi-device-twice.patch

