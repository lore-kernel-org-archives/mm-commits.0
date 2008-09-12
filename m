From: akpm@linux-foundation.org
Subject: + sysfs-fix-deadlock.patch added to -mm tree
Date: Fri, 12 Sep 2008 12:58:31 -0700
Message-ID: <200809121958.m8CJwVD5001174@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54272 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752922AbYILT64 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Sep 2008 15:58:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, greg@kroah.com, npiggin@suse.de


The patch titled
     sysfs: fix deadlock
has been added to the -mm tree.  Its filename is
     sysfs-fix-deadlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysfs: fix deadlock


=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.27-rc6-tip #1
-------------------------------------------------------
X/4873 is trying to acquire lock:
 (&bb->mutex){--..}, at: [<c020ba20>] mmap+0x40/0xa0

but task is already holding lock:
 (&mm->mmap_sem){----}, at: [<c0125a1e>] sys_mmap2+0x8e/0xc0

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&mm->mmap_sem){----}:
       [<c017dc96>] validate_chain+0xa96/0xf50
       [<c017ef2b>] __lock_acquire+0x2cb/0x5b0
       [<c017f299>] lock_acquire+0x89/0xc0
       [<c01aa8fb>] might_fault+0x6b/0x90
       [<c040b618>] copy_to_user+0x38/0x60
       [<c020bcfb>] read+0xfb/0x170
       [<c01c09a5>] vfs_read+0x95/0x110
       [<c01c1443>] sys_pread64+0x63/0x80
       [<c012146f>] sysenter_do_call+0x12/0x43
       [<ffffffff>] 0xffffffff

-> #0 (&bb->mutex){--..}:
       [<c017d8b7>] validate_chain+0x6b7/0xf50
       [<c017ef2b>] __lock_acquire+0x2cb/0x5b0
       [<c017f299>] lock_acquire+0x89/0xc0
       [<c0d6f2ab>] __mutex_lock_common+0xab/0x3c0
       [<c0d6f698>] mutex_lock_nested+0x38/0x50
       [<c020ba20>] mmap+0x40/0xa0
       [<c01b111e>] mmap_region+0x14e/0x450
       [<c01b170f>] do_mmap_pgoff+0x2ef/0x310
       [<c0125a3d>] sys_mmap2+0xad/0xc0
       [<c012146f>] sysenter_do_call+0x12/0x43
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

1 lock held by X/4873:
 #0:  (&mm->mmap_sem){----}, at: [<c0125a1e>] sys_mmap2+0x8e/0xc0

stack backtrace:
Pid: 4873, comm: X Not tainted 2.6.27-rc6-tip #1
 [<c017cd09>] print_circular_bug_tail+0x79/0xc0
 [<c017d8b7>] validate_chain+0x6b7/0xf50
 [<c017a5b5>] ? trace_hardirqs_off_caller+0x15/0xb0
 [<c017ef2b>] __lock_acquire+0x2cb/0x5b0
 [<c017f299>] lock_acquire+0x89/0xc0
 [<c020ba20>] ? mmap+0x40/0xa0
 [<c0d6f2ab>] __mutex_lock_common+0xab/0x3c0
 [<c020ba20>] ? mmap+0x40/0xa0
 [<c0d6f698>] mutex_lock_nested+0x38/0x50
 [<c020ba20>] ? mmap+0x40/0xa0
 [<c020ba20>] mmap+0x40/0xa0
 [<c01b111e>] mmap_region+0x14e/0x450
 [<c01afb88>] ? arch_get_unmapped_area_topdown+0xf8/0x160
 [<c01b170f>] do_mmap_pgoff+0x2ef/0x310
 [<c0125a3d>] sys_mmap2+0xad/0xc0
 [<c012146f>] sysenter_do_call+0x12/0x43
 [<c0120000>] ? __switch_to+0x130/0x220
 =======================
evbug.c: Event. Dev: input3, Type: 20, Code: 0, Value: 500
warning: `sudo' uses deprecated v2 capabilities in a way that may be insecure.


bin.c takes bb->mutex under mmap_sem when it is mmapped, and then does its
copy_*_user under bb->mutex too.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Reported-by: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/bin.c |   42 +++++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)

diff -puN fs/sysfs/bin.c~sysfs-fix-deadlock fs/sysfs/bin.c
--- a/fs/sysfs/bin.c~sysfs-fix-deadlock
+++ a/fs/sysfs/bin.c
@@ -61,6 +61,7 @@ read(struct file *file, char __user *use
 	int size = dentry->d_inode->i_size;
 	loff_t offs = *off;
 	int count = min_t(size_t, bytes, PAGE_SIZE);
+	char *temp;
 
 	if (size) {
 		if (offs > size)
@@ -69,23 +70,33 @@ read(struct file *file, char __user *use
 			count = size - offs;
 	}
 
+	temp = kmalloc(count, GFP_KERNEL);
+	if (!temp)
+		return -ENOMEM;
+
 	mutex_lock(&bb->mutex);
 
 	count = fill_read(dentry, bb->buffer, offs, count);
-	if (count < 0)
-		goto out_unlock;
+	if (count < 0) {
+		mutex_unlock(&bb->mutex);
+		goto out_free;
+	}
 
-	if (copy_to_user(userbuf, bb->buffer, count)) {
+	memcpy(temp, bb->buffer, count);
+
+	mutex_unlock(&bb->mutex);
+
+	if (copy_to_user(userbuf, temp, count)) {
 		count = -EFAULT;
-		goto out_unlock;
+		goto out_free;
 	}
 
 	pr_debug("offs = %lld, *off = %lld, count = %d\n", offs, *off, count);
 
 	*off = offs + count;
 
- out_unlock:
-	mutex_unlock(&bb->mutex);
+ out_free:
+	kfree(temp);
 	return count;
 }
 
@@ -118,6 +129,7 @@ static ssize_t write(struct file *file, 
 	int size = dentry->d_inode->i_size;
 	loff_t offs = *off;
 	int count = min_t(size_t, bytes, PAGE_SIZE);
+	char *temp;
 
 	if (size) {
 		if (offs > size)
@@ -126,19 +138,27 @@ static ssize_t write(struct file *file, 
 			count = size - offs;
 	}
 
-	mutex_lock(&bb->mutex);
+	temp = kmalloc(count, GFP_KERNEL);
+	if (!temp)
+		return -ENOMEM;
 
-	if (copy_from_user(bb->buffer, userbuf, count)) {
+	if (copy_from_user(temp, userbuf, count)) {
 		count = -EFAULT;
-		goto out_unlock;
+		goto out_free;
 	}
 
+	mutex_lock(&bb->mutex);
+
+	memcpy(bb->buffer, temp, count);
+
 	count = flush_write(dentry, bb->buffer, offs, count);
+	mutex_unlock(&bb->mutex);
+
 	if (count > 0)
 		*off = offs + count;
 
- out_unlock:
-	mutex_unlock(&bb->mutex);
+out_free:
+	kfree(temp);
 	return count;
 }
 
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
linux-next.patch
kbuild-ftrace-dont-assume-that-scripts-recordmcountpl-is-executable.patch
introduce-generic-header-file-for-the-software-io-tlb.patch
x86-remove-init_mm-export-as-planned-for-2626.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
x86-tracehook-config_have_arch_tracehook.patch
x86-make-poll_idle-behave-more-like-the-other-idle-methods.patch
x86-make-poll_idle-behave-more-like-the-other-idle-methods-checkpatch-fixes.patch
x86-init-annotations-in-early_printk-setup.patch
x86-adjust-dependencies-for-config_x86_cmov.patch
x86-pgd_cdtor-cleanup.patch
x86-x86_physvirt_bits-field-also-for-i386.patch
x86-adjust-vmalloc_sync_all-for-xen-2nd-try.patch
x86-fix-ticket-spin-lock-asm-constraints.patch
x86-64-reduce-boot-fixmap-space.patch
x86-64-add-two-__cpuinit-annotations.patch
x86-64-eliminate-dead-code.patch
x86-64-slightly-streamline-32-bit-syscall-entry-code.patch
arch-x86-kernel-early_printkc-remove-unused-enable_debug_console.patch
x86-use-common-header-for-software-io-tlb.patch
sysfs-fix-deadlock.patch
initramfs-fix-compilation-warning.patch
less-softirq-vectors.patch
dyn_array-use-%pf-instead-of-print_fn_descriptor_symbol.patch
dyn_array-fix-typo.patch
sched-fix-init_hrtick-section-mismatch-warning.patch
sched-clarify-ifdef-tangle.patch
sched-fix-compilation-with-gcc-346.patch
debug_locks_warn_on-disable-if-oops_in_progress.patch
rcu-spinlocks-take-an-unsigned-long-flags.patch
rcu-fix-sparse-shadowed-variable-warning.patch
ftrace-warn-on-failure-to-disable-mcount-callers.patch
sched-reinitialise-rt_rq-rt_throttled-in-__enable_runtime.patch
mm-define-use_split_ptlocks-rather-than-repeating-expression.patch
xen-fix-pinning-when-not-using-split-pte-locks.patch
add-phys_addr_t-for-holding-physical-addresses.patch
make-pfn_phys-explicitly-return-phys_addr_t.patch
redefine-resource_size_t-as-phys_addr_t.patch
wait-kill-is_sync_wait.patch
kconfig-eliminate-def_bool-n-constructs.patch
make-taint-bit-reliable-v3.patch
make-taint-bit-reliable-v3-fix.patch
profiling-dynamically-enable-readprofile-at-runtime.patch
compat-generic-compat-get-settimeofday.patch
x86-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
introduce-generic-iommu_num_pages-function.patch
x86-convert-gart-driver-to-generic-iommu_num_pages-function.patch
x86-amd-iommu-convert-driver-to-generic-iommu_num_pages-function.patch
x86-convert-calgary-iommu-driver-to-generic-iommu_num_pages-function.patch
legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option.patch
rtc-cmos-export-second-nvram-bank.patch
genirq-record-trigger-type.patch
genirq-record-trigger-type-fix.patch
irq-warn-about-irqf_disabledirqf_shared.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch
kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore.patch
x86-sysfs-kill-owner-field-from-attribute.patch
x86-sysfs-kill-owner-field-from-attribute-fix.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
likely-profiling-disable-ftrace.patch

