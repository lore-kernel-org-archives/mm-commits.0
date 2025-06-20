Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA5917E
	for <mm-commits@vger.kernel.org>; Fri, 20 Jun 2025 00:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750378280; cv=none; b=J/F8ZibNgz2cknzWFsBxf6yPheRSOXt0Aos4cJKKaQ+UXWrveNdda+0daTx+uOKgq1Cz/B5BEV94i2fhXeg7lBc1ZGGmZhxi01Z99BImX7LfWXzCSn8NG8fqlSZJzu89f0nvtAB7h+VqDXNsi/zAFXuWJgD2nPcLzjPfZPZoObI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750378280; c=relaxed/simple;
	bh=mPHQpeirVv9y5FR49D8cDju9e5H2RfknSgmQ3F+4PjY=;
	h=Date:To:From:Subject:Message-Id; b=up7xNw9RogUziHytzCrZPdbEJ3j+t4hgZgldzj7kRYHcVt5rWRNeM/vwjnrxqLbu+lCKJNs4hcejsGAnGpWk2PNK8EMZe4R3nWkcV8JQWJynATxT0ifmAPNTk27t4I0Z8akzi68gsFKbyq2Fw9TGVSXPB4HWyEeVjtcMKY6a6TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L5Oz6+nz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L5Oz6+nz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9EEC4CEEA;
	Fri, 20 Jun 2025 00:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750378279;
	bh=mPHQpeirVv9y5FR49D8cDju9e5H2RfknSgmQ3F+4PjY=;
	h=Date:To:From:Subject:From;
	b=L5Oz6+nzRq6g2tuH1f6MYqJ0OP/nyTS/8zvCEaoFoTQDl2kBprxkXN5GQyJxJa7uc
	 5EEzjEK3gwpNg35xnckPzlm73GtEDby+58LoGK7+X+z0Hrije9nykXX5UjiI7CD13b
	 lejTEaomv6vINMa00hp1bYjnzVIz65E9Sk+5Nyio=
Date: Thu, 19 Jun 2025 17:11:19 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rppt@kernel.org,pfalcato@suse.de,osalvador@suse.de,Liam.Howlett@oracle.com,kees@kernel.org,jannh@google.com,jack@suse.cz,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument-fix.patch added to mm-new branch
Message-Id: <20250620001119.BB9EEC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add missing vm_get_page_prot() instance, remove include
has been added to the -mm mm-new branch.  Its filename is
     mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument-fix.patch

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

maintainers-add-missing-mm-workingsetc-file-to-mm-reclaim-section.patch
maintainers-add-missing-test-files-to-mm-gup-section.patch
maintainers-add-further-init-files-to-mm-init-block.patch
maintainers-add-hugetlb_cgroupc-to-hugetlb-section.patch
maintainers-add-stray-rmap-file-to-mm-rmap-section.patch
maintainers-add-memfd-shmem-quota-files-to-shmem-section.patch
maintainers-add-additional-mmap-related-files-to-mmap-section.patch
maintainers-add-missing-files-to-mm-page-alloc-section.patch
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
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument-fix.patch
mm-update-core-kernel-code-to-use-vm_flags_t-consistently.patch
mm-update-architecture-and-driver-code-to-use-vm_flags_t.patch

