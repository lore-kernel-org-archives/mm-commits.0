Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18D71E376C
	for <mm-commits@vger.kernel.org>; Sat,  6 Jun 2026 00:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780705091; cv=none; b=PAuGeWwskN9Ka2gV3aRlwAMN9Ap9HC3AhsoFVfVB7cyQAoiZuSkyKmCZ7CQnPgYLlO7F8e5eYH5TjJjcyMp1VGNKKd5IHM1NkY6IXl6PZ9iqZTorCy/RQI3H3FrMlhgFm9un1NQhHSY6833aT5EgxdbuLWf1uNrriLtt9lWGO54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780705091; c=relaxed/simple;
	bh=PF+cjhHGiDx7PlMB9AQdtJJqe2PkquX2m/ZNGwudEMs=;
	h=Date:To:From:Subject:Message-Id; b=NLThJnuCQrVDHInjtU3hnc6daI31L3l11Fj+GUF8pTQJzNdqovM2BmYOFcNA/h4kPdg06DQIPQudsmbIoGoj1Rev2X37CAjwAYNwDUKfzD1d+l3HD9i3T1UyPQNr4SQFsggiYHT/V2jqwu6KLCvk/33IlF6y9WZD5jTYtf5B+OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=McpeE5tH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="McpeE5tH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F681F00893;
	Sat,  6 Jun 2026 00:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780705089;
	bh=h8xFGHviG9+lUAzEmid2zhf3AKjoBMx2yOMue08XYjw=;
	h=Date:To:From:Subject;
	b=McpeE5tH0oaOzQF/wOqwYjtAaQodfFyLfI+a9T6OWNtHIwCDGoIPpJMbpvIHrb51/
	 uFmOffqMg3p0tBnSS0lCigBVyxzGhVi/h+dW12swZZwOES1nnj0O8PrAhrUHm+EZJp
	 yNHQWvQqeOb/FrT4uany/zYvrhI2OP6kmqJ+JPS8=
Date: Fri, 05 Jun 2026 17:18:09 -0700
To: mm-commits@vger.kernel.org,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-improve-tracepoints-for-mthp-orders.patch removed from -mm tree
Message-Id: <20260606001809.95F681F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: improve tracepoints for mTHP orders
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-improve-tracepoints-for-mthp-orders.patch

This patch was dropped because an updated version will be issued

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
@@ -785,13 +785,13 @@ next:
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
 
@@ -1191,7 +1191,8 @@ static enum scan_result __collapse_huge_
 
 	result = SCAN_SUCCEED;
 out:
-	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result);
+	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result,
+					   order);
 	return result;
 }
 
@@ -1411,7 +1412,7 @@ out_up_write:
 out_nolock:
 	if (folio)
 		folio_put(folio);
-	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result);
+	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result, order);
 	return result;
 }
 
_

Patches currently in -mm which might be from npache@redhat.com are

mm-khugepaged-introduce-collapse_allowable_orders-helper-function.patch
mm-khugepaged-introduce-mthp-collapse-support.patch
mm-khugepaged-introduce-mthp-collapse-support-fix.patch
mm-khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch
documentation-mm-update-the-admin-guide-for-mthp-collapse.patch

