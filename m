From: akpm@linux-foundation.org
Subject: + char-riscom8-change-rc_init_drivers-prototype.patch added to -mm tree
Date: Mon, 12 Nov 2007 13:51:15 -0800
Message-ID: <200711122151.lACLpFW0010610@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41030 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752322AbXKLVvY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 16:51:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     Char: riscom8, change rc_init_drivers prototype
has been added to the -mm tree.  Its filename is
     char-riscom8-change-rc_init_drivers-prototype.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: riscom8, change rc_init_drivers prototype
From: Jiri Slaby <jirislaby@gmail.com>

Let compiler decide if the rc_init_drivers function will be inlined and
mark it as __init, because it's called only from __init function.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/riscom8.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/riscom8.c~char-riscom8-change-rc_init_drivers-prototype drivers/char/riscom8.c
--- a/drivers/char/riscom8.c~char-riscom8-change-rc_init_drivers-prototype
+++ a/drivers/char/riscom8.c
@@ -1618,7 +1618,7 @@ static const struct tty_operations risco
 	.tiocmset = rc_tiocmset,
 };
 
-static inline int rc_init_drivers(void)
+static int __init rc_init_drivers(void)
 {
 	int error;
 	int i;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

fs-sysfs-remove-spin_lock_unlocked.patch
net-sunrpc-remove-spin_lock_unlocked.patch
net-ibm_newemac-remove-spin_lock_unlocked.patch
sbus-cpwatchdog-remove-spin_lock_unlocked.patch
watchdog-bfin_wdt-remove-spin_lock_unlocked.patch
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
char-rocket-switch-long-delay-to-sleep.patch
char-rocket-printk-cleanup.patch
char-rocket-remove-useless-macros.patch
char-char-serial-remove-serial_type_normal-redefines.patch
char-mxser_new-ioaddresses-are-ulong.patch
char-stallion-fix-compiler-warnings.patch
char-riscom8-change-rc_init_drivers-prototype.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
