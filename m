Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF375329515
	for <mm-commits@vger.kernel.org>; Wed, 17 Sep 2025 23:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758152445; cv=none; b=g8bjSVFfIlk+T7IchlJSuX0lNFgou2kt3x4ExwdehFwcVp3ulieC6kzGbRtWIydHID4qnm84UB5uuvTzE+r9cPqAlwYHDQMeWafJfWryu7IiZ3vm/JW71qs7aI1HWbffmiYmnC4zLLblGdT2PkH1YcMNEkQtSPx8awA3SABgtBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758152445; c=relaxed/simple;
	bh=UeGaKyVAHScZmR9Ede3FNHRI7SOHICCdMmATQHN586I=;
	h=Date:To:From:Subject:Message-Id; b=FHag6DjY/6Vsyz7v7mg04JfbcoME+b9KfoI/FAgdxr9KMmyvET4+HhQkWd6RT2mfclqmIK5m5tXtPJoZjyBK1gEmYgyn+5aSffvuEEODkgo3PBEHKNTMcpTy77IGnZW/2rYhs7e2K11zs+KH/uTrhgNicyBr+Y6lE0k3QB0na18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vmrFAaLi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vmrFAaLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B65CC4CEE7;
	Wed, 17 Sep 2025 23:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758152444;
	bh=UeGaKyVAHScZmR9Ede3FNHRI7SOHICCdMmATQHN586I=;
	h=Date:To:From:Subject:From;
	b=vmrFAaLio8n1o8PyIQA0tsBn9OJw5jRHNXjQKxpCzUL7BhbuW3bqdQb8mgHwBFA/v
	 aGkYyG3GAV/2c8eXFtAyK2oCHUKYpergZDCwwcxyIEXU83JS9eGnf4h+aVrDGyx7om
	 R+Re11irhd/w7WQK6S0JKuhxE9YFthZhSLwcs1EE=
Date: Wed, 17 Sep 2025 16:40:43 -0700
To: mm-commits@vger.kernel.org,clm@meta.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-oom_killc-fix-inverted-check.patch added to mm-unstable branch
Message-Id: <20250917234044.6B65CC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/oom_kill.c: fix inverted check
has been added to the -mm mm-unstable branch.  Its filename is
     mm-oom_killc-fix-inverted-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-oom_killc-fix-inverted-check.patch

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
Subject: mm/oom_kill.c: fix inverted check
Date: Wed, 17 Sep 2025 06:16:37 +0100

Fix an incorrect logic conversion in process_mrelease().

Link: https://lkml.kernel.org/r/3b7f0faf-4dbc-4d67-8a71-752fbcdf0906@lucifer.local
Fixes: 12e423ba4eae ("mm: convert core mm to mm_flags_*() accessors")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Chris Mason <clm@meta.com>
  Closes: https://lkml.kernel.org/r/c2e28e27-d84b-4671-8784-de5fe0d14f41@lucifer.local
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/oom_kill.c~mm-oom_killc-fix-inverted-check
+++ a/mm/oom_kill.c
@@ -1257,7 +1257,7 @@ SYSCALL_DEFINE2(process_mrelease, int, p
 	 * Check MMF_OOM_SKIP again under mmap_read_lock protection to ensure
 	 * possible change in exit_mmap is seen
 	 */
-	if (mm_flags_test(MMF_OOM_SKIP, mm) && !__oom_reap_task_mm(mm))
+	if (!mm_flags_test(MMF_OOM_SKIP, mm) && !__oom_reap_task_mm(mm))
 		ret = -EAGAIN;
 	mmap_read_unlock(mm);
 
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
mm-add-ability-to-take-further-action-in-vm_area_desc.patch
doc-update-porting-vfs-documentation-for-mmap_prepare-actions.patch
mm-hugetlbfs-update-hugetlbfs-to-use-mmap_prepare.patch
mm-add-shmem_zero_setup_desc.patch
mm-update-mem-char-driver-to-use-mmap_prepare.patch
mm-update-resctl-to-use-mmap_prepare.patch
mm-oom_killc-fix-inverted-check.patch

