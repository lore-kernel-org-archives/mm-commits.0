From: akpm@linux-foundation.org
Subject: + ipmi-add-new-ipmi-nmi-watchdog-handling.patch added to -mm tree
Date: Wed, 14 Feb 2007 19:57:40 -0800
Message-ID: <200702150357.l1F3vepk019136@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32907 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932309AbXBOD5o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 22:57:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minyard@acm.org


The patch titled
     ipmi: add new IPMI nmi watchdog handling
has been added to the -mm tree.  Its filename is
     ipmi-add-new-ipmi-nmi-watchdog-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ipmi: add new IPMI nmi watchdog handling
From: Corey Minyard <minyard@acm.org>

Convert over to the new NMI handling for getting IPMI watchdog timeouts via an
NMI.  This add config options to know if there is the ability to receive NMIs
and if it has an NMI post processing call.  Then it modifies the IPMI watchdog
to take advantage of this so that it can know if an NMI comes in.

It also adds testing that the IPMI NMI watchdog works.

Signed-off-by: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig.debug           |    4 
 arch/i386/kernel/traps.c          |    5 +
 arch/x86_64/Kconfig.debug         |    4 
 arch/x86_64/kernel/traps.c        |    2 
 drivers/char/ipmi/ipmi_watchdog.c |  113 +++++++++++++++++++---------
 include/asm-i386/kdebug.h         |    3 
 include/asm-x86_64/kdebug.h       |    3 
 7 files changed, 99 insertions(+), 35 deletions(-)

diff -puN arch/i386/Kconfig.debug~ipmi-add-new-ipmi-nmi-watchdog-handling arch/i386/Kconfig.debug
--- a/arch/i386/Kconfig.debug~ipmi-add-new-ipmi-nmi-watchdog-handling
+++ a/arch/i386/Kconfig.debug
@@ -4,6 +4,10 @@ config TRACE_IRQFLAGS_SUPPORT
 	bool
 	default y
 
+config HAVE_STANDARD_NOTIFY_DIE
+	bool
+	default y
+
 source "lib/Kconfig.debug"
 
 config EARLY_PRINTK
diff -puN arch/i386/kernel/traps.c~ipmi-add-new-ipmi-nmi-watchdog-handling arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c~ipmi-add-new-ipmi-nmi-watchdog-handling
+++ a/arch/i386/kernel/traps.c
@@ -745,6 +745,11 @@ static __kprobes void default_do_nmi(str
 		 */
 		if (nmi_watchdog_tick(regs, reason))
 			return;
+#endif
+		if (notify_die(DIE_NMI_POST, "nmi_post", regs, reason, 2, 0)
+							== NOTIFY_STOP)
+			return;
+#ifdef CONFIG_X86_LOCAL_APIC
 		if (!do_nmi_callback(regs, smp_processor_id()))
 #endif
 			unknown_nmi_error(reason, regs);
diff -puN arch/x86_64/Kconfig.debug~ipmi-add-new-ipmi-nmi-watchdog-handling arch/x86_64/Kconfig.debug
--- a/arch/x86_64/Kconfig.debug~ipmi-add-new-ipmi-nmi-watchdog-handling
+++ a/arch/x86_64/Kconfig.debug
@@ -4,6 +4,10 @@ config TRACE_IRQFLAGS_SUPPORT
 	bool
 	default y
 
+config HAVE_STANDARD_NOTIFY_DIE
+	bool
+	default y
+
 source "lib/Kconfig.debug"
 
 config DEBUG_RODATA
diff -puN arch/x86_64/kernel/traps.c~ipmi-add-new-ipmi-nmi-watchdog-handling arch/x86_64/kernel/traps.c
--- a/arch/x86_64/kernel/traps.c~ipmi-add-new-ipmi-nmi-watchdog-handling
+++ a/arch/x86_64/kernel/traps.c
@@ -791,6 +791,8 @@ asmlinkage __kprobes void default_do_nmi
 		 */
 		if (nmi_watchdog_tick(regs,reason))
 			return;
+		if (notify_die(DIE_NMI_POST, "nmi_post", regs, reason, 2, 0)
+								== NOTIFY_STOP)
 		if (!do_nmi_callback(regs,cpu))
 			unknown_nmi_error(reason, regs);
 
diff -puN drivers/char/ipmi/ipmi_watchdog.c~ipmi-add-new-ipmi-nmi-watchdog-handling drivers/char/ipmi/ipmi_watchdog.c
--- a/drivers/char/ipmi/ipmi_watchdog.c~ipmi-add-new-ipmi-nmi-watchdog-handling
+++ a/drivers/char/ipmi/ipmi_watchdog.c
@@ -49,9 +49,10 @@
 #include <linux/poll.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
+#include <linux/delay.h>
 #include <asm/atomic.h>
-#ifdef CONFIG_X86_LOCAL_APIC
-#include <asm/apic.h>
+#ifdef CONFIG_HAVE_STANDARD_NOTIFY_DIE
+#include <asm/kdebug.h>
 #endif
 
 #define	PFX "IPMI Watchdog: "
@@ -317,6 +318,11 @@ static unsigned char ipmi_version_minor;
 /* If a pretimeout occurs, this is used to allow only one panic to happen. */
 static atomic_t preop_panic_excl = ATOMIC_INIT(-1);
 
+#ifdef HAVE_DIE_NMI_POST
+static int testing_nmi;
+static int nmi_handler_registered;
+#endif
+
 static int ipmi_heartbeat(void);
 static void panic_halt_ipmi_heartbeat(void);
 
@@ -919,6 +925,45 @@ static void ipmi_register_watchdog(int i
 		printk(KERN_CRIT PFX "Unable to register misc device\n");
 	}
 
+#ifdef HAVE_DIE_NMI_POST
+	if (nmi_handler_registered) {
+		int old_pretimeout = pretimeout;
+		int old_timeout = timeout;
+		int old_preop_val = preop_val;
+
+		/* Set the pretimeout to go off in a second and give
+		   ourselves plenty of time to stop the timer. */
+		ipmi_watchdog_state = WDOG_TIMEOUT_RESET;
+		preop_val = WDOG_PREOP_NONE; /* Make sure nothing happens */
+		pretimeout = 99;
+		timeout = 100;
+
+		testing_nmi = 1;
+
+		rv = ipmi_set_timeout(IPMI_SET_TIMEOUT_FORCE_HB);
+		if (rv) {
+			printk(KERN_WARNING PFX "Error starting timer to"
+			       " test NMI: 0x%x.  The NMI pretimeout will"
+			       " likely not work\n", rv);
+			rv = 0;
+			goto out_restore;
+		}
+
+		msleep(1500);
+
+		if (testing_nmi != 2) {
+			printk(KERN_WARNING PFX "IPMI NMI didn't seem to"
+			       " occur.  The NMI pretimeout will"
+			       " likely not work\n");
+		}
+	out_restore:
+		testing_nmi = 0;
+		preop_val = old_preop_val;
+		pretimeout = old_pretimeout;
+		timeout = old_timeout;
+	}
+#endif
+
  out:
 	up_write(&register_sem);
 
@@ -928,6 +973,10 @@ static void ipmi_register_watchdog(int i
 		ipmi_watchdog_state = action_val;
 		ipmi_set_timeout(IPMI_SET_TIMEOUT_FORCE_HB);
 		printk(KERN_INFO PFX "Starting now!\n");
+	} else {
+		/* Stop the timer now. */
+		ipmi_watchdog_state = WDOG_TIMEOUT_NONE;
+		ipmi_set_timeout(IPMI_SET_TIMEOUT_NO_HB);
 	}
 }
 
@@ -964,17 +1013,28 @@ static void ipmi_unregister_watchdog(int
 	up_write(&register_sem);
 }
 
-#ifdef HAVE_NMI_HANDLER
+#ifdef HAVE_DIE_NMI_POST
 static int
-ipmi_nmi(void *dev_id, int cpu, int handled)
+ipmi_nmi(struct notifier_block *self, unsigned long val, void *data)
 {
+	if (val != DIE_NMI_POST)
+		return NOTIFY_OK;
+
+	if (testing_nmi) {
+		testing_nmi = 2;
+		return NOTIFY_STOP;
+	}
+
         /* If we are not expecting a timeout, ignore it. */
 	if (ipmi_watchdog_state == WDOG_TIMEOUT_NONE)
-		return NOTIFY_DONE;
+		return NOTIFY_OK;
+
+	if (preaction_val != WDOG_PRETIMEOUT_NMI)
+		return NOTIFY_OK;
 
 	/* If no one else handled the NMI, we assume it was the IPMI
            watchdog. */
-	if ((!handled) && (preop_val == WDOG_PREOP_PANIC)) {
+	if (preop_val == WDOG_PREOP_PANIC) {
 		/* On some machines, the heartbeat will give
 		   an error and not work unless we re-enable
 		   the timer.   So do so. */
@@ -983,18 +1043,12 @@ ipmi_nmi(void *dev_id, int cpu, int hand
 			panic(PFX "pre-timeout");
 	}
 
-	return NOTIFY_DONE;
+	return NOTIFY_STOP;
 }
 
-static struct nmi_handler ipmi_nmi_handler =
-{
-	.link     = LIST_HEAD_INIT(ipmi_nmi_handler.link),
-	.dev_name = "ipmi_watchdog",
-	.dev_id   = NULL,
-	.handler  = ipmi_nmi,
-	.priority = 0, /* Call us last. */
+static struct notifier_block ipmi_nmi_handler = {
+	.notifier_call = ipmi_nmi
 };
-int nmi_handler_registered;
 #endif
 
 static int wdog_reboot_handler(struct notifier_block *this,
@@ -1111,7 +1165,7 @@ static int preaction_op(const char *inva
 		preaction_val = WDOG_PRETIMEOUT_NONE;
 	else if (strcmp(inval, "pre_smi") == 0)
 		preaction_val = WDOG_PRETIMEOUT_SMI;
-#ifdef HAVE_NMI_HANDLER
+#ifdef HAVE_DIE_NMI_POST
 	else if (strcmp(inval, "pre_nmi") == 0)
 		preaction_val = WDOG_PRETIMEOUT_NMI;
 #endif
@@ -1145,7 +1199,7 @@ static int preop_op(const char *inval, c
 
 static void check_parms(void)
 {
-#ifdef HAVE_NMI_HANDLER
+#ifdef HAVE_DIE_NMI_POST
 	int do_nmi = 0;
 	int rv;
 
@@ -1158,20 +1212,9 @@ static void check_parms(void)
 			preop_op("preop_none", NULL);
 			do_nmi = 0;
 		}
-#ifdef CONFIG_X86_LOCAL_APIC
-		if (nmi_watchdog == NMI_IO_APIC) {
-			printk(KERN_WARNING PFX "nmi_watchdog is set to IO APIC"
-			       " mode (value is %d), that is incompatible"
-			       " with using NMI in the IPMI watchdog."
-			       " Disabling IPMI nmi pretimeout.\n",
-			       nmi_watchdog);
-			preaction_val = WDOG_PRETIMEOUT_NONE;
-			do_nmi = 0;
-		}
-#endif
 	}
 	if (do_nmi && !nmi_handler_registered) {
-		rv = request_nmi(&ipmi_nmi_handler);
+		rv = register_die_notifier(&ipmi_nmi_handler);
 		if (rv) {
 			printk(KERN_WARNING PFX
 			       "Can't register nmi handler\n");
@@ -1179,7 +1222,7 @@ static void check_parms(void)
 		} else
 			nmi_handler_registered = 1;
 	} else if (!do_nmi && nmi_handler_registered) {
-		release_nmi(&ipmi_nmi_handler);
+		unregister_die_notifier(&ipmi_nmi_handler);
 		nmi_handler_registered = 0;
 	}
 #endif
@@ -1215,9 +1258,9 @@ static int __init ipmi_wdog_init(void)
 
 	rv = ipmi_smi_watcher_register(&smi_watcher);
 	if (rv) {
-#ifdef HAVE_NMI_HANDLER
-		if (preaction_val == WDOG_PRETIMEOUT_NMI)
-			release_nmi(&ipmi_nmi_handler);
+#ifdef HAVE_DIE_NMI_POST
+		if (nmi_handler_registered)
+			unregister_die_notifier(&ipmi_nmi_handler);
 #endif
 		atomic_notifier_chain_unregister(&panic_notifier_list,
 						 &wdog_panic_notifier);
@@ -1236,9 +1279,9 @@ static void __exit ipmi_wdog_exit(void)
 	ipmi_smi_watcher_unregister(&smi_watcher);
 	ipmi_unregister_watchdog(watchdog_ifnum);
 
-#ifdef HAVE_NMI_HANDLER
+#ifdef HAVE_DIE_NMI_POST
 	if (nmi_handler_registered)
-		release_nmi(&ipmi_nmi_handler);
+		unregister_die_notifier(&ipmi_nmi_handler);
 #endif
 
 	atomic_notifier_chain_unregister(&panic_notifier_list,
diff -puN include/asm-i386/kdebug.h~ipmi-add-new-ipmi-nmi-watchdog-handling include/asm-i386/kdebug.h
--- a/include/asm-i386/kdebug.h~ipmi-add-new-ipmi-nmi-watchdog-handling
+++ a/include/asm-i386/kdebug.h
@@ -38,9 +38,12 @@ enum die_val {
 	DIE_GPF,
 	DIE_CALL,
 	DIE_NMI_IPI,
+	DIE_NMI_POST,
 	DIE_PAGE_FAULT,
 };
 
+#define HAVE_DIE_NMI_POST
+
 static inline int notify_die(enum die_val val, const char *str,
 			struct pt_regs *regs, long err, int trap, int sig)
 {
diff -puN include/asm-x86_64/kdebug.h~ipmi-add-new-ipmi-nmi-watchdog-handling include/asm-x86_64/kdebug.h
--- a/include/asm-x86_64/kdebug.h~ipmi-add-new-ipmi-nmi-watchdog-handling
+++ a/include/asm-x86_64/kdebug.h
@@ -33,9 +33,12 @@ enum die_val {
 	DIE_GPF,
 	DIE_CALL,
 	DIE_NMI_IPI,
+	DIE_NMI_POST,
 	DIE_PAGE_FAULT,
 };
 
+#define HAVE_DIE_NMI_POST
+
 static inline int notify_die(enum die_val val, const char *str,
 			struct pt_regs *regs, long err, int trap, int sig)
 {
_

Patches currently in -mm which might be from minyard@acm.org are

origin.patch
sysctl-ipmi-remove-unnecessary-insert_at_head-flag.patch
sysctl-remove-insert_at_head-from-register_sysctl.patch
ipmi-add-powerpc-openfirmware-sensing.patch
ipmi-allow-shared-interrupts.patch
ipmi-add-pci-remove-handling.patch
ipmi-add-new-ipmi-nmi-watchdog-handling.patch
