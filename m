From: akpm@linux-foundation.org
Subject: [merged] sparse-define-__must_be_array-for-__checker__.patch removed from -mm tree
Date: Wed, 25 May 2011 13:31:31 -0700
Message-ID: <201105252029.p4PKTsOb014888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932804Ab1EYUs4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:48:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, dave@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     sparse: define __must_be_array() for __CHECKER__
has been removed from the -mm tree.  Its filename was
     sparse-define-__must_be_array-for-__checker__.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sparse: define __must_be_array() for __CHECKER__
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit c5e631cf65f ("ARRAY_SIZE: check for type") added __must_be_array().
But sparse can't parse this gcc extention.

Now make C=2 makes following sparse errors a lot.

  kernel/futex.c:2699:25: error: No right hand side of '+'-expression

Because __must_be_array() is used for ARRAY_SIZE() macro and it is
used very widely.

This patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/linux/compiler-gcc.h~sparse-define-__must_be_array-for-__checker__ include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~sparse-define-__must_be_array-for-__checker__
+++ a/include/linux/compiler-gcc.h
@@ -34,8 +34,12 @@
     __asm__ ("" : "=r"(__ptr) : "0"(ptr));		\
     (typeof(ptr)) (__ptr + (off)); })
 
+#ifdef __CHECKER__
+#define __must_be_array(arr) 0
+#else
 /* &a[0] degrades to a pointer: a different type from an array */
 #define __must_be_array(a) BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
+#endif
 
 /*
  * Force always-inline if the user requests it so via the .config,
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
mm-increase-reclaim_distance-to-30.patch
slab-use-numa_no_node.patch
m32r-convert-cpumask-api.patch
m32r-fix-spin_lock_irqsave-misuse.patch
m32r-remove-redundant-declaration.patch
getdelays-show-average-cpu-io-swap-reclaim-delays.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix-2.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order-fix.patch
memcg-fix-get_scan_count-for-small-targets.patch
memcg-remove-unused-retry-signal-from-reclaim.patch
vmscanmemcg-memcg-aware-swap-token.patch
vmscan-implement-swap-token-trace.patch
vmscan-implement-swap-token-priority-aging.patch
add-the-pagefault-count-into-memcg-stats.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
proc-put-check_mem_permission-after-__get_free_page-in-mem_write.patch
proc-fix-pagemap_read-error-case.patch
cpumask-convert-for_each_cpumask-with-for_each_cpu.patch
cpumask-convert-cpumask_of_cpu-to-cpumask_of.patch
cpumask-alloc_cpumask_var-use-numa_no_node.patch
cpumask-add-cpumask_var_t-documentation.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

