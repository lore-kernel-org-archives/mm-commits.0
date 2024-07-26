Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41045149C40;
	Fri, 26 Jul 2024 20:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722026289; cv=none; b=ASyQ8fYJjG8h1biv1wfaCnlH2mWmHz5/J1XnANTfUkQXnTdfXEdcFiYEop9TQ4bwXlLaSLwKWdKtx94TTvhV5fVNgHwY/3QaIucQyzhM+9e1KSsFEZb40xfUwgGVfbtuvwsZKj9CuQTMVpXz7sjD+HzKwJ3TDZ5w3O5VwTY8m/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722026289; c=relaxed/simple;
	bh=7CkVEFKSO5Qeoq0TPhttOriIxrZN99AwN+jGkrctOzU=;
	h=Date:To:From:Subject:Message-Id; b=Y0u1b7cEQtR64XJlRaDfA0XravBe40wLYqVSC+ppE38uwOVkxdpXkpTr8Q7lzYWS4VBkN3WNiwYTmu21SLjqUKk/xP11vITOiw1JdOV0irP950cXl4RnTGqFK5xBK4aHY/dhF3NXCciBtjwizZboZDGUBXc5FpRQ17oXXlUfMrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pLoNN0W9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pLoNN0W9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0538C32782;
	Fri, 26 Jul 2024 20:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722026288;
	bh=7CkVEFKSO5Qeoq0TPhttOriIxrZN99AwN+jGkrctOzU=;
	h=Date:To:From:Subject:From;
	b=pLoNN0W90qBESIFjdWlrL9knDr1wCVPhAsaQoUsRx2lUpa8VosZvtqsStP4T0zCaZ
	 /0qgQqUTrLwlmHD0WIpZfkPmWp0tek1Ez3BFI5clP5hWBM0KWnJ8oO9zYaHFpghqko
	 g4TQV4acwGSktayjZNuu6Q154HmCn9fkTKCbYhoY=
Date: Fri, 26 Jul 2024 13:38:08 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,fengwei.yin@intel.com,apopple@nvidia.com,rtummala@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-old-young-bit-handling-in-the-faulting-path.patch removed from -mm tree
Message-Id: <20240726203808.C0538C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix old/young bit handling in the faulting path
has been removed from the -mm tree.  Its filename was
     mm-fix-old-young-bit-handling-in-the-faulting-path.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -4780,7 +4780,7 @@ void set_pte_range(struct vm_fault *vmf,
 {
 	struct vm_area_struct *vma = vmf->vma;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
-	bool prefault = in_range(vmf->address, addr, nr * PAGE_SIZE);
+	bool prefault = !in_range(vmf->address, addr, nr * PAGE_SIZE);
 	pte_t entry;
 
 	flush_icache_pages(vma, page, nr);
_

Patches currently in -mm which might be from rtummala@nvidia.com are


