Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDF519C546;
	Sat, 12 Oct 2024 22:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728773392; cv=none; b=jzKfNAoCFXxf5Fh1x4Ml7yLFrKbS2XeF/opDZ/Ya/GG5+fTUssAQqDLHRbde3GgfCJbn4I4iLFj+DhoR7eCzdgnLjNWw+LAdExR2dR9REFp9l+tlE2saIvABeUHQKwLXKMgpupjam4ycBpeJoNWKhFDDO0kNtupFnWm2m2HLiBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728773392; c=relaxed/simple;
	bh=Xsk0AvS0O4Wbp1maisU8BAhHelTB8hhY1D9tSaM5ABw=;
	h=Date:To:From:Subject:Message-Id; b=S7kY9wexBFmTyz4YXd0HxgT7+47JekEqOzfP/1daWcX6JCiwvuPrk+/D8mG8rcxZrAVHCMhN73+FPbkRCt6J50/uTc5T++mC4R4QMLS4JIjomXsoz9sQUiD/zwWvgD9Pt/CT6NxKi/06e/+BZqeE7g0gQyNdrPpmhQxqXDUgSP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qLElkrr0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qLElkrr0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55548C4CEC6;
	Sat, 12 Oct 2024 22:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728773392;
	bh=Xsk0AvS0O4Wbp1maisU8BAhHelTB8hhY1D9tSaM5ABw=;
	h=Date:To:From:Subject:From;
	b=qLElkrr0R+3Ybuy5KEkGAXdV57UqLXbJTA6KDc3bG0DnBiqDVmHDLwg8Bv+X2NHG+
	 c7y+Rd8I0ZdlYL4kpMYVYR1uvSDXOiXZLX0kZtuM9cXThoXr3427jvQpwz/3jcP+qc
	 jDv2T1Ll8otyi/LLemMB7hiSGGt4uvA8KWw8iWL0=
Date: Sat, 12 Oct 2024 15:49:51 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,thuth@redhat.com,stable@vger.kernel.org,ryan.roberts@arm.com,imbrenda@linux.ibm.com,hughd@google.com,frankja@linux.ibm.com,borntraeger@linux.ibm.com,bfu@redhat.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-dont-install-pmd-mappings-when-thps-are-disabled-by-the-hw-process-vma.patch added to mm-hotfixes-unstable branch
Message-Id: <20241012224952.55548C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: don't install PMD mappings when THPs are disabled by the hw/process/vma
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-dont-install-pmd-mappings-when-thps-are-disabled-by-the-hw-process-vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-dont-install-pmd-mappings-when-thps-are-disabled-by-the-hw-process-vma.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm: don't install PMD mappings when THPs are disabled by the hw/process/vma
Date: Fri, 11 Oct 2024 12:24:45 +0200

We (or rather, readahead logic :) ) might be allocating a THP in the
pagecache and then try mapping it into a process that explicitly disabled
THP: we might end up installing PMD mappings.

This is a problem for s390x KVM, which explicitly remaps all PMD-mapped
THPs to be PTE-mapped in s390_enable_sie()->thp_split_mm(), before
starting the VM.

For example, starting a VM backed on a file system with large folios
supported makes the VM crash when the VM tries accessing such a mapping
using KVM.

Is it also a problem when the HW disabled THP using
TRANSPARENT_HUGEPAGE_UNSUPPORTED?  At least on x86 this would be the case
without X86_FEATURE_PSE.

In the future, we might be able to do better on s390x and only disallow
PMD mappings -- what s390x and likely TRANSPARENT_HUGEPAGE_UNSUPPORTED
really wants.  For now, fix it by essentially performing the same check as
would be done in __thp_vma_allowable_orders() or in shmem code, where this
works as expected, and disallow PMD mappings, making us fallback to PTE
mappings.

Link: https://lkml.kernel.org/r/20241011102445.934409-3-david@redhat.com
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Leo Fu <bfu@redhat.com>
Tested-by: Thomas Huth <thuth@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/memory.c~mm-dont-install-pmd-mappings-when-thps-are-disabled-by-the-hw-process-vma
+++ a/mm/memory.c
@@ -4931,6 +4931,15 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 	pmd_t entry;
 	vm_fault_t ret = VM_FAULT_FALLBACK;
 
+	/*
+	 * It is too late to allocate a small folio, we already have a large
+	 * folio in the pagecache: especially s390 KVM cannot tolerate any
+	 * PMD mappings, but PTE-mapped THP are fine. So let's simply refuse any
+	 * PMD mappings if THPs are disabled.
+	 */
+	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vma->vm_flags))
+		return ret;
+
 	if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
 		return ret;
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-dont-install-pmd-mappings-when-thps-are-disabled-by-the-hw-process-vma.patch
selftests-mm-hugetlb_fault_after_madv-use-default-hguetlb-page-size.patch
selftests-mm-hugetlb_fault_after_madv-improve-test-output.patch

