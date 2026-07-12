Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63617372063
	for <mm-commits@vger.kernel.org>; Sun, 12 Jul 2026 07:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783840366; cv=none; b=sUC6X4aWTGjH57L3oNeDrA5xNhZj51RZWJ1rwKQ4ecXm5/hS7v7fAODMSuKaMTtsVDgYpYY2LhZI8CUZozyKoGoCs0Sk+MiqJvEHEr7UncufszZTJe9F4137ISibrn6w3eybnTUblZzy5WDKDJBSWXSHEz2OlxbcISKeLRRYa2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783840366; c=relaxed/simple;
	bh=uJah11EZiEfRFgqCgkM7ihqtgGXJTZE+asQN90DZ7uU=;
	h=Date:To:From:Subject:Message-Id; b=mKN43c08B4c5yvC1MwDANRRv+yxLQpA0nWesoT12yAPpyNVc0LiAj5ulgL6NINRmh7B6DUE1OOgnrwLEP4MgwPy7uhHLzwTRRtNt4yHCa7QOLjasqYFFS9YwpL+Nrqb2/2HAqXiDYRzoX/0UTYjD3MY8m/GEyJNE42Ra+yMDbzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Uj6m+Cvx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Uj6m+Cvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA7E1F000E9;
	Sun, 12 Jul 2026 07:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783840365;
	bh=07gxJJNSyDK5U2hL4HqcouoNpspSVRPFdUFGeXXsmr0=;
	h=Date:To:From:Subject;
	b=Uj6m+CvxFGTMlhY+p7RZkyq7FlegmCqL+4bA+nX4kUORpLa2cUvVFZRrRmBhcDjZa
	 owJCmKJ19+vmWgmfNa1OL37WNl1L6kngnPldSDXegmVEeGLZJGm65rLIrZe4T6tfLv
	 m1tZSV2rtbcWOqIrYtxkW9UFpXYgRyBDIAD+/LTU=
Date: Sun, 12 Jul 2026 00:12:44 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,songmuchun@bytedance.com,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-remove-obsolete-hugetlb-vmemmap-test-fix.patch added to mm-new branch
Message-Id: <20260712071244.ECA7E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-mm-remove-obsolete-hugetlb-vmemmap-test-fix
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-remove-obsolete-hugetlb-vmemmap-test-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-remove-obsolete-hugetlb-vmemmap-test-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-mm-remove-obsolete-hugetlb-vmemmap-test-fix
Date: Sun Jul 12 12:09:22 AM PDT 2026

don't clean old executables out of .gitignore

Link: https://lore.kernel.org/CAHk-=wiHK5_oBUdUiNAaevmN9f-ORe+QBqbRefAZaw-RbgEn3w@mail.gmail.com
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: SJ Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/mm/.gitignore~selftests-mm-remove-obsolete-hugetlb-vmemmap-test-fix
+++ a/tools/testing/selftests/mm/.gitignore
@@ -3,9 +3,11 @@ cow
 hugepage-mmap
 hugepage-mremap
 hugepage-shm
+hugepage-vmemmap
 hugetlb-mmap
 hugetlb-mremap
 hugetlb-shm
+hugetlb-vmemmap
 hugetlb-madvise
 hugetlb-read-hwpoison
 hugetlb-soft-offline
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch
csky-implement-flush_cache_vmap-in-c.patch
mm-annotate-data-race-in-cpu_needs_drain-fix.patch
mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb-fix.patch
mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
selftests-mm-remove-obsolete-hugetlb-vmemmap-test-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

