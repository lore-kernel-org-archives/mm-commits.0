Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06275339360
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622293; cv=none; b=JRaaxJgi/9nmVBb3SRAn7KPe8nKG2b5MZP57Fcf42feZrgID6PZvLYWha0Q8MUB+0VUZITQgEcbesmeY6VbWgqNOe04EMPTHp063FMe1TMnaZhZ6na0bspTyOd8vKj3QfIGjuvxWCd3eOY5LfegBStCt2J2A84V0MRpAF+hlDJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622293; c=relaxed/simple;
	bh=UVl964Jl0+oC9rDBiugUOmTUUoblWNvKBoKF29ulnrE=;
	h=Date:To:From:Subject:Message-Id; b=JX1+mji1HVy7frylm5eoiwNacLYDULdB9g0hbsokoILDZftwbEA1H7HH7RSRslyoX3sESVN/tCVViSsTsWFIw7ADr+erV05rXtpIh7CKsxM/We2yvikIvbPvcfVA5b1OFgXxnOVhMbVzYaztic0mwzPcL87wdHCoTb2BrtbJVsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=fail (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SL8kwSlV reason="signature verification failed"; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SL8kwSlV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7921F000E9;
	Tue, 25 Aug 2026 01:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622291;
	bh=MRmuIbhqEOANinhGXDUPAk3AMCVAHFtqWNWiZOj1rC8=;
	h=Date:To:From:Subject;
	b=SL8kwSlV0b2cuuY2syHjqiWqdqdOh6eiF1ODp4J4wDidWEx03aPSmOkqIz3KVeksr
	 7vxzTP9sqE/XaOoI9ysg80jF/LtJ4idnMmC++7/1pPvmyHCn15d4moeBeH58PZC17n
	 1f7lfqwDxMdNsxiMq4BtFRyG5cmCXuaZLQ8SS9j4=
Date: Mon, 24 Aug 2026 18:44:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,xu.xin16@zte.com.cn,willy@infradead.org,vbabka@kernel.org,tzimmermann@suse.de,thomas.hellstrom@linux.intel.com,svens@linux.ibm.com,surenb@google.com,steven.price@arm.com,shikemeng@huaweicloud.com,ryan.roberts@arm.com,rppt@kernel.org,rodrigo.vivi@intel.com,riel@surriel.com,Ray.Huang@amd.com,rakie.kim@sk.com,pfalcato@suse.de,peterz@infradead.org,peterx@redhat.com,osalvador@suse.de,oleg@redhat.com,nphamcs@gmail.com,npache@redhat.com,nao.horiguchi@gmail.com,namhyung@kernel.org,muchun.song@linux.dev,mripard@kernel.org,mingo@redhat.com,mhocko@suse.com,mhiramat@kernel.org,matthew.brost@intel.com,matthew.auld@intel.com,mark.rutland@arm.com,maarten.lankhorst@linux.intel.com,liviu.dudau@arm.com,linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,kees@kernel.org,kasong@tencent.com,joshua.hahnjy@gmail.com,jolsa@kernel.org,jhubbard@nvidia.com,jgg@ziepe.ca,jannh@google.com,james.clark@linaro.org,jack@suse.cz,iroger
 s@google.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,harry@kernel.org,gregkh@linuxfoundation.org,gourry@gourry.net,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,dev.jain@arm.com,david@kernel.org,christian.koenig@amd.com,chrisl@kernel.org,chengming.zhou@linux.dev,byungchul@sk.com,borntraeger@linux.ibm.com,boris.brezillon@collabora.com,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,arnd@arndb.de,apopple@nvidia.com,alexander.shishkin@linux.intel.com,alexander.deucher@amd.com,airlied@gmail.com,agordeev@linux.ibm.com,adrian.hunter@intel.com,acme@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-update-remove_migration_pmd-to-accept-a-folio.patch removed from -mm tree
Message-Id: <20260825014451.AF7921F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: update remove_migration_pmd() to accept a folio
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-update-remove_migration_pmd-to-accept-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/huge_memory: update remove_migration_pmd() to accept a folio
Date: Thu, 13 Aug 2026 18:32:29 +0100

This function does not need to accept a page and requiring it to is
unnecessary and misleading.

make_[writable, readable]_device_private_entry() must be passed a
PMD-aligned PFN as they immediately used to obtain a softleaf PMD entry
and the same argument applies to folio_add_[anon, file]_rmap_pmd().

While we are here, update a VM_BUG_ON() to a VM_WARN_ON_ONCE().

No functional change intended.

Link: https://lore.kernel.org/20260813-b4-scalable-cow-virt-pgoff-v5-12-c21581c0c3c8@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Deucher <alexander.deucher@amd.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christan König <christian.koenig@amd.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gregory Price (Meta) <gourry@gourry.net>
Cc: Harry Yoo <harry@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huang Ray <Ray.Huang@amd.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Liviu Dudau <liviu.dudau@arm.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Namhyung kim <namhyung@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |    6 +++---
 mm/huge_memory.c        |   16 +++++++---------
 mm/migrate.c            |    2 +-
 3 files changed, 11 insertions(+), 13 deletions(-)

--- a/include/linux/swapops.h~mm-huge_memory-update-remove_migration_pmd-to-accept-a-folio
+++ a/include/linux/swapops.h
@@ -325,8 +325,8 @@ struct page_vma_mapped_walk;
 extern int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 		struct page *page);
 
-extern void remove_migration_pmd(struct page_vma_mapped_walk *pvmw,
-		struct page *new);
+void remove_migration_pmd(struct page_vma_mapped_walk *pvmw,
+		struct folio *folio);
 
 extern void pmd_migration_entry_wait(struct mm_struct *mm, pmd_t *pmd);
 
@@ -346,7 +346,7 @@ static inline int set_pmd_migration_entr
 }
 
 static inline void remove_migration_pmd(struct page_vma_mapped_walk *pvmw,
-		struct page *new)
+		struct folio *folio)
 {
 	BUILD_BUG();
 }
--- a/mm/huge_memory.c~mm-huge_memory-update-remove_migration_pmd-to-accept-a-folio
+++ a/mm/huge_memory.c
@@ -5077,9 +5077,8 @@ int set_pmd_migration_entry(struct page_
 	return 0;
 }
 
-void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
+void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct folio *folio)
 {
-	struct folio *folio = page_folio(new);
 	struct vm_area_struct *vma = pvmw->vma;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long address = pvmw->address;
@@ -5115,11 +5114,9 @@ void remove_migration_pmd(struct page_vm
 		swp_entry_t entry;
 
 		if (pmd_write(pmde))
-			entry = make_writable_device_private_entry(
-							page_to_pfn(new));
+			entry = make_writable_device_private_entry(folio_pfn(folio));
 		else
-			entry = make_readable_device_private_entry(
-							page_to_pfn(new));
+			entry = make_readable_device_private_entry(folio_pfn(folio));
 		pmde = softleaf_to_pmd(entry);
 
 		if (pmd_swp_soft_dirty(*pvmw->pmd))
@@ -5134,11 +5131,12 @@ void remove_migration_pmd(struct page_vm
 		if (!softleaf_is_migration_read(entry))
 			rmap_flags |= RMAP_EXCLUSIVE;
 
-		folio_add_anon_rmap_pmd(folio, new, vma, haddr, rmap_flags);
+		folio_add_anon_rmap_pmd(folio, &folio->page, vma, haddr, rmap_flags);
 	} else {
-		folio_add_file_rmap_pmd(folio, new, vma);
+		folio_add_file_rmap_pmd(folio, &folio->page, vma);
 	}
-	VM_BUG_ON(pmd_write(pmde) && folio_test_anon(folio) && !PageAnonExclusive(new));
+	VM_WARN_ON_ONCE(pmd_write(pmde) && folio_test_anon(folio) &&
+			!PageAnonExclusive(&folio->page));
 	set_pmd_at(mm, haddr, pvmw->pmd, pmde);
 
 	/* No need to invalidate - it was non-present before */
--- a/mm/migrate.c~mm-huge_memory-update-remove_migration_pmd-to-accept-a-folio
+++ a/mm/migrate.c
@@ -372,7 +372,7 @@ static bool remove_migration_pte(struct
 		if (!pvmw.pte) {
 			VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
 					!folio_test_pmd_mappable(folio), folio);
-			remove_migration_pmd(&pvmw, new);
+			remove_migration_pmd(&pvmw, folio);
 			continue;
 		}
 #endif
_

Patches currently in -mm which might be from ljs@kernel.org are


