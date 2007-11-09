From: akpm@linux-foundation.org
Subject: + pcmcia-net-use-roundup_pow_of_two-macro-instead-of-grotesque-loop.patch added to -mm tree
Date: Thu, 08 Nov 2007 20:23:49 -0800
Message-ID: <200711090423.lA94NocV029110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47169 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754652AbXKIEYE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2007 23:24:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, jeff@garzik.org, linux@dominikbrodowski.net


The patch titled
     pcmcia net: use roundup_pow_of_two() macro instead of grotesque loop
has been added to the -mm tree.  Its filename is
     pcmcia-net-use-roundup_pow_of_two-macro-instead-of-grotesque-loop.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
arm-remove-reference-to-non-existent-mtd_obsolete_chips.patch
lvm-use-rounddown_pow_of_two-macro-for-simplicity.patch
hwmon-replace-power-of-two-test-in-drivers-hwmon-adt7470c.patch
pcmcia-net-use-roundup_pow_of_two-macro-instead-of-grotesque-loop.patch
blackfin-typo-config_rtc_bfin_module.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
m68knommu-remove-vestiges-of-non-existent-disktel.patch
uml-delete-some-unused-headers.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
