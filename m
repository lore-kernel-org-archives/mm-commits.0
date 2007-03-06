From: akpm@linux-foundation.org
Subject: - ipmi-add-new-ipmi-nmi-watchdog-handling-cleanup.patch removed from -mm tree
Date: Mon, 05 Mar 2007 16:58:40 -0800
Message-ID: <200703060058.l260wfWZ006919@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43653 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933701AbXCFA6w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 19:58:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minyard@acm.org, mm-commits@vger.kernel.org


The patch titled
     ipmi: add new IPMI nmi watchdog handling (cleanup)
has been removed from the -mm tree.  Its filename was
     ipmi-add-new-ipmi-nmi-watchdog-handling-cleanup.patch

This patch was dropped because it was folded into ipmi-add-new-ipmi-nmi-watchdog-handling.patch

------------------------------------------------------
Subject: ipmi: add new IPMI nmi watchdog handling (cleanup)
From: Corey Minyard <minyard@acm.org>

Reduce the "gruesomness" of the IPMI NMI watchdog handling.

Basically, I've looked at this and thought about it a while, and the only
reasonable architecture that will currently support this is x86.  Anything
else is just a pipe dream and the implementation would be quite different
and difficult to predict.  So just make this x86-only for now and remove
all the junk that is no longer necessary.

Signed-off-by: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig.debug           |    4 ----
 arch/x86_64/Kconfig.debug         |    4 ----
 drivers/char/ipmi/ipmi_watchdog.c |   25 +++++++++++++++++--------
 include/asm-i386/kdebug.h         |    2 --
 include/asm-x86_64/kdebug.h       |    2 --
 5 files changed, 17 insertions(+), 20 deletions(-)

diff -puN arch/i386/Kconfig.debug~ipmi-add-new-ipmi-nmi-watchdog-handling-cleanup arch/i386/Kconfig.debug
--- a/arch/i386/Kconfig.debug~ipmi-add-new-ipmi-nmi-watchdog-handling-cleanup
+++ a/arch/i386/Kconfig.debug
@@ -4,10 +4,6 @@ config TRACE_IRQFLAGS_SUPPORT
 	bool
 	default y
 
-config HAVE_STANDARD_NOTIFY_DIE
-	bool
-	default y
-
 source "lib/Kconfig.debug"
 
 config EARLY_PRINTK
diff -puN arch/x86_64/Kconfig.debug~ipmi-add-new-ipmi-nmi-watchdog-handling-cleanup arch/x86_64/Kconfig.debug
--- a/arch/x86_64/Kconfig.debug~ipmi-add-new-ipmi-nmi-watchdog-handling-cleanup
+++ a/arch/x86_64/Kconfig.debug
@@ -4,10 +4,6 @@ config TRACE_IRQFLAGS_SUPPORT
 	bool
 	default y
 
-config HAVE_STANDARD_NOTIFY_DIE
-	bool
-	default y
-
 source "lib/Kconfig.debug"
 
 config DEBUG_RODATA
diff -puN drivers/char/ipmi/ipmi_watchdog.c~ipmi-add-new-ipmi-nmi-watchdog-handling-cleanup drivers/char/ipmi/ipmi_watchdog.c
--- a/drivers/char/ipmi/ipmi_watchdog.c~ipmi-add-new-ipmi-nmi-watchdog-handling-cleanup
+++ a/drivers/char/ipmi/ipmi_watchdog.c
@@ -51,8 +51,17 @@
 #include <linux/ctype.h>
 #include <linux/delay.h>
 #include <asm/atomic.h>
-#ifdef CONFIG_HAVE_STANDARD_NOTIFY_DIE
+
+#ifdef CONFIG_X86
+/* This is ugly, but I've determined that x86 is the only architecture
+   that can reasonably support the IPMI NMI watchdog timeout at this
+   time.  If another architecture adds this capability somehow, it
+   will have to be a somewhat different mechanism and I have no idea
+   how it will work.  So in the unlikely event that another
+   architecture supports this, we can figure out a good generic
+   mechanism for it at that time. */
 #include <asm/kdebug.h>
+#define HAVE_DIE_NMI_POST
 #endif
 
 #define	PFX "IPMI Watchdog: "
@@ -364,6 +373,10 @@ static int i_ipmi_set_timeout(struct ipm
 	int                               hbnow = 0;
 
 
+	/* These can be cleared as we are setting the timeout. */
+	ipmi_start_timer_on_heartbeat = 0;
+	pretimeout_since_last_heartbeat = 0;
+
 	data[0] = 0;
 	WDOG_SET_TIMER_USE(data[0], WDOG_TIMER_USE_SMS_OS);
 
@@ -438,13 +451,12 @@ static int ipmi_set_timeout(int do_heart
 
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
@@ -524,12 +536,10 @@ static int ipmi_heartbeat(void)
 	int                               rv;
 	struct ipmi_system_interface_addr addr;
 
-	if (ipmi_ignore_heartbeat) {
+	if (ipmi_ignore_heartbeat)
 		return 0;
-	}
 
 	if (ipmi_start_timer_on_heartbeat) {
-		ipmi_start_timer_on_heartbeat = 0;
 		ipmi_watchdog_state = action_val;
 		return ipmi_set_timeout(IPMI_SET_TIMEOUT_FORCE_HB);
 	} else if (pretimeout_since_last_heartbeat) {
@@ -537,7 +547,6 @@ static int ipmi_heartbeat(void)
 		   We don't want to set the action, though, we want to
 		   leave that alone (thus it can't be combined with the
 		   above operation. */
-		pretimeout_since_last_heartbeat = 0;
 		return ipmi_set_timeout(IPMI_SET_TIMEOUT_HB_IF_NECESSARY);
 	}
 
diff -puN include/asm-i386/kdebug.h~ipmi-add-new-ipmi-nmi-watchdog-handling-cleanup include/asm-i386/kdebug.h
--- a/include/asm-i386/kdebug.h~ipmi-add-new-ipmi-nmi-watchdog-handling-cleanup
+++ a/include/asm-i386/kdebug.h
@@ -42,8 +42,6 @@ enum die_val {
 	DIE_PAGE_FAULT,
 };
 
-#define HAVE_DIE_NMI_POST
-
 static inline int notify_die(enum die_val val, const char *str,
 			struct pt_regs *regs, long err, int trap, int sig)
 {
diff -puN include/asm-x86_64/kdebug.h~ipmi-add-new-ipmi-nmi-watchdog-handling-cleanup include/asm-x86_64/kdebug.h
--- a/include/asm-x86_64/kdebug.h~ipmi-add-new-ipmi-nmi-watchdog-handling-cleanup
+++ a/include/asm-x86_64/kdebug.h
@@ -37,8 +37,6 @@ enum die_val {
 	DIE_PAGE_FAULT,
 };
 
-#define HAVE_DIE_NMI_POST
-
 static inline int notify_die(enum die_val val, const char *str,
 			struct pt_regs *regs, long err, int trap, int sig)
 {
_

Patches currently in -mm which might be from minyard@acm.org are

origin.patch
ipmi-add-powerpc-openfirmware-sensing.patch
ipmi-allow-shared-interrupts.patch
ipmi-add-new-ipmi-nmi-watchdog-handling.patch
ipmi-add-new-ipmi-nmi-watchdog-handling-cleanup.patch
ipmi-add-pci-remove-handling.patch
