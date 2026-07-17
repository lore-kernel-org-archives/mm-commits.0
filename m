Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9D9EADC
	for <mm-commits@vger.kernel.org>; Fri, 17 Jul 2026 00:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784246576; cv=none; b=IoKGPRduEDv1Qmq/nlBqB7vufBCcalqTiVXFeqSADsGazfmdCVfK1iWTsgKFA/Ul87VvTY9lQZMKV8AspydUwWmF1KEhRlWsDQL9GWVCqAHvIvmp2PP3LEG7bnGwE/NN2SozXVJzgCRvw4zBiBJGv0qILX39QdTBSFLCHI9uh6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784246576; c=relaxed/simple;
	bh=CHdgfGyyHMnasen8brb3TvKZO1Aqwcrz3ZxBthz4QP0=;
	h=Date:To:From:Subject:Message-Id; b=XdxW+oUA/29XmPQObV8WD9K2D1EyMigtkfmhNbn1hV51i+tJ4E1QuhGijrRIYkoaNKQbMfjZPFVlxckQNkthXZeeaZwuVkNi7afDSZFiE34XhR7brMsVdz1K6Sll8rym0EVP/f7KzrAPYRt3HDdf9eiMovyKrBKBH84pfiEmXm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RSekYVrg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RSekYVrg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC261F000E9;
	Fri, 17 Jul 2026 00:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784246574;
	bh=XF1nNY0lEQ7iHp3XpPBD5H6kukMpR2LD/x9D50V/+pE=;
	h=Date:To:From:Subject;
	b=RSekYVrgLgjlbwzTh1UZHsAwSdn5JDBvU7jVAbyc/xEdAlN/p/lsPUlhUfzYaIRua
	 Zx80ACigbksDP5n5TddlMrMTMtSU/RfLP18poSuCqqqa8pK/3YhUtCJqTe1IoZjArs
	 PlGypZPQOk+WRZjcl1W0Ikcx+vas8iOdHm7NANyE=
Date: Thu, 16 Jul 2026 17:02:54 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-drop-order-parameter-from-free_pagetable.patch added to mm-unstable branch
Message-Id: <20260717000254.7CC261F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mm: drop order parameter from free_pagetable()
has been added to the -mm mm-unstable branch.  Its filename is
     x86-mm-drop-order-parameter-from-free_pagetable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-drop-order-parameter-from-free_pagetable.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: x86/mm: drop order parameter from free_pagetable()
Date: Thu, 16 Jul 2026 16:51:00 +0200

Patch series "mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE (Part 2)", v2.

Let's remove the remaining pieces of CONFIG_HAVE_BOOTMEM_INFO_NODE,
performing some smaller cleanups around freeing of reserved vmemmap pages
on the way.


This patch (of 10):

All callers pass 0, so let's drop the parameter.

Link: https://lore.kernel.org/20260716-bootmem_info_part2-v2-0-4afc76c73d61@kernel.org
Link: https://lore.kernel.org/20260716-bootmem_info_part2-v2-1-4afc76c73d61@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
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
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- a/arch/x86/mm/init_64.c~x86-mm-drop-order-parameter-from-free_pagetable
+++ a/arch/x86/mm/init_64.c
@@ -1006,22 +1006,19 @@ static void free_reserved_pages(struct p
 		free_reserved_page(page++);
 }
 
-static void __meminit free_pagetable(struct page *page, int order)
+static void __meminit free_pagetable(struct page *page)
 {
 	/* bootmem page has reserved flag */
 	if (PageReserved(page)) {
-		unsigned long nr_pages = 1 << order;
 #ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
 		enum bootmem_type type = bootmem_type(page);
 
-		if (type == MIX_SECTION_INFO) {
-			while (nr_pages--)
-				put_page_bootmem(page++);
-		} else {
-			free_reserved_pages(page, nr_pages);
-		}
+		if (type == MIX_SECTION_INFO)
+			put_page_bootmem(page);
+		else
+			free_reserved_page(page);
 #else
-		free_reserved_pages(page, nr_pages);
+		free_reserved_page(page);
 #endif
 	} else {
 		pagetable_free(page_ptdesc(page));
@@ -1060,7 +1057,7 @@ static void __meminit free_pte_table(pte
 	}
 
 	/* free a pte table */
-	free_pagetable(pmd_page(*pmd), 0);
+	free_pagetable(pmd_page(*pmd));
 	spin_lock(&init_mm.page_table_lock);
 	pmd_clear(pmd);
 	spin_unlock(&init_mm.page_table_lock);
@@ -1078,7 +1075,7 @@ static void __meminit free_pmd_table(pmd
 	}
 
 	/* free a pmd table */
-	free_pagetable(pud_page(*pud), 0);
+	free_pagetable(pud_page(*pud));
 	spin_lock(&init_mm.page_table_lock);
 	pud_clear(pud);
 	spin_unlock(&init_mm.page_table_lock);
@@ -1096,7 +1093,7 @@ static void __meminit free_pud_table(pud
 	}
 
 	/* free a pud table */
-	free_pagetable(p4d_page(*p4d), 0);
+	free_pagetable(p4d_page(*p4d));
 	spin_lock(&init_mm.page_table_lock);
 	p4d_clear(p4d);
 	spin_unlock(&init_mm.page_table_lock);
_

Patches currently in -mm which might be from david@kernel.org are

sparc-mm-drop-custom-pte_clear_not_present_full.patch
mm-drop-pte_clear_not_present_full.patch
mm-cleanup-clear_not_present_full_ptes-and-rename-to-clear_non_present_ptes.patch
x86-mm-drop-order-parameter-from-free_pagetable.patch
mm-provide-free_reserved_pages-removing-x86-variant.patch
s390-mm-use-free_reserved_pages-in-vmem_free_pages.patch
mm-bootmem_info-allow-calling-free_bootmem_page-on-pages-without-a-bootmem_type.patch
x86-mm-stop-marking-vmemmap-as-section_info.patch
x86-mm-stop-marking-page-tables-as-mix_section_info.patch
x86-mm-remove-config_have_bootmem_info_node.patch
mm-hugetlb_vmemmap-remove-bootmem_info-leftovers.patch
mm-sparse-remove-bootmem_infoh-include.patch
mm-bootmem_info-remove-config_have_bootmem_info_node.patch
mm-standardize-printing-for-pgtable-entries.patch

