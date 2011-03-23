From: akpm@linux-foundation.org
Subject: [folded] page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem-fix.patch removed from -mm tree
Date: Wed, 23 Mar 2011 16:21:08 -0700
Message-ID: <201103232321.p2NNL9dR004434@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932972Ab1CWXVt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 19:21:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, balbir@in.ibm.com, dave@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem-fix
has been removed from the -mm tree.  Its filename was
     page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem-fix.patch

This patch was dropped because it was folded into page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem-fix
From: Johannes Weiner <hannes@cmpxchg.org>

Subject: mm: do not define unused free_page_cgroup without memory hotplug

Without memory hotplug configured in, the page cgroup array is never
actually freed again:

mm/page_cgroup.c:149:13: warning: `free_page_cgroup' defined but not used

Wrap the definition in ifdefs.  Rather than moving it into an existing
ifdef section, to keep it close to its allocation counterpart.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Ackedy-by: Michal Hocko <mhocko@suse.cz>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/page_cgroup.c~page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem-fix mm/page_cgroup.c
--- a/mm/page_cgroup.c~page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem-fix
+++ a/mm/page_cgroup.c
@@ -146,6 +146,7 @@ static void *__init_refok alloc_page_cgr
 	return addr;
 }
 
+#ifdef CONFIG_MEMORY_HOTPLUG
 static void free_page_cgroup(void *addr)
 {
 	if (is_vmalloc_addr(addr)) {
@@ -159,6 +160,7 @@ static void free_page_cgroup(void *addr)
 		}
 	}
 }
+#endif
 
 static int __init_refok init_section_page_cgroup(unsigned long pfn)
 {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
memcg-remove-unused-page-flag-bitfield-defines.patch
memcg-remove-impossible-conditional-when-committing.patch
memcg-remove-null-check-from-lookup_page_cgroup-result.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch
memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch
memcg-change-page_cgroup_zoneinfo-signature.patch
memcg-fold-__mem_cgroup_move_account-into-caller.patch
memcg-condense-page_cgroup-to-page-lookup-points.patch
memcg-remove-direct-page_cgroup-to-page-pointer.patch
memcg-charged-pages-always-have-valid-per-memcg-zone-info.patch
memcg-remove-memcg-reclaim_param_lock.patch
memcg-keep-only-one-charge-cancelling-function.patch
memcg-convert-per-cpu-stock-from-bytes-to-page-granularity.patch
memcg-convert-uncharge-batching-from-bytes-to-page-granularity.patch
memcg-unify-charge-uncharge-quantities-to-units-of-pages.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-use-native-word-page-statistics-counters.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem.patch
memcg-fix-leak-on-wrong-lru-with-fuse.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix-fix.patch

