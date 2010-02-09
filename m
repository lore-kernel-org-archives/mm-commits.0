From: akpm@linux-foundation.org
Subject: + fs-execc-restrict-initial-stack-space-expansion-to-rlimit-cleanup.patch added to -mm tree
Date: Tue, 09 Feb 2010 13:21:50 -0800
Message-ID: <201002092121.o19LLoXP002524@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751169Ab0BIVXc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2010 16:23:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, anton@samba.org, benh@kernel.crashing.org, jmorris@namei.org, mingo@elte.hu, oleg@redhat.com, serue@us.ibm.com, stable@kernel.org, xiyou.wangcong@gmail.com


The patch titled
     fs-execc-restrict-initial-stack-space-expansion-to-rlimit-cleanup
has been added to the -mm tree.  Its filename is
     fs-execc-restrict-initial-stack-space-expansion-to-rlimit-cleanup.patch

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
Subject: fs-execc-restrict-initial-stack-space-expansion-to-rlimit-cleanup
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Americo Wang <xiyou.wangcong@gmail.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: <stable@kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff -puN fs/exec.c~fs-execc-restrict-initial-stack-space-expansion-to-rlimit-cleanup fs/exec.c
--- a/fs/exec.c~fs-execc-restrict-initial-stack-space-expansion-to-rlimit-cleanup
+++ a/fs/exec.c
@@ -555,7 +555,6 @@ static int shift_arg_pages(struct vm_are
 }
 
 #define EXTRA_STACK_VM_PAGES	20	/* random */
-#define ALIGN_DOWN(addr,size)	((addr)&(~((size)-1)))
 
 /*
  * Finalizes the stack vm_area_struct. The flags and permissions are updated,
@@ -571,7 +570,10 @@ int setup_arg_pages(struct linux_binprm 
 	struct vm_area_struct *vma = bprm->vma;
 	struct vm_area_struct *prev = NULL;
 	unsigned long vm_flags;
-	unsigned long stack_base, stack_expand, stack_expand_lim, stack_size;
+	unsigned long stack_base;
+	unsigned long stack_size;
+	unsigned long stack_expand;
+	unsigned long rlim_stack;
 
 #ifdef CONFIG_STACK_GROWSUP
 	/* Limit stack size to 1GB */
@@ -630,22 +632,25 @@ int setup_arg_pages(struct linux_binprm 
 
 	stack_expand = EXTRA_STACK_VM_PAGES * PAGE_SIZE;
 	stack_size = vma->vm_end - vma->vm_start;
-	if (rlimit(RLIMIT_STACK) < stack_size)
-		stack_expand_lim = 0; /* don't shrick the stack */
-	else
-		/*
-		 * Align this down to a page boundary as expand_stack
-		 * will align it up.
-		 */
-		stack_expand_lim = ALIGN_DOWN(rlimit(RLIMIT_STACK) - stack_size,
-					      PAGE_SIZE);
-	/* Initial stack must not cause stack overflow. */
-	if (stack_expand > stack_expand_lim)
-		stack_expand = stack_expand_lim;
+	/*
+	 * Align this down to a page boundary as expand_stack
+	 * will align it up.
+	 */
+	rlim_stack = rlimit(RLIMIT_STACK) & PAGE_MASK;
+	if (rlim_stack < stack_size)
+		rlim_stack = stack_size;
 #ifdef CONFIG_STACK_GROWSUP
-	stack_base = vma->vm_end + stack_expand;
+	if (stack_size + stack_expand > rlim_stack) {
+		stack_base = vma->vm_start + rlim_stack;
+	} else {
+		stack_base = vma->vm_end + stack_expand;
+	}
 #else
-	stack_base = vma->vm_start - stack_expand;
+	if (stack_size + stack_expand > rlim_stack) {
+		stack_base = vma->vm_end - rlim_stack;
+	} else {
+		stack_base = vma->vm_start - stack_expand;
+	}
 #endif
 	ret = expand_stack(vma, stack_base);
 	if (ret)
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
fs-execc-restrict-initial-stack-space-expansion-to-rlimit.patch
fs-execc-restrict-initial-stack-space-expansion-to-rlimit-cleanup.patch
fs-execc-restrict-initial-stack-space-expansion-to-rlimit-cleanup-cleanup.patch
percpu_counter-make-__percpu_counter_add-an-inline-function-on-up.patch
sched-cpuacct-use-bigger-percpu-counter-batch-values-for-stats-counters.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mlock_vma_pages_range-never-return-negative-value.patch
mlock_vma_pages_range-only-return-success-or-failure.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
vmscan-get_scan_ratio-cleanup.patch
mm-lockdep-annotate-reclaim-context-to-zone-reclaim-too.patch
mm-page_allocc-remove-duplicate-call-to-trace_mm_page_free_direct.patch
mm-page_allocc-adjust-a-call-site-to-trace_mm_page_free_direct.patch
mm-remove-function-free_hot_page.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
mm-fix-mbind-vma-merge-problem.patch
mm-fix-mbind-vma-merge-problem-fix.patch
mm-mempolicyc-fix-indentation-of-the-comments-of-do_migrate_pages.patch
mm-migratec-kill-anon-local-variable-from-migrate_page_copy.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-further-cleanups.patch
rmap-remove-obsolete-check-from-__page_check_anon_rmap.patch
rmap-move-exclusively-owned-pages-to-own-anon_vma-in-do_wp_page.patch
mm-remove-vm_lock_rmap-code.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch
prctl-add-pr_set_proctitle_area-option-for-prctl.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency.patch
memcg-move-charges-of-anonymous-swap-fix-2.patch
sysctl-clean-up-vm-related-variable-declarations.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch
reiser4.patch

