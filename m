Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D31B18E05F
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925295; cv=none; b=Ey9wGD7gc3b189Hm1ihibsFChcq9MlqwsTd6sKl1EO+ky/vBPzctVE6DiG5mmW1zrDwlq5w7f3Pj0fC/DdGpHTiHlJFD8S8xvshp0gOuDi6iMP/4sTwQUfN16T+l5QsxNN+x+ggqV0pCohijbwkeJI48yCy/9WIoWEwaHAcRKu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925295; c=relaxed/simple;
	bh=Bv3zs1RPsVUcE3mrjbtumnub55EIXCFheLoTqxuc2w4=;
	h=Date:To:From:Subject:Message-Id; b=XbumZKIGAL7DGbQiui95Rqr8Zf/zpfU7J4ZDecgrUWiuimoSS1kSMvA9iRnYypf7jUpp3WuJA3wOFN+UNd9zyRjUp1pqGTash8grCGFrDfKU0YImg+zAa+9f79NC/HXRqvpxyjothOWwxKs0i34ifMK6p3p1JNT2PsgPnAWcQHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rz7I20DN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rz7I20DN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2320DC4CEC5;
	Mon,  9 Sep 2024 23:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925295;
	bh=Bv3zs1RPsVUcE3mrjbtumnub55EIXCFheLoTqxuc2w4=;
	h=Date:To:From:Subject:From;
	b=Rz7I20DNLRk6pTq+oYIBAQP47UeSwlbp8L2PSBZ3R+2pa2kVABj2yACd3bOOPG2eY
	 CXwOAdTL8/MI+lGZAYdca5z05dtvi7A08vjhTxe8CM7xd0bfgkNTEZqMlDKtIl45gx
	 czagTK2nfBt/HzU0vACJGd4QjiTy1qACdgd/aauM=
Date: Mon, 09 Sep 2024 16:41:34 -0700
To: mm-commits@vger.kernel.org,linux@roeck-us.net,Liam.Howlett@oracle.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-vaddr-kunit-init-maple-tree-without-mt_flags_lock_extern.patch removed from -mm tree
Message-Id: <20240909234135.2320DC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/vaddr-kunit: init maple tree without MT_FLAGS_LOCK_EXTERN
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-vaddr-kunit-init-maple-tree-without-mt_flags_lock_extern.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/vaddr-kunit: init maple tree without MT_FLAGS_LOCK_EXTERN
Date: Wed, 4 Sep 2024 10:29:31 -0700

damon_test_three_regions_in_vmas() initializes a maple tree with
MM_MT_FLAGS.  The flags contains MT_FLAGS_LOCK_EXTERN, which means mt_lock
of the maple tree will not be used.  And therefore the maple tree
initialization code skips initialization of the mt_lock.  However,
__link_vmas(), which adds vmas for test to the maple tree, uses the
mt_lock.  In other words, the uninitialized spinlock is used.  The problem
becomes clear when spinlock debugging is turned on, since it reports
spinlock bad magic bug.

Fix the issue by excluding MT_FLAGS_LOCK_EXTERN from the maple tree
initialization flags.  Note that we don't use empty flags to make it
further similar to the usage of mm maple tree, and to be prepared for
possible future changes, as suggested by Liam.

Link: https://lkml.kernel.org/r/20240904172931.1284-1-sj@kernel.org
Fixes: d0cf3dd47f0d ("damon: convert __damon_va_three_regions to use the VMA iterator")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/1453b2b2-6119-4082-ad9e-f3c5239bf87e@roeck-us.net
Suggested-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/vaddr-kunit.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/tests/vaddr-kunit.h~mm-damon-tests-vaddr-kunit-init-maple-tree-without-mt_flags_lock_extern
+++ a/mm/damon/tests/vaddr-kunit.h
@@ -77,7 +77,7 @@ static void damon_test_three_regions_in_
 		(struct vm_area_struct) {.vm_start = 307, .vm_end = 330},
 	};
 
-	mt_init_flags(&mm.mm_mt, MM_MT_FLAGS);
+	mt_init_flags(&mm.mm_mt, MT_FLAGS_ALLOC_RANGE | MT_FLAGS_USE_RCU);
 	if (__link_vmas(&mm.mm_mt, vmas, ARRAY_SIZE(vmas)))
 		kunit_skip(test, "Failed to create VMA tree");
 
_

Patches currently in -mm which might be from sj@kernel.org are


