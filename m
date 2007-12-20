From: akpm@linux-foundation.org
Subject: - pcmcia-net-use-roundup_pow_of_two-macro-instead-of-grotesque-loop.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:37:48 -0800
Message-ID: <200712202337.lBKNbmwS018931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53470 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757675AbXLTXrz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:47:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, jeff@garzik.org, linux@dominikbrodowski.net, mm-commits@vger.kernel.org


The patch titled
     pcmcia net: use roundup_pow_of_two() macro instead of grotesque loop
has been removed from the -mm tree.  Its filename was
     pcmcia-net-use-roundup_pow_of_two-macro-instead-of-grotesque-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pcmcia net: use roundup_pow_of_two() macro instead of grotesque loop
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/pcmcia/pcnet_cs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/pcmcia/pcnet_cs.c~pcmcia-net-use-roundup_pow_of_two-macro-instead-of-grotesque-loop drivers/net/pcmcia/pcnet_cs.c
--- a/drivers/net/pcmcia/pcnet_cs.c~pcmcia-net-use-roundup_pow_of_two-macro-instead-of-grotesque-loop
+++ a/drivers/net/pcmcia/pcnet_cs.c
@@ -38,6 +38,7 @@
 #include <linux/delay.h>
 #include <linux/ethtool.h>
 #include <linux/netdevice.h>
+#include <linux/log2.h>
 #include "../8390.h"
 
 #include <pcmcia/cs_types.h>
@@ -1484,8 +1485,7 @@ static int setup_shmem_window(struct pcm
 	window_size = 32 * 1024;
 
     /* Make sure it's a power of two.  */
-    while ((window_size & (window_size - 1)) != 0)
-	window_size += window_size & ~(window_size - 1);
+    window_size = roundup_pow_of_two(window_size);
 
     /* Allocate a memory window */
     req.Attributes = WIN_DATA_WIDTH_16|WIN_MEMORY_TYPE_CM|WIN_ENABLE;
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

git-arm.patch
git-hwmon.patch
git-mips.patch
git-netdev-all.patch
git-nfsd.patch
git-xfs.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
m68knommu-remove-vestiges-of-non-existent-disktel.patch
uml-delete-some-unused-headers.patch
rd-use-is_power_of_2-in-drivers-block-rdc.patch
log2h-define-order_base_2-macro-for-convenience.patch
a-few-corrections-to-include-linux-kbuild.patch
ncpfs-update-diagnostic-strings-to-match-routine-names.patch
hfs-update-comment-to-reflect-actual-init-and-exit-routines.patch
synclink-standardize-format-of-linux-header-file-includes-with.patch
remove-superfluous-checks-for-config_blk_dev_initrd-from-initramfsc.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
