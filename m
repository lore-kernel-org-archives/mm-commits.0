Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227947580E
	for <mm-commits@vger.kernel.org>; Sun,  5 May 2024 21:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714942891; cv=none; b=pckqdwQKIZtF2JWpEqCJX5N33dJs3fq3sq8qzIIsBkKs20QSxVEJJlLhXnZtXl0EMBcRiZJrTF7wX5SkHzCb1cRgwVFNqtqVKb8OHuCSN8ks0esW/jXwgpBs97j8KrECabCTnP/ALdVVL1EZSMz7lM8PdlV4GWyDDs/Sg/EpcaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714942891; c=relaxed/simple;
	bh=lsI25GkPiJ4FnZ/Yxb309IF8BZdVDLhISbdxjO3JvJU=;
	h=Date:To:From:Subject:Message-Id; b=HBXBm8ZLIz/Gn9NQu/tAS3WiJ/GmxVOR32AOLmoCnS5oQnogsl4sWJTvS82kUe94mAU3BQ2gWtZr011UMt7kNi0joZLj0zZ6aM7jM1ABquSZ8bnGz0q0QbGlujXeosgBz3Op75UlcK2NlU1rinR0UNTAHeuqDf8oJqgDtezT/Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1Kwnu5FF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1Kwnu5FF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D0FC116B1;
	Sun,  5 May 2024 21:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714942891;
	bh=lsI25GkPiJ4FnZ/Yxb309IF8BZdVDLhISbdxjO3JvJU=;
	h=Date:To:From:Subject:From;
	b=1Kwnu5FFG9H1oODCjwtBEcbtx8eeuKkfwIYCQmHPa2FR4mJwh2omyKfS+tMbjTozD
	 LGgtd0ROW3cCoAo8+jl5aElTPWMPsdPkPe+KIMsostnlGS/WXRqRcztVsASfjqkdvS
	 wpUsYU1//n0QBzehFvGfQdsvFWr0jiCAJys8h/44=
Date: Sun, 05 May 2024 14:01:30 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-remove-redundant-addition-of-memory-controller.patch added to mm-unstable branch
Message-Id: <20240505210130.E5D0FC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: cgroup: remove redundant enabling of memory controller
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-cgroup-remove-redundant-addition-of-memory-controller.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-remove-redundant-addition-of-memory-controller.patch

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
From: Usama Arif <usamaarif642@gmail.com>
Subject: selftests: cgroup: remove redundant enabling of memory controller
Date: Thu, 2 May 2024 21:04:26 +0100

Memory controller is already enabled in main which invokes the test, hence
this does not need to be done in test_no_kmem_bypass.

Link: https://lkml.kernel.org/r/20240502200529.4193651-2-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_zswap.c |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-remove-redundant-addition-of-memory-controller
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -364,8 +364,6 @@ static int test_no_kmem_bypass(const cha
 	trigger_allocation_size = sys_info.totalram / 20;
 
 	/* Set up test memcg */
-	if (cg_write(root, "cgroup.subtree_control", "+memory"))
-		goto out;
 	test_group = cg_name(root, "kmem_bypass_test");
 	if (!test_group)
 		goto out;
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

selftests-cgroup-remove-redundant-addition-of-memory-controller.patch

