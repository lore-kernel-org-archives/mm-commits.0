Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03D3283FE4
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126318; cv=none; b=irqKTGka5FzZ5ozo+DDpnOc47S72sXPIV1T1q2N7JcknPrxaCCspPvYNi6LC4G5mnXiSaQDsU8R6dzIEfI8sLR8615jy0+PZdDovfV4djZca3k2Qr0Dtl4y/bWlcJE03K0tnOI4yKXmVgOJ/jvaKjwBTsU4jHHGHSSFem8TqsTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126318; c=relaxed/simple;
	bh=xAg8bb1Xoy0uVjjJU8COvcNj9mivQ/kuXpjp/xdHxcg=;
	h=Date:To:From:Subject:Message-Id; b=ax1nY0pmmyrz5gRMBFKwXm/rJsI+XPB6Vv3yb31tE4uay8xNfntJA4Y3isWHnh7j/6ebY87FvuAbL0HqXqi+D7QPmPdPp7VpH6qcar9zV8AfbJ2fbNk0yn6sTygA/Nsbz+CsXLId9Dit0/2gEGwcNibB/FlDIZCePR49CZUPnps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FYW0tzLZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FYW0tzLZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77682C4CEE3;
	Thu, 10 Jul 2025 05:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126318;
	bh=xAg8bb1Xoy0uVjjJU8COvcNj9mivQ/kuXpjp/xdHxcg=;
	h=Date:To:From:Subject:From;
	b=FYW0tzLZLMt4krjPLOa8eCOXYyj0mAR1L8IHDdgF9CfS0y/Af5GV2Jb3Tj8BDkf0w
	 eZXRVkEqeixmJ4nbcZm17BClT890rFl4zLdRKcf478QUYyeDoY5LT5yax+9NHk7cfp
	 uC8PRixrN4ZiHOR/byySfrYG/sBmypT46fruspX4=
Date: Wed, 09 Jul 2025 22:45:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,rppt@kernel.org,pfalcato@suse.de,osalvador@suse.de,Liam.Howlett@oracle.com,kees@kernel.org,jarkko@kernel.org,jannh@google.com,jack@suse.cz,david@redhat.com,catalin.marinas@arm.com,brauner@kernel.org,anshuman.khandual@arm.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument.patch removed from -mm tree
Message-Id: <20250710054518.77682C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: change vm_get_page_prot() to accept vm_flags_t argument
has been removed from the -mm tree.  Its filename was
     mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[lorenzo.stoakes@oracle.com: add missing vm_get_page_prot() instance, remove include]
  Link: https://lkml.kernel.org/r/552f88e1-2df8-4e95-92b8-812f7c8db829@lucifer.local
Link: https://lkml.kernel.org/r/cover.1750274467.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/a12769720a2743f235643b158c4f4f0a9911daf0.1750274467.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Christian Brauner <brauner@kernel.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>	[arm64]
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmap.c                       |    2 +-
 arch/powerpc/include/asm/book3s/64/pkeys.h |    2 +-
 arch/powerpc/mm/book3s64/pgtable.c         |    2 +-
 arch/sparc/mm/init_64.c                    |    2 +-
 arch/x86/mm/pgprot.c                       |    2 +-
 include/linux/mm.h                         |    4 ++--
 include/linux/pgtable.h                    |    2 +-
 tools/testing/vma/vma_internal.h           |    2 +-
 8 files changed, 9 insertions(+), 9 deletions(-)

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
@@ -5,7 +5,7 @@
 
 #include <asm/book3s/64/hash-pkey.h>
 
-static inline u64 vmflag_to_pte_pkey_bits(u64 vm_flags)
+static inline u64 vmflag_to_pte_pkey_bits(vm_flags_t vm_flags)
 {
 	if (!mmu_has_feature(MMU_FTR_PKEY))
 		return 0x0UL;
--- a/arch/powerpc/mm/book3s64/pgtable.c~mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument
+++ a/arch/powerpc/mm/book3s64/pgtable.c
@@ -644,7 +644,7 @@ unsigned long memremap_compat_align(void
 EXPORT_SYMBOL_GPL(memremap_compat_align);
 #endif
 
-pgprot_t vm_get_page_prot(unsigned long vm_flags)
+pgprot_t vm_get_page_prot(vm_flags_t vm_flags)
 {
 	unsigned long prot;
 
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
@@ -3489,10 +3489,10 @@ static inline bool range_in_vma(struct v
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
@@ -2016,7 +2016,7 @@ typedef unsigned int pgtbl_mod_mask;
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
@@ -576,7 +576,7 @@ static inline pgprot_t pgprot_modify(pgp
 	return __pgprot(pgprot_val(oldprot) | pgprot_val(newprot));
 }
 
-static inline pgprot_t vm_get_page_prot(unsigned long vm_flags)
+static inline pgprot_t vm_get_page_prot(vm_flags_t vm_flags)
 {
 	return __pgprot(vm_flags);
 }
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-madvise-remove-the-visitor-pattern-and-thread-anon_vma-state.patch
mm-madvise-thread-mm_struct-through-madvise_behavior.patch
mm-madvise-thread-vma-range-state-through-madvise_behavior.patch
mm-madvise-thread-all-madvise-state-through-madv_behavior.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma-fix.patch
tools-testing-selftests-add-mremap-unfaulted-faulted-test-cases.patch
mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap-fix.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch

