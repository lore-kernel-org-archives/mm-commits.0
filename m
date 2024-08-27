Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6908484A2F
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724799852; cv=none; b=hQFL8VKMRiqdQra4HtDxnntOUPHFgdqfukK84yb4rOzKWA9hD0kMDEr+TdIBcwI1eNZuiBocc+4wltBB96J+/Z/8Gq8WVQVFXBH69a/Y/yy/GYHgrUbVV6WLBJch4jriVC1JypiYhn2uxCeOJ7GFfwsObGdk/2pWjoRJGkNwTdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724799852; c=relaxed/simple;
	bh=8XLyTUGuQ6HuhyuB37HOKIfB+qLdgdWKQswSv3WzuBM=;
	h=Date:To:From:Subject:Message-Id; b=tmJ2QdY9t/ipo29YKiWeppv/deGo88KGIBh7ws0WjDw25W1hlsLxRslp9uDBrYuOmiEpWcm7iKmIKOny9RQQ89SOx2sscc10562Yt9A2E2aM2hGQKJGtPKs1LcwpuHJlJ+wIVuUtpGzefKmyPZkzc6c/GimEK9eI3XPHUP9UpNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cooM3863; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cooM3863"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BAB3C4AF17;
	Tue, 27 Aug 2024 23:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724799852;
	bh=8XLyTUGuQ6HuhyuB37HOKIfB+qLdgdWKQswSv3WzuBM=;
	h=Date:To:From:Subject:From;
	b=cooM3863ynmI1E6KQNNge4m5XvKQDDjwJo7DHWKcFVc7YuAv5q7NiEUQVwW5eCBEk
	 jFM8LjjhBW49f89Cj3/0jkJxKlfRWoFLDsy/Ry9O606u8dHJcXUGP+kLkmLd/rD45u
	 Og/+ZmY9ea4CFvietRQ/ycUIftkaVQKVnYzCkP8g=
Date: Tue, 27 Aug 2024 16:04:11 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,oliver.sang@intel.com,Liam.Howlett@oracle.com,kees@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-avoid-using-vma_merge-for-new-vmas-fix.patch added to mm-unstable branch
Message-Id: <20240827230412.3BAB3C4AF17@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: only advance iterator if prev exists
has been added to the -mm mm-unstable branch.  Its filename is
     mm-avoid-using-vma_merge-for-new-vmas-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-avoid-using-vma_merge-for-new-vmas-fix.patch

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
Subject: mm: only advance iterator if prev exists
Date: Tue, 27 Aug 2024 11:59:27 +0100

If we have no VMAs prior to us, such as in a case where we are
mremap()'ing a VMA backwards, then we will advance the iterator backwards
to 0, before moving to the original range again.

The intent is to position the iterator at or before the gap, therefore we
must avoid this - this is simply addressed by only advancing the iterator
should vma_prev() yield a result.

Link: https://lkml.kernel.org/r/c0ef6b6a-1c9b-4da2-a180-c8e1c73b1c28@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202408271452.c842a71d-lkp@intel.com
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vma.c~mm-avoid-using-vma_merge-for-new-vmas-fix
+++ a/mm/vma.c
@@ -1557,8 +1557,8 @@ struct vm_area_struct *copy_vma(struct v
 	vmg.vma = NULL; /* New VMA range. */
 	vmg.pgoff = pgoff;
 	vmg.next = vma_next(&vmi);
-	vma_prev(&vmi);
-	vma_iter_next_range(&vmi);
+	if (vma_prev(&vmi))
+		vma_iter_next_range(&vmi);
 
 	new_vma = vma_merge_new_range(&vmg);
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc.patch
userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc-fix.patch
mm-move-vma_modify-and-helpers-to-internal-header.patch
mm-move-vma_shrink-vma_expand-to-internal-header.patch
mm-move-internal-core-vma-manipulation-functions-to-own-file.patch
maintainers-add-entry-for-new-vma-files.patch
tools-separate-out-shared-radix-tree-components.patch
tools-add-skeleton-code-for-userland-testing-of-vma-logic.patch
mm-vma-track-start-and-end-for-munmap-in-vma_munmap_struct-fix.patch
tools-improve-vma-test-makefile.patch
tools-add-vma-merge-tests.patch
mm-introduce-vma_merge_struct-and-abstract-vma_mergevma_modify.patch
mm-remove-duplicated-open-coded-vma-policy-check.patch
mm-abstract-vma_expand-to-use-vma_merge_struct.patch
mm-avoid-using-vma_merge-for-new-vmas.patch
mm-avoid-using-vma_merge-for-new-vmas-fix.patch
mm-make-vma_prepare-and-friends-static-and-internal-to-vmac.patch
mm-introduce-commit_merge-abstracting-final-commit-of-merge.patch
mm-refactor-vma_merge-into-modify-only-vma_merge_existing_range.patch
mm-rework-vm_ops-close-handling-on-vma-merge.patch

