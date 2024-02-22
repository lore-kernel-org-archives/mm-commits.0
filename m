Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE80414B815
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 21:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708638220; cv=none; b=WB7go/Zmt+/+d7SJuRD8N+vRzpZFYn7cfrI9Xkih1aGXWx2NbLzNhc0xWDaaWp5G8H4np8Pga8lMz+/EKrHjQ6lZ7ZIMz0aUutHYnYHcVZYwg89m8WgdBsvhnV/kTOsz+osOIKwIyMk9Jk7Pf2RpdfB5MzbpCkvIYfY2PidUA6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708638220; c=relaxed/simple;
	bh=l8XZT2BDr8gNYt6ES9RlZHlC1Va1CRYn2EwXy3LZ8dk=;
	h=Date:To:From:Subject:Message-Id; b=otZ8d6b6/QS45ycsgYbYy8tRoRaRuEm+Emwd/v9pq1nPxEy7cemVA3ebGFZUpsFlCwVezsYTegApHhMAatW7JjndLH/iPvSrOvpXad5SfvcwPWXT2eL6fDRC4xwuRMuF3TQ5JLw45A1N5nbjPI8IYszJqUpO+m6YWytP1Q1VAlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MLkacSxh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MLkacSxh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AB3C433C7;
	Thu, 22 Feb 2024 21:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708638220;
	bh=l8XZT2BDr8gNYt6ES9RlZHlC1Va1CRYn2EwXy3LZ8dk=;
	h=Date:To:From:Subject:From;
	b=MLkacSxh4npBI2C1h8FcG/KPotSzHS9TL86MkDKgCBZUyb6QW3QbyTgXd9dbDJPSA
	 AQuTA4rc1sIk+sfWYcQNGpC73CUZU7pHDaaflNok37xBsRC0tLzuhUyF9A4v1M0eFB
	 EvNh+ikJzEi351vuttXBdE+rtX7Gb7910jlsjlD0=
Date: Thu, 22 Feb 2024 13:43:39 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,muchun.song@linux.dev,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-allow-faults-to-be-handled-under-the-vma-lock.patch added to mm-unstable branch
Message-Id: <20240222214340.47AB3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: allow faults to be handled under the VMA lock
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-allow-faults-to-be-handled-under-the-vma-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-allow-faults-to-be-handled-under-the-vma-lock.patch

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
Subject: hugetlb: allow faults to be handled under the VMA lock
Date: Wed, 21 Feb 2024 15:47:32 -0800

Hugetlb can now safely handle faults under the VMA lock, so allow it to do
so.

This patch may cause ltp hugemmap10 to "fail".  Hugemmap10 tests hugetlb
counters, and expects the counters to remain unchanged on failure to
handle a fault.

In hugetlb_no_page(), vmf_anon_prepare() may bailout with no anon_vma
under the VMA lock after allocating a folio for the hugepage.  In
free_huge_folio(), this folio is completely freed on bailout iff there is
a surplus of hugetlb pages.  This will remove a folio off the freelist and
decrement the number of hugepages while ltp expects these counters to
remain unchanged on failure.

Originally this could only happen due to OOM failures, but now it may also
occur after we allocate a hugetlb folio without a suitable anon_vma under
the VMA lock.  This should only happen for the first freshly allocated
hugepage in this vma.

Link: https://lkml.kernel.org/r/20240221234732.187629-6-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/hugetlb.c~hugetlb-allow-faults-to-be-handled-under-the-vma-lock
+++ a/mm/hugetlb.c
@@ -6466,12 +6466,6 @@ vm_fault_t hugetlb_fault(struct mm_struc
 		 */
 	};
 
-	/* TODO: Handle faults under the VMA lock */
-	if (flags & FAULT_FLAG_VMA_LOCK) {
-		vma_end_read(vma);
-		return VM_FAULT_RETRY;
-	}
-
 	/*
 	 * Serialize hugepage allocation and instantiation, so that we don't
 	 * get spurious allocation failures if two CPUs race to instantiate
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-memory-change-vmf_anon_prepare-to-be-non-static.patch
hugetlb-move-vm_struct-declaration-to-the-top-of-hugetlb_fault.patch
hugetlb-pass-struct-vm_fault-through-to-hugetlb_handle_userfault.patch
hugetlb-use-vmf_anon_prepare-instead-of-anon_vma_prepare.patch
hugetlb-allow-faults-to-be-handled-under-the-vma-lock.patch

