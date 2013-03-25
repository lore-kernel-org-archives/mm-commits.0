From: akpm@linux-foundation.org
Subject: + init-mainc-convert-to-pr_foo.patch added to -mm tree
Date: Mon, 25 Mar 2013 14:22:07 -0700
Message-ID: <20130325212207.689F431C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:38926 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758631Ab3CYVWI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Mar 2013 17:22:08 -0400
Received: by mail-qe0-f73.google.com with SMTP id a11so664547qen.4
        for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2013 14:22:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, richard@nod.at


The patch titled
     Subject: init/main.c: convert to pr_foo()
has been added to the -mm tree.  Its filename is
     init-mainc-convert-to-pr_foo.patch

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
Subject: init/main.c: convert to pr_foo()

Also enables cleanup of some 80-col trickery.

Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff -puN init/main.c~init-mainc-convert-to-pr_foo init/main.c
--- a/init/main.c~init-mainc-convert-to-pr_foo
+++ a/init/main.c
@@ -174,8 +174,8 @@ static int __init obsolete_checksetup(ch
 				if (line[n] == '\0' || line[n] == '=')
 					had_early_param = 1;
 			} else if (!p->setup_func) {
-				printk(KERN_WARNING "Parameter %s is obsolete,"
-				       " ignored\n", p->str);
+				pr_warn("Parameter %s is obsolete, ignored\n",
+					p->str);
 				return 1;
 			} else if (p->setup_func(line + n))
 				return 1;
@@ -398,8 +398,7 @@ static int __init do_early_param(char *p
 		     strcmp(p->str, "earlycon") == 0)
 		) {
 			if (p->setup_func(val) != 0)
-				printk(KERN_WARNING
-				       "Malformed early option '%s'\n", param);
+				pr_warn("Malformed early option '%s'\n", param);
 		}
 	}
 	/* We accept everything at this stage. */
@@ -496,7 +495,7 @@ asmlinkage void __init start_kernel(void
  */
 	boot_cpu_init();
 	page_address_init();
-	printk(KERN_NOTICE "%s", linux_banner);
+	pr_notice("%s", linux_banner);
 	setup_arch(&command_line);
 	mm_init_owner(&init_mm, &init_task);
 	mm_init_cpumask(&init_mm);
@@ -508,7 +507,7 @@ asmlinkage void __init start_kernel(void
 	build_all_zonelists(NULL, NULL);
 	page_alloc_init();
 
-	printk(KERN_NOTICE "Kernel command line: %s\n", boot_command_line);
+	pr_notice("Kernel command line: %s\n", boot_command_line);
 	parse_early_param();
 	parse_args("Booting kernel", static_command_line, __start___param,
 		   __stop___param - __start___param,
@@ -582,8 +581,7 @@ asmlinkage void __init start_kernel(void
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (initrd_start && !initrd_below_start_ok &&
 	    page_to_pfn(virt_to_page((void *)initrd_start)) < min_low_pfn) {
-		printk(KERN_CRIT "initrd overwritten (0x%08lx < 0x%08lx) - "
-		    "disabling it.\n",
+		pr_crit("initrd overwritten (0x%08lx < 0x%08lx) - disabling it.\n",
 		    page_to_pfn(virt_to_page((void *)initrd_start)),
 		    min_low_pfn);
 		initrd_start = 0;
@@ -662,14 +660,14 @@ static int __init_or_module do_one_initc
 	unsigned long long duration;
 	int ret;
 
-	printk(KERN_DEBUG "calling  %pF @ %i\n", fn, task_pid_nr(current));
+	pr_debug("calling  %pF @ %i\n", fn, task_pid_nr(current));
 	calltime = ktime_get();
 	ret = fn();
 	rettime = ktime_get();
 	delta = ktime_sub(rettime, calltime);
 	duration = (unsigned long long) ktime_to_ns(delta) >> 10;
-	printk(KERN_DEBUG "initcall %pF returned %d after %lld usecs\n", fn,
-		ret, duration);
+	pr_debug("initcall %pF returned %d after %lld usecs\n",
+		 fn, ret, duration);
 
 	return ret;
 }
@@ -825,8 +823,7 @@ static int __ref kernel_init(void *unuse
 	if (ramdisk_execute_command) {
 		if (!run_init_process(ramdisk_execute_command))
 			return 0;
-		printk(KERN_ERR "Failed to execute %s\n",
-				ramdisk_execute_command);
+		pr_err("Failed to execute %s\n", ramdisk_execute_command);
 	}
 
 	/*
@@ -838,8 +835,8 @@ static int __ref kernel_init(void *unuse
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
@@ -884,7 +881,7 @@ static noinline void __init kernel_init_
 
 	/* Open the /dev/console on the rootfs, this should never fail */
 	if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
-		printk(KERN_ERR "Warning: unable to open an initial console.\n");
+		pr_err("Warning: unable to open an initial console.\n");
 
 	(void) sys_dup(0);
 	(void) sys_dup(0);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mips-define-kvm_user_mem_slots.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
memcg-relax-memcg-iter-caching-checkpatch-fixes.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix-fix.patch
kexec-vmalloc-export-additional-vmalloc-layer-information-fix.patch
mm-hugetlb-include-hugepages-in-meminfo-checkpatch-fixes.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
early_printk-consolidate-random-copies-of-identical-code-v3-fix.patch
include-linux-printkh-include-stdargh.patch
get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch
argv_split-teach-it-to-handle-mutable-strings-fix.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-mainc-convert-to-pr_foo.patch
rtc-ds1307-long-block-operations-bugfix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
ipc-introduce-obtaining-a-lockless-ipc-object-fix.patch
ipcsem-open-code-and-rename-sem_lock-fix.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
gadget-remove-only-user-of-aio-retry-checkpatch-fixes.patch
aio-remove-retry-based-aio-checkpatch-fixes.patch
aio-add-kiocb_cancel.patch
aio-make-aio_put_req-lockless-checkpatch-fixes.patch
aio-refcounting-cleanup-checkpatch-fixes.patch
wait-add-wait_event_hrtimeout.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers-checkpatch-fixes.patch
aio-use-cancellation-list-lazily.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
generic-dynamic-per-cpu-refcounting.patch
generic-dynamic-per-cpu-refcounting-checkpatch-fixes.patch
aio-dont-include-aioh-in-schedh.patch
aio-kill-ki_retry.patch
aio-kill-ki_retry-checkpatch-fixes.patch
block-prep-work-for-batch-completion-checkpatch-fixes.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

