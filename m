Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E548B14B815
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 21:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708638216; cv=none; b=EPbYp0NqWz2OFP8xRSvIwObOdx/mkCKfgMm1tirtTFMYORUU6sHLBbq/STLJmUIDff5abewJaarwIDfpya/BU4ycj0ZnArs841ZGZoUzBQA+KjoRfX11GirGUIZE7QQy6CgDab1EG4kYBvvzVmaQ402bTgYYzMZkk/6wN16tF4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708638216; c=relaxed/simple;
	bh=6zbytXTGOFWy0tdgywJOuo4uP1K9p696vajPnJ0076k=;
	h=Date:To:From:Subject:Message-Id; b=Ogo8c2jiLMi/tyRikVP2Oy86WPNt+WGegZFMVk4YSoAXbBp2+aCIdUtX7a5zdgnPj07edQ7tbY+yC2gkfTtabIs5Z8qiBbzA3FDLd4+cFW+BgagF2p/l2Vj6LltoeiZVlZ2KZYIG+wo3a3H3LibwNeOhSo6t6CQfnAIOv2HmmnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JzWuWe4t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JzWuWe4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4A2C433C7;
	Thu, 22 Feb 2024 21:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708638215;
	bh=6zbytXTGOFWy0tdgywJOuo4uP1K9p696vajPnJ0076k=;
	h=Date:To:From:Subject:From;
	b=JzWuWe4tlWOf/zeCGKFMImVwez+xpu1XKXh5eLaaAu6mZykvvga2rTkYYfBxIToon
	 cOsBlawvmCOA8/fBsFyPF/3k3nUHg8viRHj4lZFRCKqvLnE8X8zcHj6ZmFJBDhV0zW
	 dPdfklT8NqmSxjv7rd/PETT5NPcWhW1w1zfq2lbw=
Date: Thu, 22 Feb 2024 13:43:34 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,muchun.song@linux.dev,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-change-vmf_anon_prepare-to-be-non-static.patch added to mm-unstable branch
Message-Id: <20240222214335.4C4A2C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: change vmf_anon_prepare() to be non-static
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-change-vmf_anon_prepare-to-be-non-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-change-vmf_anon_prepare-to-be-non-static.patch

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/memory: change vmf_anon_prepare() to be non-static
Date: Wed, 21 Feb 2024 15:47:28 -0800

Patch series "Handle hugetlb faults under the VMA lock", v2.

It is generally safe to handle hugetlb faults under the VMA lock.  The
only time this is unsafe is when no anon_vma has been allocated to this
vma yet, so we can use vmf_anon_prepare() instead of anon_vma_prepare() to
bailout if necessary.  This should only happen for the first hugetlb page
in the vma.

Additionally, this patchset begins to use struct vm_fault within
hugetlb_fault().  This works towards cleaning up hugetlb code, and should
significantly reduce the number of arguments passed to functions.

The last patch in this series may cause ltp hugemmap10 to "fail".  This is
because vmf_anon_prepare() may bailout with no anon_vma under the VMA lock
after allocating a folio for the hugepage.  In free_huge_folio(), this
folio is completely freed on bailout iff there is a surplus of hugetlb
pages.  This will remove a folio off the freelist and decrement the number
of hugepages while ltp expects these counters to remain unchanged on
failure.  The rest of the ltp testcases pass.


This patch (of 2):

In order to handle hugetlb faults under the VMA lock, hugetlb can use
vmf_anon_prepare() to ensure we can safely prepare an anon_vma.  Change it
to be a non-static function so it can be used within hugetlb as well.

Link: https://lkml.kernel.org/r/20240221234732.187629-6-vishal.moola@gmail.com
Link: https://lkml.kernel.org/r/20240221234732.187629-2-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    1 +
 mm/memory.c   |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/mm/internal.h~mm-memory-change-vmf_anon_prepare-to-be-non-static
+++ a/mm/internal.h
@@ -103,6 +103,7 @@ static inline void wake_throttle_isolate
 		wake_up(wqh);
 }
 
+vm_fault_t vmf_anon_prepare(struct vm_fault *vmf);
 vm_fault_t do_swap_page(struct vm_fault *vmf);
 void folio_rotate_reclaimable(struct folio *folio);
 bool __folio_end_writeback(struct folio *folio);
--- a/mm/memory.c~mm-memory-change-vmf_anon_prepare-to-be-non-static
+++ a/mm/memory.c
@@ -3280,7 +3280,7 @@ static inline vm_fault_t vmf_can_call_fa
 	return VM_FAULT_RETRY;
 }
 
-static vm_fault_t vmf_anon_prepare(struct vm_fault *vmf)
+vm_fault_t vmf_anon_prepare(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-memory-change-vmf_anon_prepare-to-be-non-static.patch
hugetlb-move-vm_struct-declaration-to-the-top-of-hugetlb_fault.patch
hugetlb-pass-struct-vm_fault-through-to-hugetlb_handle_userfault.patch
hugetlb-use-vmf_anon_prepare-instead-of-anon_vma_prepare.patch
hugetlb-allow-faults-to-be-handled-under-the-vma-lock.patch

