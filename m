From: akpm@linux-foundation.org
Subject: [merged] drivers-pcmcia-pxa2xxc-pcmcia-vs-mecr-on-pxa25x-sa1111.patch removed from -mm tree
Date: Tue, 22 Feb 2011 14:18:13 -0800
Message-ID: <201102222218.p1MMIDTZ025505@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749Ab1BVWTF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Feb 2011 17:19:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pma@sysgo.com, eric.y.miao@gmail.com, linux@dominikbrodowski.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     drivers/pcmcia/pxa2xx*.c: pcmcia vs. MECR on pxa25x/sa1111
has been removed from the -mm tree.  Its filename was
     drivers-pcmcia-pxa2xxc-pcmcia-vs-mecr-on-pxa25x-sa1111.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

