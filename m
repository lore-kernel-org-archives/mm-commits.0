From: akpm@linux-foundation.org
Subject: [merged] drivers-spi-spic-dont-release-the-spi-device-twice.patch removed from -mm tree
Date: Thu, 23 Dec 2010 14:36:54 -0800
Message-ID: <201012232240.oBNMefjX015469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751636Ab0LWWll (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Dec 2010 17:41:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bigeasy@linutronix.de, equinox@diac24.net, grant.likely@secretlab.ca, mm-commits@vger.kernel.org


The patch titled
     drivers/spi/spi.c: don't release the spi device twice
has been removed from the -mm tree.  Its filename was
     drivers-spi-spic-dont-release-the-spi-device-twice.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

