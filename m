From: akpm@linux-foundation.org
Subject: [merged] sound-core-pcm_timerc-use-lib-gcdc.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:32:18 -0800
Message-ID: <200912292132.nBTLWImr008621@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752777AbZL2Vct (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:32:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: florian@openwrt.org, davem@davemloft.net, horms@verge.net.au, juliusv@google.com, kaber@trash.net, sshtylyov@ru.mvista.com, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     sound/core/pcm_timer.c: use lib/gcd.c
has been removed from the -mm tree.  Its filename was
     sound-core-pcm_timerc-use-lib-gcdc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sound/core/pcm_timer.c: use lib/gcd.c
From: Florian Fainelli <florian@openwrt.org>

Make sound/core/pcm_timer.c use lib/gcd.c

Signed-off-by: Florian Fainelli <florian@openwrt.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Simon Horman <horms@verge.net.au>
Cc: Julius Volz <juliusv@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/core/Kconfig     |    1 +
 sound/core/pcm_timer.c |   17 +----------------
 2 files changed, 2 insertions(+), 16 deletions(-)

diff -puN sound/core/Kconfig~sound-core-pcm_timerc-use-lib-gcdc sound/core/Kconfig
--- a/sound/core/Kconfig~sound-core-pcm_timerc-use-lib-gcdc
+++ a/sound/core/Kconfig
@@ -5,6 +5,7 @@ config SND_TIMER
 config SND_PCM
 	tristate
 	select SND_TIMER
+	select GCD
 
 config SND_HWDEP
 	tristate
diff -puN sound/core/pcm_timer.c~sound-core-pcm_timerc-use-lib-gcdc sound/core/pcm_timer.c
--- a/sound/core/pcm_timer.c~sound-core-pcm_timerc-use-lib-gcdc
+++ a/sound/core/pcm_timer.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/time.h>
+#include <linux/gcd.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/timer.h>
@@ -28,22 +29,6 @@
  *  Timer functions
  */
 
-/* Greatest common divisor */
-static unsigned long gcd(unsigned long a, unsigned long b)
-{
-	unsigned long r;
-	if (a < b) {
-		r = a;
-		a = b;
-		b = r;
-	}
-	while ((r = a % b) != 0) {
-		a = b;
-		b = r;
-	}
-	return b;
-}
