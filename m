From: akpm@linux-foundation.org
Subject: [merged] sparse-undef-__compiletime_warningerror-if-__checker__-is-defined.patch removed from -mm tree
Date: Wed, 25 May 2011 13:31:33 -0700
Message-ID: <201105252029.p4PKTunu014891@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755737Ab1EYUtB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:49:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, arjan@infradead.org, dave@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     sparse: Undef __compiletime_{warning,error} if __CHECKER__ is defined
has been removed from the -mm tree.  Its filename was
     sparse-undef-__compiletime_warningerror-if-__checker__-is-defined.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sparse: Undef __compiletime_{warning,error} if __CHECKER__ is defined
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

sparse can't parse warning and error attribute.  then they should be
hidden from sparse.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc4.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/compiler-gcc4.h~sparse-undef-__compiletime_warningerror-if-__checker__-is-defined include/linux/compiler-gcc4.h
--- a/include/linux/compiler-gcc4.h~sparse-undef-__compiletime_warningerror-if-__checker__-is-defined
+++ a/include/linux/compiler-gcc4.h
@@ -51,7 +51,7 @@
 #if __GNUC_MINOR__ > 0
 #define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
 #endif
-#if __GNUC_MINOR__ >= 4
+#if __GNUC_MINOR__ >= 4 && !defined(__CHECKER__)
 #define __compiletime_warning(message) __attribute__((warning(message)))
 #define __compiletime_error(message) __attribute__((error(message)))
 #endif
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

