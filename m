Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFF132E692
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622279; cv=none; b=qTM7fCOUn3JAxLVlhFcR65sbdM6Uw5sMZUwpL903rlInblzMJt60QXetKvr5SQvwDkhvDJvvGdXdeCc6h06tFyphyW+Uib3mE3wqnzyxduFAPIbGliXOHasIXehmcfUqnAi4oo8yUAx0B3ljdtX9dBsJmllKm1QkUvv2GckNfJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622279; c=relaxed/simple;
	bh=RyKVJE4IWMklBavz+RLZjneZ1/Gr0kTdE3ly00hmemI=;
	h=Date:To:From:Subject:Message-Id; b=rPfPHhRnXnNU1rBV3rvx+Ux/kB6ih6LAayiq+E+l0INtdnV3Uw2OFdeqJcZugag0GVNGVHjocVFuxh6MZuKBv6sABL+iwylGeT0PuwatVLc9j9mEkch1/V5RsXfKvSv3HK/1LynX17A1fF3LL4XaBFSKlBywmCeuOv6JuhzClYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=fail (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fu2a+neK reason="signature verification failed"; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fu2a+neK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBE51F000E9;
	Tue, 25 Aug 2026 01:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622277;
	bh=2HqR/Xb0xGLLJ/8fF2zHcJpJcAF1GzKmMPuB/WCQRvk=;
	h=Date:To:From:Subject;
	b=Fu2a+neKR1VgWJERVQ4nRQsRf1FNob6EYodkXyXOWlYohXN3PEKTV8FaWoi7tsAyi
	 NuXTP7sG8TjS4g3qOVBBMJ8PIGyPLilqAEIUgOiY+pM7FdxOcXGNwy/rS3oNDSebpe
	 qF7wZ14fb3+nFW0x+uXA4BulOujOx6xHG8yZA66U=
Date: Mon, 24 Aug 2026 18:44:37 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,xu.xin16@zte.com.cn,willy@infradead.org,vbabka@kernel.org,tzimmermann@suse.de,thomas.hellstrom@linux.intel.com,svens@linux.ibm.com,surenb@google.com,steven.price@arm.com,shikemeng@huaweicloud.com,ryan.roberts@arm.com,rppt@kernel.org,rodrigo.vivi@intel.com,riel@surriel.com,Ray.Huang@amd.com,rakie.kim@sk.com,pfalcato@suse.de,peterz@infradead.org,peterx@redhat.com,osalvador@suse.de,oleg@redhat.com,nphamcs@gmail.com,npache@redhat.com,nao.horiguchi@gmail.com,namhyung@kernel.org,muchun.song@linux.dev,mripard@kernel.org,mingo@redhat.com,mhocko@suse.com,mhiramat@kernel.org,matthew.brost@intel.com,matthew.auld@intel.com,mark.rutland@arm.com,maarten.lankhorst@linux.intel.com,liviu.dudau@arm.com,linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,kees@kernel.org,kasong@tencent.com,joshua.hahnjy@gmail.com,jolsa@kernel.org,jhubbard@nvidia.com,jgg@ziepe.ca,jannh@google.com,james.clark@linaro.org,jack@suse.cz,iroger
 s@google.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,harry@kernel.org,gregkh@linuxfoundation.org,gourry@gourry.net,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,dev.jain@arm.com,david@kernel.org,christian.koenig@amd.com,chrisl@kernel.org,chengming.zhou@linux.dev,byungchul@sk.com,borntraeger@linux.ibm.com,boris.brezillon@collabora.com,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,arnd@arndb.de,apopple@nvidia.com,alexander.shishkin@linux.intel.com,alexander.deucher@amd.com,airlied@gmail.com,agordeev@linux.ibm.com,adrian.hunter@intel.com,acme@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-and-use-vma_filebacked_address.patch removed from -mm tree
Message-Id: <20260825014437.6BBE51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce and use vma_filebacked_address()
has been removed from the -mm tree.  Its filename was
     mm-introduce-and-use-vma_filebacked_address.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm: introduce and use vma_filebacked_address()
Date: Thu, 13 Aug 2026 18:32:23 +0100

In cases where we know that the VMA is file-backed, use
vma_filebacked_address() rather than vma_address().

This lays the foundation for using the anonymous page offset via
vma_anon_address().

Also add an assert to ensure that the VMA whose address is required is not
anonymous.

No functional change intended.

Link: https://lore.kernel.org/20260813-b4-scalable-cow-virt-pgoff-v5-6-c21581c0c3c8@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: syzbot@syzkaller.appspotmail.com
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

 mm/internal.h        |   18 ++++++++++++++++++
 mm/memory-failure.c  |    4 ++--
 mm/page_vma_mapped.c |    6 +++++-
 mm/rmap.c            |   10 ++++++----
 4 files changed, 31 insertions(+), 7 deletions(-)

--- a/mm/internal.h~mm-introduce-and-use-vma_filebacked_address
+++ a/mm/internal.h
@@ -1038,6 +1038,24 @@ static inline unsigned long __vma_addres
 }
 
 /**
+ * vma_filebacked_address - Find the virtual address a file-backed page range is
+ * mapped at.
+ * @vma: The vma which maps this object.
+ * @pgoff: The page offset within its object.
+ * @nr_pages: The number of pages to consider.
+ *
+ * Returns: If any page in this range is mapped by this VMA, return the first
+ * address where any of these pages appear.  Otherwise, return -EFAULT.
+ */
+static inline unsigned long vma_filebacked_address(const struct vm_area_struct *vma,
+		pgoff_t pgoff, unsigned long nr_pages)
+{
+	VM_WARN_ON_ONCE(vma_is_anonymous(vma));
+
+	return __vma_address(vma, pgoff, vma_start_pgoff(vma), nr_pages);
+}
+
+/**
  * vma_address - Find the virtual address a page range is mapped at.
  * @vma: The vma which maps this object.
  * @pgoff: The page offset within its object.
--- a/mm/memory-failure.c~mm-introduce-and-use-vma_filebacked_address
+++ a/mm/memory-failure.c
@@ -620,7 +620,7 @@ static void add_to_kill_fsdax(struct tas
 			      struct vm_area_struct *vma,
 			      struct list_head *to_kill, pgoff_t pgoff)
 {
-	unsigned long addr = vma_address(vma, pgoff, 1);
+	unsigned long addr = vma_filebacked_address(vma, pgoff, 1);
 	__add_to_kill(tsk, p, vma, to_kill, addr);
 }
 
@@ -2265,7 +2265,7 @@ static void add_to_kill_pgoff(struct tas
 	}
 
 	/* Check for pgoff not backed by struct page */
-	tk->addr = vma_address(vma, pgoff, 1);
+	tk->addr = vma_filebacked_address(vma, pgoff, 1);
 	tk->size_shift = PAGE_SHIFT;
 
 	if (tk->addr == -EFAULT)
--- a/mm/page_vma_mapped.c~mm-introduce-and-use-vma_filebacked_address
+++ a/mm/page_vma_mapped.c
@@ -356,6 +356,7 @@ unsigned long page_mapped_in_vma(const s
 		struct vm_area_struct *vma)
 {
 	const struct folio *folio = page_folio(page);
+	const pgoff_t pgoff = page_pgoff(folio, page);
 	struct page_vma_mapped_walk pvmw = {
 		.pfn = page_to_pfn(page),
 		.nr_pages = 1,
@@ -363,7 +364,10 @@ unsigned long page_mapped_in_vma(const s
 		.flags = PVMW_SYNC,
 	};
 
-	pvmw.address = vma_address(vma, page_pgoff(folio, page), 1);
+	if (folio_test_anon(folio))
+		pvmw.address = vma_address(vma, pgoff, 1);
+	else
+		pvmw.address = vma_filebacked_address(vma, pgoff, 1);
 	if (pvmw.address == -EFAULT)
 		goto out;
 	if (!page_vma_mapped_walk(&pvmw))
--- a/mm/rmap.c~mm-introduce-and-use-vma_filebacked_address
+++ a/mm/rmap.c
@@ -865,14 +865,15 @@ unsigned long page_address_in_vma(const
 		if (!vma->anon_vma || !anon_vma ||
 		    vma->anon_vma->root != anon_vma->root)
 			return -EFAULT;
+		/* KSM folios don't reach here because of the !anon_vma check */
+		return vma_address(vma, page_pgoff(folio, page), 1);
 	} else if (!vma->vm_file) {
 		return -EFAULT;
 	} else if (vma->vm_file->f_mapping != folio->mapping) {
 		return -EFAULT;
 	}
 
-	/* KSM folios don't reach here because of the !anon_vma check */
-	return vma_address(vma, page_pgoff(folio, page), 1);
+	return vma_filebacked_address(vma, page_pgoff(folio, page), 1);
 }
 
 /*
@@ -1321,7 +1322,7 @@ int pfn_mkclean_range(unsigned long pfn,
 	if (invalid_mkclean_vma(vma, NULL))
 		return 0;
 
-	pvmw.address = vma_address(vma, pgoff, nr_pages);
+	pvmw.address = vma_filebacked_address(vma, pgoff, nr_pages);
 	VM_BUG_ON_VMA(pvmw.address == -EFAULT, vma);
 
 	return page_vma_mkclean_one(&pvmw);
@@ -3098,7 +3099,8 @@ static void __rmap_walk_file(struct foli
 	}
 lookup:
 	mapping_rmap_tree_foreach(vma, mapping, pgoff_start, pgoff_end) {
-		unsigned long address = vma_address(vma, pgoff_start, nr_pages);
+		unsigned long address = vma_filebacked_address(vma, pgoff_start,
+							       nr_pages);
 
 		VM_BUG_ON_VMA(address == -EFAULT, vma);
 		cond_resched();
_

Patches currently in -mm which might be from ljs@kernel.org are


