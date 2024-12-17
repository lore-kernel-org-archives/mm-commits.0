Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13E91F8F0B
	for <mm-commits@vger.kernel.org>; Tue, 17 Dec 2024 18:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734461708; cv=none; b=ncAYpBxQBdZHd3zNj6HuZhnIut2vvSvUi9ZK3qnsIOgPe7u8xh2DjjWIVeQ2gq6ilFLukp1VJh7VXrWfGMq1heeoUHt1llckBpOMvZmSXIzeJ94gHVhMu+YsQyB1zLQW+mteHGcGt3erCwrROQybzqmT/+YxEWW4Cl+eLbvJMzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734461708; c=relaxed/simple;
	bh=TRmYrsYjR4XVJYcLv2LE++4fgqBQ8hNPykUOor9Edo8=;
	h=Date:To:From:Subject:Message-Id; b=F7nnxvkxOZUvHIW52TiBAfRcpNERldiQUsBB/63TIHJZbguJDoulSIAUxM4BwbXNzbeYtiZeqYi4Jo2tU1bw0Py2ceOPdRYpxict6Q6GtU9EmTBPf/z67aTui1hNCsfN3xlhp9Ar4B7OgQxfetHzG6gEI4Pl2Dp3jL4nFHslS3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IDNtbQsd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IDNtbQsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83968C4CED7;
	Tue, 17 Dec 2024 18:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734461708;
	bh=TRmYrsYjR4XVJYcLv2LE++4fgqBQ8hNPykUOor9Edo8=;
	h=Date:To:From:Subject:From;
	b=IDNtbQsdYZZUbVQFAi3bC1AdBgR4BTX+HYjoeMXRA9WLWGWakPgkWTdjL79X/EurT
	 rfJkiu74JhKiw/blda5zQ/L/I+qi/qukmFrK8/Wrc/NoC7qREkZbSfl/w+hCcq7XaW
	 uKHOAonr4Pw4TZpymn488ME5Ing8bIpj3joPxzJo=
Date: Tue, 17 Dec 2024 10:55:07 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,lokeshgidra@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail-fix.patch added to mm-unstable branch
Message-Id: <20241217185508.83968C4CED7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail-fix
Date: Tue Dec 17 10:53:33 AM PST 2024

fix uffd_move_lock() test, per Lokesh

Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/userfaultfd.c~mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail-fix
+++ a/mm/userfaultfd.c
@@ -1484,7 +1484,7 @@ static int uffd_move_lock(struct mm_stru
 	mmap_read_lock(mm);
 	err = find_vmas_mm_locked(mm, dst_start, src_start, dst_vmap, src_vmap);
 	if (!err) {
-		if (!vma_start_read_locked(*dst_vmap)) {
+		if (vma_start_read_locked(*dst_vmap)) {
 			if (*dst_vmap != *src_vmap) {
 				if (!vma_start_read_locked_nested(*src_vmap,
 							SINGLE_DEPTH_NESTING)) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim-checkpatch-fixes.patch
mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch
mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail-fix.patch
mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless-fix.patch
mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch
mm-huge_memoryc-rename-shadowed-local.patch
xarray-port-tests-to-kunit-fix.patch
fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix.patch

