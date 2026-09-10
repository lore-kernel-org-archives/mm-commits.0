Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4562C234E;
	Thu, 10 Sep 2026 06:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789021236; cv=none; b=f2gKAP/jDQUv/bmqYH6R8s07HqNY4YOkONHtrrLx5RZAyfuzSwgMm+LxrG11zHWB8LHRR/Bw9fBBhTEYzQ4hzJhyhbOwxlB8TQsD+NzA11CATmD6kS38JlhZlY70EONAoubzGD+wlP51rkCVtxyzqe5eO9i4beSC0a3khrtaiAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789021236; c=relaxed/simple;
	bh=OOjJqj+kZUo8t+tSlXF/nNDhYOBq8B+d+HdyuNNRjjE=;
	h=Date:To:From:Subject:Message-Id; b=qeq9fI1+SszXlGZmOJGuXwVKo3vuDumk0+JlG+zXGZbAV0+1S5ENRaHVOuZQoS2M1TUrY0Ixs1+5yxEpMa6U+NjP+YngmT1sLuJRmB1PJU5n9GtAXSk7Z5EugD0NenUTwZX5rfb9fq32CPZ3CQxlN2UaYfS4YC6poJTZxuER0S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0lN3eS4C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0lN3eS4C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25BDF1F00893;
	Thu, 10 Sep 2026 06:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789021226;
	bh=jyO5zDQFnkFvl83LZFuJ758xx6PqDyuUGAft9EfDLrw=;
	h=Date:To:From:Subject;
	b=0lN3eS4CiG5UdalPBucE7xlUV82dkaNqcBRCJtcq7OYNGCGAn74PnG9M3MssvzlRh
	 JvrdgECU5CQIhw/ykcwdLvjSw+D4643OXZK/2qf8YgSASDO2xPYc+q9x6nzryhRrOC
	 DZCxcbQlKE16XLBgQ0HkujNQTKYqEQsSH2zvy2h8=
Date: Wed, 09 Sep 2026 23:20:25 -0700
To: mm-commits@vger.kernel.org,weir@nebusec.ai,vega@nebusec.ai,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,notasas@gmail.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,rakukuip@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-constrain-generic_access_phys-to-page-boundary.patch added to mm-unstable branch
Message-Id: <20260910062026.25BDF1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: constrain generic_access_phys() to page boundary
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-constrain-generic_access_phys-to-page-boundary.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-constrain-generic_access_phys-to-page-boundary.patch

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

mm-memory-constrain-generic_access_phys-to-page-boundary.patch

