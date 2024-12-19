Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18161EA90;
	Thu, 19 Dec 2024 03:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734577542; cv=none; b=qzVCTLtaZJsg18YeTBE87TZjvjUW6JJ6KsuAAekWrHiT7DsrTyApjJXiX+0gyi+aaT2/EWCM1Vna0Z93PJjyCD1Url2aw7dAuRzMcL0pWr9Ew+yIAOAqLtvUTrnPHh1VrtWJeTvtIfxfowfQIvFdsMC1+9BprHCm6fQP1beEezQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734577542; c=relaxed/simple;
	bh=15DUaa4rQsw56QZ0MxZdgbPqerAZxltoyfnSo7OKcTQ=;
	h=Date:To:From:Subject:Message-Id; b=Bb9RrYahqL8r+gwlB6wPTmJkp2Oah3UdhKOhtdYinmQ4B3YH6lNxqQq1KyFicVvksRNytGcrOhy49L0OdCSFXA2bKb8GPrxIdHmXhCxhq55uwuMbq8OLdn2WvmbXUCXoELdgtP+DKFeeqxQ9lhDB0OPqJtC/qhtwaNlxncJWq8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gbLfFyNO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gbLfFyNO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F76C4CED4;
	Thu, 19 Dec 2024 03:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734577542;
	bh=15DUaa4rQsw56QZ0MxZdgbPqerAZxltoyfnSo7OKcTQ=;
	h=Date:To:From:Subject:From;
	b=gbLfFyNOBcscvbtnZPXA7qBSmEEb7yUvCRtTzTj85OqnB5lUB/Wz05rEmvwKiWEtc
	 kP1oYOHTlSk6ksu2mGH2jcR/4SFk0+nilNsvN4igENrt+f0eopYbozHpl1eGmF6pp4
	 1yH5DdmJ5Vuy4O7l1GUeq1bQ2zdd8c5fSbuZqWDs=
Date: Wed, 18 Dec 2024 19:05:41 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,stable@vger.kernel.org,souravpanda@google.com,rppt@kernel.org,pasha.tatashin@soleen.com,oliver.sang@intel.com,kent.overstreet@linux.dev,ahuang12@lenovo.com,00107082@163.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] alloc_tag-fix-module-allocation-tags-populated-area-calculation.patch removed from -mm tree
Message-Id: <20241219030542.28F76C4CED4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: fix module allocation tags populated area calculation
has been removed from the -mm tree.  Its filename was
     alloc_tag-fix-module-allocation-tags-populated-area-calculation.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: fix module allocation tags populated area calculation
Date: Fri, 29 Nov 2024 16:14:22 -0800

vm_module_tags_populate() calculation of the populated area assumes that
area starts at a page boundary and therefore when new pages are allocation,
the end of the area is page-aligned as well. If the start of the area is
not page-aligned then allocating a page and incrementing the end of the
area by PAGE_SIZE leads to an area at the end but within the area boundary
which is not populated. Accessing this are will lead to a kernel panic.
Fix the calculation by down-aligning the start of the area and using that
as the location allocated pages are mapped to.

[gehao@kylinos.cn: fix vm_module_tags_populate's KASAN poisoning logic]
  Link: https://lkml.kernel.org/r/20241205170528.81000-1-hao.ge@linux.dev
[gehao@kylinos.cn: fix panic when CONFIG_KASAN enabled and CONFIG_KASAN_VMALLOC not enabled]
  Link: https://lkml.kernel.org/r/20241212072126.134572-1-hao.ge@linux.dev
Link: https://lkml.kernel.org/r/20241130001423.1114965-1-surenb@google.com
Fixes: 0f9b685626da ("alloc_tag: populate memory for module tags as needed")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202411132111.6a221562-lkp@intel.com
Acked-by: Yu Zhao <yuzhao@google.com>
Tested-by: Adrian Huang <ahuang12@lenovo.com> 
Cc: David Wang <00107082@163.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |   34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

--- a/lib/alloc_tag.c~alloc_tag-fix-module-allocation-tags-populated-area-calculation
+++ a/lib/alloc_tag.c
@@ -408,28 +408,52 @@ repeat:
 
 static int vm_module_tags_populate(void)
 {
-	unsigned long phys_size = vm_module_tags->nr_pages << PAGE_SHIFT;
+	unsigned long phys_end = ALIGN_DOWN(module_tags.start_addr, PAGE_SIZE) +
+				 (vm_module_tags->nr_pages << PAGE_SHIFT);
+	unsigned long new_end = module_tags.start_addr + module_tags.size;
 
-	if (phys_size < module_tags.size) {
+	if (phys_end < new_end) {
 		struct page **next_page = vm_module_tags->pages + vm_module_tags->nr_pages;
-		unsigned long addr = module_tags.start_addr + phys_size;
+		unsigned long old_shadow_end = ALIGN(phys_end, MODULE_ALIGN);
+		unsigned long new_shadow_end = ALIGN(new_end, MODULE_ALIGN);
 		unsigned long more_pages;
 		unsigned long nr;
 
-		more_pages = ALIGN(module_tags.size - phys_size, PAGE_SIZE) >> PAGE_SHIFT;
+		more_pages = ALIGN(new_end - phys_end, PAGE_SIZE) >> PAGE_SHIFT;
 		nr = alloc_pages_bulk_array_node(GFP_KERNEL | __GFP_NOWARN,
 						 NUMA_NO_NODE, more_pages, next_page);
 		if (nr < more_pages ||
-		    vmap_pages_range(addr, addr + (nr << PAGE_SHIFT), PAGE_KERNEL,
+		    vmap_pages_range(phys_end, phys_end + (nr << PAGE_SHIFT), PAGE_KERNEL,
 				     next_page, PAGE_SHIFT) < 0) {
 			/* Clean up and error out */
 			for (int i = 0; i < nr; i++)
 				__free_page(next_page[i]);
 			return -ENOMEM;
 		}
+
 		vm_module_tags->nr_pages += nr;
+
+		/*
+		 * Kasan allocates 1 byte of shadow for every 8 bytes of data.
+		 * When kasan_alloc_module_shadow allocates shadow memory,
+		 * its unit of allocation is a page.
+		 * Therefore, here we need to align to MODULE_ALIGN.
+		 */
+		if (old_shadow_end < new_shadow_end)
+			kasan_alloc_module_shadow((void *)old_shadow_end,
+						  new_shadow_end - old_shadow_end,
+						  GFP_KERNEL);
 	}
 
+	/*
+	 * Mark the pages as accessible, now that they are mapped.
+	 * With hardware tag-based KASAN, marking is skipped for
+	 * non-VM_ALLOC mappings, see __kasan_unpoison_vmalloc().
+	 */
+	kasan_unpoison_vmalloc((void *)module_tags.start_addr,
+				new_end - module_tags.start_addr,
+				KASAN_VMALLOC_PROT_NORMAL);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from surenb@google.com are

seqlock-add-raw_seqcount_try_begin.patch
mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculate_try_beginretry.patch

