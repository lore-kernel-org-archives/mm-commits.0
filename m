Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F036336892
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465827; cv=none; b=em6nMyZCDuu5CsdhQg+DnjZuJXggQ7CeoG7WCQwlKUC1FS+oXO7Q6HNqqeVnZFmV+QAIa70m4ZdopuGwLOTxnBb3W4Wc503sQqWOEkj9pHCln89TYBY4R9xULF5ss4X1MhtUCMoyah5joOW+sriQuuNtjgeIvEGLw7Kr9aBDdDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465827; c=relaxed/simple;
	bh=7SdDkpbjE4/SSmMqOKMcytvYENrtaYl2ZwmvT3atY4A=;
	h=Date:To:From:Subject:Message-Id; b=epD5Rtpiu9Xi7FkFlp2lPsNofKBgfUN+5//0j6s1QnPHSE/gAwW7mkOh9L2KVcwaMor5KSw/pxe7y2nx7I0gP1uimOFM4tRjF7+A7Gjw5CJ9Y/TDwzizCfeEN3Wr4c+c0LtDf6YcM9xladPHfhQQnebqS5Wzof8coym4f7sV8+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hXUNVl9n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hXUNVl9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338861F00A3D;
	Fri, 31 Jul 2026 02:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465823;
	bh=Xest+sE+4zco9aJEI2pzjT043otrTuzdWw1uoL0k0GA=;
	h=Date:To:From:Subject;
	b=hXUNVl9nn6L84NrfgPREATEdPxCfzcL8W6IoojKCPjs2fM/F35y+bMCFl9CDAs8+p
	 bUTG4Il2mtWZQPWVLvSYBql6wCD0hQGEwX0t66dMwplckKnQDAjwJKZy/VuZ+vF2EU
	 a6QIzJqj3FwkjwCNMrXB/BdLFmeKYrdQ9o0WFUxQ=
Date: Thu, 30 Jul 2026 19:43:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,will@kernel.org,vbabka@kernel.org,ryan.roberts@arm.com,riel@surriel.com,rcampbell@nvidia.com,rakie.kim@sk.com,pfalcato@suse.de,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,mel@csn.ul.ie,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,jpoimboe@kernel.org,joshua.hahnjy@gmail.com,j-nomura@ce.jp.nec.com,jannh@google.com,harry@kernel.org,gourry@gourry.net,david@kernel.org,dave.hansen@intel.com,catalin.marinas@arm.com,byungchul@sk.com,apopple@nvidia.com,anshuman.khandual@arm.com,ak@linux.intel.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mprotect-use-huge_ptep_get-for-hugetlb.patch removed from -mm tree
Message-Id: <20260731024343.338861F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mprotect: use huge_ptep_get() for hugetlb
has been removed from the -mm tree.  Its filename was
     mm-mprotect-use-huge_ptep_get-for-hugetlb.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm/mprotect: use huge_ptep_get() for hugetlb
Date: Fri, 3 Jul 2026 11:41:59 +0000

prot_none_hugetlb_entry() is the hugetlb callback for the early
mprotect(PROT_NONE) PFN permission walk on x86.

The callback passes the decoded PFN to pfn_modify_allowed().  For a
hugetlb callback, the pte pointer refers to a hugetlb entry.  On
architectures where hugetlb entries need huge_ptep_get(), reading that
entry with ptep_get() can make the permission check use the wrong PFN.

Use huge_ptep_get() before decoding the hugetlb PFN.

Currently there is no path which can trigger a bug: huge_ptep_get() is a
simple ptep_get() for x86, and the prot_none walk occurs only for x86.

So no need to backport - use the correct helper anyways.

[akpm@linux-foundation.org: s/EACCESS/EACCES/]
Link: https://lore.kernel.org/20260703114202.365553-7-dev.jain@arm.com
Fixes: 42e4089c7890 ("x86/speculation/l1tf: Disallow non privileged high MMIO PROT_NONE mappings")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Harry Yoo <harry@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Jun'ichi "Nick" Nomura <j-nomura@ce.jp.nec.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/mprotect.c~mm-mprotect-use-huge_ptep_get-for-hugetlb
+++ a/mm/mprotect.c
@@ -699,14 +699,20 @@ static int prot_none_pte_entry(pte_t *pt
 		0 : -EACCES;
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
 static int prot_none_hugetlb_entry(pte_t *pte, unsigned long hmask,
 				   unsigned long addr, unsigned long next,
 				   struct mm_walk *walk)
 {
-	return pfn_modify_allowed(pte_pfn(ptep_get(pte)),
-				  *(pgprot_t *)(walk->private)) ?
-		0 : -EACCES;
+	const pte_t entry = huge_ptep_get(walk->mm, addr, pte);
+
+	if (pfn_modify_allowed(pte_pfn(entry), *(pgprot_t *)(walk->private)))
+		return 0;
+	return -EACCES;
 }
+#else
+#define prot_none_hugetlb_entry	NULL
+#endif
 
 static const struct mm_walk_ops prot_none_walk_ops = {
 	.pte_entry		= prot_none_pte_entry,
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-rmap-convert-page-folio-for-hwpoison-checks.patch
mm-rmap-add-try_to_unmap_poisoned_hugetlb_one.patch
mm-rmap-refactor-some-code-around-lazyfree-folio-unmapping.patch
mm-rmap-refactor-anon-folio-unmap-in-try_to_unmap_one.patch
mm-rmap-add-anon-folio-unmap-dispatcher.patch
mm-memory-move-pte_install_uffd_wp_if_needed-into-memoryc.patch
mm-memory-batch-set-uffd-wp-markers-during-zapping.patch
mm-rmap-batch-unmap-file-folios-belonging-to-uffd-wp-vmas.patch

