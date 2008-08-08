From: akpm@linux-foundation.org
Subject: + watchdog-fix-shwdtc-compilation.patch added to -mm tree
Date: Fri, 08 Aug 2008 15:29:52 -0700
Message-ID: <200808082229.m78MTqrq032400@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764745AbYHHWai (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 18:30:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, bunk@kernel.org, wim@iguana.be


The patch titled
     watchdog: fix shwdt.c compilation
has been added to the -mm tree.  Its filename is
     watchdog-fix-shwdtc-compilation.patch

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
Subject: watchdog: fix shwdt.c compilation
From: Adrian Bunk <bunk@stusta.de>

Fix the following compile errors caused by commit
70b814ec1a484279a51bf9f7193551b996627247 ([WATCHDOG 45/57] shwdt: coding
style, cleanup, switch to unlocked_io):

shwdt.c:64: error: 'WTCSR_CKS_4096' undeclared here (not in a function)
shwdt.c: In function 'sh_wdt_start':
shwdt.c:92: error: 'wdt_lock' undeclared (first use in this function)
shwdt.c:92: error: (Each undeclared identifier is reported only once
shwdt.c:92: error: for each function it appears in.)
shwdt.c:97: error: implicit declaration of function 'sh_wdt_read_csr'
shwdt.c:98: error: 'WTCSR_WT' undeclared (first use in this function)
shwdt.c:99: error: implicit declaration of function 'sh_wdt_write_csr'
shwdt.c:101: error: implicit declaration of function 'sh_wdt_write_cnt'
shwdt.c:112: error: 'WTCSR_TME' undeclared (first use in this function)
shwdt.c:113: error: 'WTCSR_RSTS' undeclared (first use in this function)
shwdt.c: In function 'sh_wdt_stop':
shwdt.c:142: error: 'wdt_lock' undeclared (first use in this function)
shwdt.c:147: error: 'WTCSR_TME' undeclared (first use in this function)
shwdt.c: In function 'sh_wdt_keepalive':
shwdt.c:160: error: 'wdt_lock' undeclared (first use in this function)
shwdt.c: In function 'sh_wdt_set_heartbeat':
shwdt.c:176: error: 'wdt_lock' undeclared (first use in this function)
shwdt.c: In function 'sh_wdt_ping':
shwdt.c:192: error: 'wdt_lock' undeclared (first use in this function)
shwdt.c:197: error: 'WTCSR_IOVF' undeclared (first use in this function)
shwdt.c: At top level:
shwdt.c:417: error: conflicting type qualifiers for 'sh_wdt_info'
shwdt.c:71: error: previous declaration of 'sh_wdt_info' was here
make[3]: *** [drivers/watchdog/shwdt.o] Error 1

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/shwdt.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff -puN drivers/watchdog/shwdt.c~watchdog-fix-shwdtc-compilation drivers/watchdog/shwdt.c
--- a/drivers/watchdog/shwdt.c~watchdog-fix-shwdtc-compilation
+++ a/drivers/watchdog/shwdt.c
@@ -31,6 +31,7 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 #include <linux/watchdog.h>
+#include <asm/watchdog.h>
 
 #define PFX "shwdt: "
 
@@ -68,7 +69,7 @@ static int clock_division_ratio = WTCSR_
 static void sh_wdt_ping(unsigned long data);
 
 static unsigned long shwdt_is_open;
-static struct watchdog_info sh_wdt_info;
+static const struct watchdog_info sh_wdt_info;
 static char shwdt_expect_close;
 static DEFINE_TIMER(timer, sh_wdt_ping, 0, 0);
 static unsigned long next_heartbeat;
@@ -89,7 +90,7 @@ static void sh_wdt_start(void)
 	__u8 csr;
 	unsigned long flags;
 
-	spin_lock_irqsave(&wdt_lock, flags);
+	spin_lock_irqsave(&shwdt_lock, flags);
 
 	next_heartbeat = jiffies + (heartbeat * HZ);
 	mod_timer(&timer, next_ping_period(clock_division_ratio));
@@ -127,7 +128,7 @@ static void sh_wdt_start(void)
 	csr &= ~RSTCSR_RSTS;
 	sh_wdt_write_rstcsr(csr);
 #endif
-	spin_unlock_irqrestore(&wdt_lock, flags);
+	spin_unlock_irqrestore(&shwdt_lock, flags);
 }
 
 /**
@@ -139,14 +140,14 @@ static void sh_wdt_stop(void)
 	__u8 csr;
 	unsigned long flags;
 
-	spin_lock_irqsave(&wdt_lock, flags);
+	spin_lock_irqsave(&shwdt_lock, flags);
 
 	del_timer(&timer);
 
 	csr = sh_wdt_read_csr();
 	csr &= ~WTCSR_TME;
 	sh_wdt_write_csr(csr);
-	spin_unlock_irqrestore(&wdt_lock, flags);
+	spin_unlock_irqrestore(&shwdt_lock, flags);
 }
 
 /**
@@ -157,9 +158,9 @@ static inline void sh_wdt_keepalive(void
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&wdt_lock, flags);
+	spin_lock_irqsave(&shwdt_lock, flags);
 	next_heartbeat = jiffies + (heartbeat * HZ);
-	spin_unlock_irqrestore(&wdt_lock, flags);
+	spin_unlock_irqrestore(&shwdt_lock, flags);
 }
 
 /**
@@ -173,9 +174,9 @@ static int sh_wdt_set_heartbeat(int t)
 	if (unlikely(t < 1 || t > 3600)) /* arbitrary upper limit */
 		return -EINVAL;
 
-	spin_lock_irqsave(&wdt_lock, flags);
+	spin_lock_irqsave(&shwdt_lock, flags);
 	heartbeat = t;
-	spin_unlock_irqrestore(&wdt_lock, flags);
+	spin_unlock_irqrestore(&shwdt_lock, flags);
 	return 0;
 }
 
@@ -189,7 +190,7 @@ static void sh_wdt_ping(unsigned long da
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&wdt_lock, flags);
+	spin_lock_irqsave(&shwdt_lock, flags);
 	if (time_before(jiffies, next_heartbeat)) {
 		__u8 csr;
 
@@ -203,7 +204,7 @@ static void sh_wdt_ping(unsigned long da
 	} else
 		printk(KERN_WARNING PFX "Heartbeat lost! Will not ping "
 		       "the watchdog\n");
-	spin_unlock_irqrestore(&wdt_lock, flags);
+	spin_unlock_irqrestore(&shwdt_lock, flags);
 }
 
 /**
_

Patches currently in -mm which might be from bunk@stusta.de are

linux-next.patch
git-unionfs.patch
watchdog-fix-shwdtc-compilation.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch

