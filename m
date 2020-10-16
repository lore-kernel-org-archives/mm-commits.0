Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57583C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:10:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0941E2087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817832;
	bh=5ubQ8lSj5xQJHAXI6i5fnGU+NYgnN37T5E38xOVGJuE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Q7MfSM7dKiqTiA61r/U202X5GWFKUuNPk16QVHCVvDqQon2vLiEzz/w25o2CcvPTw
	 4ZxnWds70SNnKE0+CEuzr5/EBURRZco7nDrFKxy3Elea1LZAItKNZpfQnSHZTqs2xw
	 fFjx08hIgVWVR3FPXYcwt5l24W/ukR8GHcmo6lDM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733106AbgJPDKb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:10:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732461AbgJPDKb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:10:31 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01FD120878;
        Fri, 16 Oct 2020 03:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817829;
        bh=5ubQ8lSj5xQJHAXI6i5fnGU+NYgnN37T5E38xOVGJuE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=RbO8oXOsI2ksySESBcqL12411l7nC3y/5wI18krBQJNUJ3tV504+PfvlY/gdweYgG
         hROX5tYC4pFPueAyiDIoZ41P2n1pZ9RTIklqpM5R46DCbJyPnivAvbMT5WhZubq4Tl
         eIbTrnQzKZ3GnZLdPQpOBi82RGQF5x3hQDz4++/E=
Date:   Thu, 15 Oct 2020 20:10:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 098/156] kernel/: fix repeated words in comments
Message-ID: <20201016031028.2AgU4VZCg%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: kernel/: fix repeated words in comments

Fix multiple occurrences of duplicated words in kernel/.

Fix one typo/spello on the same line as a duplicate word.  Change one
instance of "the the" to "that the".  Otherwise just drop one of the
repeated words.

Link: https://lkml.kernel.org/r/98202fa6-8919-ef63-9efe-c0fad5ca7af1@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/acct.c            |    2 +-
 kernel/cgroup/cpuset.c   |    2 +-
 kernel/dma/direct.c      |    2 +-
 kernel/fork.c            |    2 +-
 kernel/futex.c           |    2 +-
 kernel/irq/timings.c     |    2 +-
 kernel/jump_label.c      |    2 +-
 kernel/kcsan/encoding.h  |    2 +-
 kernel/kexec_core.c      |    2 +-
 kernel/kthread.c         |    2 +-
 kernel/livepatch/state.c |    2 +-
 kernel/pid_namespace.c   |    2 +-
 kernel/power/snapshot.c  |    2 +-
 kernel/smp.c             |    2 +-
 kernel/user_namespace.c  |    2 +-
 15 files changed, 15 insertions(+), 15 deletions(-)

--- a/kernel/acct.c~kernel-fix-repeated-words-in-comments
+++ a/kernel/acct.c
@@ -25,7 +25,7 @@
  *  Now we silently close acct_file on attempt to reopen. Cleaned sys_acct().
  *  XTerms and EMACS are manifestations of pure evil. 21/10/98, AV.
  *
- *  Fixed a nasty interaction with with sys_umount(). If the accointing
+ *  Fixed a nasty interaction with sys_umount(). If the accounting
  *  was suspeneded we failed to stop it on umount(). Messy.
  *  Another one: remount to readonly didn't stop accounting.
  *	Question: what should we do if we have CAP_SYS_ADMIN but not
--- a/kernel/cgroup/cpuset.c~kernel-fix-repeated-words-in-comments
+++ a/kernel/cgroup/cpuset.c
@@ -390,7 +390,7 @@ static void guarantee_online_cpus(struct
 			 * The top cpuset doesn't have any online cpu as a
 			 * consequence of a race between cpuset_hotplug_work
 			 * and cpu hotplug notifier.  But we know the top
-			 * cpuset's effective_cpus is on its way to to be
+			 * cpuset's effective_cpus is on its way to be
 			 * identical to cpu_online_mask.
 			 */
 			cpumask_copy(pmask, cpu_online_mask);
--- a/kernel/dma/direct.c~kernel-fix-repeated-words-in-comments
+++ a/kernel/dma/direct.c
@@ -16,7 +16,7 @@
 #include "direct.h"
 
 /*
- * Most architectures use ZONE_DMA for the first 16 Megabytes, but some use it
+ * Most architectures use ZONE_DMA for the first 16 Megabytes, but some use
  * it for entirely different regions. In that case the arch code needs to
  * override the variable below for dma-direct to work properly.
  */
--- a/kernel/fork.c~kernel-fix-repeated-words-in-comments
+++ a/kernel/fork.c
@@ -2189,7 +2189,7 @@ static __latent_entropy struct task_stru
 
 	/*
 	 * Ensure that the cgroup subsystem policies allow the new process to be
-	 * forked. It should be noted the the new process's css_set can be changed
+	 * forked. It should be noted that the new process's css_set can be changed
 	 * between here and cgroup_post_fork() if an organisation operation is in
 	 * progress.
 	 */
--- a/kernel/futex.c~kernel-fix-repeated-words-in-comments
+++ a/kernel/futex.c
@@ -916,7 +916,7 @@ static inline void exit_pi_state_list(st
  * [10] Found  | Found    | task      | !=taskTID | 0/1    | Invalid
  *
  * [1]	Indicates that the kernel can acquire the futex atomically. We
- *	came came here due to a stale FUTEX_WAITERS/FUTEX_OWNER_DIED bit.
+ *	came here due to a stale FUTEX_WAITERS/FUTEX_OWNER_DIED bit.
  *
  * [2]	Valid, if TID does not belong to a kernel thread. If no matching
  *      thread is found then it indicates that the owner TID has died.
--- a/kernel/irq/timings.c~kernel-fix-repeated-words-in-comments
+++ a/kernel/irq/timings.c
@@ -604,7 +604,7 @@ int irq_timings_alloc(int irq)
 
 	/*
 	 * Some platforms can have the same private interrupt per cpu,
-	 * so this function may be be called several times with the
+	 * so this function may be called several times with the
 	 * same interrupt number. Just bail out in case the per cpu
 	 * stat structure is already allocated.
 	 */
--- a/kernel/jump_label.c~kernel-fix-repeated-words-in-comments
+++ a/kernel/jump_label.c
@@ -19,7 +19,7 @@
 #include <linux/cpu.h>
 #include <asm/sections.h>
 
-/* mutex to protect coming/going of the the jump_label table */
+/* mutex to protect coming/going of the jump_label table */
 static DEFINE_MUTEX(jump_label_mutex);
 
 void jump_label_lock(void)
--- a/kernel/kcsan/encoding.h~kernel-fix-repeated-words-in-comments
+++ a/kernel/kcsan/encoding.h
@@ -32,7 +32,7 @@
  *	1. different addresses but with the same encoded address race;
  *	2. and both map onto the same watchpoint slots;
  *
- * Both these are assumed to be very unlikely. However, in case it still happens
+ * Both these are assumed to be very unlikely. However, in case it still
  * happens, the report logic will filter out the false positive (see report.c).
  */
 #define WATCHPOINT_ADDR_BITS (BITS_PER_LONG-1 - WATCHPOINT_SIZE_BITS)
--- a/kernel/kexec_core.c~kernel-fix-repeated-words-in-comments
+++ a/kernel/kexec_core.c
@@ -109,7 +109,7 @@ EXPORT_SYMBOL_GPL(kexec_crash_loaded);
  * defined more restrictively in <asm/kexec.h>.
  *
  * The code for the transition from the current kernel to the
- * the new kernel is placed in the control_code_buffer, whose size
+ * new kernel is placed in the control_code_buffer, whose size
  * is given by KEXEC_CONTROL_PAGE_SIZE.  In the best case only a single
  * page of memory is necessary, but some architectures require more.
  * Because this memory must be identity mapped in the transition from
--- a/kernel/kthread.c~kernel-fix-repeated-words-in-comments
+++ a/kernel/kthread.c
@@ -775,7 +775,7 @@ EXPORT_SYMBOL(kthread_create_worker);
 
 /**
  * kthread_create_worker_on_cpu - create a kthread worker and bind it
- *	it to a given CPU and the associated NUMA node.
+ *	to a given CPU and the associated NUMA node.
  * @cpu: CPU number
  * @flags: flags modifying the default behavior of the worker
  * @namefmt: printf-style name for the kthread worker (task).
--- a/kernel/livepatch/state.c~kernel-fix-repeated-words-in-comments
+++ a/kernel/livepatch/state.c
@@ -55,7 +55,7 @@ EXPORT_SYMBOL_GPL(klp_get_state);
  *
  * The function can be called only during transition when a new
  * livepatch is being enabled or when such a transition is reverted.
- * It is typically called only from from pre/post (un)patch
+ * It is typically called only from pre/post (un)patch
  * callbacks.
  *
  * Return: pointer to the latest struct klp_state from already
--- a/kernel/pid_namespace.c~kernel-fix-repeated-words-in-comments
+++ a/kernel/pid_namespace.c
@@ -233,7 +233,7 @@ void zap_pid_ns_processes(struct pid_nam
 	 * to pid_ns->child_reaper.  Thus pidns->child_reaper needs to
 	 * stay valid until they all go away.
 	 *
-	 * The code relies on the the pid_ns->child_reaper ignoring
+	 * The code relies on the pid_ns->child_reaper ignoring
 	 * SIGCHILD to cause those EXIT_ZOMBIE processes to be
 	 * autoreaped if reparented.
 	 *
--- a/kernel/power/snapshot.c~kernel-fix-repeated-words-in-comments
+++ a/kernel/power/snapshot.c
@@ -735,7 +735,7 @@ zone_found:
 	 */
 
 	/*
-	 * If the zone we wish to scan is the the current zone and the
+	 * If the zone we wish to scan is the current zone and the
 	 * pfn falls into the current node then we do not need to walk
 	 * the tree.
 	 */
--- a/kernel/smp.c~kernel-fix-repeated-words-in-comments
+++ a/kernel/smp.c
@@ -741,7 +741,7 @@ EXPORT_SYMBOL(on_each_cpu_mask);
  * for all the required CPUs to finish. This may include the local
  * processor.
  * @cond_func:	A callback function that is passed a cpu id and
- *		the the info parameter. The function is called
+ *		the info parameter. The function is called
  *		with preemption disabled. The function should
  *		return a blooean value indicating whether to IPI
  *		the specified CPU.
--- a/kernel/user_namespace.c~kernel-fix-repeated-words-in-comments
+++ a/kernel/user_namespace.c
@@ -515,7 +515,7 @@ EXPORT_SYMBOL(from_kgid_munged);
  *
  *	When there is no mapping defined for the user-namespace projid
  *	pair INVALID_PROJID is returned.  Callers are expected to test
- *	for and handle handle INVALID_PROJID being returned.  INVALID_PROJID
+ *	for and handle INVALID_PROJID being returned.  INVALID_PROJID
  *	may be tested for using projid_valid().
  */
 kprojid_t make_kprojid(struct user_namespace *ns, projid_t projid)
_
