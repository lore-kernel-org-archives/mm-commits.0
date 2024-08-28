Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0619E1DA32
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 02:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724813773; cv=none; b=Unnx99DrITXHf9+63CyBRJYl5uOclqZRmB1n2E8TN0P5K5M8zwds4f7LjQr4QHQYo7GoF7M13TS+iU7CisbqIepQPH4ekSXhLSUfQ8s4HedfnP5PLVmPoc3SD8QgZaWBE8JjpE36tG72dcbGHt276r9cr/tmgRgLQIg9WHZCVpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724813773; c=relaxed/simple;
	bh=UEdB/U2uy/6zyxsT25wDAQ2K4UM/CQRQ91gXpi4h45I=;
	h=Date:To:From:Subject:Message-Id; b=ErBE6tjxGd6dKLv2EtjmSoKHnfWe6Ev/jQnC5AM2/x6K3/TzxNSeIPb7WkMZb3cJhSHFaUYZKhF97YjJapMuf1rQLOr907RzW7J9tgSiizwZh8l5/Odl2v/vf50RjigCB4A1t9aQ5gnRS6y1N9v9ajoduJRuXOZRweZiShvIP9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O2lkwWa3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O2lkwWa3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79FCAC4AF11;
	Wed, 28 Aug 2024 02:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724813772;
	bh=UEdB/U2uy/6zyxsT25wDAQ2K4UM/CQRQ91gXpi4h45I=;
	h=Date:To:From:Subject:From;
	b=O2lkwWa3xs9qRB3rmfn7hP6r+9QamOVJnS6Bw3avWpZwIyTRISwios+DiV6kZoXRN
	 wWU2IMKrTTiTFS1u8AHlzStE1Ll+bZoOKIc1AxSJdTG3xeget42OpRA3900Azjm0v6
	 jtINiw7N3pthpivJouBjSMaruByITchr8TmQza1U=
Date: Tue, 27 Aug 2024 19:56:11 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-duplicated-include-in-vma_internalh-fix.patch added to mm-unstable branch
Message-Id: <20240828025612.79FCAC4AF11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fixup vma.h for nommu
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-duplicated-include-in-vma_internalh-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-duplicated-include-in-vma_internalh-fix.patch

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
Subject: mm: fixup vma.h for nommu
Date: Sun, 25 Aug 2024 12:29:47 +0100

Some series of includes result in vma.h being imported by nommu under
certain circumstances, which references FIRST_USER_ADDRESS and
USER_PGTABLES_CEILING, neither of which are necessarily defined in a nommu
scenario.

Work around this by wrapping the inline function which references these
(init_vma_munmap()) in an #ifdef CONFIG_MMU.

Link: https://lkml.kernel.org/r/7d0ea994-f750-49c5-b392-ae7117369cf3@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/vma.h~mm-remove-duplicated-include-in-vma_internalh-fix
+++ a/mm/vma.h
@@ -225,6 +225,7 @@ static inline int vma_iter_store_gfp(str
 }
 
 
+#ifdef CONFIG_MMU
 /*
  * These three helpers classifies VMAs for virtual memory accounting.
  */
@@ -255,6 +256,7 @@ static inline bool is_data_mapping(vm_fl
 {
 	return (flags & (VM_WRITE | VM_SHARED | VM_STACK)) == VM_WRITE;
 }
+#endif
 
 
 static inline void vma_iter_config(struct vma_iterator *vmi,
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc.patch
userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc-fix.patch
mm-move-vma_modify-and-helpers-to-internal-header.patch
mm-move-vma_shrink-vma_expand-to-internal-header.patch
mm-move-internal-core-vma-manipulation-functions-to-own-file.patch
maintainers-add-entry-for-new-vma-files.patch
tools-separate-out-shared-radix-tree-components.patch
tools-add-skeleton-code-for-userland-testing-of-vma-logic.patch
mm-remove-duplicated-include-in-vma_internalh-fix.patch
mm-vma-track-start-and-end-for-munmap-in-vma_munmap_struct-fix.patch
tools-improve-vma-test-makefile.patch
tools-add-vma-merge-tests.patch
mm-introduce-vma_merge_struct-and-abstract-vma_mergevma_modify.patch
mm-remove-duplicated-open-coded-vma-policy-check.patch
mm-abstract-vma_expand-to-use-vma_merge_struct.patch
mm-avoid-using-vma_merge-for-new-vmas.patch
mm-avoid-using-vma_merge-for-new-vmas-fix.patch
mm-make-vma_prepare-and-friends-static-and-internal-to-vmac.patch
mm-introduce-commit_merge-abstracting-final-commit-of-merge.patch
mm-refactor-vma_merge-into-modify-only-vma_merge_existing_range.patch
mm-rework-vm_ops-close-handling-on-vma-merge.patch

