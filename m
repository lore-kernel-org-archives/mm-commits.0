From: akpm@linux-foundation.org
Subject: [merged] init-mainc-convert-to-pr_foo.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:53:47 -0700
Message-ID: <20130430185347.750725A41E9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:51197 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933146Ab3D3Sxs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:53:48 -0400
Received: by mail-qe0-f73.google.com with SMTP id 9so86516qea.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:53:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, richard@nod.at, u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: init/main.c: convert to pr_foo()
has been removed from the -mm tree.  Its filename was
     init-mainc-convert-to-pr_foo.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Andrew Morton <akpm@linux-foundation.org>
Subject: init/main.c: convert to pr_foo()

Also enables cleanup of some 80-col trickery.

Cc: Richard Weinberger <richard@nod.at>
Cc: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff -puN init/main.c~init-mainc-convert-to-pr_foo init/main.c
--- a/init/main.c~init-mainc-convert-to-pr_foo
+++ a/init/main.c
@@ -9,6 +9,8 @@
  *  Simplified starting of init:  Michael A. Griffith <grif@acm.org>=20
  */
=20
+#define DEBUG		/* Enable initcall_debug */
+
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/proc_fs.h>
@@ -174,8 +176,8 @@ static int __init obsolete_checksetup(ch
 				if (line[n] =3D=3D '\0' || line[n] =3D=3D '=3D')
 					had_early_param =3D 1;
 			} else if (!p->setup_func) {
-				printk(KERN_WARNING "Parameter %s is obsolete,"
-				       " ignored\n", p->str);
+				pr_warn("Parameter %s is obsolete, ignored\n",
+					p->str);
 				return 1;
 			} else if (p->setup_func(line + n))
 				return 1;
@@ -398,8 +400,7 @@ static int __init do_early_param(char *p
 		     strcmp(p->str, "earlycon") =3D=3D 0)
 		) {
 			if (p->setup_func(val) !=3D 0)
-				printk(KERN_WARNING
-				       "Malformed early option '%s'\n", param);
+				pr_warn("Malformed early option '%s'\n", param);
 		}
 	}
 	/* We accept everything at this stage. */
@@ -497,7 +498,7 @@ asmlinkage void __init start_kernel(void
 	tick_init();
 	boot_cpu_init();
 	page_address_init();
-	printk(KERN_NOTICE "%s", linux_banner);
+	pr_notice("%s", linux_banner);
 	setup_arch(&command_line);
 	mm_init_owner(&init_mm, &init_task);
 	mm_init_cpumask(&init_mm);
@@ -509,7 +510,7 @@ asmlinkage void __init start_kernel(void
 	build_all_zonelists(NULL, NULL);
 	page_alloc_init();
=20
-	printk(KERN_NOTICE "Kernel command line: %s\n", boot_command_line);
+	pr_notice("Kernel command line: %s\n", boot_command_line);
 	parse_early_param();
 	parse_args("Booting kernel", static_command_line, __start___param,
 		   __stop___param - __start___param,
@@ -582,8 +583,7 @@ asmlinkage void __init start_kernel(void
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (initrd_start && !initrd_below_start_ok &&
 	    page_to_pfn(virt_to_page((void *)initrd_start)) < min_low_pfn) {
-		printk(KERN_CRIT "initrd overwritten (0x%08lx < 0x%08lx) - "
-		    "disabling it.\n",
+		pr_crit("initrd overwritten (0x%08lx < 0x%08lx) - disabling it.\n",
 		    page_to_pfn(virt_to_page((void *)initrd_start)),
 		    min_low_pfn);
 		initrd_start =3D 0;
@@ -662,14 +662,14 @@ static int __init_or_module do_one_initc
 	unsigned long long duration;
 	int ret;
=20
-	printk(KERN_DEBUG "calling  %pF @ %i\n", fn, task_pid_nr(current));
+	pr_debug("calling  %pF @ %i\n", fn, task_pid_nr(current));
 	calltime =3D ktime_get();
 	ret =3D fn();
 	rettime =3D ktime_get();
 	delta =3D ktime_sub(rettime, calltime);
 	duration =3D (unsigned long long) ktime_to_ns(delta) >> 10;
-	printk(KERN_DEBUG "initcall %pF returned %d after %lld usecs\n", fn,
-		ret, duration);
+	pr_debug("initcall %pF returned %d after %lld usecs\n",
+		 fn, ret, duration);
=20
 	return ret;
 }
@@ -825,8 +825,7 @@ static int __ref kernel_init(void *unuse
 	if (ramdisk_execute_command) {
 		if (!run_init_process(ramdisk_execute_command))
 			return 0;
-		printk(KERN_ERR "Failed to execute %s\n",
-				ramdisk_execute_command);
+		pr_err("Failed to execute %s\n", ramdisk_execute_command);
 	}
=20
 	/*
@@ -838,8 +837,8 @@ static int __ref kernel_init(void *unuse
 	if (execute_command) {
 		if (!run_init_process(execute_command))
 			return 0;
-		printk(KERN_ERR "Failed to execute %s.  Attempting "
-					"defaults...\n", execute_command);
+		pr_err("Failed to execute %s.  Attempting defaults...\n",
+			execute_command);
 	}
 	if (!run_init_process("/sbin/init") ||
 	    !run_init_process("/etc/init") ||
@@ -884,7 +883,7 @@ static noinline void __init kernel_init_
=20
 	/* Open the /dev/console on the rootfs, this should never fail */
 	if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
-		printk(KERN_ERR "Warning: unable to open an initial console.\n");
+		pr_err("Warning: unable to open an initial console.\n");
=20
 	(void) sys_dup(0);
 	(void) sys_dup(0);
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

origin.patch
clear_refs-sanitize-accepted-commands-declaration.patch
linux-next.patch
linux-next-git-rejects1.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
drivers-usb-storage-realtek_crc-fix-build.patch
revert-ipc-dont-allocate-a-copy-larger-than-max.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
inotify-invalid-mask-should-return-a-error-number-but-not-set-it-fix.pa=
tch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_sc=
hedule.patch
mm.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
staging-zcache-enable-ramster-to-be-built-loaded-as-a-module-fix.patch
selftest-add-simple-test-for-soft-dirty-bit.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
lib-string_helpers-introduce-generic-string_unescape-fix.patch
kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-checkp=
atch-fixes.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-beca=
use-of-drivers-internal-error-or-metadata-corruption-fix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_=
by_cnid-fix.patch
fat-additions-to-support-fat_fallocate-fix.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
revert-ipc_schedule_free-can-do-vfree-now.patch
ipc-introduce-obtaining-a-lockless-ipc-object-fix.patch
ipcsem-do-not-hold-ipc-lock-more-than-necessary-fix-checkpatch-fixes.pa=
tch
ipcsem-open-code-and-rename-sem_lock-fix.patch
ipcsem-fine-grained-locking-for-semtimedop-ipc-make-refcounter-atomic-f=
ix.patch
ipc-sysv-shared-memory-limited-to-8tib-fix.patch
rapidio-make-enumeration-discovery-configurable-fix.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
gadget-remove-only-user-of-aio-retry-checkpatch-fixes.patch
aio-remove-retry-based-aio-checkpatch-fixes.patch
aio-add-kiocb_cancel.patch
aio-make-aio_put_req-lockless-checkpatch-fixes.patch
aio-refcounting-cleanup-checkpatch-fixes.patch
wait-add-wait_event_hrtimeout.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers-checkpatch-fix=
es.patch
aio-use-cancellation-list-lazily.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
generic-dynamic-per-cpu-refcounting.patch
generic-dynamic-per-cpu-refcounting-checkpatch-fixes.patch
aio-dont-include-aioh-in-schedh.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-kill-ki_retry.patch
aio-kill-ki_retry-fix.patch
aio-kill-ki_retry-checkpatch-fixes.patch
block-prep-work-for-batch-completion-checkpatch-fixes.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-4.patch
block-prep-work-for-batch-completion-fix-99.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
bpf-add-comments-explaining-the-schedule_work-operation.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
