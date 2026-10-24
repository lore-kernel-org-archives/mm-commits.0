Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832489;
	b=khdku9fY0HfA1akHbLHyB7U3sebTHWkyp01Xg+bRPreBuqSqUYTqPnNmySU9nUECULA/
	 /Q0ea9aZ0kINnQkBaf6p9eXSDMIYOQ34+nMIIoAt3X5ZmZ1BBroicr94Tz12Tua/97d0B
	 GPg9YelEkxBjvIJ7QNydSOd0eLSi0KOf9wE///ZF+AbytJ18NUgfrKOQWXd0Ms+8Ugj2W
	 iRtn4Z6ggSTTbGQd5FHRru3PwrA2ZJ6RTzGZbQC6bKsLob9ZfTDR6GOaIFoEQO9r8Sszu
	 j/Gu2DyZdegZlzoY9+okgS1Kq4IRWzBfzZfsN197AaKEZXX+eBpkebmLdtNhEE3MPEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832489;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=RdMTGMNUbNYfAjqi55RqlwCb6Wg7t4tEFWolIhjXvv8=;
	b=fQA+rLi1BbfiyMthDY0y4IG7yh7bjCocsTtFvzMYzDwsrz8fJQe+eHVyZ+gxHw25g61d
	 3hipbedAcIbq8MUatP9zF3XG/DAhzBaNqt3EAgNKuin0XortDZwPkUhSudsAtZtuNBSPY
	 5oN59/N0zadv3jVexqkE66GDurxd3ag92xE64UmH7Hh5X0SDq3SPqGBNAQzir0ay37w4v
	 NSA3NHMcuupvlASX4kGphj1w6ResGwKD6R3g7zeo/aR31Whmxx6Q23CGXZ+YiRUdrH31f
	 U4pjjUEyb4x4cgy3OKS5epCfAeAin5vDE55ht5HfNhX2PLf8ypGkw2IyLxNLWGlbOAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=v+tnCyeP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE145606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=v+tnCyeP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B754C1F01825;
	Sat, 24 Oct 2026 09:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832488;
	bh=RdMTGMNUbNYfAjqi55RqlwCb6Wg7t4tEFWolIhjXvv8=;
	h=Date:To:From:Subject;
	b=v+tnCyePDVQk+mb81FshKAi5Sxf735XPNhhdw1CCMYCokD8Z6OpTBdASpoyywiiA8
	 IsytSCtAaeDhbXZPLERNDDpDrvVv0lSRtykFfEQlpUznnQ0acOhplblJ4OMmtG682A
	 AbOC4PHlNx9iqd06qw4gsQs7qpDBQp/OJAoGYFlI=
Date: Sat, 24 Oct 2026 02:01:28 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,ryan.roberts@arm.com,nico.pache@linux.dev,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-collapse-drop-the-collapse_possible-wrapper.patch removed from -mm tree
Message-Id: <20261024090128.B754C1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/collapse: drop the collapse_possible() wrapper
has been removed from the -mm tree.  Its filename was
     mm-collapse-drop-the-collapse_possible-wrapper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/collapse: drop the collapse_possible() wrapper
Date: Wed, 14 Oct 2026 18:11:39 +0100

collapse_possible() only forwards to collapse_possible_orders() and turns
its mask into a bool.  Its three callers can test the mask themselves.

No functional change.

Link: https://lore.kernel.org/20261014171145.3292736-7-kas@kernel.org
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Assisted-by: LLM
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
---

 mm/khugepaged.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/mm/khugepaged.c~mm-collapse-drop-the-collapse_possible-wrapper
+++ a/mm/khugepaged.c
@@ -494,17 +494,11 @@ static unsigned long collapse_possible_o
 	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
 }
 
-static bool collapse_possible(struct vm_area_struct *vma,
-		vm_flags_t vm_flags, enum tva_type tva_flags)
-{
-	return collapse_possible_orders(vma, vm_flags, tva_flags);
-}
-
 void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  vm_flags_t vm_flags)
 {
-	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) && hugepage_enabled()
-	    && collapse_possible(vma, vm_flags, TVA_KHUGEPAGED))
+	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) && hugepage_enabled() &&
+	    collapse_possible_orders(vma, vm_flags, TVA_KHUGEPAGED))
 		__khugepaged_enter(vma->vm_mm);
 }
 
@@ -2881,7 +2875,8 @@ static void collapse_scan_mm_slot(unsign
 			cc->progress++;
 			break;
 		}
-		if (!collapse_possible(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
+		if (!collapse_possible_orders(vma, vma->vm_flags,
+					      TVA_KHUGEPAGED)) {
 			cc->progress++;
 			continue;
 		}
@@ -3193,7 +3188,7 @@ int madvise_collapse(struct vm_area_stru
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!collapse_possible(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
+	if (!collapse_possible_orders(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
 		return -EINVAL;
 
 	hstart = ALIGN(start, HPAGE_PMD_SIZE);
_

Patches currently in -mm which might be from kas@kernel.org are


