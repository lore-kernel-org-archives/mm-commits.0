Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B55938F64D
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 22:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787352288; cv=none; b=aAZMXz17S1iI0LHAnp87hVI5okPlfsoyHeLL9YDH/Wq53NaqnHAuUg8a4+nLy9tBoinz/6FcKAAO/5tG2nhqxs/e4MJUPK+Dwj2jWNpMz5tTRGDaK959xwCNfv48Ltc9bZn9UgNWio/XBTZr0ymQ3suMlrqBV9btmWBOvrWcM8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787352288; c=relaxed/simple;
	bh=9yYjBvjKsebFRDZEB2YK3g0QpXViqzn+sX5CzpI0ppo=;
	h=Date:To:From:Subject:Message-Id; b=HlgaI8UhP6CZtktQb9x9SjyAlFMQdswZBmdyYnpjzngJ3H/JtAMl/9M4qRKk3AQLCWtNyiyHcLvMRlyoqpQwn5yKllTvbkm8VaHiYRoAuTAW7j1ezszU3NxOZnnoyDmw41VQU9cu/w2xTT83m17kqFB5/UpU5FAqkEbA8dGD8+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KqIu9fUJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KqIu9fUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234EF1F000E9;
	Fri, 21 Aug 2026 22:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787352287;
	bh=MQJUN2SxzX3kuGB1iepu9vyA7VUweIsa8fEbGxv0ztI=;
	h=Date:To:From:Subject;
	b=KqIu9fUJ3dC0RISOSHuM8Ca4m2DACqvFLdI7jiGpWvEvwhsOO53IvUfQArdmO3ps8
	 qNNHSXLH0y7EDJa9dGWQuIlv3pME6oJDqO5n4/9gljhbRnbgaLfXLTjSjUjGwfyic6
	 F+SShyIbRWgJ6VCXaoHIOw56cyklhzqGajqUCBJY=
Date: Fri, 21 Aug 2026 15:44:46 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,liam@infradead.org,leitao@debian.org,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-document-erase-and-allocations-better-fix.patch added to mm-unstable branch
Message-Id: <20260821224447.234EF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree-document-erase-and-allocations-better-fix
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-document-erase-and-allocations-better-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-document-erase-and-allocations-better-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: maple_tree-document-erase-and-allocations-better-fix
Date: Fri Aug 21 03:27:57 PM PDT 2026

tweak mtree_erase() description, per Jason

Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/maple_tree.rst |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/Documentation/core-api/maple_tree.rst~maple_tree-document-erase-and-allocations-better-fix
+++ a/Documentation/core-api/maple_tree.rst
@@ -75,7 +75,8 @@ given index.  You can use mtree_erase()
 knowing one value within that range, or mtree_store() call with an entry of
 NULL may be used to partially erase a range or many ranges at once.  Note that
 mtree_erase() may use GFP_KERNEL | __GFP_NOFAIL for allocations and cannot
-fail, but may need to sleep - do not use mtree_erase() from a blocking context.
+fail.  mtree_erase() can sleep, so it must not be called from an atomic
+context.
 
 If you want to only store a new entry to a range (or index) if that range is
 currently ``NULL``, you can use mtree_insert_range() or mtree_insert() which
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix.patch
selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning-fix.patch
maple_tree-document-erase-and-allocations-better-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

