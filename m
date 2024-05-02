Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FDB28FC
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 17:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714669675; cv=none; b=KVJNRYA7hyEYHq2d6mvFiwcj+phbxQ5Wh8O+LnG9uM0H9GFcOuyMdjIblsut9TtRDkYVi2wgajixKr03MIjaiGAXBZ3XBW87Sm28HzjGlAfuhjrCEcU3mHhQNXCoUARkMdppO+ivYnGkvU58nI80I8s3LIqeKz6b3odb8POxlQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714669675; c=relaxed/simple;
	bh=GXivTwBaxx5HkbQEdSeu450Z4wtqjWXGmPsVkmzgtPY=;
	h=Date:To:From:Subject:Message-Id; b=D03LUnAZKFJ8Wtl9fl6uwyLjaLtHlRrgWmFUHPuk/I+7dX44C/rJ/Zo4dguOACPBYCIX338l2ASiSgl7pdVYILGnzqF4xTOtu3Jpql9oB+Vs4ZXeLcK6ZMCIllU1yf0FFtOi1woTXnyTWmme4Nnnl5hI8iQqgdM0S6PYFCAPLRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G3PEzFlA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G3PEzFlA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213ABC113CC;
	Thu,  2 May 2024 17:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714669675;
	bh=GXivTwBaxx5HkbQEdSeu450Z4wtqjWXGmPsVkmzgtPY=;
	h=Date:To:From:Subject:From;
	b=G3PEzFlANIfQUpTXC+icegdx0zOlmhGUdnSHRzINK+gSO0cA9dNbRWXI2REdKHtJ9
	 8URSPCZieqvwChuL4vfF25eFMVI5HlYxU4jU7zKgKqrEvMIAHbsEBefpOzJHJtFefh
	 Lw9owjBX8XgANJdVApHWKPgVJDYGyOM22C0spkHA=
Date: Thu, 02 May 2024 10:07:53 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,hch@lst.de,elver@google.com,andreyknvl@gmail.com,dchinner@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-lift-gfp_kmemleak_mask-to-gfph.patch added to mm-unstable branch
Message-Id: <20240502170755.213ABC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: lift gfp_kmemleak_mask() to gfp.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-lift-gfp_kmemleak_mask-to-gfph.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-lift-gfp_kmemleak_mask-to-gfph.patch

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
From: Dave Chinner <dchinner@redhat.com>
Subject: mm: lift gfp_kmemleak_mask() to gfp.h
Date: Tue, 30 Apr 2024 15:28:23 +1000

Patch series "mm: fix nested allocation context filtering".

This patchset is the followup to the comment I made earlier today:

https://lore.kernel.org/linux-xfs/ZjAyIWUzDipofHFJ@dread.disaster.area/

Tl;dr: Memory allocations that are done inside the public memory
allocation API need to obey the reclaim recursion constraints placed on
the allocation by the original caller, including the "don't track
recursion for this allocation" case defined by __GFP_NOLOCKDEP.

These nested allocations are generally in debug code that is tracking
something about the allocation (kmemleak, KASAN, etc) and so are
allocating private kernel objects that only that debug system will use.

Neither the page-owner code nor the stack depot code get this right.  They
also also clear GFP_ZONEMASK as a separate operation, which is completely
redundant because the constraint filter applied immediately after
guarantees that GFP_ZONEMASK bits are cleared.

kmemleak gets this filtering right.  It preserves the allocation
constraints for deadlock prevention and clears all other context flags
whilst also ensuring that the nested allocation will fail quickly,
silently and without depleting emergency kernel reserves if there is no
memory available.

This can be made much more robust, immune to whack-a-mole games and the
code greatly simplified by lifting gfp_kmemleak_mask() to
include/linux/gfp.h and using that everywhere.  Also document it so that
there is no excuse for not knowing about it when writing new debug code
that nests allocations.

Tested with lockdep, KASAN + page_owner=on and kmemleak=on over multiple
fstests runs with XFS.


This patch (of 3):

Any "internal" nested allocation done from within an allocation context
needs to obey the high level allocation gfp_mask constraints.  This is
necessary for debug code like KASAN, kmemleak, lockdep, etc that allocate
memory for saving stack traces and other information during memory
allocation.  If they don't obey things like __GFP_NOLOCKDEP or
__GFP_NOWARN, they produce false positive failure detections.

kmemleak gets this right by using gfp_kmemleak_mask() to pass through the
relevant context flags to the nested allocation to ensure that the
allocation follows the constraints of the caller context.

KASAN recently was foudn to be missing __GFP_NOLOCKDEP due to stack depot
allocations, and even more recently the page owner tracking code was also
found to be missing __GFP_NOLOCKDEP support.

We also don't wan't want KASAN or lockdep to drive the system into OOM
kill territory by exhausting emergency reserves.  This is something that
kmemleak also gets right by adding (__GFP_NORETRY | __GFP_NOMEMALLOC |
__GFP_NOWARN) to the allocation mask.

Hence it is clear that we need to define a common nested allocation filter
mask for these sorts of third party nested allocations used in debug code.
So to start this process, lift gfp_kmemleak_mask() to gfp.h and rename it
to gfp_nested_mask(), and convert the kmemleak callers to use it.

Link: https://lkml.kernel.org/r/20240430054604.4169568-1-david@fromorbit.com
Link: https://lkml.kernel.org/r/20240430054604.4169568-2-david@fromorbit.com
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |   25 +++++++++++++++++++++++++
 mm/kmemleak.c       |   12 ++++--------
 2 files changed, 29 insertions(+), 8 deletions(-)

--- a/include/linux/gfp.h~mm-lift-gfp_kmemleak_mask-to-gfph
+++ a/include/linux/gfp.h
@@ -157,6 +157,31 @@ static inline int gfp_zonelist(gfp_t fla
 }
 
 /*
+ * gfp flag masking for nested internal allocations.
+ *
+ * For code that needs to do allocations inside the public allocation API (e.g.
+ * memory allocation tracking code) the allocations need to obey the caller
+ * allocation context constrains to prevent allocation context mismatches (e.g.
+ * GFP_KERNEL allocations in GFP_NOFS contexts) from potential deadlock
+ * situations.
+ *
+ * It is also assumed that these nested allocations are for internal kernel
+ * object storage purposes only and are not going to be used for DMA, etc. Hence
+ * we strip out all the zone information and leave just the context information
+ * intact.
+ *
+ * Further, internal allocations must fail before the higher level allocation
+ * can fail, so we must make them fail faster and fail silently. We also don't
+ * want them to deplete emergency reserves.  Hence nested allocations must be
+ * prepared for these allocations to fail.
+ */
+static inline gfp_t gfp_nested_mask(gfp_t flags)
+{
+	return ((flags & (GFP_KERNEL | GFP_ATOMIC | __GFP_NOLOCKDEP)) |
+		(__GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN));
+}
+
+/*
  * We get the zone list from the current node and the gfp_mask.
  * This zone list contains a maximum of MAX_NUMNODES*MAX_NR_ZONES zones.
  * There are two zonelists per node, one for all zones with memory and
--- a/mm/kmemleak.c~mm-lift-gfp_kmemleak_mask-to-gfph
+++ a/mm/kmemleak.c
@@ -114,12 +114,6 @@
 
 #define BYTES_PER_POINTER	sizeof(void *)
 
-/* GFP bitmask for kmemleak internal allocations */
-#define gfp_kmemleak_mask(gfp)	(((gfp) & (GFP_KERNEL | GFP_ATOMIC | \
-					   __GFP_NOLOCKDEP)) | \
-				 __GFP_NORETRY | __GFP_NOMEMALLOC | \
-				 __GFP_NOWARN)
-
 /* scanning area inside a memory block */
 struct kmemleak_scan_area {
 	struct hlist_node node;
@@ -463,7 +457,8 @@ static struct kmemleak_object *mem_pool_
 
 	/* try the slab allocator first */
 	if (object_cache) {
-		object = kmem_cache_alloc_noprof(object_cache, gfp_kmemleak_mask(gfp));
+		object = kmem_cache_alloc_noprof(object_cache,
+						 gfp_nested_mask(gfp));
 		if (object)
 			return object;
 	}
@@ -947,7 +942,8 @@ static void add_scan_area(unsigned long
 	untagged_objp = (unsigned long)kasan_reset_tag((void *)object->pointer);
 
 	if (scan_area_cache)
-		area = kmem_cache_alloc_noprof(scan_area_cache, gfp_kmemleak_mask(gfp));
+		area = kmem_cache_alloc_noprof(scan_area_cache,
+					       gfp_nested_mask(gfp));
 
 	raw_spin_lock_irqsave(&object->lock, flags);
 	if (!area) {
_

Patches currently in -mm which might be from dchinner@redhat.com are

mm-lift-gfp_kmemleak_mask-to-gfph.patch
stackdepot-use-gfp_nested_mask-instead-of-open-coded-masking.patch

