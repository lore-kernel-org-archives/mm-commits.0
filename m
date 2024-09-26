Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F42D13CABC
	for <mm-commits@vger.kernel.org>; Thu, 26 Sep 2024 20:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727382759; cv=none; b=L5VKLzmiMIsLO/uYnB/7eQFC4XeABOEESrUWrGgCDOELt1m3+wMA5toZpmxWqA60u6IlvCjhHveXpcKIh/x2gDFDqt/9tKXWNYXBJIUZobtDbNTG45ulfJyddnACZIlRqdABFOUiiPrL7eUtQgu/2MEQ8M+N2LFM1A0e1g66N/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727382759; c=relaxed/simple;
	bh=6vhVfiRKvUJHSZK5ZP6frwJ7/IwV99yey6+HKneubec=;
	h=Date:To:From:Subject:Message-Id; b=DVnp3e1XSHmAC74ymQnoGlDs9OmpT8/756Etpv3MpGaif4UMr1dKXfa62C6O/dimEMDLnm+QFeCmS9/QHq0GsCy+3hkWIFju3KcFcjgW7fiGzCj4cd9KPAQ8csigkumacnpCIVf50o522njmzVqS4WM4AbISyPbBEiwEAVkehQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KfJ5NW8U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KfJ5NW8U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D515FC4CEC5;
	Thu, 26 Sep 2024 20:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727382758;
	bh=6vhVfiRKvUJHSZK5ZP6frwJ7/IwV99yey6+HKneubec=;
	h=Date:To:From:Subject:From;
	b=KfJ5NW8UzApJ4iD34zJZWFJ10txthr/Tqr3k3ALsm/aIXKZlI3Qm1WxhuIInRDLyc
	 2ljt++DRZz2ricfdbrl5LABzkd5sx/sZtAAD5uTh7WPt+UjrlIMluopVqNM9fttRx6
	 KlJU26TOFHCvY9iwHTzWzw+CIHbB7voZqCTgru+c=
Date: Thu, 26 Sep 2024 13:32:38 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-handle_pte_fault-use-pte_offset_map_rw_nolock.patch added to mm-unstable branch
Message-Id: <20240926203238.D515FC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: handle_pte_fault() use pte_offset_map_rw_nolock()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-handle_pte_fault-use-pte_offset_map_rw_nolock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-handle_pte_fault-use-pte_offset_map_rw_nolock.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: handle_pte_fault() use pte_offset_map_rw_nolock()
Date: Thu, 26 Sep 2024 14:46:19 +0800

In handle_pte_fault(), we may modify the vmf->pte after acquiring the
vmf->ptl, so convert it to using pte_offset_map_rw_nolock().  But since we
will do the pte_same() check, so there is no need to get pmdval to do
pmd_same() check, just pass a dummy variable to it.

Link: https://lkml.kernel.org/r/af8d694853b44c5a6018403ae435440e275854c7.1727332572.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-handle_pte_fault-use-pte_offset_map_rw_nolock
+++ a/mm/memory.c
@@ -5727,14 +5727,24 @@ static vm_fault_t handle_pte_fault(struc
 		vmf->pte = NULL;
 		vmf->flags &= ~FAULT_FLAG_ORIG_PTE_VALID;
 	} else {
+		pmd_t dummy_pmdval;
+
 		/*
 		 * A regular pmd is established and it can't morph into a huge
 		 * pmd by anon khugepaged, since that takes mmap_lock in write
 		 * mode; but shmem or file collapse to THP could still morph
 		 * it into a huge pmd: just retry later if so.
+		 *
+		 * Use the maywrite version to indicate that vmf->pte may be
+		 * modified, but since we will use pte_same() to detect the
+		 * change of the !pte_none() entry, there is no need to recheck
+		 * the pmdval. Here we chooes to pass a dummy variable instead
+		 * of NULL, which helps new user think about why this place is
+		 * special.
 		 */
-		vmf->pte = pte_offset_map_nolock(vmf->vma->vm_mm, vmf->pmd,
-						 vmf->address, &vmf->ptl);
+		vmf->pte = pte_offset_map_rw_nolock(vmf->vma->vm_mm, vmf->pmd,
+						    vmf->address, &dummy_pmdval,
+						    &vmf->ptl);
 		if (unlikely(!vmf->pte))
 			return 0;
 		vmf->orig_pte = ptep_get_lockless(vmf->pte);
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-pgtable-introduce-pte_offset_map_rorw_nolock.patch
powerpc-assert_pte_locked-use-pte_offset_map_ro_nolock.patch
mm-filemap-filemap_fault_recheck_pte_none-use-pte_offset_map_ro_nolock.patch
mm-khugepaged-__collapse_huge_page_swapin-use-pte_offset_map_ro_nolock.patch
arm-adjust_pte-use-pte_offset_map_rw_nolock.patch
mm-handle_pte_fault-use-pte_offset_map_rw_nolock.patch
mm-khugepaged-collapse_pte_mapped_thp-use-pte_offset_map_rw_nolock.patch
mm-copy_pte_range-use-pte_offset_map_rw_nolock.patch
mm-mremap-move_ptes-use-pte_offset_map_rw_nolock.patch
mm-page_vma_mapped_walk-map_pte-use-pte_offset_map_rw_nolock.patch
mm-userfaultfd-move_pages_pte-use-pte_offset_map_rw_nolock.patch
mm-multi-gen-lru-walk_pte_range-use-pte_offset_map_rw_nolock.patch
mm-pgtable-remove-pte_offset_map_nolock.patch

