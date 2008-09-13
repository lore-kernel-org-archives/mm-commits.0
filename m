From: akpm@linux-foundation.org
Subject: - less-softirq-vectors.patch removed from -mm tree
Date: Sat, 13 Sep 2008 00:46:04 -0700
Message-ID: <200809130746.m8D7k4kI026821@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753480AbYIMHqT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 13 Sep 2008 03:46:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Less softirq vectors
has been removed from the -mm tree.  Its filename was
     less-softirq-vectors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Less softirq vectors
From: Alexey Dobriyan <adobriyan@gmail.com>

We don't need whole 32 of them, only NR_SOFTIRQS.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/interrupt.h |    2 ++
 kernel/softirq.c          |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/interrupt.h~less-softirq-vectors include/linux/interrupt.h
--- a/include/linux/interrupt.h~less-softirq-vectors
+++ a/include/linux/interrupt.h
@@ -259,6 +259,8 @@ enum
 	HRTIMER_SOFTIRQ,
 #endif
 	RCU_SOFTIRQ, 	/* Preferable RCU should always be the last softirq */
+
+	NR_SOFTIRQS
 };
 
 /* softirq mask and active fields moved to irq_cpustat_t in
diff -puN kernel/softirq.c~less-softirq-vectors kernel/softirq.c
--- a/kernel/softirq.c~less-softirq-vectors
+++ a/kernel/softirq.c
@@ -46,7 +46,7 @@ irq_cpustat_t irq_stat[NR_CPUS] ____cach
 EXPORT_SYMBOL(irq_stat);
 #endif
 
-static struct softirq_action softirq_vec[32] __cacheline_aligned_in_smp;
+static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp;
 
 static DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-more-debugging-for-already-registered-case.patch
linux-next.patch
itimers-fix-itimer-many-thread-hang.patch
itimers-fix-itimer-many-thread-hang-checkpatch-fixes.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
cpuset-use-seq_cpumask-seq_nodemask.patch
compat_binfmt_elf-definition-tweak.patch
proc-move-sysrq-trigger-out-of-fs-proc.patch
proc-fix-return-value-of-proc_reg_open-in-too-late-case.patch
proc-proc_sys_root-tweak.patch
proc-remove-dummy-vmcore_open.patch
proc-remove-unused-get_dma_list.patch
sysctl-simplify-strategy.patch
fs-kconfig-move-ext2-ext3-ext4-jbd-jbd2-out.patch
fs-kconfig-move-cifs-out.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

