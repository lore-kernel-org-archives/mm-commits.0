From: akpm@linux-foundation.org
Subject: + gcc-46-kernel-fix-unused-but-set-warnings.patch added to -mm tree
Date: Fri, 18 Jun 2010 16:31:39 -0700
Message-ID: <201006182331.o5INVd0L029556@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753097Ab0FRXb4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 19:31:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, a.p.zijlstra@chello.nl, ak@linux.intel.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     gcc-4.6: kernel/*: fix unused but set warnings
has been added to the -mm tree.  Its filename is
     gcc-46-kernel-fix-unused-but-set-warnings.patch

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
Subject: gcc-4.6: kernel/*: fix unused but set warnings
From: Andi Kleen <andi@firstfloor.org>

No real bugs I believe, just some dead code.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/debug/kdb/kdb_bp.c  |    2 --
 kernel/hrtimer.c           |    3 +--
 kernel/sched_fair.c        |    3 +--
 kernel/sysctl.c            |    5 +----
 kernel/trace/ring_buffer.c |    2 --
 5 files changed, 3 insertions(+), 12 deletions(-)

diff -puN kernel/debug/kdb/kdb_bp.c~gcc-46-kernel-fix-unused-but-set-warnings kernel/debug/kdb/kdb_bp.c
--- a/kernel/debug/kdb/kdb_bp.c~gcc-46-kernel-fix-unused-but-set-warnings
+++ a/kernel/debug/kdb/kdb_bp.c
@@ -274,7 +274,6 @@ static int kdb_bp(int argc, const char *
 	int i, bpno;
 	kdb_bp_t *bp, *bp_check;
 	int diag;
-	int free;
 	char *symname = NULL;
 	long offset = 0ul;
 	int nextarg;
@@ -305,7 +304,6 @@ static int kdb_bp(int argc, const char *
 	/*
 	 * Find an empty bp structure to allocate
 	 */
-	free = KDB_MAXBPT;
 	for (bpno = 0, bp = kdb_breakpoints; bpno < KDB_MAXBPT; bpno++, bp++) {
 		if (bp->bp_free)
 			break;
diff -puN kernel/hrtimer.c~gcc-46-kernel-fix-unused-but-set-warnings kernel/hrtimer.c
--- a/kernel/hrtimer.c~gcc-46-kernel-fix-unused-but-set-warnings
+++ a/kernel/hrtimer.c
@@ -1096,11 +1096,10 @@ EXPORT_SYMBOL_GPL(hrtimer_cancel);
  */
 ktime_t hrtimer_get_remaining(const struct hrtimer *timer)
 {
-	struct hrtimer_clock_base *base;
 	unsigned long flags;
 	ktime_t rem;
 
-	base = lock_hrtimer_base(timer, &flags);
+	lock_hrtimer_base(timer, &flags);
 	rem = hrtimer_expires_remaining(timer);
 	unlock_hrtimer_base(timer, &flags);
 
diff -puN kernel/sched_fair.c~gcc-46-kernel-fix-unused-but-set-warnings kernel/sched_fair.c
--- a/kernel/sched_fair.c~gcc-46-kernel-fix-unused-but-set-warnings
+++ a/kernel/sched_fair.c
@@ -1311,7 +1311,7 @@ static struct sched_group *
 find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 		  int this_cpu, int load_idx)
 {
-	struct sched_group *idlest = NULL, *this = NULL, *group = sd->groups;
+	struct sched_group *idlest = NULL, *group = sd->groups;
 	unsigned long min_load = ULONG_MAX, this_load = 0;
 	int imbalance = 100 + (sd->imbalance_pct-100)/2;
 
@@ -1346,7 +1346,6 @@ find_idlest_group(struct sched_domain *s
 
 		if (local_group) {
 			this_load = avg_load;
-			this = group;
 		} else if (avg_load < min_load) {
 			min_load = avg_load;
 			idlest = group;
diff -puN kernel/sysctl.c~gcc-46-kernel-fix-unused-but-set-warnings kernel/sysctl.c
--- a/kernel/sysctl.c~gcc-46-kernel-fix-unused-but-set-warnings
+++ a/kernel/sysctl.c
@@ -1721,10 +1721,7 @@ static __init int sysctl_init(void)
 {
 	sysctl_set_parent(NULL, root_table);
 #ifdef CONFIG_SYSCTL_SYSCALL_CHECK
-	{
-		int err;
-		err = sysctl_check_table(current->nsproxy, root_table);
-	}
+	sysctl_check_table(current->nsproxy, root_table);
 #endif
 	return 0;
 }
diff -puN kernel/trace/ring_buffer.c~gcc-46-kernel-fix-unused-but-set-warnings kernel/trace/ring_buffer.c
--- a/kernel/trace/ring_buffer.c~gcc-46-kernel-fix-unused-but-set-warnings
+++ a/kernel/trace/ring_buffer.c
@@ -3007,13 +3007,11 @@ static void rb_advance_reader(struct rin
 
 static void rb_advance_iter(struct ring_buffer_iter *iter)
 {
-	struct ring_buffer *buffer;
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event;
 	unsigned length;
 
 	cpu_buffer = iter->cpu_buffer;
-	buffer = cpu_buffer->buffer;
 
 	/*
 	 * Check if we are at the end of the buffer.
_

Patches currently in -mm which might be from andi@firstfloor.org are

linux-next.patch
percpu-online-cpu-before-memory-failed-in-pcpu_alloc_pages.patch
modpost-support-objects-with-more-than-64k-sections.patch
kernelh-add-hw_err-printk-prefix-for-hardware-error-logging.patch
x86-use-hw_err-in-mce-handler.patch
gcc-46-irq-move-alloc_desk_mask-variables-inside-ifdef.patch
gcc-46-x86-avoid-unused-by-set-variables-in-rdmsr.patch
gcc-46-pagemap-avoid-unused-but-set-variable.patch
gcc-46-perf-fix-set-but-unused-variables-in-perf.patch
gcc-46-x86-fix-set-but-not-read-variables.patch
gcc-46-kgdb-remove-set-but-unused-newpc.patch
gcc-46-printk-use-stable-variable-to-dump-kmsg-buffer.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
gcc-46-btrfs-clean-up-unused-variables-nonbugs.patch
gcc-46-nfsd-fix-initialized-but-not-read-warnings.patch
gcc-46-acpi-fix-unused-but-set-variables-in-acpi.patch
gcc-46-mm-fix-unused-but-set-warnings.patch
gcc-46-kernel-fix-unused-but-set-warnings.patch
gcc-46-block-fix-unused-but-set-variables-in-blk-merge.patch
gcc-46-fs-fix-unused-but-set-warnings.patch

