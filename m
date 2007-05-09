From: akpm@linux-foundation.org
Subject: - mac80211-include-linux-delayh-instead-of-asm-delayh.patch removed from -mm tree
Date: Tue, 08 May 2007 20:03:50 -0700
Message-ID: <200705090303.l4933ont010987@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032945AbXEIDEv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:04:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, davem@davemloft.net, jeff@garzik.org, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     mac80211: include <linux/delay.h> instead of <asm/delay.h>
has been removed from the -mm tree.  Its filename was
     mac80211-include-linux-delayh-instead-of-asm-delayh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mac80211: include <linux/delay.h> instead of <asm/delay.h>
From: Geert Uytterhoeven <geert@linux-m68k.org>

|   CC      net/mac80211/ieee80211_sta.o
| In file included from linux/net/mac80211/ieee80211_sta.c:31:
| include2/asm/delay.h: In function '__const_udelay':
| include2/asm/delay.h:33: error: 'loops_per_jiffy' undeclared (first use in this function)
| include2/asm/delay.h:33: error: (Each undeclared identifier is reported only once
| include2/asm/delay.h:33: error: for each function it appears in.)

mac80211: include <linux/delay.h> instead of <asm/delay.h>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/ieee80211_sta.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN net/mac80211/ieee80211_sta.c~mac80211-include-linux-delayh-instead-of-asm-delayh net/mac80211/ieee80211_sta.c
--- a/net/mac80211/ieee80211_sta.c~mac80211-include-linux-delayh-instead-of-asm-delayh
+++ a/net/mac80211/ieee80211_sta.c
@@ -17,6 +17,7 @@
  * scan result table filtering (by capability (privacy, IBSS/BSS, WPA/RSN IE,
  *    SSID)
  */
+#include <linux/delay.h>
 #include <linux/if_ether.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
@@ -27,7 +28,6 @@
 #include <linux/rtnetlink.h>
 #include <net/iw_handler.h>
 #include <asm/types.h>
-#include <asm/delay.h>
 
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
m68k-asm-scatterlisth-needs-linux-typesh.patch
git-net.patch
allow-arch-to-initialize-arch-field-of-the-module-structure.patch
