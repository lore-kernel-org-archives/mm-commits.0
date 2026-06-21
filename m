Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F4129898F
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782066761; cv=none; b=P3iygFxGwXbNBdIlIr2M3OKc6Rg7pCE7B0VW1DfeDYCHcoOdDyWzTKk4SsOfRe37/vbWj6rmfXsq0gVhGBwuLKhpXHp3vdNi4+6Yxw62uOjH/8vq4jqT07qRcHCg5Hzq00CbB9FPdkyidrsuKLfSMnHgvqWEQEwH/h1iQaeGF1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782066761; c=relaxed/simple;
	bh=hsizKaNtdhkPmH3AAfcsMmh2SxeLrGPJL2IBS9lv+2c=;
	h=Date:To:From:Subject:Message-Id; b=c/QBAyhuWBLbQYmnDnjm193GUInM/pMRDtQY51iIVDGHpjcJuY0G63gfgOBK1uWmOkEPJKxxgE50JFs/hTPTwDOR5T+VspTIwFerkzPDxl9qLr6TTqWWyS2CQjdRlR58q2EF8ZT9HLQLob6CX0HOqXYJQnz1xlfRv7X5Nak0MD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=fail (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o5N3sgP1 reason="signature verification failed"; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o5N3sgP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55001F000E9;
	Sun, 21 Jun 2026 18:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782066759;
	bh=0ui+PFYePLln7g/u8b7fSw0efuNXF3nl5M73S/sz/TY=;
	h=Date:To:From:Subject;
	b=o5N3sgP1y8GleFj7OKSiuClB+V7eFr2CuJeNT2k2dzCHIyNtdunXDjYBcbz2kG972
	 0RFlo+c2Zhj17+LhQizP+bBjLQ85KI24Tn0Ivgzph0bZwwI4pH3ZTavLC9ZGA0OtY0
	 8ZV8L+XK62oaUsKGPbsdPFEu/0R06VOnnv+2Cz7I=
Date: Sun, 21 Jun 2026 11:32:39 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,ying.huang@linux.alibaba.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,vbabka@suse.cz,usama.arif@linux.dev,usamaarif642@gmail.com,tiwai@suse.de,thomas.hellstrom@linux.intel.com,surenb@google.com,sunnanyong@huawei.com,shivankg@amd.com,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,rientjes@google.com,richard.weiyang@gmail.com,rdunlap@infradead.org,raquini@redhat.com,rakie.kim@sk.com,pfalcato@suse.de,peterx@redhat.com,mhocko@suse.com,mhiramat@kernel.org,matthew.brost@intel.com,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,joshua.hahnjy@gmail.com,jannh@google.com,jack@suse.cz,jackmanb@google.com,hughd@google.com,hannes@cmpxchg.org,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,catalin.marinas@arm.com,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,bagasdotme@gmail.co
 m,apopple@nvidia.com,anshuman.khandual@arm.com,aarcange@redhat.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-add-per-order-mthp-collapse-failure-statistics.patch removed from -mm tree
Message-Id: <20260621183239.A55001F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: add per-order mTHP collapse failure statistics
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-add-per-order-mthp-collapse-failure-statistics.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: mm/khugepaged: add per-order mTHP collapse failure statistics
Date: Fri, 5 Jun 2026 10:14:15 -0600

Add three new mTHP statistics to track collapse failures for different
orders when encountering swap PTEs, excessive none PTEs, and shared PTEs:

- collapse_exceed_swap_pte: Increment when mTHP collapse fails due to
	encountering a swap PTE.

- collapse_exceed_none_pte: Counts when mTHP collapse fails due to
  	exceeding the none PTE threshold for the given order

- collapse_exceed_shared_pte: Counts when mTHP collapse fails due to
	encountering a shared PTE.

These statistics complement the existing THP_SCAN_EXCEED_* events by
providing per-order granularity for mTHP collapse attempts.  The stats are
exposed via sysfs under
`/sys/kernel/mm/transparent_hugepage/hugepages-*/stats/` for each
supported hugepage size.

As we currently do not support collapsing mTHPs that contain a swap or
shared entry, those statistics keep track of how often we are encountering
failed mTHP collapses due to these restrictions.

We will add support for mTHP collapse for anonymous pages next; lets also
track when this happens at the PMD level within the per-mTHP stats.

Link: https://lore.kernel.org/20260605161422.213817-9-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Takashi Iwai (SUSE) <tiwai@suse.de>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |   14 ++++++++++++++
 include/linux/huge_mm.h                    |    3 +++
 mm/huge_memory.c                           |    7 +++++++
 mm/khugepaged.c                            |   15 +++++++++++++--
 4 files changed, 37 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-khugepaged-add-per-order-mthp-collapse-failure-statistics
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -714,6 +714,20 @@ nr_anon_partially_mapped
        an anonymous THP as "partially mapped" and count it here, even though it
        is not actually partially mapped anymore.
 
+collapse_exceed_none_pte
+       The number of collapse attempts that failed due to exceeding the
+       max_ptes_none threshold.
+
+collapse_exceed_swap_pte
+       The number of collapse attempts that failed due to exceeding the
+       max_ptes_swap threshold. For non-PMD orders this occurs if a mTHP range
+       contains at least one swap PTE.
+
+collapse_exceed_shared_pte
+       The number of collapse attempts that failed due to exceeding the
+       max_ptes_shared threshold. For non-PMD orders this occurs if a mTHP range
+       contains at least one shared PTE.
+
 As the system ages, allocating huge pages may be expensive as the
 system uses memory compaction to copy data around memory to free a
 huge page for use. There are some counters in ``/proc/vmstat`` to help
--- a/include/linux/huge_mm.h~mm-khugepaged-add-per-order-mthp-collapse-failure-statistics
+++ a/include/linux/huge_mm.h
@@ -144,6 +144,9 @@ enum mthp_stat_item {
 	MTHP_STAT_SPLIT_DEFERRED,
 	MTHP_STAT_NR_ANON,
 	MTHP_STAT_NR_ANON_PARTIALLY_MAPPED,
+	MTHP_STAT_COLLAPSE_EXCEED_SWAP,
+	MTHP_STAT_COLLAPSE_EXCEED_NONE,
+	MTHP_STAT_COLLAPSE_EXCEED_SHARED,
 	__MTHP_STAT_COUNT
 };
 
--- a/mm/huge_memory.c~mm-khugepaged-add-per-order-mthp-collapse-failure-statistics
+++ a/mm/huge_memory.c
@@ -720,6 +720,10 @@ DEFINE_MTHP_STAT_ATTR(split_failed, MTHP
 DEFINE_MTHP_STAT_ATTR(split_deferred, MTHP_STAT_SPLIT_DEFERRED);
 DEFINE_MTHP_STAT_ATTR(nr_anon, MTHP_STAT_NR_ANON);
 DEFINE_MTHP_STAT_ATTR(nr_anon_partially_mapped, MTHP_STAT_NR_ANON_PARTIALLY_MAPPED);
+DEFINE_MTHP_STAT_ATTR(collapse_exceed_swap_pte, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
+DEFINE_MTHP_STAT_ATTR(collapse_exceed_none_pte, MTHP_STAT_COLLAPSE_EXCEED_NONE);
+DEFINE_MTHP_STAT_ATTR(collapse_exceed_shared_pte, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
+
 
 static struct attribute *anon_stats_attrs[] = {
 	&anon_fault_alloc_attr.attr,
@@ -736,6 +740,9 @@ static struct attribute *anon_stats_attr
 	&split_deferred_attr.attr,
 	&nr_anon_attr.attr,
 	&nr_anon_partially_mapped_attr.attr,
+	&collapse_exceed_swap_pte_attr.attr,
+	&collapse_exceed_none_pte_attr.attr,
+	&collapse_exceed_shared_pte_attr.attr,
 	NULL,
 };
 
--- a/mm/khugepaged.c~mm-khugepaged-add-per-order-mthp-collapse-failure-statistics
+++ a/mm/khugepaged.c
@@ -651,7 +651,9 @@ static enum scan_result __collapse_huge_
 		if (pte_none_or_zero(pteval)) {
 			if (++none_or_zero > max_ptes_none) {
 				result = SCAN_EXCEED_NONE_PTE;
-				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+				if (is_pmd_order(order))
+					count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_NONE);
 				goto out;
 			}
 			continue;
@@ -693,7 +695,9 @@ static enum scan_result __collapse_huge_
 			 */
 			if (++shared > max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
-				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
+				if (is_pmd_order(order))
+					count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
+				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
 				goto out;
 			}
 		}
@@ -1152,6 +1156,7 @@ static enum scan_result __collapse_huge_
 		 * range.
 		 */
 		if (!is_pmd_order(order)) {
+			count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
 			pte_unmap(pte);
 			mmap_read_unlock(mm);
 			result = SCAN_EXCEED_SWAP_PTE;
@@ -1464,6 +1469,8 @@ static enum scan_result collapse_scan_pm
 			if (++none_or_zero > max_ptes_none) {
 				result = SCAN_EXCEED_NONE_PTE;
 				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+				count_mthp_stat(HPAGE_PMD_ORDER,
+						MTHP_STAT_COLLAPSE_EXCEED_NONE);
 				goto out_unmap;
 			}
 			continue;
@@ -1472,6 +1479,8 @@ static enum scan_result collapse_scan_pm
 			if (++unmapped > max_ptes_swap) {
 				result = SCAN_EXCEED_SWAP_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
+				count_mthp_stat(HPAGE_PMD_ORDER,
+						MTHP_STAT_COLLAPSE_EXCEED_SWAP);
 				goto out_unmap;
 			}
 			/*
@@ -1529,6 +1538,8 @@ static enum scan_result collapse_scan_pm
 			if (++shared > max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
+				count_mthp_stat(HPAGE_PMD_ORDER,
+						MTHP_STAT_COLLAPSE_EXCEED_SHARED);
 				goto out_unmap;
 			}
 		}
_

Patches currently in -mm which might be from npache@redhat.com are


