Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B20A56458;
	Wed, 10 Jul 2024 05:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720589683; cv=none; b=Ubw7txu5Fe6wwJJznI76J8yeJc13rJvwusFFP//qmcmtb0pz2Yg5aJ65IKEEU4KnC0k4ia5SB7i40YEapKeaI/fIftIEibc/8Fc8cdU2OQFe93gcV7gBZJ60kc99Xk5IiO6h7C0vISwjz2pFwxVffMWea7zb4Vq+O7wXKZ1akY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720589683; c=relaxed/simple;
	bh=ho1KHNo/tcnWIm0p7hfN5/hYfW3z/3X5ryqwtCDk1RE=;
	h=Date:To:From:Subject:Message-Id; b=XHU5hL5s0GVu+Y8F2rspzBnspUQT2tholLSWdAeRFNXmsQ0hq7VfAf/1Xt7CvPL6ycQFxJSvKS/Eq56m7u6vt9sRM0/hD4Oyql0yMu+A6hXbYJcR328aQxWeN0TxAQy43gMxirrmvaKcyyjwmt0qwHnn/LmgPnluxEfGisvvtKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ENgWD6KS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ENgWD6KS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD8EC32781;
	Wed, 10 Jul 2024 05:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720589682;
	bh=ho1KHNo/tcnWIm0p7hfN5/hYfW3z/3X5ryqwtCDk1RE=;
	h=Date:To:From:Subject:From;
	b=ENgWD6KSq60yKLd9hmU0GeNvDl4CW+LZSbB3la5qe27zaywJLNWi0Xh2z5WymrsYE
	 xPxqALUvmrLTYXRpxcuhX/XQRtB9/sWvpQZSVbaWA3psjhRXWWxpfPx5I3gWmP+DRb
	 132SvAcx2MjxwGRQHEVCkjFnZMgqHcoycJBlDewQ=
Date: Tue, 09 Jul 2024 22:34:42 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,fengwei.yin@intel.com,david@redhat.com,apopple@nvidia.com,rtummala@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-pte_af-handling-in-fault-path-on-architectures-with-hw-af-support.patch added to mm-hotfixes-unstable branch
Message-Id: <20240710053442.BCD8EC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix PTE_AF handling in fault path on architectures with HW AF support
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-pte_af-handling-in-fault-path-on-architectures-with-hw-af-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-pte_af-handling-in-fault-path-on-architectures-with-hw-af-support.patch

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
From: Ram Tummala <rtummala@nvidia.com>
Subject: mm: fix PTE_AF handling in fault path on architectures with HW AF support
Date: Tue, 9 Jul 2024 17:09:42 -0700

Commit 3bd786f76de2 ("mm: convert do_set_pte() to set_pte_range()")
replaced do_set_pte() with set_pte_range() and that introduced a
regression in the following faulting path of non-anonymous vmas on CPUs
with HW AF (Access Flag) support.

handle_pte_fault()
  do_pte_missing()
    do_fault()
      do_read_fault() || do_cow_fault() || do_shared_fault()
        finish_fault()
          set_pte_range()

The polarity of prefault calculation is incorrect.  This leads to prefault
being incorrectly set for the faulting address.  The following if check
will incorrectly clear the PTE_AF bit instead of setting it and the access
will fault again on the same address due to the missing PTE_AF bit.

    if (prefault && arch_wants_old_prefaulted_pte())
        entry = pte_mkold(entry);

On a subsequent fault on the same address, the faulting path will see a
non NULL vmf->pte and instead of reaching the do_pte_missing() path,
PTE_AF will be correctly set in handle_pte_fault() itself.

Due to this bug, performance degradation in the fault handling path will
be observed due to unnecessary double faulting.

Link: https://lkml.kernel.org/r/20240710000942.623704-1-rtummala@nvidia.com
Fixes: 3bd786f76de2 ("mm: convert do_set_pte() to set_pte_range()")
Signed-off-by: Ram Tummala <rtummala@nvidia.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-fix-pte_af-handling-in-fault-path-on-architectures-with-hw-af-support
+++ a/mm/memory.c
@@ -4681,7 +4681,7 @@ void set_pte_range(struct vm_fault *vmf,
 {
 	struct vm_area_struct *vma = vmf->vma;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
-	bool prefault = in_range(vmf->address, addr, nr * PAGE_SIZE);
+	bool prefault = !in_range(vmf->address, addr, nr * PAGE_SIZE);
 	pte_t entry;
 
 	flush_icache_pages(vma, page, nr);
_

Patches currently in -mm which might be from rtummala@nvidia.com are

mm-fix-pte_af-handling-in-fault-path-on-architectures-with-hw-af-support.patch

