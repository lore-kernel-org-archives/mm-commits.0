Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E123257843
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 23:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757807394; cv=none; b=TcwHKyBVDCQ9IWX8/EmxkTiSa5fSnCx1EdPquhCfyISC1IG1993ILPXxAf2ViK2JO8S6epzk2Kajzb9CqsRZAt6Cg4QSeBOtj+9BJWLgluI1WXOWdaB3JKIM8jvBli1ob+Aoi1CY2ttrQm/Ea2b6bRbdkXkJNPP5dfPiCUn8mdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757807394; c=relaxed/simple;
	bh=Z319lpf6k3ZLPHbPIjp78LdAzAqhbDDE0329YwNr0y0=;
	h=Date:To:From:Subject:Message-Id; b=fn5f+UCGIQ9VimjEWLoG5pRONtMPJFFDjE+GanTkZF0ZtcFDQ/vP/6W1colU12coIQBa77bcupDWnF2J9sBD0HqqouHZXtvsYRwAUscdO/Lg2E/0zW+E7M8sNDwnj3gisdFcPH5OgYSCt5wBqMPeOj4SEimkGv3r5logkx4lLXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gfXzX+xJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gfXzX+xJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00F7C4CEF7;
	Sat, 13 Sep 2025 23:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757807393;
	bh=Z319lpf6k3ZLPHbPIjp78LdAzAqhbDDE0329YwNr0y0=;
	h=Date:To:From:Subject:From;
	b=gfXzX+xJ9myQa17dN8CpTUuudn9AwhTjN0JnM2xI+kI5P9n71xuznst4WrCk2USe/
	 r9G+Jic4saQr6ysKzWQcjhiyDxhy58KZidscZjl/EyDkg8S055ZNByKthnmud958dr
	 MMdNeGsYw1bqDe8/RjIXiHQjn5kIvx2qPfBfP/E0=
Date: Sat, 13 Sep 2025 16:49:53 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-convert-arch-specific-code-to-mm_flags_-accessors-fix.patch removed from -mm tree
Message-Id: <20250913234953.D00F7C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fix typo
has been removed from the -mm tree.  Its filename was
     mm-convert-arch-specific-code-to-mm_flags_-accessors-fix.patch

This patch was dropped because it was folded into mm-convert-arch-specific-code-to-mm_flags_-accessors.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: fix typo
Date: Wed, 13 Aug 2025 15:08:36 +0100

Link: https://lkml.kernel.org/r/f8ff8fe9-0c89-4742-bf52-d31319d948c1@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202508132154.feFNDPyq-lkp@intel.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/mm/mmap.c~mm-convert-arch-specific-code-to-mm_flags_-accessors-fix
+++ a/arch/s390/mm/mmap.c
@@ -185,7 +185,7 @@ void arch_pick_mmap_layout(struct mm_str
 		mm_flags_clear(MMF_TOPDOWN, mm);
 	} else {
 		mm->mmap_base = mmap_base(random_factor, rlim_stack);
-		mm_flag_set(MMF_TOPDOWN, mm);
+		mm_flags_set(MMF_TOPDOWN, mm);
 	}
 }
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-add-bitmap-mm-flags-field.patch
mm-convert-core-mm-to-mm_flags_-accessors.patch
mm-convert-prctl-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors.patch
mm-convert-uprobes-to-mm_flags_-accessors.patch
mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags.patch
mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags-fix.patch
mm-correct-sign-extension-issue-in-mmf_-flag-masks.patch
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
fs-proc-update-vmcore-to-use-proc_mmap_prepare-fix.patch
kcov-update-kcov-to-use-mmap_prepare.patch

