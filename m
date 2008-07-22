From: akpm@linux-foundation.org
Subject: + char-merge-ip2main-and-ip2base.patch added to -mm tree
Date: Tue, 22 Jul 2008 02:45:29 -0700
Message-ID: <200807220945.m6M9jT0h021580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752649AbYGVJpj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 05:45:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, akinobu.mita@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     Char: merge ip2main and ip2base
has been added to the -mm tree.  Its filename is
     char-merge-ip2main-and-ip2base.patch

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
Subject: Char: merge ip2main and ip2base
From: Jiri Slaby <jirislaby@gmail.com>

It's pretty useless to have one setup() function separated along with
module_init() which only calls a function from ip2main anyway.  Get rid of
ip2base.

Remove also checks of always-true now.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ip2/Makefile  |    2 
 drivers/char/ip2/ip2base.c |  108 -----------------------------------
 drivers/char/ip2/ip2main.c |   92 ++++++++++++++++++++++++-----
 3 files changed, 77 insertions(+), 125 deletions(-)

diff -puN drivers/char/ip2/Makefile~char-merge-ip2main-and-ip2base drivers/char/ip2/Makefile
--- a/drivers/char/ip2/Makefile~char-merge-ip2main-and-ip2base
+++ a/drivers/char/ip2/Makefile
@@ -4,5 +4,5 @@
 
 obj-$(CONFIG_COMPUTONE)         += ip2.o
 
-ip2-objs			:= ip2base.o ip2main.o
+ip2-objs			:= ip2main.o
 
diff -puN drivers/char/ip2/ip2base.c~char-merge-ip2main-and-ip2base /dev/null
--- a/drivers/char/ip2/ip2base.c
+++ /dev/null
@@ -1,108 +0,0 @@
-// ip2.c
-// This is a dummy module to make the firmware available when needed
-// and allows it to be unloaded when not. Rumor is the __initdata 
-// macro doesn't always works on all platforms so we use this kludge.
-// If not compiled as a module it just makes fip_firm avaliable then
-//  __initdata should work as advertized
-//
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/wait.h>
-
-#ifndef __init
-#define __init
-#endif
-#ifndef __initfunc
-#define __initfunc(a) a
-#endif
-#ifndef __initdata
-#define __initdata
-#endif
-
-#include "ip2types.h"		
-
-int
-ip2_loadmain(int *, int *); // ref into ip2main.c
-
-/* Note: Add compiled in defaults to these arrays, not to the structure
-	in ip2.h any longer.  That structure WILL get overridden
-	by these values, or command line values, or insmod values!!!  =mhw=
-*/
-static int io[IP2_MAX_BOARDS]= { 0, 0, 0, 0 };
-static int irq[IP2_MAX_BOARDS] = { -1, -1, -1, -1 }; 
-
-static int poll_only = 0;
-
-MODULE_AUTHOR("Doug McNash");
-MODULE_DESCRIPTION("Computone IntelliPort Plus Driver");
-module_param_array(irq, int, NULL, 0);
-MODULE_PARM_DESC(irq,"Interrupts for IntelliPort Cards");
-module_param_array(io, int, NULL, 0);
-MODULE_PARM_DESC(io,"I/O ports for IntelliPort Cards");
-module_param(poll_only, bool, 0);
-MODULE_PARM_DESC(poll_only,"Do not use card interrupts");
-
-
-static int __init ip2_init(void)
-{
-	if( poll_only ) {
-		/* Hard lock the interrupts to zero */
-		irq[0] = irq[1] = irq[2] = irq[3] = 0;
-	}
-
-	return ip2_loadmain(io, irq);
-}
-module_init(ip2_init);
-
-MODULE_LICENSE("GPL");
-
-#ifndef MODULE
-/******************************************************************************
- *	ip2_setup:
- *		str: kernel command line string
- *
- *	Can't autoprobe the boards so user must specify configuration on
- *	kernel command line.  Sane people build it modular but the others
- *	come here.
- *
- *	Alternating pairs of io,irq for up to 4 boards.
- *		ip2=io0,irq0,io1,irq1,io2,irq2,io3,irq3
- *
- *		io=0 => No board
- *		io=1 => PCI
- *		io=2 => EISA
- *		else => ISA I/O address
- *
- *		irq=0 or invalid for ISA will revert to polling mode
- *
- *		Any value = -1, do not overwrite compiled in value.
- *
- ******************************************************************************/
-static int __init ip2_setup(char *str)
-{
-	int	ints[10];	/* 4 boards, 2 parameters + 2 */
-	int	i, j;
-
-	str = get_options (str, ARRAY_SIZE(ints), ints);
-
-	for( i = 0, j = 1; i < 4; i++ ) {
-		if( j > ints[0] ) {
-			break;
-		}
-		if( ints[j] >= 0 ) {
-			io[i] = ints[j];
-		}
-		j++;
-		if( j > ints[0] ) {
-			break;
-		}
-		if( ints[j] >= 0 ) {
-			irq[i] = ints[j];
-		}
-		j++;
-	}
-	return 1;
-}
-__setup("ip2=", ip2_setup);
-#endif /* !MODULE */
diff -puN drivers/char/ip2/ip2main.c~char-merge-ip2main-and-ip2base drivers/char/ip2/ip2main.c
--- a/drivers/char/ip2/ip2main.c~char-merge-ip2main-and-ip2base
+++ a/drivers/char/ip2/ip2main.c
@@ -157,9 +157,6 @@ static char *pcVersion = "1.2.14";
 static char *pcDriver_name   = "ip2";
 static char *pcIpl    		 = "ip2ipl";
 
-// cheezy kludge or genius - you decide?
-int ip2_loadmain(int *, int *);
-
 /***********************/
 /* Function Prototypes */
 /***********************/
@@ -287,6 +284,7 @@ static int tracewrap;
 
 MODULE_AUTHOR("Doug McNash");
 MODULE_DESCRIPTION("Computone IntelliPort Plus Driver");
+MODULE_LICENSE("GPL");
 
 static int poll_only = 0;
 
@@ -297,6 +295,22 @@ static int iindx;
 static char rirqs[IP2_MAX_BOARDS];
 static int Valid_Irqs[] = { 3, 4, 5, 7, 10, 11, 12, 15, 0};
 
+/* Note: Add compiled in defaults to these arrays, not to the structure
+	in ip2.h any longer.  That structure WILL get overridden
+	by these values, or command line values, or insmod values!!!  =mhw=
+*/
+static int io[IP2_MAX_BOARDS];
+static int irq[IP2_MAX_BOARDS] = { -1, -1, -1, -1 };
+
+MODULE_AUTHOR("Doug McNash");
+MODULE_DESCRIPTION("Computone IntelliPort Plus Driver");
+module_param_array(irq, int, NULL, 0);
+MODULE_PARM_DESC(irq, "Interrupts for IntelliPort Cards");
+module_param_array(io, int, NULL, 0);
+MODULE_PARM_DESC(io, "I/O ports for IntelliPort Cards");
+module_param(poll_only, bool, 0);
+MODULE_PARM_DESC(poll_only, "Do not use card interrupts");
+
 /* for sysfs class support */
 static struct class *ip2_class;
 
@@ -494,8 +508,53 @@ static const struct firmware *ip2_reques
 	return fw;
 }
 
-int
-ip2_loadmain(int *iop, int *irqp)
+#ifndef MODULE
+/******************************************************************************
+ *	ip2_setup:
+ *		str: kernel command line string
+ *
+ *	Can't autoprobe the boards so user must specify configuration on
+ *	kernel command line.  Sane people build it modular but the others
+ *	come here.
+ *
+ *	Alternating pairs of io,irq for up to 4 boards.
+ *		ip2=io0,irq0,io1,irq1,io2,irq2,io3,irq3
+ *
+ *		io=0 => No board
+ *		io=1 => PCI
+ *		io=2 => EISA
+ *		else => ISA I/O address
+ *
+ *		irq=0 or invalid for ISA will revert to polling mode
+ *
+ *		Any value = -1, do not overwrite compiled in value.
+ *
+ ******************************************************************************/
+static int __init ip2_setup(char *str)
+{
+	int j, ints[10];	/* 4 boards, 2 parameters + 2 */
+	unsigned int i;
+
+	str = get_options(str, ARRAY_SIZE(ints), ints);
+
+	for (i = 0, j = 1; i < 4; i++) {
+		if (j > ints[0])
+			break;
+		if (ints[j] >= 0)
+			io[i] = ints[j];
+		j++;
+		if (j > ints[0])
+			break;
+		if (ints[j] >= 0)
+			irq[i] = ints[j];
+		j++;
+	}
+	return 1;
+}
+__setup("ip2=", ip2_setup);
+#endif /* !MODULE */
+
+static int ip2_loadmain(void)
 {
 	int i, j, box;
 	int err = 0;
@@ -505,6 +564,11 @@ ip2_loadmain(int *iop, int *irqp)
 	static struct pci_dev *pci_dev_i = NULL;
 	const struct firmware *fw = NULL;
 
+	if (poll_only) {
+		/* Hard lock the interrupts to zero */
+		irq[0] = irq[1] = irq[2] = irq[3] = poll_only = 0;
+	}
+
 	ip2trace (ITRC_NO_PORT, ITRC_INIT, ITRC_ENTER, 0 );
 
 	/* process command line arguments to modprobe or
@@ -512,14 +576,11 @@ ip2_loadmain(int *iop, int *irqp)
 	/* irqp and iop should ALWAYS be specified now...  But we check
 		them individually just to be sure, anyways... */
 	for ( i = 0; i < IP2_MAX_BOARDS; ++i ) {
-		if (iop) {
-			ip2config.addr[i] = iop[i];
-			if (irqp) {
-				if( irqp[i] >= 0 ) {
-					ip2config.irq[i] = irqp[i];
-				} else {
-					ip2config.irq[i] = 0;
-				}
+		ip2config.addr[i] = io[i];
+		if (irq[i] >= 0)
+			ip2config.irq[i] = irq[i];
+		else
+			ip2config.irq[i] = 0;
 	// This is a little bit of a hack.  If poll_only=1 on command
 	// line back in ip2.c OR all IRQs on all specified boards are
 	// explicitly set to 0, then drop to poll only mode and override
@@ -531,9 +592,7 @@ ip2_loadmain(int *iop, int *irqp)
 	// to -1, is to use 0 as a hard coded, do not probe.
 	//
 	//	/\/\|=mhw=|\/\/
-				poll_only |= irqp[i];
-			}
-		}
+		poll_only |= irq[i];
 	}
 	poll_only = !poll_only;
 
@@ -783,6 +842,7 @@ out_chrdev:
 out:
 	return err;
 }
+module_init(ip2_loadmain);
 
 /******************************************************************************/
 /* Function:   ip2_init_board()                                               */
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

