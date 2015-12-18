From: akpm@linux-foundation.org
Subject: + mm-oom-introduce-oom-reaper-fix-3.patch added to -mm tree
Date: Thu, 17 Dec 2015 16:23:25 -0800
Message-ID: <567351fd.CoC7K1yMOR2/z3ZF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53354 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbbLRAX0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Dec 2015 19:23:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andrea@kernel.org, hughd@google.com, mgorman@suse.de, mhocko@suse.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom-introduce-oom-reaper-fix-3
has been added to the -mm tree.  Its filename is
     mm-oom-introduce-oom-reaper-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-introduce-oom-reaper-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-introduce-oom-reaper-fix-3.patch

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
Subject: mm-oom-introduce-oom-reaper-fix-3

fix CONFIG_MMU=n build

slub.c:(.text+0x4184): undefined reference to `tlb_gather_mmu'
slub.c:(.text+0x41bc): undefined reference to `unmap_page_range'
slub.c:(.text+0x41d8): undefined reference to `tlb_finish_mmu'

Cc: Andrea Argangeli <andrea@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   50 +++++++++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff -puN include/linux/mm.h~mm-oom-introduce-oom-reaper-fix-3 include/linux/mm.h
diff -puN mm/internal.h~mm-oom-introduce-oom-reaper-fix-3 mm/internal.h
diff -puN mm/memory.c~mm-oom-introduce-oom-reaper-fix-3 mm/memory.c
diff -puN mm/oom_kill.c~mm-oom-introduce-oom-reaper-fix-3 mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-introduce-oom-reaper-fix-3
+++ a/mm/oom_kill.c
@@ -415,6 +415,7 @@ static DECLARE_WAIT_QUEUE_HEAD(oom_victi
 
 bool oom_killer_disabled __read_mostly;
 
+#ifdef CONFIG_MMU
 /*
  * OOM Reaper kernel thread which tries to reap the memory used by the OOM
  * victim (if that is possible) to help the OOM killer to move on.
@@ -517,6 +518,27 @@ static void wake_oom_reaper(struct mm_st
 		mmdrop(mm);
 }
 
+static int __init oom_init(void)
+{
+	oom_reaper_th = kthread_run(oom_reaper, NULL, "oom_reaper");
+	if (IS_ERR(oom_reaper_th)) {
+		pr_err("Unable to start OOM reaper %ld. Continuing regardless\n",
+				PTR_ERR(oom_reaper_th));
+		oom_reaper_th = NULL;
+	} else {
+		struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
+
+		/*
+		 * Make sure our oom reaper thread will get scheduled when
+		 * ASAP and that it won't get preempted by malicious userspace.
+		 */
+		sched_setscheduler(oom_reaper_th, SCHED_FIFO, &param);
+	}
+	return 0;
+}
+module_init(oom_init)
+#endif
+
 /**
  * mark_oom_victim - mark the given task as OOM victim
  * @tsk: task to mark
@@ -626,7 +648,9 @@ void oom_kill_process(struct oom_control
 	unsigned int victim_points = 0;
 	static DEFINE_RATELIMIT_STATE(oom_rs, DEFAULT_RATELIMIT_INTERVAL,
 					      DEFAULT_RATELIMIT_BURST);
+#ifdef CONFIG_MMU
 	bool can_oom_reap = true;
+#endif
 
 	/*
 	 * If the task is already exiting, don't alarm the sysadmin or kill
@@ -719,6 +743,7 @@ void oom_kill_process(struct oom_control
 			continue;
 		if (is_global_init(p))
 			continue;
+#ifdef CONFIG_MMU
 		if (unlikely(p->flags & PF_KTHREAD) ||
 		    p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN) {
 			/*
@@ -729,13 +754,16 @@ void oom_kill_process(struct oom_control
 			can_oom_reap = false;
 			continue;
 		}
-
+#endif
 		do_send_sig_info(SIGKILL, SEND_SIG_FORCED, p, true);
 	}
 	rcu_read_unlock();
 
+#ifdef CONFIG_MMU
 	if (can_oom_reap)
 		wake_oom_reaper(mm);
+#endif
+
 	mmdrop(mm);
 	put_task_struct(victim);
 }
@@ -887,23 +915,3 @@ void pagefault_out_of_memory(void)
 
 	mutex_unlock(&oom_lock);
 }
-
-static int __init oom_init(void)
-{
-	oom_reaper_th = kthread_run(oom_reaper, NULL, "oom_reaper");
-	if (IS_ERR(oom_reaper_th)) {
-		pr_err("Unable to start OOM reaper %ld. Continuing regardless\n",
-				PTR_ERR(oom_reaper_th));
-		oom_reaper_th = NULL;
-	} else {
-		struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
-
-		/*
-		 * Make sure our oom reaper thread will get scheduled when
-		 * ASAP and that it won't get preempted by malicious userspace.
-		 */
-		sched_setscheduler(oom_reaper_th, SCHED_FIFO, &param);
-	}
-	return 0;
-}
-module_init(oom_init)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
mm.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
arm64-mm-support-arch_mmap_rnd_bits-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-printk-introduce-new-format-string-for-flags-fix-2.patch
mm-support-madvisemadv_free-fix-2-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-3.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
mm-oom-introduce-oom-reaper-fix-fix.patch
mm-oom-introduce-oom-reaper-fix-fix-2.patch
mm-oom-introduce-oom-reaper-checkpatch-fixes.patch
mm-oom-introduce-oom-reaper-fix-3.patch
kernel-stop_machinec-remove-config_smp-dependencies.patch
lib-vsprintfc-expand-field_width-to-24-bits-fix.patch
lib-test_printfc-test-dentry-printing-fix.patch
printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix.patch
printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix-3.patch
linux-next-rejects.patch
include-linux-propertyh-fix-build-issues-with-gcc-444.patch
include-linux-propertyh-fix-build-issues-with-gcc-444-fix.patch
fs-overlayfs-superc-needs-pagemaph.patch
fs-adfs-adfsh-tidy-up-comments.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

