Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7E1F9CF
	for <mm-commits@vger.kernel.org>; Sat, 26 Oct 2024 23:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729985485; cv=none; b=uDND/o9i/0oFIeJPkBCpPddJDQya5/FxRQSn3wWB9TMn/tXJ4AMQpos7l9iV7S4U6A19tLna9TqLU9KgdqVZC99j8mzTL0PWdV3qZNs36f3/GqKvqcY8nbdpQPU+SYBk4kuby6KkAvYlEplBFuW1xlnHbnozA8aKd/bMdozXUME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729985485; c=relaxed/simple;
	bh=T8ZWyCtTs5fef35XSmschRSUIUa3LlZ6a98g0ZZ6RCg=;
	h=Date:To:From:Subject:Message-Id; b=XHawzzDjNNBiR19fepemkjlHNRHki7kuHN9ltkCWkpf4zVhFZCnWusBKE/1FOF7jj4my9lkEvZ1z0ynZw7irH7JFVuj31BFI/Ai0LASwhwNXyhwV7FPCMSgkLfk0gDSc+7SHY1AIKiaCwz8hH3qbFZEXO4NyCGtzkEKdfG4c71Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dEX1O1/C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dEX1O1/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD77C4CEC6;
	Sat, 26 Oct 2024 23:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729985484;
	bh=T8ZWyCtTs5fef35XSmschRSUIUa3LlZ6a98g0ZZ6RCg=;
	h=Date:To:From:Subject:From;
	b=dEX1O1/C8y7Rwpypbc4VEWyzKWrqZfW4uLlsEThT1kpsV9jlz88p6gZ7nZero/F0R
	 zUGkv2LL08MWATCc23m1jvv8bi9Q6FwygGi9cPUZfp81ElOb07BJeK8fcUIDdlaVqM
	 e2y9vLqKdwgoRyI8wpIPC1eE1LqBVkeDSx6Tom8g=
Date: Sat, 26 Oct 2024 16:31:24 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,muchun.song@linux.dev,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-aligned-address-in-clear_gigantic_page.patch added to mm-unstable branch
Message-Id: <20241026233124.ACD77C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use aligned address in clear_gigantic_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-aligned-address-in-clear_gigantic_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-aligned-address-in-clear_gigantic_page.patch

This patch will later appear in the mm-unstable branch at
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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: use aligned address in clear_gigantic_page()
Date: Sat, 26 Oct 2024 13:43:06 +0800

When clearing gigantic page, it zeros page from the first page to the last
page, if directly passing addr_hint which maybe not the address of the
first page of folio, then some archs could flush the wrong cache if it
does use the addr_hint as a hint.  For non-gigantic page, it calculates
the base address inside, even passed the wrong addr_hint, it only has
performance impact as the process_huge_page() wants to process target page
last to keep its cache lines hot), no functional impact.

Let's pass the real accessed address to folio_zero_user() and use the
aligned address in clear_gigantic_page() to fix it.

Link: https://lkml.kernel.org/r/20241026054307.3896926-1-wangkefeng.wang@huawei.com
Fixes: 78fefd04c123 ("mm: memory: convert clear_huge_page() to folio_zero_user()")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 mm/memory.c          |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/fs/hugetlbfs/inode.c~mm-use-aligned-address-in-clear_gigantic_page
+++ a/fs/hugetlbfs/inode.c
@@ -819,7 +819,7 @@ static long hugetlbfs_fallocate(struct f
 			error = PTR_ERR(folio);
 			goto out;
 		}
-		folio_zero_user(folio, ALIGN_DOWN(addr, hpage_size));
+		folio_zero_user(folio, addr);
 		__folio_mark_uptodate(folio);
 		error = hugetlb_add_to_page_cache(folio, mapping, index);
 		if (unlikely(error)) {
--- a/mm/memory.c~mm-use-aligned-address-in-clear_gigantic_page
+++ a/mm/memory.c
@@ -6810,6 +6810,7 @@ static void clear_gigantic_page(struct f
 	int i;
 
 	might_sleep();
+	addr = ALIGN_DOWN(addr, folio_size(folio));
 	for (i = 0; i < nr_pages; i++) {
 		cond_resched();
 		clear_user_highpage(folio_page(folio, i), addr + i * PAGE_SIZE);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-remove-unused-hugepage-for-vma_alloc_folio.patch
tmpfs-dont-enable-large-folios-if-not-supported.patch
mm-huge_memory-move-file_thp_enabled-into-huge_memoryc.patch
mm-shmem-remove-__shmem_huge_global_enabled.patch
mm-use-aligned-address-in-clear_gigantic_page.patch
mm-use-aligned-address-in-copy_user_gigantic_page.patch

