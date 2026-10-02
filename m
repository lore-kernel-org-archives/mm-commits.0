Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5C43E8C4C
	for <mm-commits@vger.kernel.org>; Fri,  2 Oct 2026 06:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790922144; cv=none; b=G4vxwlKv50bZcNljrODqkNWs4ANNWvFidD18tpWmitolISO0fXtH1bRvuAm1YwzhpqibjQuNyNQq35+pEbKgpBm6bKITGyiaYfKs8PX8xqgZ9ZjWqwHe1ZYTt1bS8pqj58NBljFd8OlGl/3peaYu6JOgwBaWUdWOibjkf4RLEiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790922144; c=relaxed/simple;
	bh=R1aK3BmoF8SRCLQv1q1ysVxC8K3640gFDTNrN1CLXOs=;
	h=Message-ID:Date:MIME-Version:From:To:Cc:Subject:Content-Type; b=Qg/6QsQscmF/7xQUMHW/OVv30A5wk/N4hRX0G5H0sYMhUwIWuA+cTifEDrLJ1LuCu7LLst5DkQJmnyXzF33IDFx74SuPVrOojur3HKDk+QFPp7ahwB9mmA/+rvlMx6kEfFel23YV+nSVTpIB+oprJ69J38OHC8QubrhEOYnak0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jaHTqPPU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jaHTqPPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0F61F000FF;
	Fri,  2 Oct 2026 06:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790922142;
	bh=QpZvxFpLW6YmFbfkE1kfaGx97zUKAL7jiZ+F9v+EcAA=;
	h=Date:From:To:Cc:Subject;
	b=jaHTqPPU3sqfrheu/uCvWGn/NO4OTHpKZ2og0323WCoMSwV2wyWYG+SQOO/BTwQN0
	 Fi6QMYp/v+V5ATa8qHUdSsORC/AAojLGJ16+IQ5gc0r+WS+1zQ5apgo59uSkgWqUok
	 LvqjgSNcZ2wgtd2jMHLcIWJ/HLfrg+JKQqhELASVkrL2huFNE1Es1V31G+YEOJ3fU8
	 ymBwmr+h1e6VJiTljypg4Unq2Ai0QEKgh4hPgYmIzISp5dFR9TvUwbV3dszG3MuuTu
	 j3PlaiHw+8byKNAEBLfBfHgOUrKqF4co0iCg5VobWwieBINGuClsFffCJwKmpsh7jy
	 HBplbPVkYEfeQ==
Message-ID: <75edc952-3ada-4875-b3a9-6338d6f4d36e@kernel.org>
Date: Fri, 2 Oct 2026 08:22:17 +0200
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 "Lorenzo Stoakes (Arm)" <ljs@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>, Zi Yan <ziy@nvidia.com>
Subject: mm-next: manual merge of the akpm/mm-unstable branch
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

today's mm-next merge of the akpm/mm-unstable branch tree got a conflict in:

  arch/arm64/kvm/mmu.c

between the commit:

  71cc2c67fb8f KVM: arm64: Use stage-1 leaf size for VM_PFNMAP

from Linus' tree and commits:

  7a41ed87f53f mm: drop some redundant checks around hugetlb VMAs
  f09773c2c4d0 mm: rename is_vm_hugetlb_page() to vma_is_hugetlb()

from the akpm/mm-unstable branch.

I resolved the conflicts manually:


diff --cc arch/arm64/kvm/mmu.c
index bf6d6526639f,73c8492e85c4..b0ea1a9391da
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@@ -1468,11 -1468,30 +1468,11 @@@ transparent_hugepage_adjust(struct kvm
        return PAGE_SIZE;
  }

 -static int get_vma_page_shift(struct vm_area_struct *vma, unsigned long hva)
 +static int get_vma_page_shift(struct vm_area_struct *vma)
  {
-       if (is_vm_hugetlb_page(vma))
 -      unsigned long pa;
 -
+       if (vma_is_hugetlb(vma))
                return huge_page_shift(hstate_vma(vma));

 -      if (!(vma->vm_flags & VM_PFNMAP))
 -              return PAGE_SHIFT;
 -
 -      pa = (vma->vm_pgoff << PAGE_SHIFT) + (hva - vma->vm_start);
 -
 -#ifndef __PAGETABLE_PMD_FOLDED
 -      if ((hva & (PUD_SIZE - 1)) == (pa & (PUD_SIZE - 1)) &&
 -          ALIGN_DOWN(hva, PUD_SIZE) >= vma->vm_start &&
 -          ALIGN(hva, PUD_SIZE) <= vma->vm_end)
 -              return PUD_SHIFT;
 -#endif
 -
 -      if ((hva & (PMD_SIZE - 1)) == (pa & (PMD_SIZE - 1)) &&
 -          ALIGN_DOWN(hva, PMD_SIZE) >= vma->vm_start &&
 -          ALIGN(hva, PMD_SIZE) <= vma->vm_end)
 -              return PMD_SHIFT;
 -
        return PAGE_SHIFT;
  }

-- 
Cheers,

David

