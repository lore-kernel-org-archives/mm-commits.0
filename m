From: akpm@linux-foundation.org
Subject: [to-be-updated] powerpc-add-rcu_read_lock-to-gup_fast-implementation.patch removed from -mm tree
Date: Fri, 30 Apr 2010 15:05:29 -0700
Message-ID: <201004302205.o3UM5Tui016437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759763Ab0D3WGZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 18:06:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, benh@kernel.crashing.org, npiggin@suse.de, paulmck@linux.vnet.ibm.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     powerpc: add rcu_read_lock() to gup_fast() implementation
has been removed from the -mm tree.  Its filename was
     powerpc-add-rcu_read_lock-to-gup_fast-implementation.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: add rcu_read_lock() to gup_fast() implementation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

The powerpc page table freeing relies on the fact that IRQs hold off an
RCU grace period, this is currently true for all existing RCU
implementations but is not an assumption Paul wants to support.

Therefore, also take the RCU read lock along with disabling IRQs to ensure
the RCU grace period does at least cover these lookups.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Requested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/gup.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/powerpc/mm/gup.c~powerpc-add-rcu_read_lock-to-gup_fast-implementation arch/powerpc/mm/gup.c
--- a/arch/powerpc/mm/gup.c~powerpc-add-rcu_read_lock-to-gup_fast-implementation
+++ a/arch/powerpc/mm/gup.c
@@ -142,6 +142,7 @@ int get_user_pages_fast(unsigned long st
 	 * So long as we atomically load page table pointers versus teardown,
 	 * we can follow the address down to the the page and take a ref on it.
 	 */
+	rcu_read_lock();
 	local_irq_disable();
 
 	pgdp = pgd_offset(mm, addr);
@@ -162,6 +163,7 @@ int get_user_pages_fast(unsigned long st
 	} while (pgdp++, addr = next, addr != end);
 
 	local_irq_enable();
+	rcu_read_unlock();
 
 	VM_BUG_ON(nr != (end - start) >> PAGE_SHIFT);
 	return nr;
@@ -171,6 +173,7 @@ int get_user_pages_fast(unsigned long st
 
 slow:
 		local_irq_enable();
+		rcu_read_unlock();
 slow_irqon:
 		pr_devel("  slow path ! nr = %d\n", nr);
 
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

linux-next.patch
x86-remove-last-traces-of-quicklist-usage.patch
powerpc-add-rcu_read_lock-to-gup_fast-implementation.patch
cpu-timers-optimize-run_posix_cpu_timers.patch
rcu-remove-init_rcu_head-rcu_head_init-rcu_head.patch
mm-revalidate-anon_vma-in-page_lock_anon_vma.patch
bitops-optimize-hweight-by-making-use-of-compile-time-evaluation.patch
x86-add-optimized-popcnt-variants.patch

