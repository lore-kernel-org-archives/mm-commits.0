From: akpm@linux-foundation.org
Subject: [merged] mm-add-__nocast-attribute-to-vm_flags.patch removed from -mm tree
Date: Wed, 25 May 2011 13:27:48 -0700
Message-ID: <201105252026.p4PKQB7Z014475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755053Ab1EYU0y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:26:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, adobriyan@gmail.com, benh@kernel.crashing.org, dave@linux.vnet.ibm.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, lethal@linux-sh.org, linux@ar


The patch titled
     mm: add __nocast attribute to vm_flags
has been removed from the -mm tree.  Its filename was
     mm-add-__nocast-attribute-to-vm_flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add __nocast attribute to vm_flags
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Now, We are converting vm_flags to 64bit.  so nocast attribute help to
find hidden wrong vm_flags usage.

Suggested-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/mm_types.h~mm-add-__nocast-attribute-to-vm_flags include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-add-__nocast-attribute-to-vm_flags
+++ a/include/linux/mm_types.h
@@ -109,7 +109,7 @@ struct page {
  */
 struct vm_region {
 	struct rb_node	vm_rb;		/* link in global region tree */
-	unsigned long long vm_flags;	/* VMA vm_flags */
+	unsigned long long __nocast vm_flags;	/* VMA vm_flags */
 	unsigned long	vm_start;	/* start address of region */
 	unsigned long	vm_end;		/* region initialised to here */
 	unsigned long	vm_top;		/* region allocated to here */
@@ -137,7 +137,7 @@ struct vm_area_struct {
 	struct vm_area_struct *vm_next, *vm_prev;
 
 	pgprot_t vm_page_prot;		/* Access permissions of this VMA. */
-	unsigned long long vm_flags;		/* Flags, see mm.h. */
+	unsigned long long __nocast vm_flags;	/* Flags, see mm.h. */
 
 	struct rb_node vm_rb;
 
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

