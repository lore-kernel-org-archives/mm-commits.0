From: akpm@linux-foundation.org
Subject: + sbus-cpwatchdog-remove-spin_lock_unlocked.patch added to -mm tree
Date: Mon, 12 Nov 2007 13:47:28 -0800
Message-ID: <200711122147.lACLlSS3010518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51152 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752319AbXKLVrh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 16:47:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, davem@davemloft.net, wim@iguana.be


The patch titled
     Sbus: cpwatchdog, remove SPIN_LOCK_UNLOCKED
has been added to the -mm tree.  Its filename is
     sbus-cpwatchdog-remove-spin_lock_unlocked.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Sbus: cpwatchdog, remove SPIN_LOCK_UNLOCKED
From: Jiri Slaby <jirislaby@gmail.com>

SPIN_LOCK_UNLOCKED is deprecated, use __SPIN_LOCK_UNLOCKED with an unique
name instead

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/sbus/char/cpwatchdog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/sbus/char/cpwatchdog.c~sbus-cpwatchdog-remove-spin_lock_unlocked drivers/sbus/char/cpwatchdog.c
--- a/drivers/sbus/char/cpwatchdog.c~sbus-cpwatchdog-remove-spin_lock_unlocked
+++ a/drivers/sbus/char/cpwatchdog.c
@@ -154,7 +154,7 @@ struct wd_device {
 };
 
 static struct wd_device wd_dev = { 
-		0, SPIN_LOCK_UNLOCKED, 0, 0, 0, 0,
+		0, __SPIN_LOCK_UNLOCKED(wd_dev.lock), 0, 0, 0, 0,
 };
 
 static struct timer_list wd_timer;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-wireless.patch
crisv10-serial-driver-rewrite-take-three.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
net-ibm_newemac-remove-spin_lock_unlocked.patch
watchdog-bfin_wdt-remove-spin_lock_unlocked.patch
sbus-cpwatchdog-remove-spin_lock_unlocked.patch
fs-sysfs-remove-spin_lock_unlocked.patch
net-sunrpc-remove-spin_lock_unlocked.patch
