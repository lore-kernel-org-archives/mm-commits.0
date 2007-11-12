From: akpm@linux-foundation.org
Subject: + char-rocket-remove-useless-macros.patch added to -mm tree
Date: Mon, 12 Nov 2007 13:51:09 -0800
Message-ID: <200711122151.lACLp936010598@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34590 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752573AbXKLVv0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 16:51:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@redhat.com


The patch titled
     Char: rocket, remove useless macros
has been added to the -mm tree.  Its filename is
     char-rocket-remove-useless-macros.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: rocket, remove useless macros
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rocket.c     |   11 ++---------
 drivers/char/rocket_int.h |   18 ------------------
 2 files changed, 2 insertions(+), 27 deletions(-)

diff -puN drivers/char/rocket.c~char-rocket-remove-useless-macros drivers/char/rocket.c
--- a/drivers/char/rocket.c~char-rocket-remove-useless-macros
+++ a/drivers/char/rocket.c
@@ -40,12 +40,6 @@
  */
 
 /****** Defines ******/
-#ifdef PCI_NUM_RESOURCES
-#define PCI_BASE_ADDRESS(dev, r) ((dev)->resource[r].start)
-#else
-#define PCI_BASE_ADDRESS(dev, r) ((dev)->base_address[r])
-#endif
-
 #define ROCKET_PARANOIA_CHECK
 #define ROCKET_DISABLE_SIMUSAGE
 
@@ -981,7 +975,7 @@ static int rp_open(struct tty_struct *tt
 	CHANNEL_t *cp;
 	unsigned long page;
 
-	line = TTY_GET_LINE(tty);
+	line = tty->index;
 	if ((line < 0) || (line >= MAX_RP_PORTS) || ((info = rp_table[line]) == NULL))
 		return -ENXIO;
 
@@ -1166,8 +1160,7 @@ static void rp_close(struct tty_struct *
 	if (C_HUPCL(tty))
 		sClrDTR(cp);
 
-	if (TTY_DRIVER_FLUSH_BUFFER_EXISTS(tty))
-		TTY_DRIVER_FLUSH_BUFFER(tty);
+	rp_flush_buffer(tty);
 		
 	tty_ldisc_flush(tty);
 
diff -puN drivers/char/rocket_int.h~char-rocket-remove-useless-macros drivers/char/rocket_int.h
--- a/drivers/char/rocket_int.h~char-rocket-remove-useless-macros
+++ a/drivers/char/rocket_int.h
@@ -105,12 +105,6 @@ static inline unsigned short sInW(unsign
 #define AIOPID_NULL -1		/* no AIOP or channel exists */
 #define AIOPID_0001 0x0001	/* AIOP release 1 */
 
-#define NULLDEV -1		/* identifies non-existant device */
-#define NULLCTL -1		/* identifies non-existant controller */
-#define NULLCTLPTR (CONTROLLER_T *)0	/* identifies non-existant controller */
-#define NULLAIOP -1		/* identifies non-existant AIOP */
-#define NULLCHAN -1		/* identifies non-existant channel */
-
 /************************************************************************
  Global Register Offsets - Direct Access - Fixed values
 ************************************************************************/
@@ -1187,9 +1181,6 @@ struct r_port {
 #define ROCKET_CLOSING		0x40000000	/* Serial port is closing */
 #define ROCKET_NORMAL_ACTIVE	0x20000000	/* Normal port is active */
 
-/* tty subtypes */
-#define SERIAL_TYPE_NORMAL 1
-
 /*
  * Assigned major numbers for the Comtrol Rocketport
  */
@@ -1240,12 +1231,3 @@ struct r_port {
 /* Compact PCI device */ 
 #define PCI_DEVICE_ID_CRP16INTF		0x0903	/* Rocketport Compact PCI 16 port w/external I/F */
 
-#define TTY_GET_LINE(t) t->index
-#define TTY_DRIVER_MINOR_START(t) t->driver->minor_start
-#define TTY_DRIVER_SUBTYPE(t) t->driver->subtype
-#define TTY_DRIVER_NAME(t) t->driver->name
-#define TTY_DRIVER_NAME_BASE(t) t->driver->name_base
-#define TTY_DRIVER_FLUSH_BUFFER_EXISTS(t) t->driver->flush_buffer
-#define TTY_DRIVER_FLUSH_BUFFER(t) t->driver->flush_buffer(t)
-
-
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
