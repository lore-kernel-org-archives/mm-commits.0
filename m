Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AA8176ADE;
	Thu, 26 Dec 2024 23:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735254172; cv=none; b=XeAV9eAn12D32NK5kBiF6CNRZwHLarrD/Xaljm8G10RqGDn027sPtnSG9F4VOKddiMm5kxuQcfMhuhSC33EbfeaWzuSW0SrH502/WlXpW+zkcexiZ8AdsJ+S916xuuOqcmNBe62KPiRCko44tsVO7EMqroshTm/sBQcJaB/a0lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735254172; c=relaxed/simple;
	bh=jY4tcsq7S/8S27SxlV+QxZwByH5/RBwe0EoUjU8upuQ=;
	h=Date:To:From:Subject:Message-Id; b=IV/7nCTiXOLk6FWCQg+CNXYI9VDrrH1qJTloMmq8tiaUuWH0Lj9mbhvIvWHvJew5igfRAVth1Ruw0Bio5U47Lju6mhSGxCBx4GBU228L6eWbuPgdul304Cg3a418YZSCEB7FNL6681eziqP4azKNG3CgxbjWcHhO9+iMED8Vvcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QONyqf9d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QONyqf9d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511C2C4CED1;
	Thu, 26 Dec 2024 23:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735254172;
	bh=jY4tcsq7S/8S27SxlV+QxZwByH5/RBwe0EoUjU8upuQ=;
	h=Date:To:From:Subject:From;
	b=QONyqf9dRCbbCqqpU+TYLj1lPkidmS9bbVXgzZtA12UuhlXI8eYaQOpFl2AvtSX8c
	 qPlCMFo7Za/cte8WSxgLs+MjfnEDDCFzUm4SOFx+G+XhRdmMOXUxeVqj7vvY4ecyOA
	 ShVDhNbCioRezSrMAxoX/K8YK+wVUFFmKHdocH8w=
Date: Thu, 26 Dec 2024 15:02:51 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,stable@vger.kernel.org,quic_zhenhuah@quicinc.com,kent.overstreet@linux.dev,00107082@163.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-skip-pgalloc_tag_swap-if-profiling-is-disabled.patch added to mm-hotfixes-unstable branch
Message-Id: <20241226230252.511C2C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: skip pgalloc_tag_swap if profiling is disabled
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     alloc_tag-skip-pgalloc_tag_swap-if-profiling-is-disabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-skip-pgalloc_tag_swap-if-profiling-is-disabled.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: skip pgalloc_tag_swap if profiling is disabled
Date: Thu, 26 Dec 2024 13:16:39 -0800

When memory allocation profiling is disabled, there is no need to swap
allocation tags during migration.  Skip it to avoid unnecessary overhead.

Link: https://lkml.kernel.org/r/20241226211639.1357704-2-surenb@google.com
Fixes: e0a955bf7f61 ("mm/codetag: add pgalloc_tag_copy()")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: David Wang <00107082@163.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zhenhua Huang <quic_zhenhuah@quicinc.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/alloc_tag.c~alloc_tag-skip-pgalloc_tag_swap-if-profiling-is-disabled
+++ a/lib/alloc_tag.c
@@ -197,6 +197,9 @@ void pgalloc_tag_swap(struct folio *new,
 	union codetag_ref ref_old, ref_new;
 	struct alloc_tag *tag_old, *tag_new;
 
+	if (!mem_alloc_profiling_enabled())
+		return;
+
 	tag_old = pgalloc_tag_get(&old->page);
 	if (!tag_old)
 		return;
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-avoid-current-alloc_tag-manipulations-when-profiling-is-disabled.patch
alloc_tag-skip-pgalloc_tag_swap-if-profiling-is-disabled.patch
seqlock-add-raw_seqcount_try_begin.patch
mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculate_try_beginretry.patch
mm-introduce-vma_start_read_locked_nested-helpers.patch
mm-move-per-vma-lock-into-vm_area_struct.patch
mm-mark-vma-as-detached-until-its-added-into-vma-tree.patch
mm-modify-vma_iter_store_gfp-to-indicate-if-its-storing-a-new-vma.patch
mm-mark-vmas-detached-upon-exit.patch
mm-nommu-fix-the-last-places-where-vma-is-not-locked-before-being-attached.patch
types-move-struct-rcuwait-into-typesh.patch
mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail.patch
mm-move-mmap_init_lock-out-of-the-header-file.patch
mm-uninline-the-main-body-of-vma_start_write.patch
refcount-introduce-__refcount_addinc_not_zero_limited.patch
mm-replace-vm_lock-and-detached-flag-with-a-reference-count.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma-fix.patch
mm-remove-extra-vma_numab_state_init-call.patch
mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch
mm-make-vma-cache-slab_typesafe_by_rcu.patch
docs-mm-document-latest-changes-to-vm_lock.patch

