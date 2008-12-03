From: akpm@linux-foundation.org
Subject: + arch-ia64-kernel-iosapicc-fix-warnings.patch added to -mm tree
Date: Tue, 02 Dec 2008 18:12:39 -0800
Message-ID: <200812030212.mB32Cdsg001526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753906AbYLCCMr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 21:12:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, avi@qumranet.com, tony.luck@intel.com, xiantao.zhang@intel.com


The patch titled
     arch/ia64/kernel/iosapic.c fix warnings
has been added to the -mm tree.  Its filename is
     arch-ia64-kernel-iosapicc-fix-warnings.patch

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
Subject: arch/ia64/kernel/iosapic.c fix warnings
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

arch/ia64/kernel/iosapic.c:708: warning: passing argument 2 of '__cpu_clear' from incompatible pointer type
arch/ia64/kernel/iosapic.c:711: warning: passing argument 1 of '__cpus_weight' from incompatible pointer type
arch/ia64/kernel/iosapic.c:719: warning: passing argument 1 of '__first_cpu' from incompatible pointer type
arch/ia64/kernel/iosapic.c:720: warning: passing argument 2 of '__next_cpu' from incompatible pointer type

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Cc: Avi Kivity <avi@qumranet.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/iosapic.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/ia64/kernel/iosapic.c~arch-ia64-kernel-iosapicc-fix-warnings arch/ia64/kernel/iosapic.c
--- a/arch/ia64/kernel/iosapic.c~arch-ia64-kernel-iosapicc-fix-warnings
+++ a/arch/ia64/kernel/iosapic.c
@@ -695,7 +695,7 @@ get_target_cpu (unsigned int gsi, int ir
 #ifdef CONFIG_NUMA
 	{
 		int num_cpus, cpu_index, iosapic_index, numa_cpu, i = 0;
-		const struct cpumask *cpu_mask;
+		struct cpumask *cpu_mask;
 
 		iosapic_index = find_iosapic(gsi);
 		if (iosapic_index < 0 ||
@@ -705,10 +705,10 @@ get_target_cpu (unsigned int gsi, int ir
 		cpu_mask = cpumask_of_node(iosapic_lists[iosapic_index].node);
 		for_each_cpu_and(numa_cpu, cpu_mask, &domain) {
 			if (!cpu_online(numa_cpu))
-				cpu_clear(numa_cpu, cpu_mask);
+				cpu_clear(numa_cpu, *cpu_mask);
 		}
 
-		num_cpus = cpus_weight(cpu_mask);
+		num_cpus = cpus_weight(*cpu_mask);
 
 		if (!num_cpus)
 			goto skip_numa_setup;
@@ -716,8 +716,8 @@ get_target_cpu (unsigned int gsi, int ir
 		/* Use irq assignment to distribute across cpus in node */
 		cpu_index = irq % num_cpus;
 
-		for (numa_cpu = first_cpu(cpu_mask) ; i < cpu_index ; i++)
-			numa_cpu = next_cpu(numa_cpu, cpu_mask);
+		for (numa_cpu = first_cpu(*cpu_mask) ; i < cpu_index ; i++)
+			numa_cpu = next_cpu(numa_cpu, *cpu_mask);
 
 		if (numa_cpu != NR_CPUS)
 			return cpu_physical_id(numa_cpu);
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

vmscan-evict-streaming-io-first.patch
linux-next.patch
arch-ia64-kernel-iosapicc-fix-warnings.patch
mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps.patch
mm-report-the-mmu-pagesize-in-proc-pid-smaps.patch
oom-fix-zone_scan_mutex-name.patch
mm-get-rid-of-pagevec_release_nonlru.patch
cleanup-get-rid-of-ifdef-config_migration.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-make-page_lock_anon_vma-static.patch
memcg-reclaim-shouldnt-change-zone-recent_rotated-statistics.patch
mm-make-init_section_page_cgroup-static.patch
mm-make-maddr-__iomem.patch
mm-make-mem_cgroup_resize_limit-static.patch
mm-make-scan_all_zones_unevictable_pages-static.patch
mm-make-scan_zone_unevictable_pages-static.patch
mm-make-setup_per_zone_inactive_ratio-static.patch
mm-make-vread-and-vwrite-declaration.patch
vmscan-bail-out-of-direct-reclaim-after-swap_cluster_max-pages.patch
mm-kill-zone_is_near_oom.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
memcg-new-force_empty-to-free-pages-under-group-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch

