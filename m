From: akpm@osdl.org
Subject: + extract-and-use-wake_up_klogd.patch added to -mm tree
Date: Tue, 23 Jan 2007 23:31:28 -0800
Message-ID: <200701240731.l0O7VS9R011676@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56304 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933188AbXAXHbe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 02:31:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dev@sw.ru, adobriyan@openvz.org


The patch titled
     Extract and use wake_up_klogd()
has been added to the -mm tree.  Its filename is
     extract-and-use-wake_up_klogd.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Extract and use wake_up_klogd()
From: Kirill Korotaev <dev@sw.ru>

Remove hack with printing space to wake up klogd.  Use explicit
wake_up_klogd().

See earlier discussion
http://groups.google.com/group/fa.linux.kernel/browse_frm/thread/75f496668409f58d/1a8f28983a51e1ff?lnk=st&q=wake_up_klogd+group%3Afa.linux.kernel&rnum=2#1a8f28983a51e1ff

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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

consolidate-bust_spinlocks.patch
extract-and-use-wake_up_klogd.patch
nsproxy-externalizes-exit_task_namespaces.patch
user-namespace-add-the-framework.patch
user-namespace-add-the-framework-fix.patch
user-ns-add-user_namespace-ptr-to-vfsmount.patch
user-ns-hook-permission.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix.patch
user-ns-implement-shared-mounts.patch
user_ns-handle-file-sigio.patch
user_ns-handle-file-sigio-fix.patch
user-ns-implement-user-ns-unshare.patch
user-ns-implement-user-ns-unshare-tidy.patch
user-ns-implement-user-ns-unshare-remove-config_user_ns.patch
sysctl-move-utsname-sysctls-to-their-own-file.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file.patch
