Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8FC2ECD32
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 23:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782860817; cv=none; b=cwB0QZKKhQ9G5VEvzyuZSWeePZDRPen6tga1doG4SH2EhhOWOPSFet/wmQn/YItmS/L0CnVd2gpMYfLzFGKFxRoU+z4pZxf+IVFw1C58aC3E3EhsWYnhNJzbCW5S5MKol50RKqXgDzysb9JVXZvUGbnoKp0KbkrCnmiOrlkXCUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782860817; c=relaxed/simple;
	bh=tg6N2mNAEERwIhNGUr480i14S6YGWRvPUbTCUHa/8+w=;
	h=Date:To:From:Subject:Message-Id; b=R1lg9jL7b6Hew54AdH9tnh7QnvPm/zT0uYBCAuDsO+UA1IDEooJo9xb/b1PpJutHYv6xFdRfmTZFGK4F3AWRAFk06jcHiOxaIamr1vE+PsupWjsPWcnab98CET3wIxhPSiIFg7HXFx3ZbLdX9vBpysSHF62rs1xnR0JHQNK6RiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BHWJyiAf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BHWJyiAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85F01F000E9;
	Tue, 30 Jun 2026 23:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782860815;
	bh=lUgIv/qe2+rzEyL0og72SNrtaxlaYdj0Y6XlJp6yW30=;
	h=Date:To:From:Subject;
	b=BHWJyiAf0h3woyDtDvLh5TcFBTTIrX40R5h5oilulA/ZK4Faem4b5Ej6bPUetFIvB
	 MdkqXJT7Du/MlDqDZVbZYu8DVZ0WGerIf//j97u/JAj83FBkS0mLcnpPMUxlZNbp1M
	 sB0CMPSDjGz0hMHKsl5CcXWFWef2Wm48P4b9phFo=
Date: Tue, 30 Jun 2026 16:06:55 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-documentation-fix.patch added to mm-new branch
Message-Id: <20260630230655.A85F01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: documentation fix
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-documentation-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-documentation-fix.patch

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
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: documentation fix
Date: Tue, 30 Jun 2026 15:08:28 -0400

Don't include the word flag in the quotes with the actual flag.

Link: https://lore.kernel.org/20260630190843.3563858-5-liam@infradead.org
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/maple_tree.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/core-api/maple_tree.rst~maple_tree-documentation-fix
+++ a/Documentation/core-api/maple_tree.rst
@@ -211,7 +211,7 @@ Advanced Locking
 
 The maple tree uses a spinlock by default, but external locks can be used for
 tree updates as well.  To use an external lock, the tree must be initialized
-with the ``MT_FLAGS_LOCK_EXTERN flag``, this is usually done with the
+with the ``MT_FLAGS_LOCK_EXTERN`` flag, this is usually done with the
 MTREE_INIT_EXT() #define, which takes an external lock as an argument.
 
 Functions and structures
_

Patches currently in -mm which might be from liam@infradead.org are

maple_tree-add-rcu-locking-check-when-lockdep-is-enabled.patch
locking-lockdep-add-sequence-counter-to-held_lock.patch
maple_tree-add-write-lock-checking-with-lockdep-sequence-numbers.patch
maple_tree-documentation-fix.patch
maple_tree-drop-dead-code-from-mas_extend_spanning_null.patch
maple_tree-drop-maple_alloc_slots.patch
maple_tree-clarify-comments-on-mas_nomem.patch
maple_tree-use-prefetched-value-in-mas_wr_store_type.patch
maple_tree-optimise-mas_wr_node_store-when-not-in-rcu-mode.patch
maple_tree-micro-optimisation-of-mas_wr_store_type.patch
maple_tree-add-bulk-parent-set-helper.patch
maple_tree-catch-race-in-mas_alloc_cyclic.patch
maple_tree-document-that-erase-may-use-gfp_kernel-for-allocations.patch
maple_tree-warn_on_once-when-allocations-fail.patch
maple_tree-document-erase-and-allocations-better.patch
maple_tree-change-two-gfp-flags-in-tests.patch
maple_tree-fix-argument-name-in-header.patch
maple_tree-avoid-extra-gap-calculation.patch
maple_tree-add-helper-mas_make_walkable.patch

