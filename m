Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8989B2459FE
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 03:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758597274; cv=none; b=YeIxB+QlbPbgFbTK8zuDQPeUmCiTdIDzCEfdx+arSwxrhgSnpuDfM9qAJAcagPbtQGwrTToXJn1YEIvOkMQB5NWruBJPbUCmU28Fe4JGtvusx98pr6C3hBcad6C3SlbNrCkEHFkOxlHUYge/9uH1+9Kg8yIrGAs+RSNkoZGVkkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758597274; c=relaxed/simple;
	bh=rAqykF/4xBFGh9yMJq3q4IJpLsBrBCt/kHLT6GEbjXw=;
	h=Date:To:From:Subject:Message-Id; b=n1Dnk2bbVA7XzjEQvtWRM8Sxf6o3BX1IO+IMSA00Ny4Oiyr0wSXfGTNpBKwXiIylmF9n6DAgHH6JXmtITtDLQ5Mc3TS18YlVTO1dPj+yr3S/4O0rCHgfCDwOdgSzhQEjP2t9nTeSZ+eTLHz4IHL8cOFWALrLitEw3VDZ/vdWUv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SJxm0Q6w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SJxm0Q6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D15C4CEF0;
	Tue, 23 Sep 2025 03:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758597274;
	bh=rAqykF/4xBFGh9yMJq3q4IJpLsBrBCt/kHLT6GEbjXw=;
	h=Date:To:From:Subject:From;
	b=SJxm0Q6wrmZxTz7sQVA0IL/EHiw3CHjKgU9/FPb9/y2YxjO+9VRUN8tsuGoqJPJzf
	 usJbaCztA28iS4ZNbRJLbTqDSzdaHwI64v+Pf/kvsr19Rr+qd1fflKPcLDUhege6FX
	 nxZISMcWK7RnmgZyL/AaiEqQs/Lb3U0pDRoH95IA=
Date: Mon, 22 Sep 2025 20:14:33 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-ability-to-take-further-action-in-vm_area_desc-fix.patch removed from -mm tree
Message-Id: <20250923031434.06D15C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fixup: return error on broken path, update vma_internal.h
has been removed from the -mm tree.  Its filename was
     mm-add-ability-to-take-further-action-in-vm_area_desc-fix.patch

This patch was dropped because it was folded into mm-add-ability-to-take-further-action-in-vm_area_desc.patch

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
mm-introduce-io_remap_pfn_range_.patch
mm-introduce-io_remap_pfn_range_-fix.patch
mm-add-ability-to-take-further-action-in-vm_area_desc.patch
doc-update-porting-vfs-documentation-for-mmap_prepare-actions.patch
mm-hugetlbfs-update-hugetlbfs-to-use-mmap_prepare.patch
mm-add-shmem_zero_setup_desc.patch
mm-update-mem-char-driver-to-use-mmap_prepare.patch
mm-update-resctl-to-use-mmap_prepare.patch
mm-oom_killc-fix-inverted-check.patch

