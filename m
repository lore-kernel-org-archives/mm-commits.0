From: akpm@linux-foundation.org
Subject: + net-ibm_newemac-remove-spin_lock_unlocked.patch added to -mm tree
Date: Mon, 12 Nov 2007 13:47:25 -0800
Message-ID: <200711122147.lACLlPta010512@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34840 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752319AbXKLVsH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 16:48:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, jgarzik@pobox.com


The patch titled
     Net: ibm_newemac, remove SPIN_LOCK_UNLOCKED
has been added to the -mm tree.  Its filename is
     net-ibm_newemac-remove-spin_lock_unlocked.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Net: ibm_newemac, remove SPIN_LOCK_UNLOCKED
From: Jiri Slaby <jirislaby@gmail.com>

SPIN_LOCK_UNLOCKED is deprecated, use DEFINE_SPINLOCK instead

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ibm_newemac/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/ibm_newemac/debug.c~net-ibm_newemac-remove-spin_lock_unlocked drivers/net/ibm_newemac/debug.c
--- a/drivers/net/ibm_newemac/debug.c~net-ibm_newemac-remove-spin_lock_unlocked
+++ a/drivers/net/ibm_newemac/debug.c
@@ -21,7 +21,7 @@
 
 #include "core.h"
 
-static spinlock_t emac_dbg_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(emac_dbg_lock);
 
 static void emac_desc_dump(struct emac_instance *p)
 {
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
