From: akpm@linux-foundation.org
Subject: [merged] mm-oom-remove-statically-defined-arch-functions-of-same-name.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:29:27 -0800
Message-ID: <20121214232928.4DBC5200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:56640 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932729Ab2LNX3c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:29:32 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so207388lag.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:29:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, benh@kernel.crashing.org, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, lethal@linux-sh.org, mhocko@suse.cz, mingo@redhat.com, paulus@samba.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: remove statically defined arch functions of same name
has been removed from the -mm tree.  Its filename was
     mm-oom-remove-statically-defined-arch-functions-of-same-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: remove statically defined arch functions of same name

out_of_memory() is a globally defined function to call the oom killer. 
x86, sh, and powerpc all use a function of the same name within file scope
in their respective fault.c unnecessarily.  Inline the functions into the
pagefault handlers to clean the code up.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/fault.c |   27 ++++++++++++---------------
 arch/sh/mm/fault.c      |   19 +++++++------------
 arch/x86/mm/fault.c     |   23 ++++++++---------------
 3 files changed, 27 insertions(+), 42 deletions(-)

diff -puN arch/powerpc/mm/fault.c~mm-oom-remove-statically-defined-arch-functions-of-same-name arch/powerpc/mm/fault.c
--- a/arch/powerpc/mm/fault.c~mm-oom-remove-statically-defined-arch-functions-of-same-name
+++ a/arch/powerpc/mm/fault.c
@@ -113,19 +113,6 @@ static int store_updates_sp(struct pt_re
 #define MM_FAULT_CONTINUE	-1
 #define MM_FAULT_ERR(sig)	(sig)
 
-static int out_of_memory(struct pt_regs *regs)
-{
-	/*
-	 * We ran out of memory, or some other thing happened to us that made
-	 * us unable to handle the page fault gracefully.
-	 */
-	up_read(&current->mm->mmap_sem);
-	if (!user_mode(regs))
-		return MM_FAULT_ERR(SIGKILL);
-	pagefault_out_of_memory();
-	return MM_FAULT_RETURN;
-}
-
 static int do_sigbus(struct pt_regs *regs, unsigned long address)
 {
 	siginfo_t info;
@@ -169,8 +156,18 @@ static int mm_fault_error(struct pt_regs
 		return MM_FAULT_CONTINUE;
 
 	/* Out of memory */
-	if (fault & VM_FAULT_OOM)
-		return out_of_memory(regs);
+	if (fault & VM_FAULT_OOM) {
+		up_read(&current->mm->mmap_sem);
+
+		/*
+		 * We ran out of memory, or some other thing happened to us that
+		 * made us unable to handle the page fault gracefully.
+		 */
+		if (!user_mode(regs))
+			return MM_FAULT_ERR(SIGKILL);
+		pagefault_out_of_memory();
+		return MM_FAULT_RETURN;
+	}
 
 	/* Bus error. x86 handles HWPOISON here, we'll add this if/when
 	 * we support the feature in HW
diff -puN arch/sh/mm/fault.c~mm-oom-remove-statically-defined-arch-functions-of-same-name arch/sh/mm/fault.c
--- a/arch/sh/mm/fault.c~mm-oom-remove-statically-defined-arch-functions-of-same-name
+++ a/arch/sh/mm/fault.c
@@ -301,17 +301,6 @@ bad_area_access_error(struct pt_regs *re
 	__bad_area(regs, error_code, address, SEGV_ACCERR);
 }
 
-static void out_of_memory(void)
-{
-	/*
-	 * We ran out of memory, call the OOM killer, and return the userspace
-	 * (which will retry the fault, or kill us if we got oom-killed):
-	 */
-	up_read(&current->mm->mmap_sem);
-
-	pagefault_out_of_memory();
-}
-
 static void
 do_sigbus(struct pt_regs *regs, unsigned long error_code, unsigned long address)
 {
@@ -353,8 +342,14 @@ mm_fault_error(struct pt_regs *regs, uns
 			no_context(regs, error_code, address);
 			return 1;
 		}
+		up_read(&current->mm->mmap_sem);
 
-		out_of_memory();
+		/*
+		 * We ran out of memory, call the OOM killer, and return the
+		 * userspace (which will retry the fault, or kill us if we got
+		 * oom-killed):
+		 */
+		pagefault_out_of_memory();
 	} else {
 		if (fault & VM_FAULT_SIGBUS)
 			do_sigbus(regs, error_code, address);
diff -puN arch/x86/mm/fault.c~mm-oom-remove-statically-defined-arch-functions-of-same-name arch/x86/mm/fault.c
--- a/arch/x86/mm/fault.c~mm-oom-remove-statically-defined-arch-functions-of-same-name
+++ a/arch/x86/mm/fault.c
@@ -803,20 +803,6 @@ bad_area_access_error(struct pt_regs *re
 	__bad_area(regs, error_code, address, SEGV_ACCERR);
 }
 
-/* TODO: fixup for "mm-invoke-oom-killer-from-page-fault.patch" */
-static void
-out_of_memory(struct pt_regs *regs, unsigned long error_code,
-	      unsigned long address)
-{
-	/*
-	 * We ran out of memory, call the OOM killer, and return the userspace
-	 * (which will retry the fault, or kill us if we got oom-killed):
-	 */
-	up_read(&current->mm->mmap_sem);
-
-	pagefault_out_of_memory();
-}
-
 static void
 do_sigbus(struct pt_regs *regs, unsigned long error_code, unsigned long address,
 	  unsigned int fault)
@@ -879,7 +865,14 @@ mm_fault_error(struct pt_regs *regs, uns
 			return 1;
 		}
 
-		out_of_memory(regs, error_code, address);
+		up_read(&current->mm->mmap_sem);
+
+		/*
+		 * We ran out of memory, call the OOM killer, and return the
+		 * userspace (which will retry the fault, or kill us if we got
+		 * oom-killed):
+		 */
+		pagefault_out_of_memory();
 	} else {
 		if (fault & (VM_FAULT_SIGBUS|VM_FAULT_HWPOISON|
 			     VM_FAULT_HWPOISON_LARGE))
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch
x86-fix-the-argument-passed-to-sync_global_pgds.patch
irq-tsk-comm-is-an-array.patch
mm-mempolicy-introduce-spinlock-to-read-shared-policy-tree.patch
memcg-make-it-possible-to-use-the-stock-for-more-than-one-page.patch
memcg-reclaim-when-more-than-one-page-needed.patch
memcg-change-defines-to-an-enum.patch
memcg-kmem-accounting-basic-infrastructure.patch
memcg-kmem-accounting-basic-infrastructure-fix.patch
mm-add-a-__gfp_kmemcg-flag.patch
memcg-kmem-controller-infrastructure.patch
memcg-kmem-controller-infrastructure-replace-__always_inline-with-plain-inline.patch
mm-allocate-kernel-pages-to-the-right-memcg.patch
res_counter-return-amount-of-charges-after-res_counter_uncharge.patch
memcg-kmem-accounting-lifecycle-management.patch
memcg-use-static-branches-when-code-not-in-use.patch
memcg-allow-a-memcg-with-kmem-charges-to-be-destructed.patch
memcg-execute-the-whole-memcg-freeing-in-free_worker.patch
fork-protect-architectures-where-thread_size-=-page_size-against-fork-bombs.patch
memcg-add-documentation-about-the-kmem-controller.patch
slab-slub-struct-memcg_params.patch
slab-annotate-on-slab-caches-nodelist-locks.patch
slab-slub-consider-a-memcg-parameter-in-kmem_create_cache.patch
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears.patch
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears-simplify-ida-initialization.patch
memcg-infrastructure-to-match-an-allocation-to-the-right-cache.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions-remove-test-for-current-mm-in-memcg_stop-resume_kmem_account.patch
slb-always-get-the-cache-from-its-page-in-kmem_cache_free.patch
slb-allocate-objects-from-memcg-cache.patch
memcg-destroy-memcg-caches.patch
memcg-destroy-memcg-caches-move-include-of-workqueueh-to-top-of-slabh-file.patch
memcg-slb-track-all-the-memcg-children-of-a-kmem_cache.patch
memcg-slb-shrink-dead-caches.patch
memcg-slb-shrink-dead-caches-get-rid-of-once-per-second-cache-shrinking-for-dead-memcgs.patch
memcg-aggregate-memcg-cache-values-in-slabinfo.patch
slab-propagate-tunable-values.patch
slub-slub-specific-propagation-changes.patch
slub-slub-specific-propagation-changes-fix.patch
kmem-add-slab-specific-documentation-about-the-kmem-controller.patch
memcg-add-comments-clarifying-aspects-of-cache-attribute-propagation.patch
slub-drop-mutex-before-deleting-sysfs-entry.patch
ksm-numa-awareness-sysfs-knob.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch

