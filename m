From: akpm@linux-foundation.org
Subject: + arch-mm-remove-obsolete-init-oom-protection.patch added to -mm
 tree
Date: Mon, 05 Aug 2013 15:05:49 -0700
Message-ID: <520021bd.wvxKrjH+4gBXR3B/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43223 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049Ab3HEWFu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 18:05:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, azurit@pobox.sk, hannes@cmpxchg.org

Subject: + arch-mm-remove-obsolete-init-oom-protection.patch added to -mm tree
To: hannes@cmpxchg.org,azurit@pobox.sk,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,mhocko@suse.cz,rientjes@google.com
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 15:05:49 -0700


The patch titled
     Subject: arch: mm: remove obsolete init OOM protection
has been added to the -mm tree.  Its filename is
     arch-mm-remove-obsolete-init-oom-protection.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-mm-remove-obsolete-init-oom-protection.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-mm-remove-obsolete-init-oom-protection.patch

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
Subject: arch: mm: remove obsolete init OOM protection

The memcg code can trap tasks in the context of the failing allocation
until an OOM situation is resolved.  They can hold all kinds of locks (fs,
mm) at this point, which makes it prone to deadlocking.

This series converts memcg OOM handling into a two step process that is
started in the charge context, but any waiting is done after the fault
stack is fully unwound.

Patches 1-4 prepare architecture handlers to support the new memcg
requirements, but in doing so they also remove old cruft and unify
out-of-memory behavior across architectures.

Patch 5 disables the memcg OOM handling for syscalls, readahead, kernel
faults, because they can gracefully unwind the stack with -ENOMEM.  OOM
handling is restricted to user triggered faults that have no other option.

Patch 6 reworks memcg's hierarchical OOM locking to make it a little more
obvious wth is going on in there: reduce locked regions, rename locking
functions, reorder and document.

Patch 7 implements the two-part OOM handling such that tasks are never
trapped with the full charge stack in an OOM situation.



This patch:

Back before smart OOM killing, when faulting tasks were killed directly on
allocation failures, the arch-specific fault handlers needed special
protection for the init process.

Now that all fault handlers call into the generic OOM killer (609838c "mm:
invoke oom-killer from remaining unconverted page fault handlers"), which
already provides init protection, the arch-specific leftovers can be
removed.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: azurIt <azurit@pobox.sk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/mm/fault.c   |    5 -----
 arch/score/mm/fault.c |    6 ------
 arch/tile/mm/fault.c  |    6 ------
 3 files changed, 17 deletions(-)

diff -puN arch/arc/mm/fault.c~arch-mm-remove-obsolete-init-oom-protection arch/arc/mm/fault.c
--- a/arch/arc/mm/fault.c~arch-mm-remove-obsolete-init-oom-protection
+++ a/arch/arc/mm/fault.c
@@ -122,7 +122,6 @@ good_area:
 			goto bad_area;
 	}
 
-survive:
 	/*
 	 * If for any reason at all we couldn't handle the fault,
 	 * make sure we exit gracefully rather than endlessly redo
@@ -201,10 +200,6 @@ no_context:
 	die("Oops", regs, address);
 
 out_of_memory:
-	if (is_global_init(tsk)) {
-		yield();
-		goto survive;
-	}
 	up_read(&mm->mmap_sem);
 
 	if (user_mode(regs)) {
diff -puN arch/score/mm/fault.c~arch-mm-remove-obsolete-init-oom-protection arch/score/mm/fault.c
--- a/arch/score/mm/fault.c~arch-mm-remove-obsolete-init-oom-protection
+++ a/arch/score/mm/fault.c
@@ -100,7 +100,6 @@ good_area:
 			goto bad_area;
 	}
 
-survive:
 	/*
 	* If for any reason at all we couldn't handle the fault,
 	* make sure we exit gracefully rather than endlessly redo
@@ -167,11 +166,6 @@ no_context:
 	*/
 out_of_memory:
 	up_read(&mm->mmap_sem);
-	if (is_global_init(tsk)) {
-		yield();
-		down_read(&mm->mmap_sem);
-		goto survive;
-	}
 	if (!user_mode(regs))
 		goto no_context;
 	pagefault_out_of_memory();
diff -puN arch/tile/mm/fault.c~arch-mm-remove-obsolete-init-oom-protection arch/tile/mm/fault.c
--- a/arch/tile/mm/fault.c~arch-mm-remove-obsolete-init-oom-protection
+++ a/arch/tile/mm/fault.c
@@ -430,7 +430,6 @@ good_area:
 			goto bad_area;
 	}
 
- survive:
 	/*
 	 * If for any reason at all we couldn't handle the fault,
 	 * make sure we exit gracefully rather than endlessly redo
@@ -568,11 +567,6 @@ no_context:
  */
 out_of_memory:
 	up_read(&mm->mmap_sem);
-	if (is_global_init(tsk)) {
-		yield();
-		down_read(&mm->mmap_sem);
-		goto survive;
-	}
 	if (is_kernel_mode)
 		goto no_context;
 	pagefault_out_of_memory();
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

