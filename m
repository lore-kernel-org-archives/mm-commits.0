Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6A11A4E6C
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 21:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725310878; cv=none; b=XUcp0Ja5CElkDhFnwR+IhX/nd6HBcZfrb6p3E0UqjuAuEhNrfnQYgQ0WMu1rSmf3MJtUgHyuBYbV2T3UaTqr8/sY82TAjOfhPJ9dJA0vLk7bueSr4AkkRA9wOA7wvOHK5VY6RnQ0ji1wZ7a8+BOmOeRbgE9hLFlSdm2wfaNEjao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725310878; c=relaxed/simple;
	bh=b/NFQo7ZzBdlSEEq4GlrcS1GUBJc+Y8hL1MeZ2DEh5k=;
	h=Date:To:From:Subject:Message-Id; b=jattZTUGYZ8zVyudxSkQZjZKH96uhdLVqAdhOVQElauRAzyRvMP8SgNXpOpP2r3YsWGM4OGSIhW4e3nnRf0divFfrCpCD0aitw/MrAwKbqf/2JmqL0lO9NEp5Ii/uU/dGwrNrPS+FEungCUkdhp8B5c13GRlfBBqyswd5v+61JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cdU2u12b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cdU2u12b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B115EC4CEC8;
	Mon,  2 Sep 2024 21:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725310877;
	bh=b/NFQo7ZzBdlSEEq4GlrcS1GUBJc+Y8hL1MeZ2DEh5k=;
	h=Date:To:From:Subject:From;
	b=cdU2u12bYc+cFrWLCJGK5oST5YmY5aayNrH8WKwUfbDrMLOn+59hXMraZzyGZ+cZC
	 RAVz/ewijgTHuWToX1Pky8p5YVPsOmpzfvaYJUKUnZ3wIFqs1YX+vRBxL5A+jgOs51
	 xjjhtz0kr7jZOy0xTEQ2mgWhodEIVSHcjlyZmBv8=
Date: Mon, 02 Sep 2024 14:01:17 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,me@yhndnzj.com,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-cgroup-v2-clarify-that-zswapwriteback-is-ignored-if-zswap-is-disabled-fix.patch added to mm-unstable branch
Message-Id: <20240902210117.B115EC4CEC8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-test_zswap-add-test-for-hierarchical-zswapwriteback-fix
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-cgroup-v2-clarify-that-zswapwriteback-is-ignored-if-zswap-is-disabled-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-cgroup-v2-clarify-that-zswapwriteback-is-ignored-if-zswap-is-disabled-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-test_zswap-add-test-for-hierarchical-zswapwriteback-fix
Date: Fri Aug 23 10:25:10 PM PDT 2024

fix/simplify text

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Yuan <me@yhndnzj.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~documentation-cgroup-v2-clarify-that-zswapwriteback-is-ignored-if-zswap-is-disabled-fix
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1757,7 +1757,7 @@ The following nested keys are defined.
 	Note that this is subtly different from setting memory.swap.max to
 	0, as it still allows for pages to be written to the zswap pool.
 	This setting has no effect if zswap is disabled, and swapping
-	would be allowed unless memory.swap.max is set to 0.
+	is allowed unless memory.swap.max is set to 0.
 
   memory.pressure
 	A read-only nested-keyed file.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-contig_alloc-support-__gfp_comp-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix-fix.patch
mm-remove-pageactive-fix.patch
documentation-cgroup-v2-clarify-that-zswapwriteback-is-ignored-if-zswap-is-disabled-fix.patch
mm-count-the-number-of-anonymous-thps-per-size-fix.patch
mm-memory-failure-add-unmap_poisoned_folio-fix.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix-fix.patch
lib-maple_treec-remove-unused-functions.patch

