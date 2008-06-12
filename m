From: akpm@linux-foundation.org
Subject: + pm-remove-remaining-obsolete-definitions-from-pmh.patch added to -mm tree
Date: Thu, 12 Jun 2008 02:32:41 -0700
Message-ID: <200806120932.m5C9WfpY012212@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751936AbYFLJdM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 05:33:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl


The patch titled
     pm: remove remaining obsolete definitions from pm.h
has been added to the -mm tree.  Its filename is
     pm-remove-remaining-obsolete-definitions-from-pmh.patch

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
Subject: pm: remove remaining obsolete definitions from pm.h
From: Rafael J. Wysocki <rjw@sisk.pl>

Remove the remaining obsolete definitions from include/linux/pm.h and move
the definitions of PM_SUSPEND and PM_RESUME to the header of h3600 which
is the only user of them.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-arm/arch-sa1100/h3600.h |    5 ++
 include/linux/pm.h                  |   46 --------------------------
 2 files changed, 5 insertions(+), 46 deletions(-)

diff -puN include/asm-arm/arch-sa1100/h3600.h~pm-remove-remaining-obsolete-definitions-from-pmh include/asm-arm/arch-sa1100/h3600.h
--- a/include/asm-arm/arch-sa1100/h3600.h~pm-remove-remaining-obsolete-definitions-from-pmh
+++ a/include/asm-arm/arch-sa1100/h3600.h
@@ -23,6 +23,11 @@
 #ifndef _INCLUDE_H3600_H_
 #define _INCLUDE_H3600_H_
 
+typedef int __bitwise pm_request_t;
+
+#define PM_SUSPEND	((__force pm_request_t) 1)	/* enter D1-D3 */
+#define PM_RESUME	((__force pm_request_t) 2)	/* enter D0 */
+
 /* generalized support for H3xxx series Compaq Pocket PC's */
 #define machine_is_h3xxx() (machine_is_h3100() || machine_is_h3600() || machine_is_h3800())
 
diff -puN include/linux/pm.h~pm-remove-remaining-obsolete-definitions-from-pmh include/linux/pm.h
--- a/include/linux/pm.h~pm-remove-remaining-obsolete-definitions-from-pmh
+++ a/include/linux/pm.h
@@ -26,52 +26,6 @@
 #include <asm/errno.h>
 
 /*
- * Power management requests... these are passed to pm_send_all() and friends.
- *
- * these functions are old and deprecated, see below.
- */
-typedef int __bitwise pm_request_t;
-
-#define PM_SUSPEND	((__force pm_request_t) 1)	/* enter D1-D3 */
-#define PM_RESUME	((__force pm_request_t) 2)	/* enter D0 */
-
-
-/*
- * Device types... these are passed to pm_register
- */
-typedef int __bitwise pm_dev_t;
-
-#define PM_UNKNOWN_DEV	((__force pm_dev_t) 0)	/* generic */
-#define PM_SYS_DEV	((__force pm_dev_t) 1)	/* system device (fan, KB controller, ...) */
-#define PM_PCI_DEV	((__force pm_dev_t) 2)	/* PCI device */
-#define PM_USB_DEV	((__force pm_dev_t) 3)	/* USB device */
-#define PM_SCSI_DEV	((__force pm_dev_t) 4)	/* SCSI device */
-#define PM_ISA_DEV	((__force pm_dev_t) 5)	/* ISA device */
-#define	PM_MTD_DEV	((__force pm_dev_t) 6)	/* Memory Technology Device */
-
-/*
- * System device hardware ID (PnP) values
- */
-enum
-{
-	PM_SYS_UNKNOWN = 0x00000000, /* generic */
-	PM_SYS_KBC =	 0x41d00303, /* keyboard controller */
-	PM_SYS_COM =	 0x41d00500, /* serial port */
-	PM_SYS_IRDA =	 0x41d00510, /* IRDA controller */
-	PM_SYS_FDC =	 0x41d00700, /* floppy controller */
-	PM_SYS_VGA =	 0x41d00900, /* VGA controller */
-	PM_SYS_PCMCIA =	 0x41d00e00, /* PCMCIA controller */
-};
-
-/*
- * Device identifier
- */
-#define PM_PCI_ID(dev) ((dev)->bus->number << 16 | (dev)->devfn)
-
-/* Functions above this comment are list-based old-style power
- * management. Please avoid using them.  */
