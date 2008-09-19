From: akpm@linux-foundation.org
Subject: - char-ip2-cleanup-globals.patch removed from -mm tree
Date: Fri, 19 Sep 2008 15:06:43 -0700
Message-ID: <200809192206.m8JM6hWp008850@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751951AbYISWGx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Sep 2008 18:06:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, akinobu.mita@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: ip2, cleanup globals
has been removed from the -mm tree.  Its filename was
     char-ip2-cleanup-globals.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: ip2, cleanup globals
From: Jiri Slaby <jirislaby@gmail.com>

- do not init .bss zeroed data to zero again (by memset or
  explicit assignment)
- use char [] instead of char * for string constants

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ip2/ip2main.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff -puN drivers/char/ip2/ip2main.c~char-ip2-cleanup-globals drivers/char/ip2/ip2main.c
--- a/drivers/char/ip2/ip2main.c~char-ip2-cleanup-globals
+++ a/drivers/char/ip2/ip2main.c
@@ -150,12 +150,12 @@ static int ip2_read_proc(char *, char **
 /*************/
 
 /* String constants to identify ourselves */
-static char *pcName    = "Computone IntelliPort Plus multiport driver";
-static char *pcVersion = "1.2.14";
+static const char pcName[] = "Computone IntelliPort Plus multiport driver";
+static const char pcVersion[] = "1.2.14";
 
 /* String constants for port names */
-static char *pcDriver_name   = "ip2";
-static char *pcIpl    		 = "ip2ipl";
+static const char pcDriver_name[] = "ip2";
+static const char pcIpl[] = "ip2ipl";
 
 /***********************/
 /* Function Prototypes */
@@ -237,8 +237,8 @@ static const struct file_operations ip2_
 	.open		= ip2_ipl_open,
 }; 
 
-static unsigned long irq_counter = 0;
-static unsigned long bh_counter = 0;
+static unsigned long irq_counter;
+static unsigned long bh_counter;
 
 // Use immediate queue to service interrupts
 #define USE_IQI
@@ -286,7 +286,7 @@ MODULE_AUTHOR("Doug McNash");
 MODULE_DESCRIPTION("Computone IntelliPort Plus Driver");
 MODULE_LICENSE("GPL");
 
-static int poll_only = 0;
+static int poll_only;
 
 static int Eisa_irq;
 static int Eisa_slot;
@@ -615,10 +615,6 @@ static int ip2_loadmain(void)
 	/* Initialise the iiEllis subsystem. */
 	iiEllisInit();
 
-	/* Initialize arrays. */
-	memset( i2BoardPtrTable, 0, sizeof i2BoardPtrTable );
-	memset( DevTable, 0, sizeof DevTable );
