From: akpm@linux-foundation.org
Subject: - char-char-serial-remove-serial_type_normal-redefines.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:09:32 -0800
Message-ID: <200802080809.m1889D7K014807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33799 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755253AbYBHITJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: char/serial, remove SERIAL_TYPE_NORMAL redefines
has been removed from the -mm tree.  Its filename was
     char-char-serial-remove-serial_type_normal-redefines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
git-watchdog.patch
moxa-first-pass-at-termios-reporting.patch
char-applicom-use-pci_resource_start.patch
char-applicom-use-pci_match_id.patch
char-applicom-use-pci_match_id-fix.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
