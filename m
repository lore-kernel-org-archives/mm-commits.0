From: akpm@linux-foundation.org
Subject: + alchemy-semi-au1000-pcmcia-driver-convert-pcmcia_sockets_lock-in-a-mutex.patch added to -mm tree
Date: Thu, 06 Mar 2008 23:38:10 -0800
Message-ID: <200803070738.m277cAik011290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751196AbYCGHiv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 02:38:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias@kaehlcke.net, ralf@linux-mips.org


The patch titled
     Alchemy Semi Au1000 pcmcia driver: convert pcmcia_sockets_lock in a mutex
has been added to the -mm tree.  Its filename is
     alchemy-semi-au1000-pcmcia-driver-convert-pcmcia_sockets_lock-in-a-mutex.patch

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
Subject: Alchemy Semi Au1000 pcmcia driver: convert pcmcia_sockets_lock in a mutex
From: Matthias Kaehlcke <matthias@kaehlcke.net>

Alchemy Semi Au1000 pcmcia driver: The semaphore pcmcia_sockets_lock
is used as a mutex, convert it to the mutex API

(akpm: make it static too)

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/au1000_generic.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/pcmcia/au1000_generic.c~alchemy-semi-au1000-pcmcia-driver-convert-pcmcia_sockets_lock-in-a-mutex drivers/pcmcia/au1000_generic.c
--- a/drivers/pcmcia/au1000_generic.c~alchemy-semi-au1000-pcmcia-driver-convert-pcmcia_sockets_lock-in-a-mutex
+++ a/drivers/pcmcia/au1000_generic.c
@@ -41,6 +41,7 @@
 #include <linux/notifier.h>
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/platform_device.h>
 
 #include <asm/io.h>
@@ -71,7 +72,7 @@ extern struct au1000_pcmcia_socket au100
 u32 *pcmcia_base_vaddrs[2];
 extern const unsigned long mips_io_port_base;
 
-DECLARE_MUTEX(pcmcia_sockets_lock);
+static DEFINE_MUTEX(pcmcia_sockets_lock);
 
 static int (*au1x00_pcmcia_hw_init[])(struct device *dev) = {
 	au1x_board_init,
@@ -472,7 +473,7 @@ int au1x00_drv_pcmcia_remove(struct devi
 	struct skt_dev_info *sinfo = dev_get_drvdata(dev);
 	int i;
 
-	down(&pcmcia_sockets_lock);
+	mutex_lock(&pcmcia_sockets_lock);
 	dev_set_drvdata(dev, NULL);
 
 	for (i = 0; i < sinfo->nskt; i++) {
@@ -488,7 +489,7 @@ int au1x00_drv_pcmcia_remove(struct devi
 	}
 
 	kfree(sinfo);
-	up(&pcmcia_sockets_lock);
+	mutex_unlock(&pcmcia_sockets_lock);
 	return 0;
 }
 
@@ -501,13 +502,13 @@ static int au1x00_drv_pcmcia_probe(struc
 {
 	int i, ret = -ENODEV;
 
-	down(&pcmcia_sockets_lock);
+	mutex_lock(&pcmcia_sockets_lock);
 	for (i=0; i < ARRAY_SIZE(au1x00_pcmcia_hw_init); i++) {
 		ret = au1x00_pcmcia_hw_init[i](dev);
 		if (ret == 0)
 			break;
 	}
-	up(&pcmcia_sockets_lock);
+	mutex_unlock(&pcmcia_sockets_lock);
 	return ret;
 }
 
_

Patches currently in -mm which might be from matthias@kaehlcke.net are

cosa-srp-convert-channel_datarsem-to-mutex.patch
convert-acl-sem-in-a-mutex.patch
convert-stats_sem-in-a-mutex.patch
convert-wpa_sem-in-a-mutex.patch
fs-inodec-use-hlist_for_each_entry.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
alchemy-semi-au1000-pcmcia-driver-convert-pcmcia_sockets_lock-in-a-mutex.patch

