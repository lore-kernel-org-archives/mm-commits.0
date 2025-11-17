Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD80227599
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343208; cv=none; b=Sri98/A9c2O7z305CzQEMb19rPZCeCHKOiL/shN2Q94ahLqRi8GQkxL8IBA+u7ZrLR5XJl2Zgpmxqf8UQGHnc4hvutjewinXy6u4l2V/T24HrpKLC5Bj1GZCWUL7zoqlqjbe7SjpXhi8NGZIb7/W40xaUaatskWovmLHcH5R20I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343208; c=relaxed/simple;
	bh=2enqN90wc9LTvShoqLaI5vPuQZRA8tSu1wc9hXGuu+I=;
	h=Date:To:From:Subject:Message-Id; b=nXM4w6mao55uB2oi6xcFLxGOAMNJXl1BBwpU0+ZPN69ZuloMfeKSYzUwYuSwAD16GgLZqUO9e6214PVI99P9JYHsVh34U1n0VktC+lcNpNwg5ItrLjJ0TbGCp4j5+VXqwqPRb4PhamvkPmQLQxIWI6Y+PhRIAu2lmgek00SMEZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ukXZ1EYx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ukXZ1EYx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55F8C116D0;
	Mon, 17 Nov 2025 01:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343207;
	bh=2enqN90wc9LTvShoqLaI5vPuQZRA8tSu1wc9hXGuu+I=;
	h=Date:To:From:Subject:From;
	b=ukXZ1EYx5w+D3YrHRZWBL57GMapuN5LhKExgenGmDO1Cjxx4fl8i0wWcrv1LUTfw5
	 vbQY+YJU36oupGW3RVh0kHviUbIUDvn807DfdA/ZsYKhTtW3SExLO+cYhCVMEt3IdA
	 /0e+X9LHAvuvoIa6l3oTniFV1pJO85ZIh0JJpER8=
Date: Sun, 16 Nov 2025 17:33:27 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sj@kernel.org,roman.gushchin@linux.dev,rientjes@google.com,lethal@linux-sh.org,harry.yoo@oracle.com,cl@gentwo.org,william.kucharski@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-reference-to-destructor-in-comment-in-calculate_sizes.patch removed from -mm tree
Message-Id: <20251117013327.B55F8C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove reference to destructor in comment in calculate_sizes()
has been removed from the -mm tree.  Its filename was
     mm-remove-reference-to-destructor-in-comment-in-calculate_sizes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: SeongJae Park <sj@kernel.org>
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
@@ -7901,11 +7901,11 @@ static int calculate_sizes(struct kmem_c
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


