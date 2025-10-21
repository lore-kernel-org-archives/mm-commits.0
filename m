Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7F32586C8
	for <mm-commits@vger.kernel.org>; Tue, 21 Oct 2025 19:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761073359; cv=none; b=p1dD95XJOwsj520q0x4aPHs+s4SKfRN01a4wGcNW9rw20wRXKAgtRFH3OJS7maEucJ5CaI9se9VTW12hH6qSPW3NgwCMKKSqmaYkmmKExLAgQixNcI8j1VveECbn2ul+HROZaNa6YsBSicmxhw3z3CUnPIhHpNtPILmrfIQ6eUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761073359; c=relaxed/simple;
	bh=971xribwDLIESCiUVA9VdNdDCXWV/HqifU6AJVDFyfQ=;
	h=Date:To:From:Subject:Message-Id; b=YhnzvAF1mtL7Z6uO5vGOqWGmCI8401tX6zmnct0JQOgeYofZMxY2MXFHW4J9jILfEJa1iYIAiEvvk0g67/ITup8da/SRwo24PJKeXW6ue5t2EYgnywii7aB4RNo+fLAJ5nANqeMLg+jUawEn8tlVNWLqQFztMfQkJw9PPdxv7DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l1mcp+tv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l1mcp+tv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C63C4CEF1;
	Tue, 21 Oct 2025 19:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761073358;
	bh=971xribwDLIESCiUVA9VdNdDCXWV/HqifU6AJVDFyfQ=;
	h=Date:To:From:Subject:From;
	b=l1mcp+tvEadWsfqvWY1j/WGvcRDrR7N5TV0A1E2vdceSotHhNafH7u0mDxcBq6fDk
	 TkPefOXSW921B+fgG/W2g5yHZ1W0xyl2hS2tNWNcK2jQpKHHW7VPuCghWLdqCr1Hso
	 RqF5qHdQCmXr1MXu6pBGjO8UAmqqO8OGxXNNv3yM=
Date: Tue, 21 Oct 2025 12:02:38 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,rientjes@google.com,lethal@linux-sh.org,harry.yoo@oracle.com,cl@gentwo.org,william.kucharski@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-reference-to-destructor-in-comment-in-calculate_sizes.patch added to mm-new branch
Message-Id: <20251021190238.C6C63C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove reference to destructor in comment in calculate_sizes()
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-reference-to-destructor-in-comment-in-calculate_sizes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-reference-to-destructor-in-comment-in-calculate_sizes.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: William Kucharski <william.kucharski@oracle.com>
Subject: mm: remove reference to destructor in comment in calculate_sizes()
Date: Tue, 21 Oct 2025 05:00:04 -0600

The commit that removed support for destructors from kmem_cache_alloc()
never removed the comment regarding destructors in the explanation of the
possible relocation of the free pointer in calculate_sizes().

Link: https://lkml.kernel.org/r/20251021110004.2209008-1-william.kucharski@oracle.com
Fixes: 20c2df83d25c ("mm: Remove slab destructors from kmem_cache_create().")
Signed-off-by: William Kucharski <william.kucharski@oracle.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/slub.c~mm-remove-reference-to-destructor-in-comment-in-calculate_sizes
+++ a/mm/slub.c
@@ -7874,11 +7874,11 @@ static int calculate_sizes(struct kmem_c
 		 * permitted to overwrite the first word of the object on
 		 * kmem_cache_free.
 		 *
-		 * This is the case if we do RCU, have a constructor or
-		 * destructor, are poisoning the objects, or are
-		 * redzoning an object smaller than sizeof(void *) or are
-		 * redzoning an object with slub_debug_orig_size() enabled,
-		 * in which case the right redzone may be extended.
+		 * This is the case if we do RCU, have a constructor, are
+		 * poisoning the objects, or are redzoning an object smaller
+		 * than sizeof(void *) or are redzoning an object with
+		 * slub_debug_orig_size() enabled, in which case the right
+		 * redzone may be extended.
 		 *
 		 * The assumption that s->offset >= s->inuse means free
 		 * pointer is outside of the object is used in the
_

Patches currently in -mm which might be from william.kucharski@oracle.com are

mm-remove-reference-to-destructor-in-comment-in-calculate_sizes.patch

