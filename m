From: akpm@linux-foundation.org
Subject: - serial-use-time_before-time_before_eq-etc.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:55:34 -0700
Message-ID: <200804282155.m3SLtY48018112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933474AbYD1Vzh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:55:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, mm-commits@vger.kernel.org


The patch titled
     serial: use time_before, time_before_eq, etc
has been removed from the -mm tree.  Its filename was
     serial-use-time_before-time_before_eq-etc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: use time_before, time_before_eq, etc
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/68360serial.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/serial/68360serial.c~serial-use-time_before-time_before_eq-etc drivers/serial/68360serial.c
--- a/drivers/serial/68360serial.c~serial-use-time_before-time_before_eq-etc
+++ a/drivers/serial/68360serial.c
@@ -51,6 +51,7 @@ extern int  kgdb_output_string (const ch
 
 /* #ifdef CONFIG_SERIAL_CONSOLE */ /* This seems to be a post 2.0 thing - mles */
 #include <linux/console.h>
+#include <linux/jiffies.h>
 
 /* this defines the index into rs_table for the port to use
  */
@@ -1729,7 +1730,7 @@ static void rs_360_wait_until_sent(struc
 		msleep_interruptible(jiffies_to_msecs(char_time));
 		if (signal_pending(current))
 			break;
-		if (timeout && ((orig_jiffies + timeout) < jiffies))
+		if (timeout && (time_after(jiffies, orig_jiffies + timeout)))
 			break;
 		/* The 'tx_cur' is really the next buffer to send.  We
 		 * have to back up to the previous BD and wait for it
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
drivers-scsi-use-time_before-time_before_eq-etc.patch
fs-affs-filec-use-bug_on.patch
drivers-misc-elide-a-non-zero-test-on-a-result-that-is-never-0.patch
fs-ext4-use-bug_on.patch
drivers-char-ds1286c-use-time_before-time_before_eq-etc.patch

