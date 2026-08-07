Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4163BFACB;
	Fri,  7 Aug 2026 02:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068081; cv=none; b=U974Xb0FMwciLoxAst9N4LwO9IxLkyJVgSbIhGpTBcKoeiWezpot2mZHCktKivldNjtv/n9tZrIgg+/Df6hof2nYW7rf9xCBGNBqDmgeIeEe0spBspqn6yn3ILjPz2hJj5cxfNPmiX8IkVaraxBbck98DRBs75GqMEX1/bDgY34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068081; c=relaxed/simple;
	bh=8SGaQ9R1JRmH8E/54eG1VJCkfoKiWUrkw0wLhw6NniU=;
	h=Date:To:From:Subject:Message-Id; b=npQY5KH5elfPYSVNZ8+IUmyRXJxDtmOdKsuqg3+NLABBod4I/vVVTyOjJ982QUXWVH3n9/TkpZexTgds51aYjSdkI4uo0UhkC7XfaAzwH6AjeVWV0OjyvWC4a9h0zmTqusyNpuHJCTBTkMxnF9RpxAaVuicoGATiGRAgWsfGOjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LjVqcYbW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LjVqcYbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FDF1F00A3E;
	Fri,  7 Aug 2026 02:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068076;
	bh=p+txer1aFKD45wHBDrJ5b4uKwfNKx0Ny7o+8h0bBa4w=;
	h=Date:To:From:Subject;
	b=LjVqcYbWDFwHcd4+y0hcr32hI68PiGfPbX2IgDZGMte1rZfhpP1IyJFHnHqI49IwY
	 BvBuZAWu/IKeJcgHCtcMpQXzj8O9GK3ltQdb0YRydyuV4DsAJQJiR2ehCYfgBHpX72
	 5Ycf6EtdlOGJlyJ9dnBkZVd1mXoWNosZFn6N8uPA=
Date: Thu, 06 Aug 2026 19:01:16 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-drop-last-same-folio-access-check-optimization.patch removed from -mm tree
Message-Id: <20260807020116.C2FDF1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/vaddr: drop last same folio access check optimization
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-drop-last-same-folio-access-check-optimization.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/vaddr: drop last same folio access check optimization
Date: Tue, 14 Jul 2026 20:09:58 -0700

The optimization can race when multiple kdamonds are running.  Meanwhile,
the impact of the optimization is quite doubtful.  Just remove it.

The user impact of the issue should be quite trivial.  After all, the race
can happen only when the user intentionally setup DAMON in the way.  Even
if it happens, it would be rare and only degrade the best-effort
monitoring results.  No critical consequences like kernel panic or memory
corruption happen.

The race possibility was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260715031002.108504-4-sj@kernel.org
Link: https://lore.kernel.org/20260621204050.10993-1-sj@kernel.org [1]
Fixes: 3f49584b262c ("mm/damon: implement primitives for the virtual memory address spaces")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |   33 ++++++---------------------------
 1 file changed, 6 insertions(+), 27 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-drop-last-same-folio-access-check-optimization
+++ a/mm/damon/vaddr.c
@@ -383,8 +383,6 @@ static void damon_va_prepare_access_chec
 }
 
 struct damon_young_walk_private {
-	/* size of the folio for the access checked virtual memory address */
-	unsigned long *folio_sz;
 	bool young;
 };
 
@@ -411,7 +409,6 @@ static int damon_young_pmd_entry(pmd_t *
 					mmu_notifier_test_young(walk->mm,
 						addr))
 			priv->young = true;
-		*priv->folio_sz = HPAGE_PMD_SIZE;
 huge_out:
 		spin_unlock(ptl);
 		return 0;
@@ -430,7 +427,6 @@ huge_out:
 	if (pte_young(ptent) || !folio_test_idle(folio) ||
 			mmu_notifier_test_young(walk->mm, addr))
 		priv->young = true;
-	*priv->folio_sz = folio_size(folio);
 out:
 	pte_unmap_unlock(pte, ptl);
 	return 0;
@@ -458,7 +454,6 @@ static int damon_young_hugetlb_entry(pte
 	if (pte_young(entry) || !folio_test_idle(folio) ||
 	    mmu_notifier_test_young(walk->mm, addr))
 		priv->young = true;
-	*priv->folio_sz = huge_page_size(h);
 
 	folio_put(folio);
 
@@ -470,11 +465,9 @@ out:
 #define damon_young_hugetlb_entry NULL
 #endif /* CONFIG_HUGETLB_PAGE */
 
-static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
-		unsigned long *folio_sz)
+static bool damon_va_young(struct mm_struct *mm, unsigned long addr)
 {
 	struct damon_young_walk_private arg = {
-		.folio_sz = folio_sz,
 		.young = false,
 	};
 
@@ -494,28 +487,17 @@ static bool damon_va_young(struct mm_str
  * r	the region to be checked
  */
 static void __damon_va_check_access(struct mm_struct *mm,
-				struct damon_region *r, bool same_target)
+				struct damon_region *r)
 {
-	static unsigned long last_addr;
-	static unsigned long last_folio_sz = PAGE_SIZE;
-	static bool last_accessed;
+	bool accessed;
 
 	if (!mm) {
 		damon_update_region_access_rate(r, false);
 		return;
 	}
 
-	/* If the region is in the last checked page, reuse the result */
-	if (same_target && (ALIGN_DOWN(last_addr, last_folio_sz) ==
-				ALIGN_DOWN(r->sampling_addr, last_folio_sz))) {
-		damon_update_region_access_rate(r, last_accessed);
-		return;
-	}
-
-	last_accessed = damon_va_young(mm, r->sampling_addr, &last_folio_sz);
-	damon_update_region_access_rate(r, last_accessed);
-
-	last_addr = r->sampling_addr;
+	accessed = damon_va_young(mm, r->sampling_addr);
+	damon_update_region_access_rate(r, accessed);
 }
 
 static unsigned int damon_va_check_accesses(struct damon_ctx *ctx)
@@ -524,15 +506,12 @@ static unsigned int damon_va_check_acces
 	struct mm_struct *mm;
 	struct damon_region *r;
 	unsigned int max_nr_accesses = 0;
-	bool same_target;
 
 	damon_for_each_target(t, ctx) {
 		mm = damon_get_mm(t);
-		same_target = false;
 		damon_for_each_region(r, t) {
-			__damon_va_check_access(mm, r, same_target);
+			__damon_va_check_access(mm, r);
 			max_nr_accesses = max(r->nr_accesses, max_nr_accesses);
-			same_target = true;
 		}
 		if (mm)
 			mmput(mm);
_

Patches currently in -mm which might be from sj@kernel.org are


