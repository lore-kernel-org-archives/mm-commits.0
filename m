Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088CE2C0280
	for <mm-commits@vger.kernel.org>; Thu, 18 Sep 2025 21:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758229722; cv=none; b=r6qZOkBg5GYEC9akabdBsJDZRRhBcxMKD4KEJxiqJczX2Z1G1axVZs+2HXwSkqSqsFwOWiblO78GtAFvrbyumavU5/ZOkiZTh0YyR15nD30lpBEFpJouuTDb9+5gfHOauGmCXKfHjwbNDHkxTdB0v0NB2TJmQC7+M1iZxq4wo1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758229722; c=relaxed/simple;
	bh=cCKpoWbcaQ2008cBkorspTHvFrZnncPtgJS/FqbNOHU=;
	h=Date:To:From:Subject:Message-Id; b=TGicVyXnznbgDiB512yujGV2SU4+j4PYxhNxLR6DOyHBxZvB4EHyztqhBif7+QMIjzVh4FrY3K+wAk8RFiw/8ia5l/7GgCUlOri65Xs/CST0EKVRrrxzGf76uBIisOwytb9CW3Fz/Ti00tRyEL3XJvt6B6CPgud8EZtDXqOosjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=krt2PKr7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="krt2PKr7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83356C4CEF1;
	Thu, 18 Sep 2025 21:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758229721;
	bh=cCKpoWbcaQ2008cBkorspTHvFrZnncPtgJS/FqbNOHU=;
	h=Date:To:From:Subject:From;
	b=krt2PKr7A1wTPUJShYFqJQb/eSHvXMWllzdzZAelrUm0Pn/eWTTLS4vfV2gQm4041
	 5/hCRcBewTJOT0opJfn8h/R4kb7z9N+hOV5osmMNmtz+pawvPdggKpzCzG/szmbgDn
	 JG+6dG3lifCXtPNqLQGkH3aCjDy5GRKbvGDUxnM8=
Date: Thu, 18 Sep 2025 14:08:40 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-ability-to-take-further-action-in-vm_area_desc-fix.patch added to mm-unstable branch
Message-Id: <20250918210841.83356C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fixup: return error on broken path, update vma_internal.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-ability-to-take-further-action-in-vm_area_desc-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-ability-to-take-further-action-in-vm_area_desc-fix.patch

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
Subject: fixup: return error on broken path, update vma_internal.h
Date: Thu, 18 Sep 2025 08:08:31 +0100

Link: https://lkml.kernel.org/r/20f1c97d-b958-474c-b3a1-8ea9a177e096@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c                        |    6 ++++--
 tools/testing/vma/vma_internal.h |    1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/mm/util.c~mm-add-ability-to-take-further-action-in-vm_area_desc-fix
+++ a/mm/util.c
@@ -1385,17 +1385,19 @@ EXPORT_SYMBOL(mmap_action_prepare);
 int mmap_action_complete(struct mmap_action *action,
 			struct vm_area_struct *vma)
 {
+	int err = 0;
+
 	switch (action->type) {
 	case MMAP_NOTHING:
 		break;
 	case MMAP_REMAP_PFN:
 	case MMAP_IO_REMAP_PFN:
 		WARN_ON_ONCE(1); /* nommu cannot handle this. */
-
+		err = -EINVAL;
 		break;
 	}
 
-	return mmap_action_finish(action, vma, /* err = */0);
+	return mmap_action_finish(action, vma, err);
 }
 EXPORT_SYMBOL(mmap_action_complete);
 #endif
--- a/tools/testing/vma/vma_internal.h~mm-add-ability-to-take-further-action-in-vm_area_desc-fix
+++ a/tools/testing/vma/vma_internal.h
@@ -279,6 +279,7 @@ struct vm_area_struct;
 enum mmap_action_type {
 	MMAP_NOTHING,		/* Mapping is complete, no further action. */
 	MMAP_REMAP_PFN,		/* Remap PFN range. */
+	MMAP_IO_REMAP_PFN,	/* I/O remap PFN range. */
 };
 
 /*
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
mm-add-ability-to-take-further-action-in-vm_area_desc-fix.patch
doc-update-porting-vfs-documentation-for-mmap_prepare-actions.patch
mm-hugetlbfs-update-hugetlbfs-to-use-mmap_prepare.patch
mm-add-shmem_zero_setup_desc.patch
mm-update-mem-char-driver-to-use-mmap_prepare.patch
mm-update-resctl-to-use-mmap_prepare.patch
mm-oom_killc-fix-inverted-check.patch

