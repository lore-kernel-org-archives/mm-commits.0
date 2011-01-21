From: akpm@linux-foundation.org
Subject: + console-prevent-registered-consoles-from-dumping-old-kernel-message-over-again.patch added to -mm tree
Date: Thu, 20 Jan 2011 16:22:28 -0800
Message-ID: <201101210022.p0L0MSJb011269@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753701Ab1AUAWn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Jan 2011 19:22:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: feng.tang@intel.com, alan@lxorguk.ukuu.org.uk, gregkh@suse.de


The patch titled
     console: prevent registered consoles from dumping old kernel message over again
has been added to the -mm tree.  Its filename is
     console-prevent-registered-consoles-from-dumping-old-kernel-message-over-again.patch

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
Subject: console: prevent registered consoles from dumping old kernel message over again
From: Feng Tang <feng.tang@intel.com>

For a platform with many consoles like:
 "console=tty1 console=ttyMFD2 console=ttyS0 earlyprintk=mrst"

Each time when the non "selected_console" (tty1 and ttyMFD2 here) get
registered, the existing kernel message will be printed out on registered
consoles again, the "mrst" early console will get some same message for 3
times, and "tty1" will get some for twice.

As suggested by Andrew Morton, every time a new console is registered, it
will be set as the "exclusive" console which will dump the already
existing kernel messages.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN kernel/printk.c~console-prevent-registered-consoles-from-dumping-old-kernel-message-over-again kernel/printk.c
--- a/kernel/printk.c~console-prevent-registered-consoles-from-dumping-old-kernel-message-over-again
+++ a/kernel/printk.c
@@ -113,6 +113,11 @@ static unsigned con_start;	/* Index into
 static unsigned log_end;	/* Index into log_buf: most-recently-written-char + 1 */
 
 /*
+ * If exclusive_console is non-NULL then only this console is to be printed to.
+ */
+static struct console *exclusive_console;
+
+/*
  *	Array of consoles built from command line options (console=)
  */
 struct console_cmdline
@@ -460,6 +465,8 @@ static void __call_console_drivers(unsig
 	struct console *con;
 
 	for_each_console(con) {
+		if (exclusive_console && con != exclusive_console)
+			continue;
 		if ((con->flags & CON_ENABLED) && con->write &&
 				(cpu_online(smp_processor_id()) ||
 				(con->flags & CON_ANYTIME)))
@@ -1144,6 +1151,11 @@ void console_unlock(void)
 		local_irq_restore(flags);
 	}
 	console_locked = 0;
+
+	/* Release the exclusive_console once it is used */
+	if (unlikely(exclusive_console))
+		exclusive_console = NULL;
+
 	up(&console_sem);
 	spin_unlock_irqrestore(&logbuf_lock, flags);
 	if (wake_klogd)
@@ -1378,6 +1390,12 @@ void register_console(struct console *ne
 		spin_lock_irqsave(&logbuf_lock, flags);
 		con_start = log_start;
 		spin_unlock_irqrestore(&logbuf_lock, flags);
+		/*
+		 * We're about to replay the log buffer.  Only do this to the
+		 * just-registered console to avoid excessive message spam to
+		 * the already-registered consoles.
+		 */
+		exclusive_console = newcon;
 	}
 	console_unlock();
 	console_sysfs_notify();
_

Patches currently in -mm which might be from feng.tang@intel.com are

console-prevent-registered-consoles-from-dumping-old-kernel-message-over-again.patch

