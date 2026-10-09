Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7663F787E
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525384; cv=none; b=Fvbn1A+zVIezmKhaspnC4qKM1zhmOliX+sNATb6hRn6/nr6MCRUovYz6dwpaclfEN7ebvbDoFpb1SjPGuKnhKr5R1vUf3hfPkVKRIJclOof+owDYP8/JLfrKzjVcEDQx3odotjkUt6CxASZ6LhrjeNJI87BHGM+t6cSBhEV6Qec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525384; c=relaxed/simple;
	bh=p4TV7gG6vWvgOUFFS/znzAO0TXdvVpnR3sE5MLNhRLA=;
	h=Date:To:From:Subject:Message-Id; b=QuewwqCLegz80bTIoebm0g3j8joMoXaB+RsyhWaX5ognLmXJV00J8IKIuSNNokwXOLQpPjGemIBtXH0uX0m4BCpUt7c/NJ1Mk4PArGor8DGU1V1D9dCl1U5tUF3aOCyvtoe9U4dRPdRDjrRr+CJuJseSh16qUPxXLFhVHbcf8I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kSuMeDgG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kSuMeDgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC901F000FF;
	Fri,  9 Oct 2026 05:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525383;
	bh=GwmQwx+XWIXRlGbSG6dw5vVR7aEQhmEB3JxtRvQGdcw=;
	h=Date:To:From:Subject;
	b=kSuMeDgGzLBKfNkqWE2zgZIrZ2UgiZYILZnJ33Wo2Ov2N4j18EucvXbcZA67fIv6e
	 HXc+D1yQFJ3N7SRxx8zYx1EDI8v+ScyWDTCZrdmlsXbYUVY+4ObFzmk9TvIDNOScRd
	 FZ4MoY/8cvMNiB+F7667e0aATJZW9vbmOyLuEQF4=
Date: Thu, 08 Oct 2026 22:56:22 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,christosskarlos.kernel@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-fix-various-coding-style-warnings.patch removed from -mm tree
Message-Id: <20261009055623.0AC901F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: fix various coding style warnings
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-fix-various-coding-style-warnings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christos Skarlos <christosskarlos.kernel@gmail.com>
Subject: mm/huge_memory: fix various coding style warnings
Date: Thu, 3 Sep 2026 12:22:00 +0300

Resolve coding style issues flagged by checkpatch.pl Specifically:
- Add missing blank lines after variable declarations.
- Remove unnecessary braces {} for a single statement block.

No functional changes are introduced.

Link: https://lore.kernel.org/20260903092200.88910-1-christosskarlos.kernel@gmail.com
Signed-off-by: Christos Skarlos <christosskarlos.kernel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
---

 mm/huge_memory.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-various-coding-style-warnings
+++ a/mm/huge_memory.c
@@ -1146,6 +1146,7 @@ subsys_initcall(hugepage_init);
 static int __init setup_transparent_hugepage(char *str)
 {
 	int ret = 0;
+
 	if (!str)
 		goto out;
 	if (!strcmp(str, "always")) {
@@ -1552,6 +1553,7 @@ static void set_huge_zero_folio(pgtable_
 		struct folio *zero_folio)
 {
 	pmd_t entry;
+
 	entry = folio_mk_pmd(zero_folio, vma->vm_page_prot);
 	entry = pmd_mkspecial(entry);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
@@ -2661,6 +2663,7 @@ bool move_huge_pmd(struct vm_area_struct
 
 		if (pmd_move_must_withdraw(new_ptl, old_ptl, vma)) {
 			pgtable_t pgtable;
+
 			pgtable = pgtable_trans_huge_withdraw(mm, old_pmd);
 			pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
 		}
@@ -3949,9 +3952,8 @@ int folio_check_splittable(struct folio
 	 * swapcache folio split. Only uniform split to order-0 can be used
 	 * here.
 	 */
-	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && folio_test_swapcache(folio)) {
+	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && folio_test_swapcache(folio))
 		return -EINVAL;
-	}
 
 	if (is_huge_zero_folio(folio))
 		return -EINVAL;
_

Patches currently in -mm which might be from christosskarlos.kernel@gmail.com are


