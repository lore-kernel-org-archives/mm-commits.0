Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FBD22C86D
	for <mm-commits@vger.kernel.org>; Fri, 12 Sep 2025 23:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757718949; cv=none; b=d2XoCzUie6+Xc3IZKDN3a9nsRRr7Al6S1Au4e5qKjPeu1NLlcPYbYmESjcfjz5NVyKi7z1aDVbvvSfynVIFcAYTD9bvqETQs2+roCtIX8LMsrpMRb7NacwXAAmct17ZmeO+duzru640EQyAs7rffl83nF8TDNeyh11pdP5VrxjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757718949; c=relaxed/simple;
	bh=RjKJUg+ekcbX8D2F3YQZwIPbZuWRVDJACvLUWOkLu8U=;
	h=Date:To:From:Subject:Message-Id; b=CG44mtaVaqUJaSdQdrjoZvj9zOgnaKynNkWl7IlI5ShK1RbeTb9kQYaZRRUbVrM1TP04jprsHwmP6ru/tbC27SXYuwc2TbhvZ4qGZBiXfnOaOdBwVuKHJmsZ64bf+t4luoPV6HxYJdAqgLkg1IGvLHMqWyCNmKxJekRuyy2n2/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ugx5IKdR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ugx5IKdR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CA6C4CEF1;
	Fri, 12 Sep 2025 23:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757718947;
	bh=RjKJUg+ekcbX8D2F3YQZwIPbZuWRVDJACvLUWOkLu8U=;
	h=Date:To:From:Subject:From;
	b=Ugx5IKdR8/qkflM+kbw+796UMiUFSkU6CFyfQucVHA07YoGq1/2+8O3hua8wkTAHI
	 iyhowiRQ2+pE+aGJE4vT8nrIhOKrEVOdVJrI+Ahng1aAtL5Th3fAnIQeG21JUDHkNH
	 IShBgRL4ZE9EIK7MstdoyQnx6hN8UJdGOGpkN2sA=
Date: Fri, 12 Sep 2025 16:15:47 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-io_remap_pfn_range_-fix.patch added to mm-unstable branch
Message-Id: <20250912231547.92CA6C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sparc fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-io_remap_pfn_range_-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-io_remap_pfn_range_-fix.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: sparc fix
Date: Fri, 12 Sep 2025 10:58:23 +0100

Link: https://lkml.kernel.org/r/ce124bd3-ee49-498a-ae23-47a4797f03bd@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgtable_32.h |    3 +++
 arch/sparc/include/asm/pgtable_64.h |    3 +++
 2 files changed, 6 insertions(+)

--- a/arch/sparc/include/asm/pgtable_32.h~mm-introduce-io_remap_pfn_range_-fix
+++ a/arch/sparc/include/asm/pgtable_32.h
@@ -397,6 +397,9 @@ __get_iospace (unsigned long addr)
 
 int remap_pfn_range(struct vm_area_struct *, unsigned long, unsigned long,
 		    unsigned long, pgprot_t);
+void remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long pfn);
+int remap_pfn_range_complete(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long pfn, unsigned long size, pgprot_t pgprot);
 
 static inline unsigned long calc_io_remap_pfn(unsigned long pfn)
 {
--- a/arch/sparc/include/asm/pgtable_64.h~mm-introduce-io_remap_pfn_range_-fix
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -1050,6 +1050,9 @@ int page_in_phys_avail(unsigned long pad
 
 int remap_pfn_range(struct vm_area_struct *, unsigned long, unsigned long,
 		    unsigned long, pgprot_t);
+void remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long pfn);
+int remap_pfn_range_complete(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long pfn, unsigned long size, pgprot_t pgprot);
 
 void adi_restore_tags(struct mm_struct *mm, struct vm_area_struct *vma,
 		      unsigned long addr, pte_t pte);
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-jann-horn-as-rmap-reviewer.patch
mm-add-bitmap-mm-flags-field.patch
mm-add-bitmap-mm-flags-field-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors.patch
mm-convert-prctl-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors-fix.patch
mm-convert-uprobes-to-mm_flags_-accessors.patch
mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags.patch
mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags-fix.patch
mm-correct-sign-extension-issue-in-mmf_-flag-masks.patch
mm-correct-sign-extension-issue-in-mmf_-flag-masks-fix.patch
mm-update-fork-mm-flags-initialisation-to-use-bitmap.patch
mm-convert-remaining-users-to-mm_flags_-accessors.patch
mm-replace-mm-flags-with-bitmap-entirely-and-set-to-64-bits.patch
mm-specify-separate-file-and-vm_file-params-in-vm_area_desc.patch
mm-do-not-assume-file-==-vma-vm_file-in-compat_vma_mmap_prepare.patch
mm-shmem-update-shmem-to-use-mmap_prepare.patch
device-dax-update-devdax-to-use-mmap_prepare.patch
mm-add-vma_desc_size-vma_desc_pages-helpers.patch
relay-update-relay-to-use-mmap_prepare.patch
mm-vma-rename-__mmap_prepare-function-to-avoid-confusion.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete.patch
mm-introduce-io_remap_pfn_range_.patch
mm-introduce-io_remap_pfn_range_-fix.patch
mm-add-ability-to-take-further-action-in-vm_area_desc.patch
mm-add-ability-to-take-further-action-in-vm_area_desc-fix.patch
doc-update-porting-vfs-documentation-for-mmap_prepare-actions.patch
mm-hugetlbfs-update-hugetlbfs-to-use-mmap_prepare.patch
mm-update-mem-char-driver-to-use-mmap_prepare.patch
mm-update-resctl-to-use-mmap_prepare.patch
mm-update-cramfs-to-use-mmap_prepare.patch
fs-proc-add-the-proc_mmap_prepare-hook-for-procfs.patch
fs-proc-update-vmcore-to-use-proc_mmap_prepare.patch
kcov-update-kcov-to-use-mmap_prepare.patch

