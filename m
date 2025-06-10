Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC96A17BD3
	for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 20:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749587497; cv=none; b=m5EIpZiCkPCI9pqCBgr7iq/8kLdYnneMujsE5HnfCyn8k0q6RGunK/zlRZd+rqTDtVFm6LNYXieAYc7s1Xu+zcNXSTFmN2HqWhPqXTK6GC8HgZ6Eg5oUWcUzpWIqBWqGvAQqUyzTCeYWWP/1bIODJu1Wl7Bu2hTC8D20wQpXUwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749587497; c=relaxed/simple;
	bh=KU7GM0bGv4QO9Llhjzom5ItfugcbNCR3sJjCZemCguQ=;
	h=Date:To:From:Subject:Message-Id; b=iWrjtjKtGEgoWsXYiD1JZVy0//wtr4VWS32KTxGMq6aXpa6lEWz1ZjYs6FoyxnzUCw908/VgnsuESbwhFFkBQp7SjCPjP5Loe5HboywLvjLYNN1fFu+HR9YVLFnwk5/hjHTZE/zmbNqDrrb9Idig7EdXF9ST/z6Pmycbc8PXLUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CiM/OT8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CiM/OT8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A995C4CEED;
	Tue, 10 Jun 2025 20:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749587497;
	bh=KU7GM0bGv4QO9Llhjzom5ItfugcbNCR3sJjCZemCguQ=;
	h=Date:To:From:Subject:From;
	b=CiM/OT8/hh/H+4IsoY5v0tBqSNa0Wtr59Tf7OK1+aUlkmS/pCRwQtU5+YSOjc6AlC
	 nHD0hd5Hn42iubvDjUoCh1FV+fehahTU9mpnFI94mQR1YYWzVqXbI6P7TOodoANv/B
	 pCFfX+NyfFNkRNZRNFRWOejBqcdRS2Xlfwl8HQX4=
Date: Tue, 10 Jun 2025 13:31:36 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix-2.patch added to mm-hotfixes-unstable branch
Message-Id: <20250610203137.5A995C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix-2
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix-2.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix-2
Date: Tue, 10 Jun 2025 11:03:11 +0100

remove unused declarations

Link: https://lkml.kernel.org/r/ac3ae324-4c65-432a-8c6d-2af988b18ac8@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/vma.h~mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix-2
+++ a/mm/vma.h
@@ -617,8 +617,4 @@ int create_init_stack_vma(struct mm_stru
 int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift);
 #endif
 
-struct vm_area_desc *vma_to_desc(struct vm_area_struct *vma,
-		struct vm_area_desc *desc);
-void set_vma_from_desc(struct vm_area_struct *vma, struct vm_area_desc *desc);
-
 #endif	/* __MM_VMA_H */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-reset-vma-iterator-on-commit_merge-oom-failure.patch
mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems.patch
mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix-2.patch
docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch

