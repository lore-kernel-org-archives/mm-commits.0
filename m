Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70249336892;
	Fri, 31 Jul 2026 02:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465822; cv=none; b=Kau4djMlAkf1XIelojQCnCPREiYHUGPSFCQ78KyrvopjV6jL+bhLfdUmouZsoWX/jHi0ozrr7Q9BjGElvji6248Q6P+W8YBRFwcs3zRCNcHLx5dHP1BXbX55ZhuXtiKcdAXm7PFNMt4TA53V34x/EjaPZGtWkh+ck5C8+TK9kaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465822; c=relaxed/simple;
	bh=zjoGXEkwseiMl62hNKoDUd26Vxn23yI/oLGbdSJd9WM=;
	h=Date:To:From:Subject:Message-Id; b=Vtqoi4BFmL4gyqY2rQfBoHOM8mEOsQbKUoHpP1WPl6Fxirb2wVdqq0e1xnYiADcAsMW/aJ6nmglWaoFSJFAm+hTUxvsJv59QA313kOhgdBMOCda16PzUm/00OwRWbtWamzbsPnvsqhnjOUPPSrIQg0FAYOGjDFIvTQ5PkC2UuaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zp9hQ3lN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zp9hQ3lN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F2D1F00A3D;
	Fri, 31 Jul 2026 02:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465820;
	bh=wgKYcIGjrSs+AHRJ6fqxZkxRVSpBZynBxW0JZa8tme8=;
	h=Date:To:From:Subject;
	b=Zp9hQ3lNKdbgMPw0ueLi7bKwkpC9Ial74iQ+dMVr53IcpjhgTqoDC212bKuGZOF09
	 EXJFh71rYvmwfDmUdrgcWV8yscNlHm7jExlyOuUUWemRyR6ynhwnZqt9CM/z9oRWgW
	 Le8MxEl0bJiKAJK52eaxClf80JzxAdMbbg1Hv/7M=
Date: Thu, 30 Jul 2026 19:43:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,will@kernel.org,vbabka@kernel.org,stable@vger.kernel.org,ryan.roberts@arm.com,riel@surriel.com,rcampbell@nvidia.com,rakie.kim@sk.com,pfalcato@suse.de,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,mel@csn.ul.ie,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,jpoimboe@kernel.org,joshua.hahnjy@gmail.com,j-nomura@ce.jp.nec.com,jannh@google.com,harry@kernel.org,gourry@gourry.net,david@kernel.org,dave.hansen@intel.com,catalin.marinas@arm.com,byungchul@sk.com,apopple@nvidia.com,anshuman.khandual@arm.com,ak@linux.intel.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-use-huge_ptep_get-in-remove_migration_pte.patch removed from -mm tree
Message-Id: <20260731024340.45F2D1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: use huge_ptep_get() in remove_migration_pte()
has been removed from the -mm tree.  Its filename was
     mm-migrate-use-huge_ptep_get-in-remove_migration_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm/migrate: use huge_ptep_get() in remove_migration_pte()
Date: Fri, 3 Jul 2026 11:41:57 +0000

remove_migration_pte() converts migration entries back to present PTEs
after folio migration completes.  For hugetlb folios,
page_vma_mapped_walk() returns the pte pointer to the hugetlb folio in
pvmw.pte, but the code reads it with ptep_get().

On arches which provide their own huge_ptep_get() to dereference a huge
pte pointer, accessing via ptep_get() would cause pte_pfn(),
pte_present() etc to misbehave.

It is not clear whether this has a trivially visible effect to userspace.

Use huge_ptep_get() to dereference a huge pte pointer.

Link: https://lore.kernel.org/20260703114202.365553-5-dev.jain@arm.com
Fixes: 290408d4a250 ("hugetlb: hugepage migration core")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-use-huge_ptep_get-in-remove_migration_pte
+++ a/mm/migrate.c
@@ -372,7 +372,11 @@ static bool remove_migration_pte(struct
 			continue;
 		}
 #endif
-		old_pte = ptep_get(pvmw.pte);
+		if (folio_test_hugetlb(folio))
+			old_pte = huge_ptep_get(vma->vm_mm, pvmw.address,
+						pvmw.pte);
+		else
+			old_pte = ptep_get(pvmw.pte);
 		if (rmap_walk_arg->map_unused_to_zeropage &&
 		    try_to_map_unused_to_zeropage(&pvmw, folio, old_pte, idx))
 			continue;
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

