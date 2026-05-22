Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421A435AC2F
	for <mm-commits@vger.kernel.org>; Fri, 22 May 2026 20:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779482890; cv=none; b=sVFSMz47pvFlOgJurvsXmpdCd2PObBKEdQ2nm3dOfiYWwZByPkx5u+pqJfd4i5668y17rEcgBa3X+1ptY2co+HtHcIU4YRVrMUWjbcO7ZCX5AVLxlN3N9AVIfGz440gYIoV2VYQbpX7xMMNowmRLBdMrGgsMhsDLDhvl1Qt2q88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779482890; c=relaxed/simple;
	bh=JKsPk+IQ+IakDZPScADGinm44T3vEa3GLnG9qL9v7H8=;
	h=Date:To:From:Subject:Message-Id; b=l+E7x0FwEC1cN3iU6WJequaURJ/jGfkk/g2D+5LUrrLmhDjT+8o3sro12o7Sk4igZXoub48cn/0qB1swFIdOKR3v/ryfeLSrBrhlJhgOoYVjImINTo3IPwKhAXaOH7clPqj/646A95C7WNxWuVxLU1oLBwLmB4k6FtOrvkva3A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=krUzLs2M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="krUzLs2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093201F000E9;
	Fri, 22 May 2026 20:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779482888;
	bh=WAqu9M99WgO6fjIkRREeSPk9cel7Jq5KGFDnItphSFo=;
	h=Date:To:From:Subject;
	b=krUzLs2MTkmIwcufq2Lr+7XAiCyXGc7oVJrsOFj6ANsxr5LGHnTpaVPqLMqZK5GxG
	 N3czHKea7+jAyv/KI24lNT2b1fjPeNKDZElYOFf6YWSbOwU9MqxBO6qUJjt32FFgR0
	 ylwoUm1ssAEyGptAiqLwUFOxZ1nGP0qeSJY6lQ+k=
Date: Fri, 22 May 2026 13:48:07 -0700
To: mm-commits@vger.kernel.org,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-improve-tracepoints-for-mthp-orders.patch added to mm-unstable branch
Message-Id: <20260522204808.093201F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: improve tracepoints for mTHP orders
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-improve-tracepoints-for-mthp-orders.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-improve-tracepoints-for-mthp-orders.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: mm/khugepaged: improve tracepoints for mTHP orders
Date: Fri, 22 May 2026 09:00:04 -0600

Add the order to the mm_collapse_huge_page<_swapin,_isolate> tracepoints
to give better insight into what order is being operated at for.

Link: https://lore.kernel.org/20260522150009.121603-10-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
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
Cc: Lance Yang <lance.yang@linux.dev>
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

 include/trace/events/huge_memory.h |   34 +++++++++++++++++----------
 mm/khugepaged.c                    |    9 +++----
 2 files changed, 27 insertions(+), 16 deletions(-)

--- a/include/trace/events/huge_memory.h~mm-khugepaged-improve-tracepoints-for-mthp-orders
+++ a/include/trace/events/huge_memory.h
@@ -89,40 +89,44 @@ TRACE_EVENT(mm_khugepaged_scan_pmd,
 
 TRACE_EVENT(mm_collapse_huge_page,
 
-	TP_PROTO(struct mm_struct *mm, int isolated, int status),
+	TP_PROTO(struct mm_struct *mm, int isolated, int status, unsigned int order),
 
-	TP_ARGS(mm, isolated, status),
+	TP_ARGS(mm, isolated, status, order),
 
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
 		__field(int, isolated)
 		__field(int, status)
+		__field(unsigned int, order)
 	),
 
 	TP_fast_assign(
 		__entry->mm = mm;
 		__entry->isolated = isolated;
 		__entry->status = status;
+		__entry->order = order;
 	),
 
-	TP_printk("mm=%p, isolated=%d, status=%s",
+	TP_printk("mm=%p, isolated=%d, status=%s, order=%u",
 		__entry->mm,
 		__entry->isolated,
-		__print_symbolic(__entry->status, SCAN_STATUS))
+		__print_symbolic(__entry->status, SCAN_STATUS),
+		__entry->order)
 );
 
 TRACE_EVENT(mm_collapse_huge_page_isolate,
 
 	TP_PROTO(struct folio *folio, int none_or_zero,
-		 int referenced, int status),
+		 int referenced, int status, unsigned int order),
 
-	TP_ARGS(folio, none_or_zero, referenced, status),
+	TP_ARGS(folio, none_or_zero, referenced, status, order),
 
 	TP_STRUCT__entry(
 		__field(unsigned long, pfn)
 		__field(int, none_or_zero)
 		__field(int, referenced)
 		__field(int, status)
+		__field(unsigned int, order)
 	),
 
 	TP_fast_assign(
@@ -130,26 +134,30 @@ TRACE_EVENT(mm_collapse_huge_page_isolat
 		__entry->none_or_zero = none_or_zero;
 		__entry->referenced = referenced;
 		__entry->status = status;
+		__entry->order = order;
 	),
 
-	TP_printk("scan_pfn=0x%lx, none_or_zero=%d, referenced=%d, status=%s",
+	TP_printk("scan_pfn=0x%lx, none_or_zero=%d, referenced=%d, status=%s, order=%u",
 		__entry->pfn,
 		__entry->none_or_zero,
 		__entry->referenced,
-		__print_symbolic(__entry->status, SCAN_STATUS))
+		__print_symbolic(__entry->status, SCAN_STATUS),
+		__entry->order)
 );
 
 TRACE_EVENT(mm_collapse_huge_page_swapin,
 
-	TP_PROTO(struct mm_struct *mm, int swapped_in, int referenced, int ret),
+	TP_PROTO(struct mm_struct *mm, int swapped_in, int referenced, int ret,
+		 unsigned int order),
 
-	TP_ARGS(mm, swapped_in, referenced, ret),
+	TP_ARGS(mm, swapped_in, referenced, ret, order),
 
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
 		__field(int, swapped_in)
 		__field(int, referenced)
 		__field(int, ret)
+		__field(unsigned int, order)
 	),
 
 	TP_fast_assign(
@@ -157,13 +165,15 @@ TRACE_EVENT(mm_collapse_huge_page_swapin
 		__entry->swapped_in = swapped_in;
 		__entry->referenced = referenced;
 		__entry->ret = ret;
+		__entry->order = order;
 	),
 
-	TP_printk("mm=%p, swapped_in=%d, referenced=%d, ret=%d",
+	TP_printk("mm=%p, swapped_in=%d, referenced=%d, ret=%d, order=%u",
 		__entry->mm,
 		__entry->swapped_in,
 		__entry->referenced,
-		__entry->ret)
+		__entry->ret,
+		__entry->order)
 );
 
 TRACE_EVENT(mm_khugepaged_scan_file,
--- a/mm/khugepaged.c~mm-khugepaged-improve-tracepoints-for-mthp-orders
+++ a/mm/khugepaged.c
@@ -783,13 +783,13 @@ next:
 	} else {
 		result = SCAN_SUCCEED;
 		trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
-						    referenced, result);
+						    referenced, result, order);
 		return result;
 	}
 out:
 	release_pte_pages(pte, _pte, compound_pagelist);
 	trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
-					    referenced, result);
+					    referenced, result, order);
 	return result;
 }
 
@@ -1189,7 +1189,8 @@ static enum scan_result __collapse_huge_
 
 	result = SCAN_SUCCEED;
 out:
-	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result);
+	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result,
+					   order);
 	return result;
 }
 
@@ -1397,7 +1398,7 @@ out_up_write:
 out_nolock:
 	if (folio)
 		folio_put(folio);
-	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result);
+	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result, order);
 	return result;
 }
 
_

Patches currently in -mm which might be from npache@redhat.com are

mm-khugepaged-generalize-hugepage_vma_revalidate-for-mthp-support.patch
mm-khugepaged-rework-max_ptes_-handling-with-helper-functions.patch
mm-khugepaged-generalize-__collapse_huge_page_-for-mthp-support.patch
mm-khugepaged-require-collapse_huge_page-to-enter-exit-with-the-lock-dropped.patch
mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse.patch
mm-khugepaged-skip-collapsing-mthp-to-smaller-orders.patch
mm-khugepaged-add-per-order-mthp-collapse-failure-statistics.patch
mm-khugepaged-improve-tracepoints-for-mthp-orders.patch
mm-khugepaged-introduce-collapse_allowable_orders-helper-function.patch
mm-khugepaged-introduce-mthp-collapse-support.patch
mm-khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch
documentation-mm-update-the-admin-guide-for-mthp-collapse.patch

