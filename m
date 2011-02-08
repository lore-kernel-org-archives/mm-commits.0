From: akpm@linux-foundation.org
Subject: + drivers-pcmcia-pxa2xxc-pcmcia-vs-mecr-on-pxa25x-sa1111.patch added to -mm tree
Date: Tue, 08 Feb 2011 14:18:33 -0800
Message-ID: <201102082218.p18MIXSm028958@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754091Ab1BHWTS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Feb 2011 17:19:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pma@sysgo.com, eric.y.miao@gmail.com, linux@dominikbrodowski.net, rmk@arm.linux.org.uk


The patch titled
     drivers/pcmcia/pxa2xx*.c: pcmcia vs. MECR on pxa25x/sa1111
has been added to the -mm tree.  Its filename is
     drivers-pcmcia-pxa2xxc-pcmcia-vs-mecr-on-pxa25x-sa1111.patch

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
Subject: drivers/pcmcia/pxa2xx*.c: pcmcia vs. MECR on pxa25x/sa1111
From: Pavel Machek <pma@sysgo.com>

After 2.6.34 changes, __pxa2xx_drv_pcmcia_probe() was replaced by
sa1111_pcmcia_add().  That unfortunately means that configure_sockets() is
not called, leading to MECR not being set properly, leading to strange
crashes.

Tested on pxa255+sa1111, I do not have lubbock board nearby.  Perhaps
cleaner solution exists?

Signed-off-by: Pavel Machek <pma@sysgo.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/pxa2xx_base.c    |    2 +-
 drivers/pcmcia/pxa2xx_base.h    |    1 +
 drivers/pcmcia/pxa2xx_lubbock.c |    1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/pcmcia/pxa2xx_base.c~drivers-pcmcia-pxa2xxc-pcmcia-vs-mecr-on-pxa25x-sa1111 drivers/pcmcia/pxa2xx_base.c
--- a/drivers/pcmcia/pxa2xx_base.c~drivers-pcmcia-pxa2xxc-pcmcia-vs-mecr-on-pxa25x-sa1111
+++ a/drivers/pcmcia/pxa2xx_base.c
@@ -215,7 +215,7 @@ pxa2xx_pcmcia_frequency_change(struct so
 }
 #endif
 
-static void pxa2xx_configure_sockets(struct device *dev)
+void pxa2xx_configure_sockets(struct device *dev)
 {
 	struct pcmcia_low_level *ops = dev->platform_data;
 	/*
diff -puN drivers/pcmcia/pxa2xx_base.h~drivers-pcmcia-pxa2xxc-pcmcia-vs-mecr-on-pxa25x-sa1111 drivers/pcmcia/pxa2xx_base.h
--- a/drivers/pcmcia/pxa2xx_base.h~drivers-pcmcia-pxa2xxc-pcmcia-vs-mecr-on-pxa25x-sa1111
+++ a/drivers/pcmcia/pxa2xx_base.h
@@ -1,3 +1,4 @@
 int pxa2xx_drv_pcmcia_add_one(struct soc_pcmcia_socket *skt);
 void pxa2xx_drv_pcmcia_ops(struct pcmcia_low_level *ops);
+void pxa2xx_configure_sockets(struct device *dev);
 
diff -puN drivers/pcmcia/pxa2xx_lubbock.c~drivers-pcmcia-pxa2xxc-pcmcia-vs-mecr-on-pxa25x-sa1111 drivers/pcmcia/pxa2xx_lubbock.c
--- a/drivers/pcmcia/pxa2xx_lubbock.c~drivers-pcmcia-pxa2xxc-pcmcia-vs-mecr-on-pxa25x-sa1111
+++ a/drivers/pcmcia/pxa2xx_lubbock.c
@@ -226,6 +226,7 @@ int pcmcia_lubbock_init(struct sa1111_de
 		lubbock_set_misc_wr((1 << 15) | (1 << 14), 0);
 
 		pxa2xx_drv_pcmcia_ops(&lubbock_pcmcia_ops);
+		pxa2xx_configure_sockets(&sadev->dev);
 		ret = sa1111_pcmcia_add(sadev, &lubbock_pcmcia_ops,
 				pxa2xx_drv_pcmcia_add_one);
 	}
_

Patches currently in -mm which might be from pma@sysgo.com are

drivers-pcmcia-pxa2xxc-pcmcia-vs-mecr-on-pxa25x-sa1111.patch

