Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C2921CC51
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343166; cv=none; b=Y3aEOS1y9fGQZN6dyLlvintghApeH9c++lpmkA4XofBp7Z+UhB2viZH4G5wS5nhLergHS8NED1K5WDFQQrmvNkqa4Is5hOvu+aEwXeOSadsDLdLHGVkL4IWOwBbNuR6+vGvrOMREc1gcc58mH0MMePY05Il2zuwvlzIiBmA4VGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343166; c=relaxed/simple;
	bh=88OPeDeqfaK/weNMuisfzUpeAAV5bx1msJGXOmmm1bA=;
	h=Date:To:From:Subject:Message-Id; b=a19KP+sKbswgbErhfoZvZakJ49ziSN2+D6n7pRh9R1JQA+QmuUWBe4comhqgrfky2ZgHw5lvqyqaZ/77dErjS0j08qRJC7f79rorWruJOoh9wGsjIq/K31xH1PXfU/zj32ugFyREN6RhCPx1UdAyYvfcJT+zb0/V1sQciXFJyCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XTaFCxev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XTaFCxev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CF6C4AF09;
	Mon, 17 Nov 2025 01:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343166;
	bh=88OPeDeqfaK/weNMuisfzUpeAAV5bx1msJGXOmmm1bA=;
	h=Date:To:From:Subject:From;
	b=XTaFCxev8lfPLjmANUUF4WSMAntx2B5l2pHhYohzQTlgukPF0P8aGO/zlIEdjhjrR
	 WHtzLNYqRl6mngnqLesu2GYxkAxzTWEp9LeYEgIK0SzU1/QvylN1XcMfBOJKVItPNH
	 oYf0EKP9TccddFY/LrJy7byiwlhdWMMiLQHx0Bi0=
Date: Sun, 16 Nov 2025 17:32:45 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-guard-is_zero_pfn-calls-with-pte_present.patch removed from -mm tree
Message-Id: <20251117013246.69CF6C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: guard is_zero_pfn() calls with pte_present()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-guard-is_zero_pfn-calls-with-pte_present.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <lance.yang@linux.dev>
Subject: mm/khugepaged: guard is_zero_pfn() calls with pte_present()
Date: Mon, 20 Oct 2025 23:11:11 +0800

A non-present entry, like a swap PTE, contains completely different data
(swap type and offset).  pte_pfn() doesn't know this, so if we feed it a
non-present entry, it will spit out a junk PFN.

What if that junk PFN happens to match the zeropage's PFN by sheer chance?
While really unlikely, this would be really bad if it did.

So, let's fix this potential bug by ensuring all calls to is_zero_pfn() in
khugepaged.c are properly guarded by a pte_present() check.

Link: https://lkml.kernel.org/r/20251020151111.53561-1-lance.yang@linux.dev
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Nico Pache <npache@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-guard-is_zero_pfn-calls-with-pte_present
+++ a/mm/khugepaged.c
@@ -337,6 +337,13 @@ struct attribute_group khugepaged_attr_g
 };
 #endif /* CONFIG_SYSFS */
 
+static bool pte_none_or_zero(pte_t pte)
+{
+	if (pte_none(pte))
+		return true;
+	return pte_present(pte) && is_zero_pfn(pte_pfn(pte));
+}
+
 int hugepage_madvise(struct vm_area_struct *vma,
 		     vm_flags_t *vm_flags, int advice)
 {
@@ -518,6 +525,7 @@ static void release_pte_pages(pte_t *pte
 
 		if (pte_none(pteval))
 			continue;
+		VM_WARN_ON_ONCE(!pte_present(pteval));
 		pfn = pte_pfn(pteval);
 		if (is_zero_pfn(pfn))
 			continue;
@@ -548,8 +556,7 @@ static int __collapse_huge_page_isolate(
 	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, addr += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
-		if (pte_none(pteval) || (pte_present(pteval) &&
-				is_zero_pfn(pte_pfn(pteval)))) {
+		if (pte_none_or_zero(pteval)) {
 			++none_or_zero;
 			if (!userfaultfd_armed(vma) &&
 			    (!cc->is_khugepaged ||
@@ -690,17 +697,17 @@ static void __collapse_huge_page_copy_su
 	     address += nr_ptes * PAGE_SIZE) {
 		nr_ptes = 1;
 		pteval = ptep_get(_pte);
-		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
+		if (pte_none_or_zero(pteval)) {
 			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
-			if (is_zero_pfn(pte_pfn(pteval))) {
-				/*
-				 * ptl mostly unnecessary.
-				 */
-				spin_lock(ptl);
-				ptep_clear(vma->vm_mm, address, _pte);
-				spin_unlock(ptl);
-				ksm_might_unmap_zero_page(vma->vm_mm, pteval);
-			}
+			if (pte_none(pteval))
+				continue;
+			/*
+			 * ptl mostly unnecessary.
+			 */
+			spin_lock(ptl);
+			ptep_clear(vma->vm_mm, address, _pte);
+			spin_unlock(ptl);
+			ksm_might_unmap_zero_page(vma->vm_mm, pteval);
 		} else {
 			struct page *src_page = pte_page(pteval);
 
@@ -794,7 +801,7 @@ static int __collapse_huge_page_copy(pte
 		unsigned long src_addr = address + i * PAGE_SIZE;
 		struct page *src_page;
 
-		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
+		if (pte_none_or_zero(pteval)) {
 			clear_user_highpage(page, src_addr);
 			continue;
 		}
@@ -1301,7 +1308,7 @@ static int hpage_collapse_scan_pmd(struc
 				goto out_unmap;
 			}
 		}
-		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
+		if (pte_none_or_zero(pteval)) {
 			++none_or_zero;
 			if (!userfaultfd_armed(vma) &&
 			    (!cc->is_khugepaged ||
_

Patches currently in -mm which might be from lance.yang@linux.dev are


