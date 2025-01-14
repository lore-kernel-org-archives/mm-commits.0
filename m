Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACC623D3E3
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837139; cv=none; b=bCgMW/KTSF5vLY62UQsKTVzigCL+xmDPS1zp7tjsixB04Qwsx856emVXGnJRerHrOl/Yg3VV5Yub8WPciCimHY117A6C+uy4EVskX2xF//bCd4voKNzUAHGSAi5lgtTk5r532ymhA0Xnf7+Ga/T0N5FgvWuHuo4U8N5G6rL/jHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837139; c=relaxed/simple;
	bh=BCj8R/Sb91X4blA8QkGv0UsqDigprrfeTbRv0lcTqYM=;
	h=Date:To:From:Subject:Message-Id; b=YMKXBkz1zDhVFgpBroZQSIcOM9lQL5YrgmPRVCQ6cvyVyQ5hPm7dDZAQ73q3+LN399rcG/mvqW6FZshoMdbDbgR8rxOuYiCLLocAM5R22Zn0jnuY4zr+rFpuQOmiEs2SRYHUxIzcvQG7cmjCQcleUrk3iOTOoA9zjvbXbkqXVtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jAaBQvXi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jAaBQvXi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00ABAC4CEDD;
	Tue, 14 Jan 2025 06:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837139;
	bh=BCj8R/Sb91X4blA8QkGv0UsqDigprrfeTbRv0lcTqYM=;
	h=Date:To:From:Subject:From;
	b=jAaBQvXio7Oj1U5ujkuirOMJVREYmGm5FtA/ZG90qCr7tJdabdoDqT4SUB1P6+4qI
	 59J1ZsfmaJAZ61H3gH/JNsJv5RxlHoGq8eMCAoakYwXv1LCEAPWZkv5CNf41oe/Zbh
	 2s1Tba2BQnCthSFQ14lhdqMq80XyyrQaHT/gctbw=
Date: Mon, 13 Jan 2025 22:45:38 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,mingo@elte.hu,luto@kernel.org,linus.walleij@linaro.org,dave.hansen@linux.intel.com,catalin.marinas@arm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-common-part-of-pagetable__ctor-to-helper.patch removed from -mm tree
Message-Id: <20250114064539.00ABAC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: move common part of pagetable_*_ctor to helper
has been removed from the -mm tree.  Its filename was
     mm-move-common-part-of-pagetable__ctor-to-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: mm: move common part of pagetable_*_ctor to helper
Date: Fri, 3 Jan 2025 18:44:10 +0000

Patch series "Account page tables at all levels".

This series should be considered in conjunction with Qi's series [1].
Together, they ensure that page table ctor/dtor are called at all levels
(PTE to PGD) and all architectures, where page tables are regular pages.
Besides the improvement in accounting and general cleanup, this also
create a single place where construction/destruction hooks can be called
for all page tables, namely the now-generic pagetable_dtor() introduced
by Qi, and __pagetable_ctor() introduced in this series.

[1] https://lore.kernel.org/linux-mm/cover.1735549103.git.zhengqi.arch@bytedance.com/


This patch (of 6):

pagetable_*_ctor all have the same basic implementation.  Move the common
part to a helper to reduce duplication.

Link: https://lkml.kernel.org/r/20250103184415.2744423-1-kevin.brodsky@arm.com
Link: https://lkml.kernel.org/r/20250103184415.2744423-2-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

--- a/include/linux/mm.h~mm-move-common-part-of-pagetable__ctor-to-helper
+++ a/include/linux/mm.h
@@ -2992,6 +2992,14 @@ static inline bool ptlock_init(struct pt
 static inline void ptlock_free(struct ptdesc *ptdesc) {}
 #endif /* defined(CONFIG_SPLIT_PTE_PTLOCKS) */
 
+static inline void __pagetable_ctor(struct ptdesc *ptdesc)
+{
+	struct folio *folio = ptdesc_folio(ptdesc);
+
+	__folio_set_pgtable(folio);
+	lruvec_stat_add_folio(folio, NR_PAGETABLE);
+}
+
 static inline void pagetable_dtor(struct ptdesc *ptdesc)
 {
 	struct folio *folio = ptdesc_folio(ptdesc);
@@ -3009,12 +3017,9 @@ static inline void pagetable_dtor_free(s
 
 static inline bool pagetable_pte_ctor(struct ptdesc *ptdesc)
 {
-	struct folio *folio = ptdesc_folio(ptdesc);
-
 	if (!ptlock_init(ptdesc))
 		return false;
-	__folio_set_pgtable(folio);
-	lruvec_stat_add_folio(folio, NR_PAGETABLE);
+	__pagetable_ctor(ptdesc);
 	return true;
 }
 
@@ -3118,13 +3123,10 @@ static inline spinlock_t *pmd_lock(struc
 
 static inline bool pagetable_pmd_ctor(struct ptdesc *ptdesc)
 {
-	struct folio *folio = ptdesc_folio(ptdesc);
-
 	if (!pmd_ptlock_init(ptdesc))
 		return false;
-	__folio_set_pgtable(folio);
 	ptdesc_pmd_pts_init(ptdesc);
-	lruvec_stat_add_folio(folio, NR_PAGETABLE);
+	__pagetable_ctor(ptdesc);
 	return true;
 }
 
@@ -3149,18 +3151,12 @@ static inline spinlock_t *pud_lock(struc
 
 static inline void pagetable_pud_ctor(struct ptdesc *ptdesc)
 {
-	struct folio *folio = ptdesc_folio(ptdesc);
-
-	__folio_set_pgtable(folio);
-	lruvec_stat_add_folio(folio, NR_PAGETABLE);
+	__pagetable_ctor(ptdesc);
 }
 
 static inline void pagetable_p4d_ctor(struct ptdesc *ptdesc)
 {
-	struct folio *folio = ptdesc_folio(ptdesc);
-
-	__folio_set_pgtable(folio);
-	lruvec_stat_add_folio(folio, NR_PAGETABLE);
+	__pagetable_ctor(ptdesc);
 }
 
 extern void __init pagecache_init(void);
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are


