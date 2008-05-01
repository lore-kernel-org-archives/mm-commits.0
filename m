From: akpm@linux-foundation.org
Subject: - drivers-char-ds1286c-use-time_before-time_before_eq-etc.patch removed from -mm tree
Date: Thu, 01 May 2008 02:30:00 -0700
Message-ID: <200805010930.m419U0Pq030727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753717AbYEAJaG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:30:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/char/ds1286.c: use time_before, time_before_eq, etc
has been removed from the -mm tree.  Its filename was
     drivers-char-ds1286c-use-time_before-time_before_eq-etc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/ds1286.c: use time_before, time_before_eq, etc
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
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ds1286.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/char/ds1286.c~drivers-char-ds1286c-use-time_before-time_before_eq-etc drivers/char/ds1286.c
--- a/drivers/char/ds1286.c~drivers-char-ds1286c-use-time_before-time_before_eq-etc
+++ a/drivers/char/ds1286.c
@@ -39,6 +39,7 @@
 #include <linux/spinlock.h>
 #include <linux/bcd.h>
 #include <linux/proc_fs.h>
+#include <linux/jiffies.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
@@ -451,7 +452,7 @@ static void ds1286_get_time(struct rtc_t
 	 */
 
 	if (ds1286_is_updating() != 0)
-		while (jiffies - uip_watchdog < 2*HZ/100)
+		while (time_before(jiffies, uip_watchdog + 2*HZ/100))
 			barrier();
 
 	/*
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
drivers-scsi-use-time_before-time_before_eq-etc.patch
git-cryptodev.patch
spi_s3c24xx-signedness-fix.patch
fs-ext4-use-bug_on.patch

