Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3851C33987D
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 17:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721026; cv=none; b=nIykox1kDuNzCgEBjXNPToBA6b9wmplkOu2VaWFzFnMNuzupzzw867zgBO5TrFdMh6WK4oZux35G/SYDUBjp7FliFWR+YdA+/4kQi9aHzkUHS4r9ID1Leog20dAeOU7lMTjv86ZRzFdpVx7SOEc3QvLL1Bk7WTJhFX1/JBudwbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721026; c=relaxed/simple;
	bh=ngeuvBsWq+hGOdQz4W+EJNov/AUQPdAa0XlboExP2hM=;
	h=Date:To:From:Subject:Message-Id; b=pQONd7BqY6A/A5vAxi6eGVIdZMi2W9R+YJF1eXn9KavvWOfwtQvZVoJBQTL6o0lRZyImNqubMh3Eq0Bp2B6+gXcwXsBlGXfYLtp1hW9hetX2GPV4CUYX+LBZx9pFmvZ36yy6YT0Z1Gg0wjtqLW5svohw5WdKoVuZXk9jj48547M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=atr7D8BO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="atr7D8BO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1793C116C6;
	Tue,  6 Jan 2026 17:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767721026;
	bh=ngeuvBsWq+hGOdQz4W+EJNov/AUQPdAa0XlboExP2hM=;
	h=Date:To:From:Subject:From;
	b=atr7D8BOHoe9FAALGC3yHpizHaIeUPoHWTBXgdJ/p3KYWjF+hstK8ALFr0L/qR31Q
	 5J09hFkxBikN6wEbMK+Ej6Gsxo2J7GKcT68urswPIm23b+KrvreJ6HFgEp7XPnfknG
	 IXhDAg4jzDkmto1bUJSqxanXDRvHXepav8G9lHfE=
Date: Tue, 06 Jan 2026 09:37:05 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,mhocko@suse.com,Liam.Howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,chriscli@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-remove-anon_vma_merge-function.patch added to mm-new branch
Message-Id: <20260106173705.E1793C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: remove anon_vma_merge() function
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-remove-anon_vma_merge-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-remove-anon_vma_merge-function.patch

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
Subject: mm/rmap: remove anon_vma_merge() function
Date: Tue, 6 Jan 2026 15:04:29 +0000

This function is confusing, we already have the concept of anon_vma merge
to adjacent VMA's anon_vma's to increase probability of anon_vma
compatibility and therefore VMA merge (see is_mergeable_anon_vma() etc.),
as well as anon_vma reuse, along side the usual VMA merge logic.

We can remove the anon_vma check as it is redundant - a merge would not
have been permitted with removal if the anon_vma's were not the same (and
in the case of an unfaulted/faulted merge, we would have already set the
unfaulted VMA's anon_vma to vp->remove->anon_vma in dup_anon_vma()).

Avoid overloading this term when we're very simply unlinking anon_vma
state from a removed VMA upon merge.

Link: https://lkml.kernel.org/r/1f5d605c2b35462194782fd17212a4d6c060e278.1767711638.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chriscli@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h             |    7 -------
 mm/vma.c                         |    2 +-
 tools/testing/vma/vma_internal.h |    5 -----
 3 files changed, 1 insertion(+), 13 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-remove-anon_vma_merge-function
+++ a/include/linux/rmap.h
@@ -165,13 +165,6 @@ static inline int anon_vma_prepare(struc
 	return __anon_vma_prepare(vma);
 }
 
-static inline void anon_vma_merge(struct vm_area_struct *vma,
-				  struct vm_area_struct *next)
-{
-	VM_BUG_ON_VMA(vma->anon_vma != next->anon_vma, vma);
-	unlink_anon_vmas(next);
-}
-
 struct anon_vma *folio_get_anon_vma(const struct folio *folio);
 
 #ifdef CONFIG_MM_ID
--- a/mm/vma.c~mm-rmap-remove-anon_vma_merge-function
+++ a/mm/vma.c
@@ -379,7 +379,7 @@ again:
 			fput(vp->file);
 		}
 		if (vp->remove->anon_vma)
-			anon_vma_merge(vp->vma, vp->remove);
+			unlink_anon_vmas(vp->remove);
 		mm->map_count--;
 		mpol_put(vma_policy(vp->remove));
 		if (!vp->remove2)
--- a/tools/testing/vma/vma_internal.h~mm-rmap-remove-anon_vma_merge-function
+++ a/tools/testing/vma/vma_internal.h
@@ -1265,11 +1265,6 @@ static inline void i_mmap_unlock_write(s
 {
 }
 
-static inline void anon_vma_merge(struct vm_area_struct *vma,
-				  struct vm_area_struct *next)
-{
-}
-
 static inline int userfaultfd_unmap_prep(struct vm_area_struct *vma,
 					 unsigned long start,
 					 unsigned long end,
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
mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone.patch

