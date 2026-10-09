Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702DF3FC5B7;
	Fri,  9 Oct 2026 05:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525409; cv=none; b=bFdilXx65vWFVHIWvC3AKXdIVLq7CF4ZL/woUVPjwmnzR9NjAayV4S6sbZ8/XwDfDraFs4rns6GsGvMwjcu/HtT9xeMY0X6jyrNl/aa2i1rxWmTFaFNz3VVeh9Gy9YEhJ5HQYgbQAIiccdLGsQOT0hq8Iz0HfMDi8qLZ9bHkekw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525409; c=relaxed/simple;
	bh=+hDTA8HiU+lzzBtHPNAhmr62RpjZlTHzKOSC7lKlcyw=;
	h=Date:To:From:Subject:Message-Id; b=WBlcbxpLyKUtfP6UuRoHQAcy65O8H11NTN146RaEe88nJvyssQKPu4gpqNvSvT798MBY7O+1K28leueXDg2gkMiY72IlBlC7BWY4x8MvSoISatbHG6h2LZe4LPJiI2zVTLEioLgA2gqDGVQLZeg36ur+XtKgKtDT2Xf7+4e+AMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AyOvo0ip; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AyOvo0ip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123E81F000FF;
	Fri,  9 Oct 2026 05:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525408;
	bh=zVt6U/zpO1+ZaZEFyZnq3/HHH+wa0kEwi2rwy5IlMuM=;
	h=Date:To:From:Subject;
	b=AyOvo0ipy6ExhQfJRtDUN7PhTYOpU0G8wx9QafSkAdXJxIeNMxgBuJQ9Cn9KgPpUP
	 2ADtCzHrVPMszZQYk93cngW7Tt9Bvtf2R9DSsMj6LzJBItjZBa9KWC//WOn0vPf6kH
	 fMM9BvNf1uXQIC61hKdTVzzxQfYzL/vDXqtCEtY4=
Date: Thu, 08 Oct 2026 22:56:47 -0700
To: mm-commits@vger.kernel.org,weir@nebusec.ai,vega@nebusec.ai,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,notasas@gmail.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,rakukuip@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-constrain-generic_access_phys-to-page-boundary.patch removed from -mm tree
Message-Id: <20261009055648.123E81F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: constrain generic_access_phys() to page boundary
has been removed from the -mm tree.  Its filename was
     mm-memory-constrain-generic_access_phys-to-page-boundary.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Luxiao Xu <rakukuip@gmail.com>
Subject: mm/memory: constrain generic_access_phys() to page boundary
Date: Thu, 10 Sep 2026 11:42:50 +0800

This patch addresses an issue in generic_access_phys() where accessing
memory across page boundaries in PFNMAP VMAs assumes physical pages are
contiguous, which can lead to accessing unintended physical memory or
exceeding VMA boundaries.

generic_access_phys() improperly validates the memory access range: it
only validates the start address using follow_pfnmap_start() and passes
PAGE_ALIGN(len + offset) to ioremap_prot().

This poses two problems:
1. In PFNMAP VMAs, consecutive virtual pages are not guaranteed to be
   physically contiguous, and individual PTEs may have different access
   permissions or writability.
2. The mapping may cross VMA boundaries if len extends beyond vma->vm_end.

Constrain the access in generic_access_phys() to at most the current page
boundary (PAGE_SIZE - offset) and map only a single PAGE_SIZE via
ioremap_prot().  Since the caller __access_remote_vm() already loops over
the requested length and handles partial transfers, it will naturally
iterate over the remaining pages.

Also add a missing (resource_size_t) cast during PFN re-validation to
avoid truncation on 32-bit PAE systems.

Link: https://lore.kernel.org/e06e28a46c2a176238f03b5740df0913e57c2861.1788842306.git.rakukuip@gmail.com
Fixes: 9cb12d7b4cca ("mm/memory.c: actually remap enough memory")
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Vega <vega@nebusec.ai>
Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Grazvydas Ignotas <notasas@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/memory.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-memory-constrain-generic_access_phys-to-page-boundary
+++ a/mm/memory.c
@@ -7131,6 +7131,12 @@ int generic_access_phys(struct vm_area_s
 	bool writable;
 	struct follow_pfnmap_args args = { .vma = vma, .address = addr };
 
+	/*
+	 * Limit access to one page at a time, as that's what follow_pfnmap_start()
+	 * guarantees; expect the caller to retry to read larger ranges.
+	 */
+	len = min_t(int, len, PAGE_SIZE - offset);
+
 retry:
 	if (follow_pfnmap_start(&args))
 		return -EINVAL;
@@ -7142,7 +7148,7 @@ retry:
 	if ((write & FOLL_WRITE) && !writable)
 		return -EINVAL;
 
-	maddr = ioremap_prot(phys_addr, PAGE_ALIGN(len + offset), prot);
+	maddr = ioremap_prot(phys_addr, PAGE_SIZE, prot);
 	if (!maddr)
 		return -ENOMEM;
 
@@ -7150,7 +7156,7 @@ retry:
 		goto out_unmap;
 
 	if ((pgprot_val(prot) != pgprot_val(args.pgprot)) ||
-	    (phys_addr != (args.pfn << PAGE_SHIFT)) ||
+	    (phys_addr != ((resource_size_t)args.pfn << PAGE_SHIFT)) ||
 	    (writable != args.writable)) {
 		follow_pfnmap_end(&args);
 		iounmap(maddr);
_

Patches currently in -mm which might be from rakukuip@gmail.com are


