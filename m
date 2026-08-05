Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C14A4A35
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 01:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785892998; cv=none; b=n4AA8+eD5gsuJ3ah3QFdCrs6+Fc0XIHlM8QeGPeUCf5kLj7b6szWuuc5/C5NFC69X7sJu/1s9nIYOOz+eLs+bM728+IXMAfSRmz2ul2aEOjxGJZ+cBL36brjUQxACWEeTXAQqmBiqxtIqUO6CMQ1158dIDK2U9jByT7VAnxDBUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785892998; c=relaxed/simple;
	bh=ruQOLyoUpcIgQTUjUdinpWDOGAsTpEzLDH7sasrBSzw=;
	h=Date:To:From:Subject:Message-Id; b=WJbuJpfMM4NxiHkg3yv8/dQ6PGryubjw3moZOWGhuW37K9IkCLnmC8ELl82ducBVfKj8eQnwemKJ4IlzI897p1IQeCGJm7f0UIFUmodjNFNBiUoeAiTgmKXqM/QjpgwxjCPcVZ2BK5iogHovS8iG258bGVwZ+IUCeRU3IBcCtpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dLMDBEml; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dLMDBEml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398D61F000E9;
	Wed,  5 Aug 2026 01:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785892997;
	bh=17gVdeshEFjeOUSTRMfptsytBndG1E5kXUCSM51ojRE=;
	h=Date:To:From:Subject;
	b=dLMDBEmlefyevRbEAtaE+aQSKu9Bf+PQozXiQo/6ze2bzC+qAkeab1Xa5Jx3J2lvM
	 wINrh13fOCOvy7EquL/cumVEBnCmqwG2aGE2Gf8OJWwv9YMYF+xIBq/TmEL33wElAD
	 MGLhNrZ7DFlketsYUNEyIujvCVTsu6yx5trwV0wg=
Date: Tue, 04 Aug 2026 18:23:16 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-mincore-remove-special-handling-for-vm_pfnmap-fix.patch removed from -mm tree
Message-Id: <20260805012317.398D61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mincore: fixup for remove special handling for VM_PFNMAP
has been removed from the -mm tree.  Its filename was
     mm-mincore-remove-special-handling-for-vm_pfnmap-fix.patch

This patch was dropped because it was folded into mm-mincore-remove-special-handling-for-vm_pfnmap.patch

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: mincore: fixup for remove special handling for VM_PFNMAP
Date: Mon, 20 Jul 2026 20:41:51 +0800

Address David's comments
- rename mincore_pud_range to mincore_pud_entry
- change int nr to const unsigned long
- remove a local vec variable

Link: https://lore.kernel.org/20260720124151.1483820-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/mm/mincore.c~mm-mincore-remove-special-handling-for-vm_pfnmap-fix
+++ a/mm/mincore.c
@@ -160,16 +160,15 @@ static int mincore_unmapped_range(unsign
 	return 0;
 }
 
-static int mincore_pud_range(pud_t *pudp, unsigned long addr, unsigned long end,
+static int mincore_pud_entry(pud_t *pudp, unsigned long addr, unsigned long end,
 		struct mm_walk *walk)
 {
 	if (pud_is_huge(pudp_get(pudp))) {
-		int nr = (end - addr) >> PAGE_SHIFT;
-		unsigned char *vec = walk->private;
+		const unsigned long nr = (end - addr) >> PAGE_SHIFT;
 
-		memset(vec, 1, nr);
-		walk->action = ACTION_CONTINUE;
+		memset(walk->private, 1, nr);
 		walk->private += nr;
+		walk->action = ACTION_CONTINUE;
 	}
 
 	return 0;
@@ -247,7 +246,7 @@ static inline bool can_do_mincore(struct
 }
 
 static const struct mm_walk_ops mincore_walk_ops = {
-	.pud_entry		= mincore_pud_range,
+	.pud_entry		= mincore_pud_entry,
 	.pmd_entry		= mincore_pte_range,
 	.pte_hole		= mincore_unmapped_range,
 	.hugetlb_entry		= mincore_hugetlb,
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-introduce-pud_is_huge-helper.patch
mm-mincore-remove-special-handling-for-vm_pfnmap.patch
mm-mincore-replace-__get_free_page-with-kmalloc.patch
mm-mincore-remove-xa_is_value-in-mincore_swap.patch
mm-mincore-improve-mincore_hugetlb.patch
mm-mincore-improve-mincore_hugetlb-fix.patch
mm-mincore-refactor-mincore_page.patch

