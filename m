Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A9B3D5259
	for <mm-commits@vger.kernel.org>; Thu, 16 Jul 2026 23:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784245591; cv=none; b=IDajCrz1+X94XayTUwYoDku/UjNfjWWE29Eqw8q03qi6ctJaBnuIgER9Nwbi1jhO1rA9F6sGQe98FPHwVF/gEn6O+MuJwtM1FkWnpqsnHLFpKExBvZlWsqhbBokUOsZBdmGGL8mq2tAWt+BBzm0E/qiYv+Lq0rNfkuVYLIv3ZWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784245591; c=relaxed/simple;
	bh=X+kt8AJzumMXjmHa/ryDAJRR9WwXQ+C22qfHzsVM+1E=;
	h=Date:To:From:Subject:Message-Id; b=XhuS5S1AuhnNU9hjo2E1X/hIhjAkzx/lXGd5ef8yXjEZV7jVE8tFeUFoub/0hVDB12mOI164aLXEQ9xld+rKVURjI7r/h90W69sbzoByKNTIcsw79S/JhMiOTU8PEIagSP4jxJKjM75pmeRO1A1lLW8ZzFEWJwFNitd1cJNyn4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mw24EUV0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mw24EUV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A191F00A3D;
	Thu, 16 Jul 2026 23:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784245589;
	bh=4jZU8g/hgu3Lv4M/j/QUbNjzn6+9bZs9hh+k6DNyR6o=;
	h=Date:To:From:Subject;
	b=Mw24EUV0tog0Ad6179CffqB3TAV+pTkKP3QXB+tD9TPFln/ND6DHV1vRPo2DgzHyg
	 UYwWePvwm/gW/Pa+tgnsgEDgrmPZbyOHd+qaH219/uEwr9EAIG8qp54ZeiIOzhCk18
	 Sp1q3SdX80Mm0N8DrwG0sdRwr8j6DCm4VT3PakJA=
Date: Thu, 16 Jul 2026 16:46:29 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] x86-mm-stop-marking-vmemmap-as-section_info.patch removed from -mm tree
Message-Id: <20260716234629.D0A191F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/mm: stop marking vmemmap as SECTION_INFO
has been removed from the -mm tree.  Its filename was
     x86-mm-stop-marking-vmemmap-as-section_info.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: x86/mm: stop marking vmemmap as SECTION_INFO
Date: Wed, 08 Jul 2026 16:11:00 +0200

We added the whole bootmem registration machinery in commit 04753278769f
("memory hotplug: register section/node id to free").

The main use case was to remember to which memory section memmap pages
belonged, so the memmap could be handled accordingly when freeing memory.

However, all that machinery is not required anymore: a memory section can
only get offlined if *all* pages can get offlined; and it can only get
unplugged once offline.  If some of these pages are unmovable memmap
pages: bad luck, doesn't work.  Offlining will fail.

Further, a lot of this machinery was required for pre-vmemmap support.
Now we only support the vmemmap with memory hotplug.

So the whole machinery is useless today.  Let's start by removing the last
pieces by first stopping to mark vmemmap pages as SECTION_INFO.  In
free_vmemmap_pages(), we can now always just free the reserved pages
directly.

Link: https://lore.kernel.org/20260708-bootmem_info_part2-v1-5-156ce4986598@kernel.org
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

 arch/x86/mm/init_64.c |   30 ++++--------------------------
 1 file changed, 4 insertions(+), 26 deletions(-)

--- a/arch/x86/mm/init_64.c~x86-mm-stop-marking-vmemmap-as-section_info
+++ a/arch/x86/mm/init_64.c
@@ -1024,19 +1024,12 @@ static void __meminit free_vmemmap_pages
 {
 	unsigned long nr_pages = 1u << order;
 
-	if (altmap) {
+	if (altmap)
 		vmem_altmap_free(altmap, nr_pages);
-	} else if (PageReserved(page)) {
-		if (IS_ENABLED(CONFIG_HAVE_BOOTMEM_INFO_NODE) &&
-		    bootmem_type(page) == SECTION_INFO) {
-			while (nr_pages--)
-				put_page_bootmem(page++);
-		} else {
-			free_reserved_pages(page, order);
-		}
-	} else {
+	else if (PageReserved(page))
+		free_reserved_pages(page, order);
+	else
 		__free_pages(page, order);
-	}
 }
 
 static void __meminit free_pte_table(pte_t *pte_start, pmd_t *pmd)
@@ -1593,12 +1586,8 @@ void register_page_bootmem_memmap(unsign
 	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
-	unsigned int nr_pmd_pages;
-	struct page *page;
 
 	for (; addr < end; addr = next) {
-		pte_t *pte = NULL;
-
 		pgd = pgd_offset_k(addr);
 		if (pgd_none(*pgd)) {
 			next = (addr + PAGE_SIZE) & PAGE_MASK;
@@ -1630,19 +1619,8 @@ void register_page_bootmem_memmap(unsign
 			next = (addr + PAGE_SIZE) & PAGE_MASK;
 			get_page_bootmem(section_nr, pmd_page(*pmd),
 					 MIX_SECTION_INFO);
-
-			pte = pte_offset_kernel(pmd, addr);
-			if (pte_none(*pte))
-				continue;
-			get_page_bootmem(section_nr, pte_page(*pte),
-					 SECTION_INFO);
 		} else {
 			next = pmd_addr_end(addr, end);
-			nr_pmd_pages = (next - addr) >> PAGE_SHIFT;
-			page = pmd_page(*pmd);
-			while (nr_pmd_pages--)
-				get_page_bootmem(section_nr, page++,
-						 SECTION_INFO);
 		}
 	}
 }
_

Patches currently in -mm which might be from david@kernel.org are

sparc-mm-drop-custom-pte_clear_not_present_full.patch
mm-drop-pte_clear_not_present_full.patch
mm-cleanup-clear_not_present_full_ptes-and-rename-to-clear_non_present_ptes.patch
x86-mm-stop-marking-page-tables-as-mix_section_info.patch
x86-mm-remove-config_have_bootmem_info_node.patch
mm-hugetlb_vmemmap-remove-bootmem_info-leftovers.patch
mm-sparse-remove-bootmem_infoh-include.patch
mm-bootmem_info-remove-config_have_bootmem_info_node.patch
mm-standardize-printing-for-pgtable-entries.patch

