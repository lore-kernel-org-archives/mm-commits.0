Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F65918785D
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854870; cv=none; b=iv1oMUZvTEy2qGp+5XNCQKMc/irODpjoUJyrRm5dCHqJekXoQKl3wVtprHyWF1QPQI+fPyE98J0TnSMOIKvSUMznOcjuGt6eZAAXmWn9l5FrQREYpDa7YXhRHRo+pJ2MlABLjZ+VZCL8Dkf/XKKkdgVFYWMrYke4J8N06Fg5VTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854870; c=relaxed/simple;
	bh=oIhnKsQl5kcUl9g0bG1quVWN8BTOAcjSaTdmxwUfoN8=;
	h=Date:To:From:Subject:Message-Id; b=eU5Ii1hcIcl+7GOLwgHoqm95sXL2vrxu0b5bQzkhwKgbnEe0kMFLE9ndhNknuqPxZUPPaZlM/1rZY2XM1LKYa6tku6RrpZsNLdtdV2gkko6zIDcEVqNCCs4epvkT59xJ7v1guFJ/B3gf4hBwU9i1AnjnG+OWVf0YpESP8v7Nntk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JOWlwnOe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JOWlwnOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551E3C4CECF;
	Wed,  6 Nov 2024 01:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854870;
	bh=oIhnKsQl5kcUl9g0bG1quVWN8BTOAcjSaTdmxwUfoN8=;
	h=Date:To:From:Subject:From;
	b=JOWlwnOeDzvXN49a/4s3za1Gw4ANuEmcvM6l6bJJbGSqd3jKectGu5Bwabgnsq8/7
	 V9tQ2tApyp64wJKqjGQb9WNz8nDW5i+fdEYuau8CkF/DKSMR3Km/LbVfj+/wNxWnna
	 qeYGwPVABNorFUIuBIqBGSW6Kb5ErD62WHgg5hbU=
Date: Tue, 05 Nov 2024 17:01:09 -0800
To: mm-commits@vger.kernel.org,yeweihua4@huawei.com,sj@kernel.org,sieberf@amazon.com,shakeel.butt@linux.dev,foersleo@amazon.de,zhengyejian@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-add-nr_piece-==-1-check-in-damon_va_evenly_split_region.patch removed from -mm tree
Message-Id: <20241106010110.551E3C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/vaddr: add 'nr_piece == 1' check in damon_va_evenly_split_region()
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-add-nr_piece-==-1-check-in-damon_va_evenly_split_region.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zheng Yejian <zhengyejian@huaweicloud.com>
Subject: mm/damon/vaddr: add 'nr_piece == 1' check in damon_va_evenly_split_region()
Date: Tue, 22 Oct 2024 16:39:27 +0800

As discussed in [1], damon_va_evenly_split_region() is called to
size-evenly split a region into 'nr_pieces' small regions,
when nr_pieces == 1, no actual split is required. Check that case
for better code readability and add a simple kunit testcase.

[1] https://lore.kernel.org/all/20241021163316.12443-1-sj@kernel.org/

Link: https://lkml.kernel.org/r/20241022083927.3592237-3-zhengyejian@huaweicloud.com
Signed-off-by: Zheng Yejian <zhengyejian@huaweicloud.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Fernand Sieber <sieberf@amazon.com>
Cc: Leonard Foerster <foersleo@amazon.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Ye Weihua <yeweihua4@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/vaddr-kunit.h |    1 +
 mm/damon/vaddr.c             |    3 +++
 2 files changed, 4 insertions(+)

--- a/mm/damon/tests/vaddr-kunit.h~mm-damon-vaddr-add-nr_piece-==-1-check-in-damon_va_evenly_split_region
+++ a/mm/damon/tests/vaddr-kunit.h
@@ -300,6 +300,7 @@ static void damon_test_split_evenly(stru
 	damon_test_split_evenly_fail(test, 0, 100, 0);
 	damon_test_split_evenly_succ(test, 0, 100, 10);
 	damon_test_split_evenly_succ(test, 5, 59, 5);
+	damon_test_split_evenly_succ(test, 4, 6, 1);
 	damon_test_split_evenly_succ(test, 0, 3, 2);
 	damon_test_split_evenly_fail(test, 5, 6, 2);
 }
--- a/mm/damon/vaddr.c~mm-damon-vaddr-add-nr_piece-==-1-check-in-damon_va_evenly_split_region
+++ a/mm/damon/vaddr.c
@@ -72,6 +72,9 @@ static int damon_va_evenly_split_region(
 	if (!r || !nr_pieces)
 		return -EINVAL;
 
+	if (nr_pieces == 1)
+		return 0;
+
 	orig_end = r->ar.end;
 	sz_orig = damon_sz_region(r);
 	sz_piece = ALIGN_DOWN(sz_orig / nr_pieces, DAMON_MIN_REGION);
_

Patches currently in -mm which might be from zhengyejian@huaweicloud.com are


