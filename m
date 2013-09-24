From: akpm@linux-foundation.org
Subject: + kernel-printk-printkc-convert-to-pr_foo.patch added to -mm tree
Date: Tue, 24 Sep 2013 16:26:01 -0700
Message-ID: <52421f89.V5ZXkzOlpETjo4NG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab3IXX0C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Sep 2013 19:26:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, keescook@chromium.org, joe@perches.com, gregkh@linuxfoundation.org, fweisbec@gmail.com, akpm@linux-foundation.org

Subject: + kernel-printk-printkc-convert-to-pr_foo.patch added to -mm tree
To: akpm@linux-foundation.org,fweisbec@gmail.com,gregkh@linuxfoundation.org,joe@perches.com,keescook@chromium.org,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 24 Sep 2013 16:26:01 -0700


The patch titled
     Subject: kernel/printk/printk.c: convert to pr_foo()
has been added to the -mm tree.  Its filename is
     kernel-printk-printkc-convert-to-pr_foo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-printk-printkc-convert-to-pr_foo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-printk-printkc-convert-to-pr_foo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
watchdog-update-watchdog_tresh-properly.patch
revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
revert-memcg-track-all-children-over-limit-in-the-root.patch
revert-memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
revert-memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
revert-memcg-enhance-memcg-iterator-to-support-predicates.patch
revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
revert-memcg-get-rid-of-soft-limit-tree-infrastructure.patch
revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
kernel-rebootc-re-enable-the-function-of-variable-reboot_default.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix-fix.patch
sound-soc-atmel-atmel-pcmc-fix-warning.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
kernel-printk-printkc-convert-to-pr_foo.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

