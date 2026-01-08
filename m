Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8E21DDC07
	for <mm-commits@vger.kernel.org>; Thu,  8 Jan 2026 20:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767902519; cv=none; b=RAj8E3fOoDTXA+6ZoirIC4jYHpiN/LiauvAbssa00f45DLwKA5zeJ7+Whoe1C5c2ZqgMsKe9OHNVY5CFcOVYTVBjtyYtQMc9qaD0wS1St9929qfCuPSQ/hiDoQhRhLX1vSvMYzF+3GbkslOkOAgxwODtaBaSjtYmCUObW26nQqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767902519; c=relaxed/simple;
	bh=Y1GsFKfKYDeLmE+HkrASLkSpxB9Xqq+T4AS+eMHSuQE=;
	h=Date:To:From:Subject:Message-Id; b=itxK3uuMM4NRkcwk6/Nn3lLlnPnqmBJpQP7Hff9iGj2MeeOgQjw5hak/hwBvM5zNEle3VwfM1dR+CUV9MeovuNkunJJXfJBpOMNjeWAuXyWKHRHFE9OUmgmWsxUSZIpu+1DxBs5HwVSLqjfcvMDueVzGltoUj2yJNskZaPIFxWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l9fBgTEU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l9fBgTEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0EBC116C6;
	Thu,  8 Jan 2026 20:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767902518;
	bh=Y1GsFKfKYDeLmE+HkrASLkSpxB9Xqq+T4AS+eMHSuQE=;
	h=Date:To:From:Subject:From;
	b=l9fBgTEUwo0jjFXyWzTS++Ih0PAiEfYwv5uWYYmAzSjUAjPXzBEt/czNWD3p+4GeB
	 dihdYT9+1iLAuEGytNH01VN23IkZPvXPWa0dgOnZQF4UPt7gh8hi9H+v9iODQVylT4
	 SxCLM/6Pj8rN32DhQSwwQVf4xlIekuXjICbFMc80=
Date: Thu, 08 Jan 2026 12:01:58 -0800
To: mm-commits@vger.kernel.org,liam.howlett@oracle.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone-fix.patch added to mm-new branch
Message-Id: <20260108200158.CA0EBC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone-fix
Date: Thu, 8 Jan 2026 18:49:44 +0000

rename try_to_reuse_anon_vma(), per Liam

Link: https://lkml.kernel.org/r/e38b8ed2-455f-41f5-8cf9-bfca3915c7c6@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/rmap.c~mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone-fix
+++ a/mm/rmap.c
@@ -267,8 +267,8 @@ static void check_anon_vma_clone(struct
 #endif
 }
 
-static void try_to_reuse_anon_vma(struct vm_area_struct *dst,
-				  struct anon_vma *anon_vma)
+static void maybe_reuse_anon_vma(struct vm_area_struct *dst,
+		struct anon_vma *anon_vma)
 {
 	/* If already populated, nothing to do.*/
 	if (dst->anon_vma)
@@ -356,7 +356,7 @@ int anon_vma_clone(struct vm_area_struct
 
 		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 		if (operation == VMA_OP_FORK)
-			try_to_reuse_anon_vma(dst, anon_vma);
+			maybe_reuse_anon_vma(dst, anon_vma);
 	}
 
 	if (operation != VMA_OP_FORK)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-fix-anon_vma-uaf-on-mremap-faulted-unfaulted-merge.patch
tools-testing-selftests-add-tests-for-tgt-src-mremap-merges.patch
mm-vma-enforce-vma-fork-limit-on-unfaultedfaulted-mremap-merge-too.patch
tools-testing-selftests-add-forked-un-faulted-vma-merge-tests.patch
tools-testing-selftests-fix-gup_longterm-for-unknown-fs.patch
mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts.patch
mm-rmap-skip-unfaulted-vmas-on-anon_vma-clone-unlink.patch
mm-rmap-remove-unnecessary-root-lock-dance-in-anon_vma-clone-unmap.patch
mm-rmap-remove-anon_vma_merge-function.patch
mm-rmap-make-anon_vma-functions-internal.patch
mm-mmap_lock-add-vma_is_attached-helper.patch
mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible.patch
mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible-fix.patch
mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone.patch
mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone-fix.patch

