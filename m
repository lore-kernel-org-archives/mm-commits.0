Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B317537DEBA
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622985; cv=none; b=GiCZ+sW+ePhLKLKjVCMtSEHncOhDdIsPO6qvWX0+a1rSZI/GuXIlEZXEIV9rqwLiAOEg9AKEYV6h9Doovl2fOnpFlHshW1oFDEEsEfHGoHizkAWv3teajLsCbvenqDunKAHNuryRRbhaztye4wDiOSFiAajhU94FwVbRX2LpDhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622985; c=relaxed/simple;
	bh=5ZF2eNp+Z1ExUb6x3RxcV9M0OvQ/Y73/JRvVHJWdfQk=;
	h=Date:To:From:Subject:Message-Id; b=dBundzDeM+tfMJnbCprO9nRhetDwkeEX4ct0TFdR5MrYK4jph+lwLAyijBqQ+a1ccOe4eB3guJx5BiUGMoqvLckVlSyebpoasO4R4wzQpoy0sxq7m6gRGIGbBHSnqvKMDu+cMRJPAYtpIcgc+VxjsIPy08x5TB4vMqjzbh4X1SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vc/BTdVE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vc/BTdVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F131F000E9;
	Tue, 25 Aug 2026 01:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622983;
	bh=8auQWN1nXvrLHQxB8sti/xEoFSBBEsHBHSoAAjvhioU=;
	h=Date:To:From:Subject;
	b=Vc/BTdVEeA9BlmG4ixchO7Ill/j9BIgdvkpTpaskECQ5I+i2C1cTDyVPy5HrrP4dd
	 xlDbF2Fp/nIuYkVemyDA6I1sfNv103a1HcRc3gCJsOiMeA4DGI7kHFZbmIG5+SgcKV
	 zIUsddezI9rFg4QfPXvy449T6vzU1nnFu0rlTH4U=
Date: Mon, 24 Aug 2026 18:56:23 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,leitao@debian.org,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-document-erase-and-allocations-better.patch removed from -mm tree
Message-Id: <20260825015623.85F131F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: document erase and allocations better
has been removed from the -mm tree.  Its filename was
     maple_tree-document-erase-and-allocations-better.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: document erase and allocations better
Date: Fri, 21 Aug 2026 15:26:23 -0400

During a discussion on the maple tree erase process and GFP flags, Jason
suggested there be an amendment to the documentation to clarify the
situation on allocations within the tree.

The added text is an attempt to better explain that the tree may allocate,
even when erasing, and provide some guidance on how to work around such
issues.

[akpm@linux-foundation.org: tweak mtree_erase() description, per Jason]
Link: https://lore.kernel.org/all/20260617180419.GA231643@ziepe.ca/
Link: https://lore.kernel.org/20260821192627.4085470-16-liam@infradead.org
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
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

 Documentation/core-api/maple_tree.rst |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

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
@@ -63,7 +73,10 @@ success or an error code otherwise.  mtr
 but takes a range.  mtree_load() is used to retrieve the entry stored at a
 given index.  You can use mtree_erase() to erase an entire range by only
 knowing one value within that range, or mtree_store() call with an entry of
-NULL may be used to partially erase a range or many ranges at once.
+NULL may be used to partially erase a range or many ranges at once.  Note that
+mtree_erase() may use GFP_KERNEL | __GFP_NOFAIL for allocations and cannot
+fail.  mtree_erase() can sleep, so it must not be called from an atomic
+context.
 
 If you want to only store a new entry to a range (or index) if that range is
 currently ``NULL``, you can use mtree_insert_range() or mtree_insert() which
@@ -163,7 +176,10 @@ You can use mas_erase() to erase an enti
 last of the maple state to the desired range to erase.  This will erase
 the first range that is found in that range, set the maple state index
 and last as the range that was erased and return the entry that existed
-at that location.
+at that location.  Note that mas_erase() may allocate with the GFP_KERNEL
+__GFP_NOFAIL and cannot fail, but may sleep.  If this is not okay, consider
+using mas_store_gfp() and pass it a ``NULL``,
+after setting up the correct range by walking to the entry.
 
 You can walk each entry within a range by using mas_for_each().  If you want
 to walk each element of the tree then ``0`` and ``ULONG_MAX`` may be used as
_

Patches currently in -mm which might be from liam@infradead.org are


