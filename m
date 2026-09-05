Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C96D19CC14;
	Sat,  5 Sep 2026 23:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788649470; cv=none; b=L2ucIraOucRunY5kVipS5L97tM20wFjNMPgjvhYz/BQPPK68feyHJtwp62nwaQkDuaGKLiRhO/yUNiIL8IctV9XoQ4YaQwcRJhUvathH34AVxweq7nDZuYWYdtzMThtDlws5OGeNGxAb/e9xYTZiNAS0gRgBC/I/gVlHiawtsm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788649470; c=relaxed/simple;
	bh=JWzwJClOXryOcVxg9MkKa4CvUX5Xzi+u8aahzcSLr7Q=;
	h=Date:To:From:Subject:Message-Id; b=rinH3wCcu/sSp7IVLHXeN3a7N3RhrBDE5M/j0VwTT7IRzrZZ0kgS9CBuvyoM5+9w6fB9cdnKbp0nZfwbuK8NDA7UEnLSrC6ZuCDkNs9RWOV1B2+XRFTh0CDoDQkjKNmVnxZhiJBngQUcHitCs7OMlRTZoM4hBcOVnmZDRz8RS0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BSPtwrtn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BSPtwrtn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03DD1F00A3A;
	Sat,  5 Sep 2026 23:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788649468;
	bh=y5uqwdLG5D+Wy2UbjR9NlwcPM6iprUyo9pAjwAWiZRs=;
	h=Date:To:From:Subject;
	b=BSPtwrtnVX0Y1DTbwFlkWYpvG+VpmvZbIC36XCKBCHwalGDCCH+SX0Ho3zO9cSZOM
	 UL8wpS2hroHS906Iu6dzunwSeWdMaeLkT5GXVrFMtO9rxbDSLFXf4X1BvLPnaU0hKs
	 P1xJAkbo3h+u3q0qUrFbuuflsR6fXibMku1Cg1Qk=
Date: Sat, 05 Sep 2026 16:04:28 -0700
To: mm-commits@vger.kernel.org,weir@nebusec.ai,vega@nebusec.ai,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,notasas@gmail.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,rakukuip@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-constrain-generic_access_phys-to-page-boundary.patch added to mm-new branch
Message-Id: <20260905230428.B03DD1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: constrain generic_access_phys() to page boundary
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-constrain-generic_access_phys-to-page-boundary.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-constrain-generic_access_phys-to-page-boundary.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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

mm-memory-constrain-generic_access_phys-to-page-boundary.patch

