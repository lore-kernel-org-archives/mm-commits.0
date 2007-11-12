From: akpm@linux-foundation.org
Subject: + char-char-serial-remove-serial_type_normal-redefines.patch added to -mm tree
Date: Mon, 12 Nov 2007 13:51:11 -0800
Message-ID: <200711122151.lACLpBSN010601@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56709 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752737AbXKLVv0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 16:51:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     Char: char/serial, remove SERIAL_TYPE_NORMAL redefines
has been added to the -mm tree.  Its filename is
     char-char-serial-remove-serial_type_normal-redefines.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: char/serial, remove SERIAL_TYPE_NORMAL redefines
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/epca.h          |    1 -
 drivers/char/esp.c           |    3 ---
 drivers/char/ip2/ip2main.c   |    3 ---
 drivers/char/mxser.c         |    3 ---
 drivers/char/serial167.c     |    2 --
 drivers/char/sx.h            |    2 --
 drivers/serial/68328serial.c |    3 ---
 drivers/serial/crisv10.c     |    5 -----
 include/linux/isicom.h       |    2 --
 9 files changed, 24 deletions(-)

diff -puN drivers/char/epca.h~char-char-serial-remove-serial_type_normal-redefines drivers/char/epca.h
--- a/drivers/char/epca.h~char-char-serial-remove-serial_type_normal-redefines
+++ a/drivers/char/epca.h
@@ -77,7 +77,6 @@ static char *board_desc[] = 
 #define ON         1
 
 #define FEPTIMEOUT 200000  
-#define SERIAL_TYPE_NORMAL  1
 #define SERIAL_TYPE_INFO    3
 #define EPCA_EVENT_HANGUP   1
 #define EPCA_MAGIC          0x5c6df104L
diff -puN drivers/char/esp.c~char-char-serial-remove-serial_type_normal-redefines drivers/char/esp.c
--- a/drivers/char/esp.c~char-char-serial-remove-serial_type_normal-redefines
+++ a/drivers/char/esp.c
@@ -111,9 +111,6 @@ static char serial_version[] __initdata 
 
 static struct tty_driver *esp_driver;
 
-/* serial subtype definitions */
-#define SERIAL_TYPE_NORMAL	1
-
 /*
  * Serial driver configuration section.  Here are the various options:
  *
diff -puN drivers/char/ip2/ip2main.c~char-char-serial-remove-serial_type_normal-redefines drivers/char/ip2/ip2main.c
--- a/drivers/char/ip2/ip2main.c~char-char-serial-remove-serial_type_normal-redefines
+++ a/drivers/char/ip2/ip2main.c
@@ -153,9 +153,6 @@ static char *pcVersion = "1.2.14";
 static char *pcDriver_name   = "ip2";
 static char *pcIpl    		 = "ip2ipl";
 
-/* Serial subtype definitions */
-#define SERIAL_TYPE_NORMAL    1
-
 // cheezy kludge or genius - you decide?
 int ip2_loadmain(int *, int *, unsigned char *, int);
 static unsigned char *Fip_firmware;
diff -puN drivers/char/mxser.c~char-char-serial-remove-serial_type_normal-redefines drivers/char/mxser.c
--- a/drivers/char/mxser.c~char-char-serial-remove-serial_type_normal-redefines
+++ a/drivers/char/mxser.c
@@ -81,9 +81,6 @@
 #define	MXSER_ERR_IRQ_CONFLIT	-3
 #define	MXSER_ERR_VECTOR	-4
 
-#define SERIAL_TYPE_NORMAL	1
-#define SERIAL_TYPE_CALLOUT	2
-
 #define WAKEUP_CHARS		256
 
 #define UART_MCR_AFE		0x20
diff -puN drivers/char/serial167.c~char-char-serial-remove-serial_type_normal-redefines drivers/char/serial167.c
--- a/drivers/char/serial167.c~char-char-serial-remove-serial_type_normal-redefines
+++ a/drivers/char/serial167.c
@@ -90,8 +90,6 @@
 
 #define STD_COM_FLAGS (0)
 
-#define SERIAL_TYPE_NORMAL  1
-
 static struct tty_driver *cy_serial_driver;
 extern int serial_console;
 static struct cyclades_port *serial_console_info = NULL;
diff -puN drivers/char/sx.h~char-char-serial-remove-serial_type_normal-redefines drivers/char/sx.h
--- a/drivers/char/sx.h~char-char-serial-remove-serial_type_normal-redefines
+++ a/drivers/char/sx.h
@@ -88,8 +88,6 @@ struct vpd_prom {
 
 #define IS_CF_BOARD(board) (board->flags & (SX_CFISA_BOARD | SX_CFPCI_BOARD))
 
-#define SERIAL_TYPE_NORMAL 1
-
 /* The SI processor clock is required to calculate the cc_int_count register
    value for the SI cards. */
 #define SI_PROCESSOR_CLOCK 25000000
diff -puN drivers/serial/68328serial.c~char-char-serial-remove-serial_type_normal-redefines drivers/serial/68328serial.c
--- a/drivers/serial/68328serial.c~char-char-serial-remove-serial_type_normal-redefines
+++ a/drivers/serial/68328serial.c
@@ -84,9 +84,6 @@ extern wait_queue_head_t keypress_wait; 
 
 struct tty_driver *serial_driver;
 
-/* serial subtype definitions */
-#define SERIAL_TYPE_NORMAL	1
- 
 /* number of characters left in xmit buffer before we ask for more */
 #define WAKEUP_CHARS 256
 
diff -puN drivers/serial/crisv10.c~char-char-serial-remove-serial_type_normal-redefines drivers/serial/crisv10.c
--- a/drivers/serial/crisv10.c~char-char-serial-remove-serial_type_normal-redefines
+++ a/drivers/serial/crisv10.c
@@ -68,11 +68,6 @@ static char *serial_version = "$Revision
 
 struct tty_driver *serial_driver;
 
-/* serial subtype definitions */
-#ifndef SERIAL_TYPE_NORMAL
-#define SERIAL_TYPE_NORMAL	1
-#endif
-
 /* number of characters left in xmit buffer before we ask for more */
 #define WAKEUP_CHARS 256
 
diff -puN include/linux/isicom.h~char-char-serial-remove-serial_type_normal-redefines include/linux/isicom.h
--- a/include/linux/isicom.h~char-char-serial-remove-serial_type_normal-redefines
+++ a/include/linux/isicom.h
@@ -37,8 +37,6 @@
 #define		BOARD_COUNT	4
 #define		PORT_COUNT	(BOARD_COUNT*16)
 
-#define		SERIAL_TYPE_NORMAL	1
-
 /*   character sizes  */
 
 #define		ISICOM_CS5		0x0000
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
