From: akpm@linux-foundation.org
Subject: [merged]
 kernel-printk-printkc-revert-printk-enable-interrupts-before-calling-console_trylock_for_printk.patch removed from -mm tree
Date: Mon, 07 Jul 2014 11:11:36 -0700
Message-ID: <53bae2d8.JqFaFcHz7p5UBRIE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:52128 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbaGGSLh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 14:11:37 -0400
Received: by mail-yh0-f73.google.com with SMTP id f10so656987yha.0
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 11:11:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aeb@debian.org, jack@suse.cz, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/printk/printk.c: revert "printk: enable interrupts before calling console_trylock_for_printk()"
has been removed from the -mm tree.  Its filename was
     kernel-printk-printkc-revert-printk-enable-interrupts-before-calling-console_trylock_for_printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel/printk/printk.c: revert "printk: enable interrupts before calling console_trylock_for_printk()"

Revert 939f04bec1a4 ("printk: enable interrupts before calling
console_trylock_for_printk()").

Andreas reported:

: None of the post 3.15 kernel boot for me. They all hang at the GRUB
: screen telling me it loaded and started the kernel, but the kernel
: itself stops before it prints anything (or even replaces the GRUB
: background graphics).

939f04bec1a4 is modest latency reduction.  Revert it until we understand
the reason for these failures.

Reported-by: Andreas Bombe <aeb@debian.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   44 +++++++++++++++------------------------
 1 file changed, 18 insertions(+), 26 deletions(-)

diff -puN kernel/printk/printk.c~kernel-printk-printkc-revert-printk-enable-interrupts-before-calling-console_trylock_for_printk kernel/printk/printk.c
--- a/kernel/printk/printk.c~kernel-printk-printkc-revert-printk-enable-interrupts-before-calling-console_trylock_for_printk
+++ a/kernel/printk/printk.c
@@ -1416,9 +1416,10 @@ static int have_callable_console(void)
 /*
  * Can we actually use the console at this time on this cpu?
  *
- * Console drivers may assume that per-cpu resources have been allocated. So
- * unless they're explicitly marked as being able to cope (CON_ANYTIME) don't
- * call them until this CPU is officially up.
+ * Console drivers may assume that per-cpu resources have
+ * been allocated. So unless they're explicitly marked as
+ * being able to cope (CON_ANYTIME) don't call them until
+ * this CPU is officially up.
  */
 static inline int can_use_console(unsigned int cpu)
 {
@@ -1431,10 +1432,8 @@ static inline int can_use_console(unsign
  * console_lock held, and 'console_locked' set) if it
  * is successful, false otherwise.
  */
-static int console_trylock_for_printk(void)
+static int console_trylock_for_printk(unsigned int cpu)
 {
-	unsigned int cpu = smp_processor_id();
-
 	if (!console_trylock())
 		return 0;
 	/*
@@ -1609,8 +1608,7 @@ asmlinkage int vprintk_emit(int facility
 		 */
 		if (!oops_in_progress && !lockdep_recursing(current)) {
 			recursion_bug = 1;
-			local_irq_restore(flags);
-			return 0;
+			goto out_restore_irqs;
 		}
 		zap_locks();
 	}
@@ -1718,27 +1716,21 @@ asmlinkage int vprintk_emit(int facility
 
 	logbuf_cpu = UINT_MAX;
 	raw_spin_unlock(&logbuf_lock);
-	lockdep_on();
-	local_irq_restore(flags);
 
 	/* If called from the scheduler, we can not call up(). */
-	if (in_sched)
-		return printed_len;
-
-	/*
-	 * Disable preemption to avoid being preempted while holding
-	 * console_sem which would prevent anyone from printing to console
-	 */
-	preempt_disable();
-	/*
-	 * Try to acquire and then immediately release the console semaphore.
-	 * The release will print out buffers and wake up /dev/kmsg and syslog()
-	 * users.
-	 */
-	if (console_trylock_for_printk())
-		console_unlock();
-	preempt_enable();
+	if (!in_sched) {
+		/*
+		 * Try to acquire and then immediately release the console
+		 * semaphore.  The release will print out buffers and wake up
+		 * /dev/kmsg and syslog() users.
+		 */
+		if (console_trylock_for_printk(this_cpu))
+			console_unlock();
+	}
 
+	lockdep_on();
+out_restore_irqs:
+	local_irq_restore(flags);
 	return printed_len;
 }
 EXPORT_SYMBOL(vprintk_emit);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc-fix.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
fs-isofs-logging-clean-up-fix.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch
panic-add-taint_softlockup-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
drivers-staging-emxx_udc-emxx_udcc-replace-strict_strto-with-kstrto.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

