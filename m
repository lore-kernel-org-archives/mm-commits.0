Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63953469D
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 04:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752122552; cv=none; b=H40Cc0lM6kv51IkN3AdtgvIBHyc4jnrrm9kNHWUt4DWj9IVglIBfnM1jV/v3lieIIx57xRsXe3gwmYoVrPJtBcaPhTjh6Lp3mmF5e9GBU6zXTZ5LAWxgAhRfvw4zttzzstONsx4R3o7mgm4RZ2njby0yEzpxeGoaOqMzipzsOYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752122552; c=relaxed/simple;
	bh=sv32V/I5H1p0tSx1g8hxhrWV5/jEclB994tqBrpT1IA=;
	h=Date:To:From:Subject:Message-Id; b=c0dCvl0jV6fyTBM4S5mA+l+6w7G+9ucLwFKcQmXDqHae0sJic1UAkxl30Gj1ZWDyaCKbm7bq8KNggcWS3LVP/qnVTH9yrsLAEzjTL+tUjLTbisuJscgf/pQP6fZc99OZMevFMKKNiXHgbAC0sjDw85VDxclat17dOAvTb5Ldmqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ze/XaHcz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ze/XaHcz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9CDC4CEE3;
	Thu, 10 Jul 2025 04:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752122552;
	bh=sv32V/I5H1p0tSx1g8hxhrWV5/jEclB994tqBrpT1IA=;
	h=Date:To:From:Subject:From;
	b=ze/XaHczYYXswd8LsqJg1k6/FuY3Jf8DKZvbV2bZC2y/CO35/IOKxvp2rrW1wxbX6
	 O+TzeewO2qj7hUwsph+laD9UzsEhZjtLGbJ6ZgG1Lrk1MKRll51PtvSzSRrTQAEwMk
	 6eCG5WABwI7/dlXeKXYHIBNpGVM++Fkeeua/PdMg=
Date: Wed, 09 Jul 2025 21:42:30 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,rppt@kernel.org,pfalcato@suse.de,osalvador@suse.de,Liam.Howlett@oracle.com,kees@kernel.org,jarkko@kernel.org,jannh@google.com,jack@suse.cz,david@redhat.com,catalin.marinas@arm.com,brauner@kernel.org,anshuman.khandual@arm.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument-fix.patch removed from -mm tree
Message-Id: <20250710044232.2D9CDC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add missing vm_get_page_prot() instance, remove include
has been removed from the -mm tree.  Its filename was
     mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument-fix.patch

This patch was dropped because it was folded into mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: add missing vm_get_page_prot() instance, remove include
Date: Thu, 19 Jun 2025 13:21:15 +0100

I missed a case for powerpc, also remove #include (that is not in practice
necessary) to avoid any risk of circular dependency.

Link: https://lkml.kernel.org/r/552f88e1-2df8-4e95-92b8-812f7c8db829@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/pkeys.h |    1 -
 arch/powerpc/mm/book3s64/pgtable.c         |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/arch/powerpc/include/asm/book3s/64/pkeys.h~mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument-fix
+++ a/arch/powerpc/include/asm/book3s/64/pkeys.h
@@ -4,7 +4,6 @@
 #define _ASM_POWERPC_BOOK3S_64_PKEYS_H
 
 #include <asm/book3s/64/hash-pkey.h>
-#include <linux/mm_types.h>
 
 static inline u64 vmflag_to_pte_pkey_bits(vm_flags_t vm_flags)
 {
--- a/arch/powerpc/mm/book3s64/pgtable.c~mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument-fix
+++ a/arch/powerpc/mm/book3s64/pgtable.c
@@ -644,7 +644,7 @@ unsigned long memremap_compat_align(void
 EXPORT_SYMBOL_GPL(memremap_compat_align);
 #endif
 
-pgprot_t vm_get_page_prot(unsigned long vm_flags)
+pgprot_t vm_get_page_prot(vm_flags_t vm_flags)
 {
 	unsigned long prot;
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge.patch
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument.patch
mm-update-core-kernel-code-to-use-vm_flags_t-consistently.patch
mm-update-architecture-and-driver-code-to-use-vm_flags_t.patch
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

