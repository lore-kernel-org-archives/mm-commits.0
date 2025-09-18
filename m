Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5F52E9ED7
	for <mm-commits@vger.kernel.org>; Thu, 18 Sep 2025 10:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758191467; cv=none; b=C+JeDeW9oofcEX7paWP8tw6Ndyv44GPqWiEvqB02k/8KKumk6hho9r90FgPM4EdJ2ZzDFHzVdKXlwqyScI3JbT2MLJSJXjKbotScvvJ/uDvgf+nsOwkWD1fhLBY/hOP9UMhmR0fZtAdX0WAOxVtK6Bb0J20F4CczmQ03sqKWVqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758191467; c=relaxed/simple;
	bh=UdVBqTxJLR9BCVvYPKSYijVy0wRj1+TVjbVGmA8Vs4A=;
	h=Date:To:From:Subject:Message-Id; b=R2oMZkJ7R1FyekVo1XQhwstVTLkdrl8gmOZI9l+mqtBvYx65COMbghN+iIZaFZCMGcmqV5dDJKprFKI9I6x6wQFy9D0UTpQ55EFuD+byUJO6o/dRpmpfztp5s7LDw4Ro3yr1z5V8w5VQpFMms8F0F5Aa+HoimdK0d24DI9s2RSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tIh+5Ad7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tIh+5Ad7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7543DC4CEFB;
	Thu, 18 Sep 2025 10:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758191466;
	bh=UdVBqTxJLR9BCVvYPKSYijVy0wRj1+TVjbVGmA8Vs4A=;
	h=Date:To:From:Subject:From;
	b=tIh+5Ad7Mdf0NzWdzrogvq/XCw3BTABuVHIVEffyHkdG6GsaMbvdVZNjdBlHAz9Gu
	 c2ZILhfXEwA5VGzBX+EwsOL7sKEoOY2ozS9moa9ODZui0l8ArrGYWtSEtOmuPm9yU1
	 RvxlWw1p6SgtumcG1AeHsPhdhJyNOt+OWj4w4uJ4=
Date: Thu, 18 Sep 2025 03:31:05 -0700
To: mm-commits@vger.kernel.org,jgg@nvidia.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-abstract-io_remap_pfn_range-based-on-pfn-fix.patch added to mm-unstable branch
Message-Id: <20250918103106.7543DC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: io_remap_pfn_range_pfn fixup
has been added to the -mm mm-unstable branch.  Its filename is
     mm-abstract-io_remap_pfn_range-based-on-pfn-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-abstract-io_remap_pfn_range-based-on-pfn-fix.patch

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
Subject: io_remap_pfn_range_pfn fixup
Date: Thu, 18 Sep 2025 07:41:37 +0100

Link: https://lkml.kernel.org/r/96e4a163-a791-4b08-a006-bdd7ebbecaf9@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/csky/include/asm/pgtable.h |    2 --
 include/linux/mm.h              |   15 ++-------------
 2 files changed, 2 insertions(+), 15 deletions(-)

--- a/arch/csky/include/asm/pgtable.h~mm-abstract-io_remap_pfn_range-based-on-pfn-fix
+++ a/arch/csky/include/asm/pgtable.h
@@ -263,6 +263,4 @@ void update_mmu_cache_range(struct vm_fa
 #define update_mmu_cache(vma, addr, ptep) \
 	update_mmu_cache_range(NULL, vma, addr, ptep, 1)
 
-#define io_remap_pfn_range_pfn(pfn, size) (pfn)
-
 #endif /* __ASM_CSKY_PGTABLE_H */
--- a/include/linux/mm.h~mm-abstract-io_remap_pfn_range-based-on-pfn-fix
+++ a/include/linux/mm.h
@@ -3672,23 +3672,12 @@ static inline vm_fault_t vmf_insert_page
 	return VM_FAULT_NOPAGE;
 }
 
-#ifdef io_remap_pfn_range_pfn
-static inline unsigned long io_remap_pfn_range_prot(pgprot_t prot)
-{
-	/* We do not decrypt if arch customises PFN. */
-	return prot;
-}
-#else
+#ifndef io_remap_pfn_range_pfn
 static inline unsigned long io_remap_pfn_range_pfn(unsigned long pfn,
 		unsigned long size)
 {
 	return pfn;
 }
-
-static inline pgprot_t io_remap_pfn_range_prot(pgprot_t prot)
-{
-	return pgprot_decrypted(prot);
-}
 #endif
 
 static inline int io_remap_pfn_range(struct vm_area_struct *vma,
@@ -3696,7 +3685,7 @@ static inline int io_remap_pfn_range(str
 				     unsigned long size, pgprot_t orig_prot)
 {
 	const unsigned long pfn = io_remap_pfn_range_pfn(orig_pfn, size);
-	const pgprot_t prot = io_remap_pfn_range_prot(orig_prot);
+	const pgprot_t prot = pgprot_decrypted(orig_prot);
 
 	return remap_pfn_range(vma, addr, pfn, size, prot);
 }
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-specify-separate-file-and-vm_file-params-in-vm_area_desc.patch
mm-do-not-assume-file-==-vma-vm_file-in-compat_vma_mmap_prepare.patch
mm-shmem-update-shmem-to-use-mmap_prepare.patch
device-dax-update-devdax-to-use-mmap_prepare.patch
mm-add-vma_desc_size-vma_desc_pages-helpers.patch
relay-update-relay-to-use-mmap_prepare.patch
mm-vma-rename-__mmap_prepare-function-to-avoid-confusion.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete.patch
mm-abstract-io_remap_pfn_range-based-on-pfn.patch
mm-abstract-io_remap_pfn_range-based-on-pfn-fix.patch
mm-introduce-io_remap_pfn_range_.patch
mm-add-ability-to-take-further-action-in-vm_area_desc.patch
doc-update-porting-vfs-documentation-for-mmap_prepare-actions.patch
mm-hugetlbfs-update-hugetlbfs-to-use-mmap_prepare.patch
mm-add-shmem_zero_setup_desc.patch
mm-update-mem-char-driver-to-use-mmap_prepare.patch
mm-update-resctl-to-use-mmap_prepare.patch
mm-oom_killc-fix-inverted-check.patch

