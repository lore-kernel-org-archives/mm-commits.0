Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD282AD00;
	Sat, 30 Nov 2024 02:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732935184; cv=none; b=TAmcgOInvIx0tgDGg87FqjCMrmDbJMDowpHd1pqxqZlOLx/Sy4PREh7OEc37DXpwv1fJBZrBvdnUU0lGAeRkNliUF5EARTWgMqHNECgTGVPxh0+dcs7h5CJtEX3lYYGio4jJ/OOzCNgmxIMgL54D1sv6Yxofqbn/ZC52CLnhE4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732935184; c=relaxed/simple;
	bh=+xuroTKSQ6HbuBh+AzfzTO0gzNPAzIpz8dzw5gk2s6o=;
	h=Date:To:From:Subject:Message-Id; b=a6eiiG0jcg9mzvDK9o1nostyCmQRc4e3QKtYa1607+F6esnRDAOMzV9kaDZ5wQahhEFJdPMFEROSn/y3ZVkykrvjufPqavV6wBPfwngaLN9bpZ302gGHnU2pa///kOAxVCiOM88cyHomMMKP7iISOge35mBGNCV2kKYxHm3HKw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J+gyjzH8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J+gyjzH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F027AC4CECF;
	Sat, 30 Nov 2024 02:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732935184;
	bh=+xuroTKSQ6HbuBh+AzfzTO0gzNPAzIpz8dzw5gk2s6o=;
	h=Date:To:From:Subject:From;
	b=J+gyjzH8RhHvf+B6RqM0JqWoS5AbvmtHITbAL2yaMCGYFXFC0K6vftMGrP+e5bzUW
	 HpMVArlGVJPbgWdOxu9lB7PweVu9n8v4tfc5o0NQq4qWZf2BCtp0V60ESGWdRga/Dg
	 a5RyYGBiXkm56ys/+6jK3V8TKoxW5aEVcb0n2Twc=
Date: Fri, 29 Nov 2024 18:53:03 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,stable@vger.kernel.org,souravpanda@google.com,rppt@kernel.org,pasha.tatashin@soleen.com,oliver.sang@intel.com,kent.overstreet@linux.dev,00107082@163.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-fix-module-allocation-tags-populated-area-calculation.patch added to mm-hotfixes-unstable branch
Message-Id: <20241130025303.F027AC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: fix module allocation tags populated area calculation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     alloc_tag-fix-module-allocation-tags-populated-area-calculation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-fix-module-allocation-tags-populated-area-calculation.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

Link: https://lkml.kernel.org/r/20241130001423.1114965-1-surenb@google.com
Fixes: 0f9b685626da ("alloc_tag: populate memory for module tags as needed")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202411132111.6a221562-lkp@intel.com
Cc: David Wang <00107082@163.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/lib/alloc_tag.c~alloc_tag-fix-module-allocation-tags-populated-area-calculation
+++ a/lib/alloc_tag.c
@@ -401,19 +401,20 @@ repeat:
 
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
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-fix-module-allocation-tags-populated-area-calculation.patch
alloc_tag-fix-set_codetag_empty-when-config_mem_alloc_profiling_debug.patch
mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculation_beginend.patch

