Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995D7190472;
	Wed, 10 Jul 2024 16:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720630102; cv=none; b=dEONWQP5nhcQFUW3K9C3cD0fkykYGc3IkpxyC1PZ5pHlL9P1zDMetnTUIWrlUd2I6w34BgK3O3DsvQzznQx691uTIqz0oz5Ew1PAElZVPcgZzJrPaQySRa1v7mPo5gJov/p7APbQQoYbVC4MW+/KdtBRTxCwkzaHITSCa3BztMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720630102; c=relaxed/simple;
	bh=VCCzzH/NSQUKQm99wAA3ow4vbwKbj/C8OQUJaCCRmVo=;
	h=Date:To:From:Subject:Message-Id; b=tIdZVCVAAUAkF45p+UmQ7uJi2iT2/fq6PIqMheTOJTCJTo5UbOGnTt3oUOHOIScaIsiWw10hio9chYzq1gGrjv5KMK/95RNVDFM5ahhdT7p/F9+sYW7eZ7nO34Z0hoqRyfQ0vKsCUgPW+f4EvTNrRscBQW2nHz1psmL6liYxXis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aoChw0ft; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aoChw0ft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13DEAC32781;
	Wed, 10 Jul 2024 16:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720630102;
	bh=VCCzzH/NSQUKQm99wAA3ow4vbwKbj/C8OQUJaCCRmVo=;
	h=Date:To:From:Subject:From;
	b=aoChw0ftDuLweQfMJ0G1Bs92qjxNIo47yUjjc/pcon6yfWcvHmMNDrFBuEO4Cz9a1
	 xS8cc1zAu6sIHWqKlyFn3jaPSutYfqXEwa8hTHLgqXftuNGzVbtmGTp0x+YJLAi7Mq
	 ZZcuJeVt07YM5Ai17Y7J+jfM9ZSa2eeg+ALXYuQQ=
Date: Wed, 10 Jul 2024 09:48:21 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,fengwei.yin@intel.com,apopple@nvidia.com,rtummala@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-old-young-bit-handling-in-the-faulting-path.patch added to mm-hotfixes-unstable branch
Message-Id: <20240710164822.13DEAC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix old/young bit handling in the faulting path
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-old-young-bit-handling-in-the-faulting-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-old-young-bit-handling-in-the-faulting-path.patch

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
Subject: mm: fix old/young bit handling in the faulting path
Date: Tue, 9 Jul 2024 18:45:39 -0700

Commit 3bd786f76de2 ("mm: convert do_set_pte() to set_pte_range()")
replaced do_set_pte() with set_pte_range() and that introduced a
regression in the following faulting path of non-anonymous vmas which
caused the PTE for the faulting address to be marked as old instead of
young.

handle_pte_fault()
  do_pte_missing()
    do_fault()
      do_read_fault() || do_cow_fault() || do_shared_fault()
        finish_fault()
          set_pte_range()

The polarity of prefault calculation is incorrect.  This leads to prefault
being incorrectly set for the faulting address.  The following check will
incorrectly mark the PTE old rather than young.  On some architectures
this will cause a double fault to mark it young when the access is
retried.

    if (prefault && arch_wants_old_prefaulted_pte())
        entry = pte_mkold(entry);

On a subsequent fault on the same address, the faulting path will see a
non NULL vmf->pte and instead of reaching the do_pte_missing() path, PTE
will then be correctly marked young in handle_pte_fault() itself.

Due to this bug, performance degradation in the fault handling path will
be observed due to unnecessary double faulting.

Link: https://lkml.kernel.org/r/20240710014539.746200-1-rtummala@nvidia.com
Fixes: 3bd786f76de2 ("mm: convert do_set_pte() to set_pte_range()")
Signed-off-by: Ram Tummala <rtummala@nvidia.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-fix-old-young-bit-handling-in-the-faulting-path
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

mm-fix-old-young-bit-handling-in-the-faulting-path.patch

