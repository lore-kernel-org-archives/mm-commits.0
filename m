Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C880137C92D;
	Thu, 10 Sep 2026 06:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789021162; cv=none; b=WRVz3aMLlzEPq5Qozadi3clfou7uDF4EKoM5UMcqjD39M1BTFfg+Zadgf12eDCzZhyKImJemM+e4hfT6i7PISft+YpvOGhi3V4Xxe1xtFaHY66Q7ikqGIF3wfG6voCc+HjyNLqKLIeT2q0ddbzwJMF6HNvo6o40uZ0zdSM47pMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789021162; c=relaxed/simple;
	bh=5X9kUA8rHCURoxVrUNZbLSyxWmqjyWNp/iruiVbwSJc=;
	h=Date:To:From:Subject:Message-Id; b=RQjhCsBLIJiMZesS+a0msbX2r0Mr3oidsI6QgFL676LswEa09O28NXIN9AD4VISfPyXLHAN0+EFGA/3NO+KmPrAy5FFCvGp2hWi1zGRnyZHrzLfxBG9IPbGQUddEY/DorvxNayhXE1KH1s02Q24PqiRoaQeVDKDxNO6XMA6u94s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HS/Lmngz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HS/Lmngz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10D81F00893;
	Thu, 10 Sep 2026 06:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789021149;
	bh=j6Z2s4Qz4RBca+R3C4ySLnTugbsux3Wlv7v1g0/6vhc=;
	h=Date:To:From:Subject;
	b=HS/LmngzL4nrbpZJJy45EIaHnq21evg9uHNzkLXf2aT/6eT3a2wbb0sYbv9yQQOR+
	 sq+c75faRqJYkYTLEscpYqTQzNUn3kPL3Hc81lap2nErBoQnFmesttgn/yIW7YUMoP
	 mqU634AWaxpFB39+AcVbLAcVXpNc51eKMn86+ZHg=
Date: Wed, 09 Sep 2026 23:19:09 -0700
To: mm-commits@vger.kernel.org,weir@nebusec.ai,vega@nebusec.ai,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,notasas@gmail.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,rakukuip@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-constrain-generic_access_phys-to-page-boundary.patch removed from -mm tree
Message-Id: <20260910061909.C10D81F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: constrain generic_access_phys() to page boundary
has been removed from the -mm tree.  Its filename was
     mm-memory-constrain-generic_access_phys-to-page-boundary.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Luxiao Xu <rakukuip@gmail.com>
Subject: mm/memory: constrain generic_access_phys() to page boundary
Date: Sat, 5 Sep 2026 22:12:17 +0800

generic_access_phys() improperly validates the memory access range: it
only validates the start address using follow_pfnmap_start() and passes
PAGE_ALIGN(len + offset) to ioremap_prot().

This poses two problems:
1. In PFNMAP VMAs, consecutive virtual pages are not guaranteed to be
   physically contiguous, and individual PTEs may have different access
   permissions or writability.
2. The mapping may cross VMA boundaries if len extends beyond vma->vm_end.

Since __access_remote_vm() already loops over the requested length and
accesses normal (struct page) memory page-by-page, constrain the
->access() callback in __access_remote_vm() to at most the current page
boundary.  Because VMA boundaries are always page-aligned, this also
ensures the access never exceeds the current VMA.

In generic_access_phys(), defensively clamp len to the page boundary as
well, map only a single PAGE_SIZE via ioremap_prot(), and add a missing
(resource_size_t) cast during PFN re-validation to avoid truncation on
32-bit PAE systems.

Link: https://lore.kernel.org/eaa4de66f9491888e0ffeb2d37ba7ae796ba535e.1788531737.git.rakukuip@gmail.com
Fixes: 9cb12d7b4cca ("mm/memory.c: actually remap enough memory")
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Suggested-by: David Hildenbrand <david@kernel.org>
Cc: Grazvydas Ignotas <notasas@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/memory.c~mm-memory-constrain-generic_access_phys-to-page-boundary
+++ a/mm/memory.c
@@ -7131,6 +7131,11 @@ int generic_access_phys(struct vm_area_s
 	bool writable;
 	struct follow_pfnmap_args args = { .vma = vma, .address = addr };
 
+	if (len <= 0)
+		return 0;
+
+	len = min_t(int, len, PAGE_SIZE - offset);
+
 retry:
 	if (follow_pfnmap_start(&args))
 		return -EINVAL;
@@ -7142,7 +7147,7 @@ retry:
 	if ((write & FOLL_WRITE) && !writable)
 		return -EINVAL;
 
-	maddr = ioremap_prot(phys_addr, PAGE_ALIGN(len + offset), prot);
+	maddr = ioremap_prot(phys_addr, PAGE_SIZE, prot);
 	if (!maddr)
 		return -ENOMEM;
 
@@ -7150,7 +7155,7 @@ retry:
 		goto out_unmap;
 
 	if ((pgprot_val(prot) != pgprot_val(args.pgprot)) ||
-	    (phys_addr != (args.pfn << PAGE_SHIFT)) ||
+	    (phys_addr != ((resource_size_t)args.pfn << PAGE_SHIFT)) ||
 	    (writable != args.writable)) {
 		follow_pfnmap_end(&args);
 		iounmap(maddr);
@@ -7221,7 +7226,8 @@ static int __access_remote_vm(struct mm_
 #ifdef CONFIG_HAVE_IOREMAP_PROT
 			if (vma->vm_ops && vma->vm_ops->access)
 				bytes = vma->vm_ops->access(vma, addr, buf,
-							    len, write);
+							    min_t(int, len, PAGE_SIZE - offset_in_page(addr)),
+							    write);
 #endif
 			if (bytes <= 0)
 				break;
_

Patches currently in -mm which might be from rakukuip@gmail.com are


