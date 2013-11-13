From: akpm@linux-foundation.org
Subject: [merged] kernel-printk-printkc-convert-to-pr_foo.patch removed
 from -mm tree
Date: Wed, 13 Nov 2013 12:40:16 -0800
Message-ID: <5283e3b0.1Ta/keDjPJpTfijZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42906 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab3KMUkR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:40:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, keescook@chromium.org, joe@perches.com, gregkh@linuxfoundation.org, fweisbec@gmail.com, akpm@linux-foundation.org

Subject: [merged] kernel-printk-printkc-convert-to-pr_foo.patch removed from -mm tree
To: akpm@linux-foundation.org,fweisbec@gmail.com,gregkh@linuxfoundation.org,joe@perches.com,keescook@chromium.org,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:40:16 -0800


The patch titled
     Subject: kernel/printk/printk.c: convert to pr_foo()
has been removed from the -mm tree.  Its filename was
     kernel-printk-printkc-convert-to-pr_foo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel/printk/printk.c: convert to pr_foo()

It was half-and-half.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN kernel/printk/printk.c~kernel-printk-printkc-convert-to-pr_foo kernel/printk/printk.c
--- a/kernel/printk/printk.c~kernel-printk-printkc-convert-to-pr_foo
+++ a/kernel/printk/printk.c
@@ -791,7 +791,7 @@ static bool __read_mostly ignore_logleve
 static int __init ignore_loglevel_setup(char *str)
 {
 	ignore_loglevel = 1;
-	printk(KERN_INFO "debug: ignoring loglevel setting.\n");
+	pr_info("debug: ignoring loglevel setting.\n");
 
 	return 0;
 }
@@ -2193,7 +2193,7 @@ static int __read_mostly keep_bootcon;
 static int __init keep_bootcon_setup(char *str)
 {
 	keep_bootcon = 1;
-	printk(KERN_INFO "debug: skip boot console de-registration.\n");
+	pr_info("debug: skip boot console de-registration.\n");
 
 	return 0;
 }
@@ -2241,7 +2241,7 @@ void register_console(struct console *ne
 		/* find the last or real console */
 		for_each_console(bcon) {
 			if (!(bcon->flags & CON_BOOT)) {
-				printk(KERN_INFO "Too late to register bootconsole %s%d\n",
+				pr_info("Too late to register bootconsole %s%d\n",
 					newcon->name, newcon->index);
 				return;
 			}
@@ -2358,7 +2358,7 @@ void register_console(struct console *ne
 	 * users know there might be something in the kernel's log buffer that
 	 * went to the bootconsole (that they do not see on the real console)
 	 */
-	printk(KERN_INFO "%sconsole [%s%d] enabled\n",
+	pr_info("%sconsole [%s%d] enabled\n",
 		(newcon->flags & CON_BOOT) ? "boot" : "" ,
 		newcon->name, newcon->index);
 	if (bcon &&
@@ -2379,7 +2379,7 @@ int unregister_console(struct console *c
         struct console *a, *b;
 	int res;
 
-	printk(KERN_INFO "%sconsole [%s%d] disabled\n",
+	pr_info("%sconsole [%s%d] disabled\n",
 		(console->flags & CON_BOOT) ? "boot" : "" ,
 		console->name, console->index);
 
@@ -2448,7 +2448,7 @@ static void wake_up_klogd_work_func(stru
 
 	if (pending & PRINTK_PENDING_SCHED) {
 		char *buf = __get_cpu_var(printk_sched_buf);
-		printk(KERN_WARNING "[sched_delayed] %s", buf);
+		pr_warn("[sched_delayed] %s", buf);
 	}
 
 	if (pending & PRINTK_PENDING_WAKEUP)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-memstick-core-ms_blockc-fix-spelling-in-msb_rp_recive_status_reg.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-remove-unrelated-header-files-and-export-symbol-fix.patch
posix_acl-uninlining.patch
mm.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch
kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix.patch
llists-move-llist_reverse_order-from-raid5-to-llistc-fix.patch
kfifo-api-type-safety-checkpatch-fixes.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

