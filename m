From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Mon, 02 Oct 2017 11:48:11 -0700
Message-ID: <20171002184811.DUQswj8y8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54560 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751120AbdJBSsN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Oct 2017 14:48:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/x86/kvm/vmx.c~linux-next-git-rejects arch/x86/kvm/vmx.c
--- a/arch/x86/kvm/vmx.c~linux-next-git-rejects
+++ a/arch/x86/kvm/vmx.c
@@ -11730,13 +11730,8 @@ static void __pi_post_block(struct kvm_v
 
 		/* set 'NV' to 'notification vector' */
 		new.nv = POSTED_INTR_VECTOR;
-<<<<<<< HEAD
-	} while (cmpxchg64(&pi_desc->control, old.control,
-			   new.control) != old.control);
-=======
 	} while (cmpxchg(&pi_desc->control, old.control,
 			new.control) != old.control);
->>>>>>> linux-next/akpm-base
 
 	if (!WARN_ON_ONCE(vcpu->pre_pcpu == -1)) {
 		spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
diff -puN fs/btrfs/extent_io.c~linux-next-git-rejects fs/btrfs/extent_io.c
--- a/fs/btrfs/extent_io.c~linux-next-git-rejects
+++ a/fs/btrfs/extent_io.c
@@ -4056,11 +4056,7 @@ static void flush_epd_write_bio(struct e
 	if (epd->bio) {
 		int ret;
 
-<<<<<<< HEAD
-		ret = submit_one_bio(epd->bio, 0, epd->bio_flags);
-=======
 		ret = submit_one_bio(epd->bio, 0, 0);
->>>>>>> linux-next/akpm-base
 		BUG_ON(ret < 0); /* -ENOMEM */
 		epd->bio = NULL;
 	}
diff -puN kernel/cpu.c~linux-next-git-rejects kernel/cpu.c
--- a/kernel/cpu.c~linux-next-git-rejects
+++ a/kernel/cpu.c
@@ -551,7 +551,6 @@ static void cpuhp_thread_fun(unsigned in
 	}
 
 	WARN_ON_ONCE(!cpuhp_is_ap_state(state));
-<<<<<<< HEAD
 
 	if (st->rollback) {
 		struct cpuhp_step *step = cpuhp_get_step(state);
@@ -564,20 +563,6 @@ static void cpuhp_thread_fun(unsigned in
 		st->result = cpuhp_invoke_callback(cpu, state, bringup, st->node, &st->last);
 		local_irq_enable();
 
-=======
-
-	if (st->rollback) {
-		struct cpuhp_step *step = cpuhp_get_step(state);
-		if (step->skip_onerr)
-			goto next;
-	}
-
-	if (cpuhp_is_atomic_state(state)) {
-		local_irq_disable();
-		st->result = cpuhp_invoke_callback(cpu, state, bringup, st->node, &st->last);
-		local_irq_enable();
-
->>>>>>> linux-next/akpm-base
 		/*
 		 * STARTING/DYING must not fail!
 		 */
@@ -626,17 +611,10 @@ cpuhp_invoke_ap_callback(int cpu, enum c
 	 */
 	if (!st->thread)
 		return cpuhp_invoke_callback(cpu, state, bringup, node, NULL);
-<<<<<<< HEAD
 
 	st->rollback = false;
 	st->last = NULL;
 
-=======
-
-	st->rollback = false;
-	st->last = NULL;
-
->>>>>>> linux-next/akpm-base
 	st->node = node;
 	st->bringup = bringup;
 	st->cb_state = state;
@@ -665,16 +643,6 @@ static int cpuhp_kick_ap_work(unsigned i
 
 	cpuhp_lock_acquire(false);
 	cpuhp_lock_release(false);
-<<<<<<< HEAD
-
-	cpuhp_lock_acquire(true);
-	cpuhp_lock_release(true);
-
-	trace_cpuhp_enter(cpu, st->target, prev_state, cpuhp_kick_ap_work);
-	ret = cpuhp_kick_ap(st, st->target);
-	trace_cpuhp_exit(cpu, st->state, prev_state, ret);
-
-=======
 
 	cpuhp_lock_acquire(true);
 	cpuhp_lock_release(true);
@@ -683,7 +651,6 @@ static int cpuhp_kick_ap_work(unsigned i
 	ret = cpuhp_kick_ap(st, st->target);
 	trace_cpuhp_exit(cpu, st->state, prev_state, ret);
 
->>>>>>> linux-next/akpm-base
 	return ret;
 }
 
diff -puN tools/include/uapi/linux/bpf.h~linux-next-git-rejects tools/include/uapi/linux/bpf.h
--- a/tools/include/uapi/linux/bpf.h~linux-next-git-rejects
+++ a/tools/include/uapi/linux/bpf.h
@@ -644,10 +644,7 @@ union bpf_attr {
 	FN(redirect_map),		\
 	FN(sk_redirect_map),		\
 	FN(sock_map_update),		\
-<<<<<<< HEAD
-=======
 	FN(xdp_adjust_meta),
->>>>>>> linux-next/akpm-base
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
scripts-spellingtxt-add-more-spelling-mistakes-to-spellingtxt-fix.patch
mm-oom_reaper-skip-mm-structs-with-mmu-notifiers-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-sysctl-make-numa-stats-configurable-fix.patch
mm-sysctl-make-numa-stats-configurable-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

