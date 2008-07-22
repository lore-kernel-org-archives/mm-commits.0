From: akpm@linux-foundation.org
Subject: + char-ip2-cleanup-globals.patch added to -mm tree
Date: Tue, 22 Jul 2008 02:45:31 -0700
Message-ID: <200807220945.m6M9jVU2021583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753176AbYGVJpl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 05:45:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, akinobu.mita@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     Char: ip2, cleanup globals
has been added to the -mm tree.  Its filename is
     char-ip2-cleanup-globals.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
-
 	/* Initialise all the boards we can find (up to the maximum). */
 	for ( i = 0; i < IP2_MAX_BOARDS; ++i ) {
 		switch ( ip2config.addr[i] ) { 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
ath5k-fix-memory-corruption.patch
ath5k-kill-tasklets-on-shutdown.patch
ath5k-flush-work.patch
ath5k-fix-dma-operation.patch
ath5k-suspend-resume-fixes.patch
mac80211-tx-use-dev_kfree_skb_any-for-beacon_get.patch
mac80211-return-correct-error-return-from-ieee80211_wep_init.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
serial-z85c30-avoid-a-hang-at-console-switch-over.patch
serial-dz11-avoid-a-hang-at-console-switch-over.patch
vt-hold-console_sem-across-sysfs-operations.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
dsp56k-bkl-pushdown.patch
char-mxser-ioctl-cleanup.patch
char-mxser-globals-cleanup.patch
char-mxser-update-documentation.patch
char-mxser-prints-cleanup.patch
char-mxser-remove-predefined-isa-support.patch
char-mxser-various-cleanups.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
drivers-misc-phantom-note-pci.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

