From: akpm@linux-foundation.org
Subject: + arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom.patch
 added to -mm tree
Date: Mon, 05 Aug 2013 15:05:51 -0700
Message-ID: <520021bf.l5VpFOl4nPbLg70K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43232 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048Ab3HEWFw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 18:05:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, azurit@pobox.sk, hannes@cmpxchg.org

Subject: + arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom.patch added to -mm tree
To: hannes@cmpxchg.org,azurit@pobox.sk,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,mhocko@suse.cz,rientjes@google.com
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 15:05:51 -0700


The patch titled
     Subject: arch: mm: do not invoke OOM killer on kernel fault OOM
has been added to the -mm tree.  Its filename is
     arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: arch: mm: do not invoke OOM killer on kernel fault OOM

Kernel faults are expected to handle OOM conditions gracefully (gup,
uaccess etc.), so they should never invoke the OOM killer.  Reserve this
for faults triggered in user context when it is the only option.

Most architectures already do this, fix up the remaining few.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: azurIt <azurit@pobox.sk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/fault.c       |   14 +++++++-------
 arch/arm64/mm/fault.c     |   14 +++++++-------
 arch/avr32/mm/fault.c     |    2 +-
 arch/mips/mm/fault.c      |    2 ++
 arch/um/kernel/trap.c     |    2 ++
 arch/unicore32/mm/fault.c |   14 +++++++-------
 6 files changed, 26 insertions(+), 22 deletions(-)

diff -puN arch/arm/mm/fault.c~arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom arch/arm/mm/fault.c
--- a/arch/arm/mm/fault.c~arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom
+++ a/arch/arm/mm/fault.c
@@ -349,6 +349,13 @@ retry:
 	if (likely(!(fault & (VM_FAULT_ERROR | VM_FAULT_BADMAP | VM_FAULT_BADACCESS))))
 		return 0;
 
+	/*
+	 * If we are in kernel mode at this point, we
+	 * have no context to handle this fault with.
+	 */
+	if (!user_mode(regs))
+		goto no_context;
+
 	if (fault & VM_FAULT_OOM) {
 		/*
 		 * We ran out of memory, call the OOM killer, and return to
@@ -359,13 +366,6 @@ retry:
 		return 0;
 	}
 
-	/*
-	 * If we are in kernel mode at this point, we
-	 * have no context to handle this fault with.
-	 */
-	if (!user_mode(regs))
-		goto no_context;
-
 	if (fault & VM_FAULT_SIGBUS) {
 		/*
 		 * We had some memory, but were unable to
diff -puN arch/arm64/mm/fault.c~arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom arch/arm64/mm/fault.c
--- a/arch/arm64/mm/fault.c~arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom
+++ a/arch/arm64/mm/fault.c
@@ -288,6 +288,13 @@ retry:
 			      VM_FAULT_BADACCESS))))
 		return 0;
 
+	/*
+	 * If we are in kernel mode at this point, we have no context to
+	 * handle this fault with.
+	 */
+	if (!user_mode(regs))
+		goto no_context;
+
 	if (fault & VM_FAULT_OOM) {
 		/*
 		 * We ran out of memory, call the OOM killer, and return to
@@ -298,13 +305,6 @@ retry:
 		return 0;
 	}
 
-	/*
-	 * If we are in kernel mode at this point, we have no context to
-	 * handle this fault with.
-	 */
-	if (!user_mode(regs))
-		goto no_context;
-
 	if (fault & VM_FAULT_SIGBUS) {
 		/*
 		 * We had some memory, but were unable to successfully fix up
diff -puN arch/avr32/mm/fault.c~arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom arch/avr32/mm/fault.c
--- a/arch/avr32/mm/fault.c~arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom
+++ a/arch/avr32/mm/fault.c
@@ -228,9 +228,9 @@ no_context:
 	 */
 out_of_memory:
 	up_read(&mm->mmap_sem);
-	pagefault_out_of_memory();
 	if (!user_mode(regs))
 		goto no_context;
+	pagefault_out_of_memory();
 	return;
 
 do_sigbus:
diff -puN arch/mips/mm/fault.c~arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom arch/mips/mm/fault.c
--- a/arch/mips/mm/fault.c~arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom
+++ a/arch/mips/mm/fault.c
@@ -241,6 +241,8 @@ out_of_memory:
 	 * (which will retry the fault, or kill us if we got oom-killed).
 	 */
 	up_read(&mm->mmap_sem);
+	if (!user_mode(regs))
+		goto no_context;
 	pagefault_out_of_memory();
 	return;
 
diff -puN arch/um/kernel/trap.c~arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom arch/um/kernel/trap.c
--- a/arch/um/kernel/trap.c~arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom
+++ a/arch/um/kernel/trap.c
@@ -124,6 +124,8 @@ out_of_memory:
 	 * (which will retry the fault, or kill us if we got oom-killed).
 	 */
 	up_read(&mm->mmap_sem);
+	if (!is_user)
+		goto out_nosemaphore;
 	pagefault_out_of_memory();
 	return 0;
 }
diff -puN arch/unicore32/mm/fault.c~arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom arch/unicore32/mm/fault.c
--- a/arch/unicore32/mm/fault.c~arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom
+++ a/arch/unicore32/mm/fault.c
@@ -278,6 +278,13 @@ retry:
 	       (VM_FAULT_ERROR | VM_FAULT_BADMAP | VM_FAULT_BADACCESS))))
 		return 0;
 
+	/*
+	 * If we are in kernel mode at this point, we
+	 * have no context to handle this fault with.
+	 */
+	if (!user_mode(regs))
+		goto no_context;
+
 	if (fault & VM_FAULT_OOM) {
 		/*
 		 * We ran out of memory, call the OOM killer, and return to
@@ -288,13 +295,6 @@ retry:
 		return 0;
 	}
 
-	/*
-	 * If we are in kernel mode at this point, we
-	 * have no context to handle this fault with.
-	 */
-	if (!user_mode(regs))
-		goto no_context;
-
 	if (fault & VM_FAULT_SIGBUS) {
 		/*
 		 * We had some memory, but were unable to
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

memcg-dont-initialize-kmem-cache-destroying-work-for-root-caches.patch
mm-kill-one-if-loop-in-__free_pages_bootmem.patch
mm-vmscan-fix-numa-reclaim-balance-problem-in-kswapd.patch
mm-page_alloc-rearrange-watermark-checking-in-get_page_from_freelist.patch
mm-page_alloc-fair-zone-allocator-policy.patch
mm-revert-page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory.patch
memcg-remove-redundant-code-in-mem_cgroup_force_empty_write.patch
memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
memcg-get-rid-of-soft-limit-tree-infrastructure.patch
vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
memcg-enhance-memcg-iterator-to-support-predicates.patch
memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
memcg-track-all-children-over-limit-in-the-root.patch
memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
arch-mm-remove-obsolete-init-oom-protection.patch
arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom.patch
arch-mm-pass-userspace-fault-flag-to-generic-fault-handler.patch
x86-finish-user-fault-error-path-with-fatal-signal.patch
mm-memcg-enable-memcg-oom-killer-only-for-user-faults.patch
mm-memcg-rework-and-document-oom-waiting-and-wakeup.patch
mm-memcg-do-not-trap-chargers-with-full-callstack-on-oom.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

