From: akpm@linux-foundation.org
Subject: + drivers-serial-68328serialc-remove-dead-alma_ans-dragonixvz-m68ez328ads.patch added to -mm tree
Date: Thu, 15 Jul 2010 11:58:01 -0700
Message-ID: <201007151858.o6FIw1Ce013303@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48606 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934355Ab0GOS7G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jul 2010 14:59:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: siccegge@cs.fau.de, gerg@uclinux.org, greg@kroah.com


The patch titled
     drivers/serial/68328serial.c: remove dead (ALMA_ANS | DRAGONIXVZ | M68EZ328ADS)
has been added to the -mm tree.  Its filename is
     drivers-serial-68328serialc-remove-dead-alma_ans-dragonixvz-m68ez328ads.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/serial/68328serial.c: remove dead (ALMA_ANS | DRAGONIXVZ | M68EZ328ADS)
From: Christoph Egger <siccegge@cs.fau.de>

(ALMA_ANS | DRAGONIXVZ | M68EZ328ADS) doesn't exist in Kconfig, therefore
remove all references to it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/68328serial.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff -puN drivers/serial/68328serial.c~drivers-serial-68328serialc-remove-dead-alma_ans-dragonixvz-m68ez328ads drivers/serial/68328serial.c
--- a/drivers/serial/68328serial.c~drivers-serial-68328serialc-remove-dead-alma_ans-dragonixvz-m68ez328ads
+++ a/drivers/serial/68328serial.c
@@ -98,19 +98,13 @@ static void change_speed(struct m68k_ser
  *	Setup for console. Argument comes from the boot command line.
  */
 
-#if defined(CONFIG_M68EZ328ADS) || defined(CONFIG_ALMA_ANS) || defined(CONFIG_DRAGONIXVZ)
-#define	CONSOLE_BAUD_RATE	115200
-#define	DEFAULT_CBAUD		B115200
-#else
-	/* (es) */
-	/* note: this is messy, but it works, again, perhaps defined somewhere else?*/
-	#ifdef CONFIG_M68VZ328
-	#define CONSOLE_BAUD_RATE	19200
-	#define DEFAULT_CBAUD		B19200
-	#endif
-	/* (/es) */
+/* note: this is messy, but it works, again, perhaps defined somewhere else?*/
+#ifdef CONFIG_M68VZ328
+#define CONSOLE_BAUD_RATE	19200
+#define DEFAULT_CBAUD		B19200
 #endif
 
+
 #ifndef CONSOLE_BAUD_RATE
 #define	CONSOLE_BAUD_RATE	9600
 #define	DEFAULT_CBAUD		B9600
_

Patches currently in -mm which might be from siccegge@cs.fau.de are

linux-next.patch
drivers-serial-68328serialc-remove-dead-alma_ans-dragonixvz-m68ez328ads.patch
edac-add-wissing-pieces-from-mpc85xx-fsl_soc_booke.patch

