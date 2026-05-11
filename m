Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6FC386557
	for <mm-commits@vger.kernel.org>; Mon, 11 May 2026 20:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778532965; cv=none; b=thAnOBVBMGB9ZB8m002m9667eze1fXcyW+34WIGL1kVnEYtbcuAAzdrHGtjpXj0mrnvOdPOM6HC1gcTscLMJuQ7miXJoT20DCIwqME9IRd4L19iJethhj5yHVzoU4SUQT1K+hH6KdstAjmHOuvWTRvHpA6Sg7GqM04tS2FzPWZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778532965; c=relaxed/simple;
	bh=WHxg+vROKDE4H+WBHMRNXIps/94qOVyVp3FSXg1ae1Y=;
	h=Date:To:From:Subject:Message-Id; b=nT1l31//B1eR8SnyVO4bUWbMBYhOGHwQ38XQEW/dV5p67HnTYzUoP4MuTn9c8q6gE13/XsbAPekGZ4p5/yhaWDN4YurgUSsLxPXtdxYp8+ii/6lcz6BJtRXNxdEVe45pbvH2jWmXGa+pVqgrkYwkZE9SvrZbccvJ7wF4mF9Wy9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1HhR+IkE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1HhR+IkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6D4C2BCB0;
	Mon, 11 May 2026 20:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778532965;
	bh=WHxg+vROKDE4H+WBHMRNXIps/94qOVyVp3FSXg1ae1Y=;
	h=Date:To:From:Subject:From;
	b=1HhR+IkE/yxVvl+B0lNuxVhx2YNlKummR01SgPLcJnw4H+6paw2K9Ncrb4OyboWBA
	 w4wzoaJhbcdUAD//F/4rKr1YmZaYnBTvpF+0z8Fl/dL6ClLiq+9M9RrZc0ta1XIMeW
	 NWXvxbwnhzCgjtkQTCc7GzSRKQPwxBw7zFnje0TM=
Date: Mon, 11 May 2026 13:56:05 -0700
To: mm-commits@vger.kernel.org,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-add-per-order-mthp-collapse-failure-statistics.patch removed from -mm tree
Message-Id: <20260511205605.8F6D4C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: add per-order mTHP collapse failure statistics
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-add-per-order-mthp-collapse-failure-statistics.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: mm/khugepaged: add per-order mTHP collapse failure statistics
Date: Sun, 19 Apr 2026 12:57:44 -0600

Add three new mTHP statistics to track collapse failures for different
orders when encountering swap PTEs, excessive none PTEs, and shared PTEs:

- collapse_exceed_swap_pte: Increment when mTHP collapse fails due to swap
	PTEs

- collapse_exceed_none_pte: Counts when mTHP collapse fails due to
  	exceeding the none PTE threshold for the given order

- collapse_exceed_shared_pte: Counts when mTHP collapse fails due to shared
  	PTEs

These statistics complement the existing THP_SCAN_EXCEED_* events by
providing per-order granularity for mTHP collapse attempts.  The stats are
exposed via sysfs under
`/sys/kernel/mm/transparent_hugepage/hugepages-*/stats/` for each
supported hugepage size.

As we currently dont support collapsing mTHPs that contain a swap or
shared entry, those statistics keep track of how often we are encountering
failed mTHP collapses due to these restrictions.

Now that we plan to support mTHP collapse for anon pages, lets also track
when this happens at the PMD level within the per-mTHP stats.

Link: https://lore.kernel.org/20260419185750.260784-8-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
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
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
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

 Documentation/admin-guide/mm/transhuge.rst |   24 +++++++++++++++++++
 include/linux/huge_mm.h                    |    3 ++
 mm/huge_memory.c                           |    7 +++++
 mm/khugepaged.c                            |   21 +++++++++++++++-
 4 files changed, 53 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-khugepaged-add-per-order-mthp-collapse-failure-statistics
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -714,6 +714,30 @@ nr_anon_partially_mapped
        an anonymous THP as "partially mapped" and count it here, even though it
        is not actually partially mapped anymore.
 
+collapse_exceed_none_pte
+       The number of collapse attempts that failed due to exceeding the
+       max_ptes_none threshold. For mTHP collapse, Currently only max_ptes_none
+       values of 0 and (HPAGE_PMD_NR - 1) are supported. Any other value will
+       emit a warning and no mTHP collapse will be attempted. khugepaged will
+       try to collapse to the largest enabled (m)THP size; if it fails, it will
+       try the next lower enabled mTHP size. This counter records the number of
+       times a collapse attempt was skipped for exceeding the max_ptes_none
+       threshold, and khugepaged will move on to the next available mTHP size.
+
+collapse_exceed_swap_pte
+       The number of anonymous mTHP PTE ranges which were unable to collapse due
+       to containing at least one swap PTE. Currently khugepaged does not
+       support collapsing mTHP regions that contain a swap PTE. This counter can
+       be used to monitor the number of khugepaged mTHP collapses that failed
+       due to the presence of a swap PTE.
+
+collapse_exceed_shared_pte
+       The number of anonymous mTHP PTE ranges which were unable to collapse due
+       to containing at least one shared PTE. Currently khugepaged does not
+       support collapsing mTHP PTE ranges that contain a shared PTE. This
+       counter can be used to monitor the number of khugepaged mTHP collapses
+       that failed due to the presence of a shared PTE.
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
@@ -717,6 +717,10 @@ DEFINE_MTHP_STAT_ATTR(split_failed, MTHP
 DEFINE_MTHP_STAT_ATTR(split_deferred, MTHP_STAT_SPLIT_DEFERRED);
 DEFINE_MTHP_STAT_ATTR(nr_anon, MTHP_STAT_NR_ANON);
 DEFINE_MTHP_STAT_ATTR(nr_anon_partially_mapped, MTHP_STAT_NR_ANON_PARTIALLY_MAPPED);
+DEFINE_MTHP_STAT_ATTR(collapse_exceed_swap_pte, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
+DEFINE_MTHP_STAT_ATTR(collapse_exceed_none_pte, MTHP_STAT_COLLAPSE_EXCEED_NONE);
+DEFINE_MTHP_STAT_ATTR(collapse_exceed_shared_pte, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
+
 
 static struct attribute *anon_stats_attrs[] = {
 	&anon_fault_alloc_attr.attr,
@@ -733,6 +737,9 @@ static struct attribute *anon_stats_attr
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
@@ -646,7 +646,9 @@ static enum scan_result __collapse_huge_
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
@@ -680,9 +682,17 @@ static enum scan_result __collapse_huge_
 
 		/* See collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
+			/*
+			 * TODO: Support shared pages without leading to further
+			 * mTHP collapses. Currently bringing in new pages via
+			 * shared may cause a future higher order collapse on a
+			 * rescan of the same range.
+			 */
 			if (++shared > max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
-				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
+				if (is_pmd_order(order))
+					count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
+				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
 				goto out;
 			}
 		}
@@ -1129,6 +1139,7 @@ static enum scan_result __collapse_huge_
 		 * range.
 		 */
 		if (!is_pmd_order(order)) {
+			count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
 			pte_unmap(pte);
 			mmap_read_unlock(mm);
 			result = SCAN_EXCEED_SWAP_PTE;
@@ -1412,6 +1423,8 @@ static enum scan_result collapse_scan_pm
 			if (++none_or_zero > max_ptes_none) {
 				result = SCAN_EXCEED_NONE_PTE;
 				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+				count_mthp_stat(HPAGE_PMD_ORDER,
+						MTHP_STAT_COLLAPSE_EXCEED_NONE);
 				goto out_unmap;
 			}
 			continue;
@@ -1420,6 +1433,8 @@ static enum scan_result collapse_scan_pm
 			if (++unmapped > max_ptes_swap) {
 				result = SCAN_EXCEED_SWAP_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
+				count_mthp_stat(HPAGE_PMD_ORDER,
+						MTHP_STAT_COLLAPSE_EXCEED_SWAP);
 				goto out_unmap;
 			}
 			/*
@@ -1477,6 +1492,8 @@ static enum scan_result collapse_scan_pm
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

mm-khugepaged-improve-tracepoints-for-mthp-orders.patch
mm-khugepaged-introduce-collapse_allowable_orders-helper-function.patch
mm-khugepaged-introduce-mthp-collapse-support.patch
mm-khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch
documentation-mm-update-the-admin-guide-for-mthp-collapse.patch

