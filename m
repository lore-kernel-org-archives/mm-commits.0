From: akpm@linux-foundation.org
Subject: - extract-and-use-wake_up_klogd.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:54:38 -0800
Message-ID: <200702112254.l1BMsc5Q016251@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60570 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932852AbXBKWzR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:55:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dev@sw.ru, adobriyan@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Extract and use wake_up_klogd()
has been removed from the -mm tree.  Its filename was
     extract-and-use-wake_up_klogd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Extract and use wake_up_klogd()
From: Kirill Korotaev <dev@sw.ru>

Remove hack with printing space to wake up klogd.  Use explicit
wake_up_klogd().

See earlier discussion
http://groups.google.com/group/fa.linux.kernel/browse_frm/thread/75f496668409f58d/1a8f28983a51e1ff?lnk=st&q=wake_up_klogd+group%3Afa.linux.kernel&rnum=2#1a8f28983a51e1ff

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    1 +
 kernel/printk.c        |   10 ++++++++--
 lib/bust_spinlocks.c   |   10 +---------
 3 files changed, 10 insertions(+), 11 deletions(-)

diff -puN include/linux/kernel.h~extract-and-use-wake_up_klogd include/linux/kernel.h
--- a/include/linux/kernel.h~extract-and-use-wake_up_klogd
+++ a/include/linux/kernel.h
@@ -176,6 +176,7 @@ static inline void console_verbose(void)
 }
 
 extern void bust_spinlocks(int yes);
+extern void wake_up_klogd(void);
 extern int oops_in_progress;		/* If set, an oops, panic(), BUG() or die() is in progress */
 extern int panic_timeout;
 extern int panic_on_oops;
diff -puN kernel/printk.c~extract-and-use-wake_up_klogd kernel/printk.c
--- a/kernel/printk.c~extract-and-use-wake_up_klogd
+++ a/kernel/printk.c
@@ -783,6 +783,12 @@ int is_console_locked(void)
 	return console_locked;
 }
 
+void wake_up_klogd(void)
+{
+	if (!oops_in_progress && waitqueue_active(&log_wait))
+		wake_up_interruptible(&log_wait);
+}
+
 /**
  * release_console_sem - unlock the console system
  *
@@ -825,8 +831,8 @@ void release_console_sem(void)
 	console_locked = 0;
 	up(&console_sem);
 	spin_unlock_irqrestore(&logbuf_lock, flags);
-	if (wake_klogd && !oops_in_progress && waitqueue_active(&log_wait))
-		wake_up_interruptible(&log_wait);
+	if (wake_klogd)
+		wake_up_klogd();
 }
 EXPORT_SYMBOL(release_console_sem);
 
diff -puN lib/bust_spinlocks.c~extract-and-use-wake_up_klogd lib/bust_spinlocks.c
--- a/lib/bust_spinlocks.c~extract-and-use-wake_up_klogd
+++ a/lib/bust_spinlocks.c
@@ -19,19 +19,11 @@ void __attribute__((weak)) bust_spinlock
 	if (yes) {
 		oops_in_progress = 1;
 	} else {
-		int loglevel_save = console_loglevel;
 #ifdef CONFIG_VT
 		unblank_screen();
 #endif
 		oops_in_progress = 0;
-		/*
-		 * OK, the message is on the console.  Now we call printk()
-		 * without oops_in_progress set so that printk() will give klogd
-		 * and the blanked console a poke.  Hold onto your hats...
-		 */
-		console_loglevel = 15;		/* NMI oopser may have shut the console up */
-		printk(" ");
-		console_loglevel = loglevel_save;
+		wake_up_klogd();
 	}
 }
 
_

Patches currently in -mm which might be from dev@sw.ru are

origin.patch
ipc-save-the-ipc-namespace-while-reading-proc-files.patch
sysctl-move-utsname-sysctls-to-their-own-file.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file.patch
