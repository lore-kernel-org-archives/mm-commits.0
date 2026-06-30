Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785453264FF
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 23:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782860841; cv=none; b=hQzG+T0MnNbLJT1140/4nLYOAj58ld3uaG10jEFnPl5JfrGy7atr+DhJed1RWODI4qjscxs9AWBokTD+J/YMzEWoMdnIZZrxzRitCbpHoVaXqHJ7UmKAu1miDjeIoxu29bEKuKQJsPbxgQdzBhKv6CuygMjKX3IqOFXQKFJ+iJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782860841; c=relaxed/simple;
	bh=Q/HiICQd4L9spuYHu+lAPPQYNA36C9bHrOC9djZOvGo=;
	h=Date:To:From:Subject:Message-Id; b=Vl7V7hv6G2H0espYuxSahSjXpJeYrA6PYDwESkepLor49+2gdVQF4ahI4t8uru+OqU8Y2pj+Bs/Jls5wnMK3t3WX9IQSU/iQ3X1Lgezmsb4ixxg6uW/VvvbSnZwuijB2pL1s8FiVJGsM1ipTt8/Va2P/0uAUKYbKAWTQz8bITZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZGhVXLS0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZGhVXLS0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB9F1F000E9;
	Tue, 30 Jun 2026 23:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782860840;
	bh=pJa7yTaWck7VC/YP51iSSv5ELdQnGOvSAC4t8VoDxaE=;
	h=Date:To:From:Subject;
	b=ZGhVXLS0+ym+33fiEe+ag3Yq62raHWRX4MBWmSVUfDQLTd5HrLbNJjZYva4Ae2Mkn
	 NCjJPr7HMPq6IKUqrBwnpTqMTonHRpd4Ji+6dlM1MOvanNGVb7jNepK04tssHGVSoe
	 qlI0Ppl7gOh0qSxrfnkX5LpSU+Gohj60GLIvHH5I=
Date: Tue, 30 Jun 2026 16:07:19 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-document-erase-and-allocations-better.patch added to mm-new branch
Message-Id: <20260630230720.2BB9F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: document erase and allocations better
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-document-erase-and-allocations-better.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-document-erase-and-allocations-better.patch

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
Subject: maple_tree: document erase and allocations better
Date: Tue, 30 Jun 2026 15:08:39 -0400

During a discussion on the maple tree erase process and GFP flags, Jason
suggested there be an amendment to the documentation to clarify the
situation on allocations within the tree.

The added text is an attempt to better explain that the tree may allocate,
even when erasing, and provide some guidance on how to work around such
issues.

Link: https://lore.kernel.org/all/20260617180419.GA231643@ziepe.ca/
Link: https://lore.kernel.org/20260630190843.3563858-16-liam@infradead.org
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Rik van Riel <riel@surriel.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/maple_tree.rst |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/Documentation/core-api/maple_tree.rst~maple_tree-document-erase-and-allocations-better
+++ a/Documentation/core-api/maple_tree.rst
@@ -17,7 +17,8 @@ supports iterating over a range of entri
 entry in a cache-efficient manner.  The tree can also be put into an RCU-safe
 mode of operation which allows reading and writing concurrently.  Writers must
 synchronize on a lock, which can be the default spinlock, or the user can set
-the lock to an external lock of a different type.
+the lock to an external lock of a different type.  Note that external locks may
+interfere with allocations in a low memory situation.
 
 The Maple Tree maintains a small memory footprint and was designed to use
 modern processor cache efficiently.  The majority of the users will be able to
@@ -42,6 +43,15 @@ successful store operation within a give
 code segment when allocating cannot be done.  Allocations of nodes are
 relatively small at around 256 bytes.
 
+Since the maple tree uses internal nodes that are allocated and has rules on
+data density, erasing an entry may cause allocations to occur.  That is,
+erasing an entry may consume memory.  Users must take care to ensure that they
+do not violate the larger system constraints on when and how memory is
+allocated.  Most situations are fine to allocate, but the pre-allocation
+support is provided as a mechanism to avoid trickier situations.  There is also
+the possibility of using special entries and clean up the tree later, in
+extreme circumstances.
+
 .. _maple-tree-normal-api:
 
 Normal API
@@ -63,7 +73,8 @@ success or an error code otherwise.  mtr
 but takes a range.  mtree_load() is used to retrieve the entry stored at a
 given index.  You can use mtree_erase() to erase an entire range by only
 knowing one value within that range, or mtree_store() call with an entry of
-NULL may be used to partially erase a range or many ranges at once.
+NULL may be used to partially erase a range or many ranges at once.  Note that
+mtree_erase() may use GFP_KERNEL on allocations.
 
 If you want to only store a new entry to a range (or index) if that range is
 currently ``NULL``, you can use mtree_insert_range() or mtree_insert() which
@@ -163,7 +174,9 @@ You can use mas_erase() to erase an enti
 last of the maple state to the desired range to erase.  This will erase
 the first range that is found in that range, set the maple state index
 and last as the range that was erased and return the entry that existed
-at that location.
+at that location.  Note that mas_erase() may allocate with the GFP_KERNEL flag.
+If this is not okay, consider using mas_store_gfp() and pass it a ``NULL``,
+after setting up the correct range by walking to the entry.
 
 You can walk each entry within a range by using mas_for_each().  If you want
 to walk each element of the tree then ``0`` and ``ULONG_MAX`` may be used as
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

