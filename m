From: akpm@linux-foundation.org
Subject: - drivers-char-rtcc-use-time_before-time_before_eq-etc.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:50:24 -0700
Message-ID: <200804282150.m3SLoOBD017471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765320AbYD1VvE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:51:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, a.zummo@towertech.it, david-b@pacbell.net, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     drivers/char/rtc.c: use time_before, time_before_eq, etc
has been removed from the -mm tree.  Its filename was
     drivers-char-rtcc-use-time_before-time_before_eq-etc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/rtc.c: use time_before, time_before_eq, etc
From: Julia Lawall <julia@diku.dk>

The functions time_before, time_before_eq, time_after, and time_after_eq
are more robust for comparing jiffies against other values.

A simplified version of the semantic patch making this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@ change_compare_np @
expression E;
@@

(
- jiffies <= E
+ time_before_eq(jiffies,E)
|
- jiffies >= E
+ time_after_eq(jiffies,E)
|
- jiffies < E
+ time_before(jiffies,E)
|
- jiffies > E
+ time_after(jiffies,E)
)

@ include depends on change_compare_np @
@@

#include <linux/jiffies.h>

@ no_include depends on !include && change_compare_np @
@@

  #include <linux/...>
+ #include <linux/jiffies.h>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rtc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/char/rtc.c~drivers-char-rtcc-use-time_before-time_before_eq-etc drivers/char/rtc.c
--- a/drivers/char/rtc.c~drivers-char-rtcc-use-time_before-time_before_eq-etc
+++ a/drivers/char/rtc.c
@@ -88,6 +88,7 @@
 
 #ifdef CONFIG_SPARC32
 #include <linux/pci.h>
+#include <linux/jiffies.h>
 #include <asm/ebus.h>
 
 static unsigned long rtc_port;
@@ -1316,7 +1317,8 @@ void rtc_get_rtc_time(struct rtc_time *r
 	 * Once the read clears, read the RTC time (again via ioctl). Easy.
 	 */
 
-	while (rtc_is_updating() != 0 && jiffies - uip_watchdog < 2*HZ/100)
+	while (rtc_is_updating() != 0 &&
+	       time_before(jiffies, uip_watchdog + 2*HZ/100))
 		cpu_relax();
 
 	/*
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
drivers-scsi-use-time_before-time_before_eq-etc.patch
fs-affs-filec-use-bug_on.patch
drivers-misc-elide-a-non-zero-test-on-a-result-that-is-never-0.patch
fs-ext4-use-bug_on.patch
drivers-char-ds1286c-use-time_before-time_before_eq-etc.patch

