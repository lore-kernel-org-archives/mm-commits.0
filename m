Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFBB3BB117
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068131; cv=none; b=rY5EB3gG6yTO8nCA1J7do39HjFRTZaoOZBOMqueWbuwXF00THd7rXK4vDsbji44lXcFvUV6qJx4tiqRk/n5Fodvcdd+dSx+0VgA4WMWjxZQtFvWKjUezXPHbMy7EGzm51Nl6yZ3nK9dxXO8+4tAb/WJ/7HDwBPvFbHu/UxixFpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068131; c=relaxed/simple;
	bh=IfnCKdDXrZR+8SQS1SuUbDu+M3tYR0/7WX9pIm7weTg=;
	h=Date:To:From:Subject:Message-Id; b=UpvI2b8sXdBTU11eauugyKf3d5ToNleTjJv6IsKPbuwu1OpSt4NxlWrgFKydPYCpjPlD4XOK1Rrhig/urFiKAqiEg2rkY6/8P8Vb8sIMpFWObcIKRPoXuzVPMm6lbghL4OTDbnrDSOmYyMqmXSbG3l1cYFdmyFUKQ0rcLOZU7cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WJlgh+tq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WJlgh+tq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DD61F00A3D;
	Fri,  7 Aug 2026 02:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068129;
	bh=5aAJ2Vfwgj89YxGBZWCsPDwM3vFxsGg+YcpmzkyXGIg=;
	h=Date:To:From:Subject;
	b=WJlgh+tqb2hizgZtl91B2ynJmnCk+OdkqsgA7W8gvnInEomvfGNaTqAxyxjmUhA2h
	 9s+LDseTRzsNYfrzl2JIqImrYW6srNU9aex19gvslgXZqZaMAjH7tNWe+sBu7t34jB
	 zC5wuaulgmPzFD5IQaDMlJrXTa9H4qe42PExv8p4=
Date: Thu, 06 Aug 2026 19:02:09 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xu.xin16@zte.com.cn,willy@infradead.org,wangkefeng.wang@huawei.com,svetly.todorov@memverge.com,sunnanyong@huawei.com,luizcap@redhat.com,linmiaohe@huawei.com,david@kernel.org,chengming.zhou@linux.dev,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-stable_page_flags-use-bit_ull-for-kpf-flags.patch removed from -mm tree
Message-Id: <20260807020209.A1DD61F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: stable_page_flags(): use BIT_ULL() for KPF flags
has been removed from the -mm tree.  Its filename was
     fs-stable_page_flags-use-bit_ull-for-kpf-flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: fs: stable_page_flags(): use BIT_ULL() for KPF flags
Date: Mon, 20 Jul 2026 11:30:19 +0800

Patch series "cleanup for stable_page_flags()", v2.

This series cleans up stable_page_flags(), see the details in the commit
messages.


This patch (of 3):

The stable_page_flags() function currently sets page flag bits using "1 <<
KPF_xxx" for various KPF_* definitions.  KPF_* may be larger than 32,
which will trigger -Wshift-count-overflow warning.  All KPF_* values
currently used in "1 << KPF_xxx" are smaller than 33, so no warning is
triggered with current code.

Replace all occurrences of "1 << KPF_*" with the BIT_ULL() macro to ensure
all shifts are performed on a 64-bit unsigned type.  This makes the code
robust, and safe for future extension.

No functional change is intended.

Link: https://lore.kernel.org/20260720033021.4091944-1-tujinjiang@huawei.com
Link: https://lore.kernel.org/20260720033021.4091944-2-tujinjiang@huawei.com
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Luiz Capitulino <luizcap@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Svetly Todorov <svetly.todorov@memverge.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

--- a/fs/proc/page.c~fs-stable_page_flags-use-bit_ull-for-kpf-flags
+++ a/fs/proc/page.c
@@ -157,7 +157,7 @@ u64 stable_page_flags(const struct page
 	 * it differentiates a memory hole from a page with no flags
 	 */
 	if (!page)
-		return 1 << KPF_NOPAGE;
+		return BIT_ULL(KPF_NOPAGE);
 
 	snapshot_page(&ps, page);
 	folio = &ps.folio_snapshot;
@@ -170,11 +170,11 @@ u64 stable_page_flags(const struct page
 	 * pseudo flags for the well known (anonymous) memory mapped pages
 	 */
 	if (folio_mapped(folio))
-		u |= 1 << KPF_MMAP;
+		u |= BIT_ULL(KPF_MMAP);
 	if (is_anon) {
-		u |= 1 << KPF_ANON;
+		u |= BIT_ULL(KPF_ANON);
 		if ((mapping & FOLIO_MAPPING_FLAGS) == FOLIO_MAPPING_KSM)
-			u |= 1 << KPF_KSM;
+			u |= BIT_ULL(KPF_KSM);
 	}
 
 	/*
@@ -184,35 +184,35 @@ u64 stable_page_flags(const struct page
 	if (ps.idx == 0)
 		u |= kpf_copy_bit(k, KPF_COMPOUND_HEAD, PG_head);
 	else
-		u |= 1 << KPF_COMPOUND_TAIL;
+		u |= BIT_ULL(KPF_COMPOUND_TAIL);
 	if (folio_test_hugetlb(folio))
-		u |= 1 << KPF_HUGE;
+		u |= BIT_ULL(KPF_HUGE);
 	else if (folio_test_large(folio) &&
 	         folio_test_large_rmappable(folio)) {
 		/* Note: we indicate any THPs here, not just PMD-sized ones */
-		u |= 1 << KPF_THP;
+		u |= BIT_ULL(KPF_THP);
 	} else if (is_huge_zero_pfn(ps.pfn)) {
-		u |= 1 << KPF_ZERO_PAGE;
-		u |= 1 << KPF_THP;
+		u |= BIT_ULL(KPF_ZERO_PAGE);
+		u |= BIT_ULL(KPF_THP);
 	} else if (is_zero_pfn(ps.pfn)) {
-		u |= 1 << KPF_ZERO_PAGE;
+		u |= BIT_ULL(KPF_ZERO_PAGE);
 	}
 
 	if (ps.flags & PAGE_SNAPSHOT_PG_BUDDY)
-		u |= 1 << KPF_BUDDY;
+		u |= BIT_ULL(KPF_BUDDY);
 
 	if (folio_test_offline(folio))
-		u |= 1 << KPF_OFFLINE;
+		u |= BIT_ULL(KPF_OFFLINE);
 	if (folio_test_pgtable(folio))
-		u |= 1 << KPF_PGTABLE;
+		u |= BIT_ULL(KPF_PGTABLE);
 	if (folio_test_slab(folio))
-		u |= 1 << KPF_SLAB;
+		u |= BIT_ULL(KPF_SLAB);
 
 #if defined(CONFIG_PAGE_IDLE_FLAG) && defined(CONFIG_64BIT)
 	u |= kpf_copy_bit(k, KPF_IDLE,          PG_idle);
 #else
 	if (ps.flags & PAGE_SNAPSHOT_PG_IDLE)
-		u |= 1 << KPF_IDLE;
+		u |= BIT_ULL(KPF_IDLE);
 #endif
 
 	u |= kpf_copy_bit(k, KPF_LOCKED,	PG_locked);
@@ -227,14 +227,14 @@ u64 stable_page_flags(const struct page
 
 #define SWAPCACHE ((1 << PG_swapbacked) | (1 << PG_swapcache))
 	if ((k & SWAPCACHE) == SWAPCACHE)
-		u |= 1 << KPF_SWAPCACHE;
+		u |= BIT_ULL(KPF_SWAPCACHE);
 	u |= kpf_copy_bit(k, KPF_SWAPBACKED,	PG_swapbacked);
 
 	u |= kpf_copy_bit(k, KPF_UNEVICTABLE,	PG_unevictable);
 	u |= kpf_copy_bit(k, KPF_MLOCKED,	PG_mlocked);
 
 #ifdef CONFIG_MEMORY_FAILURE
-	if (u & (1 << KPF_HUGE))
+	if (u & BIT_ULL(KPF_HUGE))
 		u |= kpf_copy_bit(k, KPF_HWPOISON,	PG_hwpoison);
 	else
 		u |= kpf_copy_bit(ps.page_snapshot.flags.f, KPF_HWPOISON, PG_hwpoison);
_

Patches currently in -mm which might be from tujinjiang@huawei.com are


