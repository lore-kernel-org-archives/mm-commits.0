From: akpm@linux-foundation.org
Subject: + ipmi-new-nmi-handling.patch added to -mm tree
Date: Mon, 15 Oct 2007 14:54:11 -0700
Message-ID: <200710152154.l9FLsB4F026988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45801 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762216AbXJOVyQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 17:54:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minyard@acm.org


The patch titled
     IPMI: new NMI handling
has been added to the -mm tree.  Its filename is
     ipmi-new-nmi-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: IPMI: new NMI handling
From: Corey Minyard <minyard@acm.org>

Convert over to the new NMI handling for getting IPMI watchdog timeouts via an
NMI.  This add config options to know if there is the ability to receive NMIs
and if it has an NMI post processing call.  Then it modifies the IPMI watchdog
to take advantage of this so that it can know if an NMI comes in.

It also adds testing that the IPMI NMI watchdog works.

Signed-off-by: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/IPMI.txt            |    8 -
 drivers/char/ipmi/ipmi_watchdog.c |  146 ++++++++++++++++++++--------
 2 files changed, 110 insertions(+), 44 deletions(-)

diff -puN Documentation/IPMI.txt~ipmi-new-nmi-handling Documentation/IPMI.txt
--- a/Documentation/IPMI.txt~ipmi-new-nmi-handling
+++ a/Documentation/IPMI.txt
@@ -584,9 +584,11 @@ The watchdog will panic and start a 120 
 gets a pre-action.  During a panic or a reboot, the watchdog will
 start a 120 timer if it is running to make sure the reboot occurs.
 
-Note that if you use the NMI preaction for the watchdog, you MUST
-NOT use nmi watchdog mode 1.  If you use the NMI watchdog, you
-must use mode 2.
+Note that if you use the NMI preaction for the watchdog, you MUST NOT
+use the nmi watchdog.  There is no reasonable way to tell if an NMI
+comes from the IPMI controller, so it must assume that if it gets an
+otherwise unhandled NMI, it must be from IPMI and it will panic
+immediately.
 
 Once you open the watchdog timer, you must write a 'V' character to the
 device to close it, or the timer will not stop.  This is a new semantic
diff -puN drivers/char/ipmi/ipmi_watchdog.c~ipmi-new-nmi-handling drivers/char/ipmi/ipmi_watchdog.c
--- a/drivers/char/ipmi/ipmi_watchdog.c~ipmi-new-nmi-handling
+++ a/drivers/char/ipmi/ipmi_watchdog.c
@@ -50,10 +50,19 @@
 #include <linux/poll.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
+#include <linux/delay.h>
 #include <asm/atomic.h>
 
-#ifdef CONFIG_X86_LOCAL_APIC
-#include <asm/apic.h>
+#ifdef CONFIG_X86
+/* This is ugly, but I've determined that x86 is the only architecture
+   that can reasonably support the IPMI NMI watchdog timeout at this
+   time.  If another architecture adds this capability somehow, it
+   will have to be a somewhat different mechanism and I have no idea
+   how it will work.  So in the unlikely event that another
+   architecture supports this, we can figure out a good generic
+   mechanism for it at that time. */
+#include <asm/kdebug.h>
+#define HAVE_DIE_NMI
 #endif
 
 #define	PFX "IPMI Watchdog: "
@@ -313,6 +322,11 @@ static unsigned char ipmi_version_minor;
 /* If a pretimeout occurs, this is used to allow only one panic to happen. */
 static atomic_t preop_panic_excl = ATOMIC_INIT(-1);
 
+#ifdef HAVE_DIE_NMI
+static int testing_nmi;
+static int nmi_handler_registered;
+#endif
+
 static int ipmi_heartbeat(void);
 
 /* We use a mutex to make sure that only one thing can send a set
@@ -352,6 +366,9 @@ static int i_ipmi_set_timeout(struct ipm
 	int                               hbnow = 0;
 
 
+	/* These can be cleared as we are setting the timeout. */
+	pretimeout_since_last_heartbeat = 0;
+
 	data[0] = 0;
 	WDOG_SET_TIMER_USE(data[0], WDOG_TIMER_USE_SMS_OS);
 
@@ -426,13 +443,12 @@ static int ipmi_set_timeout(int do_heart
 
 	wait_for_completion(&set_timeout_wait);
 
+	mutex_unlock(&set_timeout_lock);
+
 	if ((do_heartbeat == IPMI_SET_TIMEOUT_FORCE_HB)
 	    || ((send_heartbeat_now)
 		&& (do_heartbeat == IPMI_SET_TIMEOUT_HB_IF_NECESSARY)))
-	{
 		rv = ipmi_heartbeat();
-	}
-	mutex_unlock(&set_timeout_lock);
 
 out:
 	return rv;
@@ -556,9 +572,8 @@ static int ipmi_heartbeat(void)
 	int                               rv;
 	struct ipmi_system_interface_addr addr;
 
-	if (ipmi_ignore_heartbeat) {
+	if (ipmi_ignore_heartbeat)
 		return 0;
-	}
 
 	if (ipmi_start_timer_on_heartbeat) {
 		ipmi_start_timer_on_heartbeat = 0;
@@ -569,7 +584,6 @@ static int ipmi_heartbeat(void)
 		   We don't want to set the action, though, we want to
 		   leave that alone (thus it can't be combined with the
 		   above operation. */
-		pretimeout_since_last_heartbeat = 0;
 		return ipmi_set_timeout(IPMI_SET_TIMEOUT_HB_IF_NECESSARY);
 	}
 
@@ -927,6 +941,45 @@ static void ipmi_register_watchdog(int i
 		printk(KERN_CRIT PFX "Unable to register misc device\n");
 	}
 
+#ifdef HAVE_DIE_NMI
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
 	if ((start_now) && (rv == 0)) {
 		/* Run from startup, so start the timer now. */
@@ -934,6 +987,10 @@ static void ipmi_register_watchdog(int i
 		ipmi_watchdog_state = action_val;
 		ipmi_set_timeout(IPMI_SET_TIMEOUT_FORCE_HB);
 		printk(KERN_INFO PFX "Starting now!\n");
+	} else {
+		/* Stop the timer now. */
+		ipmi_watchdog_state = WDOG_TIMEOUT_NONE;
+		ipmi_set_timeout(IPMI_SET_TIMEOUT_NO_HB);
 	}
 }
 
@@ -968,17 +1025,41 @@ static void ipmi_unregister_watchdog(int
 	return;
 }
 
-#ifdef HAVE_NMI_HANDLER
+#ifdef HAVE_DIE_NMI
 static int
-ipmi_nmi(void *dev_id, int cpu, int handled)
+ipmi_nmi(struct notifier_block *self, unsigned long val, void *data)
 {
+	struct die_args *args = data;
+
+	if (val != DIE_NMI)
+		return NOTIFY_OK;
+
+	/* Hack, if it's a memory or I/O error, ignore it. */
+	if (args->err & 0xc0)
+		return NOTIFY_OK;
+
+	/*
+	 * If we get here, it's an NMI that's not a memory or I/O
+	 * error.  We can't truly tell if it's from IPMI or not
+	 * without sending a message, and sending a message is almost
+	 * impossible because of locking.
+	 */
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
@@ -987,18 +1068,12 @@ ipmi_nmi(void *dev_id, int cpu, int hand
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
@@ -1115,7 +1190,7 @@ static int preaction_op(const char *inva
 		preaction_val = WDOG_PRETIMEOUT_NONE;
 	else if (strcmp(inval, "pre_smi") == 0)
 		preaction_val = WDOG_PRETIMEOUT_SMI;
-#ifdef HAVE_NMI_HANDLER
+#ifdef HAVE_DIE_NMI
 	else if (strcmp(inval, "pre_nmi") == 0)
 		preaction_val = WDOG_PRETIMEOUT_NMI;
 #endif
@@ -1149,7 +1224,7 @@ static int preop_op(const char *inval, c
 
 static void check_parms(void)
 {
-#ifdef HAVE_NMI_HANDLER
+#ifdef HAVE_DIE_NMI
 	int do_nmi = 0;
 	int rv;
 
@@ -1162,20 +1237,9 @@ static void check_parms(void)
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
@@ -1183,7 +1247,7 @@ static void check_parms(void)
 		} else
 			nmi_handler_registered = 1;
 	} else if (!do_nmi && nmi_handler_registered) {
-		release_nmi(&ipmi_nmi_handler);
+		unregister_die_notifier(&ipmi_nmi_handler);
 		nmi_handler_registered = 0;
 	}
 #endif
@@ -1219,9 +1283,9 @@ static int __init ipmi_wdog_init(void)
 
 	rv = ipmi_smi_watcher_register(&smi_watcher);
 	if (rv) {
-#ifdef HAVE_NMI_HANDLER
-		if (preaction_val == WDOG_PRETIMEOUT_NMI)
-			release_nmi(&ipmi_nmi_handler);
+#ifdef HAVE_DIE_NMI
+		if (nmi_handler_registered)
+			unregister_die_notifier(&ipmi_nmi_handler);
 #endif
 		atomic_notifier_chain_unregister(&panic_notifier_list,
 						 &wdog_panic_notifier);
@@ -1240,9 +1304,9 @@ static void __exit ipmi_wdog_exit(void)
 	ipmi_smi_watcher_unregister(&smi_watcher);
 	ipmi_unregister_watchdog(watchdog_ifnum);
 
-#ifdef HAVE_NMI_HANDLER
+#ifdef HAVE_DIE_NMI
 	if (nmi_handler_registered)
-		release_nmi(&ipmi_nmi_handler);
+		unregister_die_notifier(&ipmi_nmi_handler);
 #endif
 
 	atomic_notifier_chain_unregister(&panic_notifier_list,
_

Patches currently in -mm which might be from minyard@acm.org are

tweak-proc-ipmi-removal.patch
ipmi-new-nmi-handling.patch
