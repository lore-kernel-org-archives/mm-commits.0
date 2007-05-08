From: akpm@linux-foundation.org
Subject: + mac80211-include-linux-delayh-instead-of-asm-delayh.patch added to -mm tree
Date: Tue, 08 May 2007 13:58:26 -0700
Message-ID: <200705082058.l48KwQT2001455@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967754AbXEHU7W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 16:59:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, davem@davemloft.net, jeff@garzik.org, linville@tuxdriver.com


The patch titled
     mac80211: include <linux/delay.h> instead of <asm/delay.h>
has been added to the -mm tree.  Its filename is
     mac80211-include-linux-delayh-instead-of-asm-delayh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
mac80211-include-linux-delayh-instead-of-asm-delayh.patch
allow-arch-to-initialize-arch-field-of-the-module-structure.patch
