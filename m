Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721723264FF
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 23:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782860845; cv=none; b=WZVwnzQ8iGfqjNjyMQiRDaPKMYWuKiY4ep3I91uGn9kVAKhrlEMaMg2WGEGeyaN7pOdNsqqDiMGwWDndghG0I4f2hsQS/IWvQic5KEJ6vdo+OvMcfUuzXDqnG96kpigYesNFe7HNRgRDJNVvsrHdEE53zG60p81XlFv9Mfaz0ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782860845; c=relaxed/simple;
	bh=k3JErifPCYNoqamGzcIIK4aaI8T0SbeqRalbnIhk4DI=;
	h=Date:To:From:Subject:Message-Id; b=c+332aPSJHMnJ1JdtZX1BnKR9MU3DmTr1s+w6pKUtmhqq4CETs8M+UkL4s7rq5YoUNgOZWcvqVe66l/PkJHME8r6yRKq2EO4SP/Rv7yUpNtiDbIP+iMVlyxDkr6cByd876RYCGLQhi02bBcfSFCPZ8yU0qTfxSvEkmiGAUC/arg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NHQj9V4l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NHQj9V4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A471F000E9;
	Tue, 30 Jun 2026 23:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782860844;
	bh=y5347L2ImCqc6Xjufya9HQNjz5E52R0p7Z3hwqDLy1s=;
	h=Date:To:From:Subject;
	b=NHQj9V4lOxGYX3eXxiwAOwVgCIaIJkIKpP2+jcbBLwnGme5yWRekpc80sSE03tQ+r
	 T3N7b5skuVj6MaRTiEAOUhOFUMIHi60SHiObm5KXCdQP35EW55A7LuAG72PIKlw+Tv
	 ULX/oKdVx4JQxKKHJ9I3GZ5XT1Oh9UG8m7flgLcU=
Date: Tue, 30 Jun 2026 16:07:23 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-argument-name-in-header.patch added to mm-new branch
Message-Id: <20260630230724.46A471F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: fix argument name in header
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-fix-argument-name-in-header.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-argument-name-in-header.patch

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
Subject: maple_tree: fix argument name in header
Date: Tue, 30 Jun 2026 15:08:41 -0400

The mas_prev_range() function takes a min and not a max.

Link: https://lore.kernel.org/20260630190843.3563858-18-liam@infradead.org
Fixes: 6b9e93e010204 ("maple_tree: add mas_prev_range() and mas_find_range_rev interface")
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

 include/linux/maple_tree.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/maple_tree.h~maple_tree-fix-argument-name-in-header
+++ a/include/linux/maple_tree.h
@@ -576,7 +576,7 @@ void maple_tree_init(void);
 void mas_destroy(struct ma_state *mas);
 
 void *mas_prev(struct ma_state *mas, unsigned long min);
-void *mas_prev_range(struct ma_state *mas, unsigned long max);
+void *mas_prev_range(struct ma_state *mas, unsigned long min);
 void *mas_next(struct ma_state *mas, unsigned long max);
 void *mas_next_range(struct ma_state *mas, unsigned long max);
 
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

