Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B733C0A01
	for <mm-commits@vger.kernel.org>; Thu, 16 Jul 2026 23:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784245588; cv=none; b=A6diJEddFn33kBMbgHJyQxxPJgtyXhkMwnc2GnNEJcxyf1c9TL2vOupOTMttIx8Fwzzem04O9U0t+iqH/dgenK3XegcwcsaCpBf1LbW3XjNM8yy32XKnjH49rNhEmTfdINDBhlOYDeHOhO1l87bf5IQTIYQs+NvnX4xCG0kH5wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784245588; c=relaxed/simple;
	bh=m7JdK5B1bMZSLSuLhH4Sh6dTvCR7DLdMtXGG8JeEopE=;
	h=Date:To:From:Subject:Message-Id; b=Mar9gX1Qu8z8sQoBla73QKcja7ifSxsIbP7IOiyIC/z/ntJ4IlNDKOsH1rdsYt2zidp+NZFqbaNwNDBjWhgriSMCp04qDEuirM6O07GbU/Nnf0LH6hFsRJst7tGt+r/Z/t0JjzmhvZK5OkkMaP+ZEeLqyYUfNH6GAvlYLxL0usw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YKeUwtw6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YKeUwtw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5711F000E9;
	Thu, 16 Jul 2026 23:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784245587;
	bh=Sd2aHwgCd7gO02ydsxCIBlW9dPQOwJKvWz+Es0xL4t4=;
	h=Date:To:From:Subject;
	b=YKeUwtw6UgKLjtuHBBBvQ3Swt8ZMN+4LP3ooY0bgQ62ZAgYBxxfJUZr09VQ2dzTTv
	 rXnckt38GfQO53VgN2/SJmFgYmFvlvA5Garun7jvaioHh5XpGecInOeEMeiVDOqzdg
	 FtvPn9KE6VKYQB7ejIhpe8ehaWAiYENhGyDcBuvA=
Date: Thu, 16 Jul 2026 16:46:26 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] s390-mm-use-free_reserved_pages-in-vmem_free_pages.patch removed from -mm tree
Message-Id: <20260716234627.0B5711F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390/mm: use free_reserved_pages() in vmem_free_pages()
has been removed from the -mm tree.  Its filename was
     s390-mm-use-free_reserved_pages-in-vmem_free_pages.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: s390/mm: use free_reserved_pages() in vmem_free_pages()
Date: Wed, 08 Jul 2026 16:10:58 +0200

Let's use our new generic helper.

Link: https://lore.kernel.org/20260708-bootmem_info_part2-v1-3-156ce4986598@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/vmem.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/s390/mm/vmem.c~s390-mm-use-free_reserved_pages-in-vmem_free_pages
+++ a/arch/s390/mm/vmem.c
@@ -39,7 +39,6 @@ static void __ref *vmem_alloc_pages(unsi
 
 static void vmem_free_pages(unsigned long addr, int order, struct vmem_altmap *altmap)
 {
-	unsigned int nr_pages = 1 << order;
 	struct page *page;
 
 	if (altmap) {
@@ -49,8 +48,7 @@ static void vmem_free_pages(unsigned lon
 	page = virt_to_page((void *)addr);
 	if (PageReserved(page)) {
 		/* allocated from memblock */
-		while (nr_pages--)
-			free_reserved_page(page++);
+		free_reserved_pages(page, order);
 	} else {
 		free_pages(addr, order);
 	}
_

Patches currently in -mm which might be from david@kernel.org are

sparc-mm-drop-custom-pte_clear_not_present_full.patch
mm-drop-pte_clear_not_present_full.patch
mm-cleanup-clear_not_present_full_ptes-and-rename-to-clear_non_present_ptes.patch
mm-bootmem_info-allow-calling-free_bootmem_page-on-pages-without-a-bootmem_type.patch
x86-mm-stop-marking-vmemmap-as-section_info.patch
x86-mm-stop-marking-page-tables-as-mix_section_info.patch
x86-mm-remove-config_have_bootmem_info_node.patch
mm-hugetlb_vmemmap-remove-bootmem_info-leftovers.patch
mm-sparse-remove-bootmem_infoh-include.patch
mm-bootmem_info-remove-config_have_bootmem_info_node.patch
mm-standardize-printing-for-pgtable-entries.patch

