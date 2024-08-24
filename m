Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A3C14B092
	for <mm-commits@vger.kernel.org>; Sat, 24 Aug 2024 05:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724477163; cv=none; b=dmMzh4qCxrFhTkcUg/hdubtSP4wTLq3GJ8/yd9ONyN5xD/Sg62wpYNUmaFKNBeAC5C6WLQ0PWe8mYYkYvTOynULNN4tk0LYpf6a+zDnXaS5VGghwI69/r1M/kBeTwKSwCT5YM49Ei7862RynsgNsjq/y/cU1YWE5pojafwFFqZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724477163; c=relaxed/simple;
	bh=HM2YONxIQI+WgoB7whAde0OytfV+78n7xMPnUDZEtqs=;
	h=Date:To:From:Subject:Message-Id; b=KHCiWNHFD8vDR/tlYro5vbChuJfduuBhUS0ow0rArxfWX/dQ62URYfPoP1q7G+FyLk5iMtNDgMxO9xSY5/QV7XnHBCR0VOEgT+Qs4xPva4jWPKCYLlWuDuJ8MxatQo7SfV9EmbzEIGN0Oh7wSUIL3u75ZTn25j2WtrxqSisVak0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kjz8Hp3m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kjz8Hp3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F1CC32781;
	Sat, 24 Aug 2024 05:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724477163;
	bh=HM2YONxIQI+WgoB7whAde0OytfV+78n7xMPnUDZEtqs=;
	h=Date:To:From:Subject:From;
	b=kjz8Hp3miU8TI3EXoG5NJR74cNpVsNtOWT9mRAxyvYjUNnSuwUACeoKS8UyRVf9oC
	 JGDT3DtNALtm1Tgu65IntVNJ3+TsQQzxYGO55bVUA7UonXoue7HvHhsGy+KPeEsYc5
	 9fl4zqqBg/MWnrbWkl4GLaj3/XVZQxkS9H62M6qI=
Date: Fri, 23 Aug 2024 22:26:02 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,me@yhndnzj.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-test_zswap-add-test-for-hierarchical-zswapwriteback.patch added to mm-unstable branch
Message-Id: <20240824052603.18F1CC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: test_zswap: add test for hierarchical zswap.writeback
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-test_zswap-add-test-for-hierarchical-zswapwriteback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-test_zswap-add-test-for-hierarchical-zswapwriteback.patch

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
From: Mike Yuan <me@yhndnzj.com>
Subject: selftests: test_zswap: add test for hierarchical zswap.writeback
Date: Fri, 23 Aug 2024 16:27:09 +0000

Ensure that zswap.writeback check goes up the cgroup tree, i.e.  is
hierarchical.  Create a subcgroup which has zswap.writeback set to 1, and
the upper hierarchy's restrictions shall apply.

Link: https://lkml.kernel.org/r/20240823162506.12117-2-me@yhndnzj.com
Signed-off-by: Mike Yuan <me@yhndnzj.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/admin-guide/cgroup-v2.rst~selftests-test_zswap-add-test-for-hierarchical-zswapwriteback
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1756,6 +1756,8 @@ The following nested keys are defined.
 
 	Note that this is subtly different from setting memory.swap.max to
 	0, as it still allows for pages to be written to the zswap pool.
+	This setting has no effect if zswap is disabled, and swapping
+	would be allowed unless memory.swap.max is set to 0.
 
   memory.pressure
 	A read-only nested-keyed file.
_

Patches currently in -mm which might be from me@yhndnzj.com are

mm-memcontrol-respect-zswapwriteback-setting-from-parent-cg-too.patch
documentation-cgroup-v2-clarify-that-zswapwriteback-is-ignored-if-zswap-is-disabled.patch
selftests-test_zswap-add-test-for-hierarchical-zswapwriteback.patch

