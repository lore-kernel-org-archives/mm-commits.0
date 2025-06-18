Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FB23085CC
	for <mm-commits@vger.kernel.org>; Wed, 18 Jun 2025 22:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750287388; cv=none; b=M2elxow0bsuBMuX6vmAJkB8PEYrVDtaBavzqPVNSipqdyX85m/vdCKhIUvc7whXf3LAq57G+GCmAvo7vt126//UeW9iTJRZvrZ/1aNwO7fONLX30/+cX2cOvfo6xxm760LXk4snR8JoE1U4W81zV32/EXkA7WRQXX9fEabamouI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750287388; c=relaxed/simple;
	bh=0Wp9+glmpu7iG53npHan9ZTGnbdqREq6QyOcLVlxxTw=;
	h=Date:To:From:Subject:Message-Id; b=XSnuqRfNspOIazsZao5nD79QYAIomvdsKZMr9QQm4O5eHXHsEZCRmE8FoZ3OEYr1t3ZQM5vR3NzRy2KoDPPg7MT5NhxpekkRyM8m5DLe9MO//p1sbDrxILT0bGUqKO4ArWnbVrQFoTCloTPNrkXVOz6JRZaJVfsDp91pJwPOIuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PUdJWr7g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PUdJWr7g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7199C4CEE7;
	Wed, 18 Jun 2025 22:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750287387;
	bh=0Wp9+glmpu7iG53npHan9ZTGnbdqREq6QyOcLVlxxTw=;
	h=Date:To:From:Subject:From;
	b=PUdJWr7gKUSqOYle6y3QF6z4OkDHR3yYE+6k4l0Csb4dbZnlCMuMC2gP5Mz6d63RJ
	 gyfZV1cQtCPsEhIb4SMpUQGfGcq8T04j7l4VOSGBlRziAwD8mRNGIwkasAX3EOcoMj
	 vklqrChWlwUBN6iMNFCGWlNPrxuZV1GA4Rc9jKD8=
Date: Wed, 18 Jun 2025 15:56:26 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,Liam.Howlett@oracle.com,kees@kernel.org,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument.patch added to mm-new branch
Message-Id: <20250618225627.B7199C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: change vm_get_page_prot() to accept vm_flags_t argument
has been added to the -mm mm-new branch.  Its filename is
     mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm: change vm_get_page_prot() to accept vm_flags_t argument
Date: Wed, 18 Jun 2025 20:42:52 +0100

Patch series "use vm_flags_t consistently".

The VMA flags field vma->vm_flags is of type vm_flags_t.  Right now this
is exactly equivalent to unsigned long, but it should not be assumed to
be.

Much code that references vma->vm_flags already correctly uses vm_flags_t,
but a fairly large chunk of code simply uses unsigned long and assumes
that the two are equivalent.

This series corrects that and has us use vm_flags_t consistently.

This series is motivated by the desire to, in a future series, adjust
vm_flags_t to be a u64 regardless of whether the kernel is 32-bit or
64-bit in order to deal with the VMA flag exhaustion issue and avoid all
the various problems that arise from it (being unable to use certain
features in 32-bit, being unable to add new flags except for 64-bit, etc.)

This is therefore a critical first step towards that goal.  At any rate,
using the correct type is of value regardless.

We additionally take the opportunity to refer to VMA flags as vm_flags
where possible to make clear what we're referring to.

Overall, this series does not introduce any functional change.


This patch (of 3):

We abstract the type of the VMA flags to vm_flags_t, however in may places
it is simply assumed this is unsigned long, which is simply incorrect.

At the moment this is simply an incongruity, however in future we plan to
change this type and therefore this change is a critical requirement for
doing so.

Overall, this patch does not introduce any functional change.

Link: https://lkml.kernel.org/r/cover.1750274467.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/a12769720a2743f235643b158c4f4f0a9911daf0.1750274467.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmap.c                       |    2 +-
 arch/powerpc/include/asm/book3s/64/pkeys.h |    3 ++-
 arch/sparc/mm/init_64.c                    |    2 +-
 arch/x86/mm/pgprot.c                       |    2 +-
 include/linux/mm.h                         |    4 ++--
 include/linux/pgtable.h                    |    2 +-
 tools/testing/vma/vma_internal.h           |    2 +-
 7 files changed, 9 insertions(+), 8 deletions(-)

--- a/arch/arm64/mm/mmap.c~mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument
+++ a/arch/arm64/mm/mmap.c
@@ -81,7 +81,7 @@ static int __init adjust_protection_map(
 }
 arch_initcall(adjust_protection_map);
 
-pgprot_t vm_get_page_prot(unsigned long vm_flags)
+pgprot_t vm_get_page_prot(vm_flags_t vm_flags)
 {
 	ptdesc_t prot;
 
--- a/arch/powerpc/include/asm/book3s/64/pkeys.h~mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument
+++ a/arch/powerpc/include/asm/book3s/64/pkeys.h
@@ -4,8 +4,9 @@
 #define _ASM_POWERPC_BOOK3S_64_PKEYS_H
 
 #include <asm/book3s/64/hash-pkey.h>
+#include <linux/mm_types.h>
 
-static inline u64 vmflag_to_pte_pkey_bits(u64 vm_flags)
+static inline u64 vmflag_to_pte_pkey_bits(vm_flags_t vm_flags)
 {
 	if (!mmu_has_feature(MMU_FTR_PKEY))
 		return 0x0UL;
--- a/arch/sparc/mm/init_64.c~mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument
+++ a/arch/sparc/mm/init_64.c
@@ -3201,7 +3201,7 @@ void copy_highpage(struct page *to, stru
 }
 EXPORT_SYMBOL(copy_highpage);
 
-pgprot_t vm_get_page_prot(unsigned long vm_flags)
+pgprot_t vm_get_page_prot(vm_flags_t vm_flags)
 {
 	unsigned long prot = pgprot_val(protection_map[vm_flags &
 					(VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)]);
--- a/arch/x86/mm/pgprot.c~mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument
+++ a/arch/x86/mm/pgprot.c
@@ -32,7 +32,7 @@ void add_encrypt_protection_map(void)
 		protection_map[i] = pgprot_encrypted(protection_map[i]);
 }
 
-pgprot_t vm_get_page_prot(unsigned long vm_flags)
+pgprot_t vm_get_page_prot(vm_flags_t vm_flags)
 {
 	unsigned long val = pgprot_val(protection_map[vm_flags &
 				      (VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)]);
--- a/include/linux/mm.h~mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument
+++ a/include/linux/mm.h
@@ -3487,10 +3487,10 @@ static inline bool range_in_vma(struct v
 }
 
 #ifdef CONFIG_MMU
-pgprot_t vm_get_page_prot(unsigned long vm_flags);
+pgprot_t vm_get_page_prot(vm_flags_t vm_flags);
 void vma_set_page_prot(struct vm_area_struct *vma);
 #else
-static inline pgprot_t vm_get_page_prot(unsigned long vm_flags)
+static inline pgprot_t vm_get_page_prot(vm_flags_t vm_flags)
 {
 	return __pgprot(0);
 }
--- a/include/linux/pgtable.h~mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument
+++ a/include/linux/pgtable.h
@@ -2001,7 +2001,7 @@ typedef unsigned int pgtbl_mod_mask;
  *								x: (yes) yes
  */
 #define DECLARE_VM_GET_PAGE_PROT					\
-pgprot_t vm_get_page_prot(unsigned long vm_flags)			\
+pgprot_t vm_get_page_prot(vm_flags_t vm_flags)				\
 {									\
 		return protection_map[vm_flags &			\
 			(VM_READ | VM_WRITE | VM_EXEC | VM_SHARED)];	\
--- a/tools/testing/vma/vma_internal.h~mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument
+++ a/tools/testing/vma/vma_internal.h
@@ -581,7 +581,7 @@ static inline pgprot_t pgprot_modify(pgp
 	return __pgprot(pgprot_val(oldprot) | pgprot_val(newprot));
 }
 
-static inline pgprot_t vm_get_page_prot(unsigned long vm_flags)
+static inline pgprot_t vm_get_page_prot(vm_flags_t vm_flags)
 {
 	return __pgprot(vm_flags);
 }
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-missing-mm-workingsetc-file-to-mm-reclaim-section.patch
maintainers-add-missing-test-files-to-mm-gup-section.patch
maintainers-add-further-init-files-to-mm-init-block.patch
maintainers-add-hugetlb_cgroupc-to-hugetlb-section.patch
maintainers-add-stray-rmap-file-to-mm-rmap-section.patch
maintainers-add-memfd-shmem-quota-files-to-shmem-section.patch
maintainers-add-additional-mmap-related-files-to-mmap-section.patch
docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-use-per_vma-lock-for-madv_dontneed-fix.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon-fix.patch
mm-mremap-add-mremap_must_relocate_anon.patch
mm-mremap-add-mremap_relocate_anon-support-for-large-folios.patch
tools-uapi-update-copy-of-linux-mmanh-from-the-kernel-sources.patch
tools-testing-selftests-add-sys_mremap-helper-to-vm_utilh.patch
tools-testing-selftests-add-mremap-cases-that-merge-normally.patch
tools-testing-selftests-add-mremap_relocate_anon-merge-test-cases.patch
tools-testing-selftests-expand-mremap-tests-for-mremap_relocate_anon.patch
tools-testing-selftests-have-cow-self-test-use-mremap_relocate_anon.patch
tools-testing-selftests-test-relocate-anon-in-split-huge-page-test.patch
tools-testing-selftests-add-mremap_relocate_anon-fork-tests.patch
secretmem-remove-uses-of-struct-page-fix.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge.patch
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument.patch
mm-update-core-kernel-code-to-use-vm_flags_t-consistently.patch
mm-update-architecture-and-driver-code-to-use-vm_flags_t.patch

