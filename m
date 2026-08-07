Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CCA3B19A3;
	Fri,  7 Aug 2026 02:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068121; cv=none; b=fQh9JHqqH1pygDZcH9oWsTY4HdSWfWvsrEBJ00ZC8+IoJ3XugUq306RHwqiFKn1maPl6kVej1Fv0GJHP9YRkQSz/oL+Z8jb12lhOPrKDowyZzEOq9EhOKNbPCIrgeZd0G4G/zhIl2cYyHPfvMDLC/Tc6L0jeqTphp3wclSJgnMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068121; c=relaxed/simple;
	bh=APlqZSG9J4aeyGcP3rCj+ef2Lpli1qgZVxjSKYDboWk=;
	h=Date:To:From:Subject:Message-Id; b=br2iAK7yvbdPUJPo4jSKkHFhkcXNiWJUnFhavawja4xXoUgcl3fbjiD1hgcgV8keKh0u8uXCvYsQtiK69bE5zex8aqEHH8zkTYTkSzMZOE0cC8k+0a0kMMEkfqwEI04NjhuH+IBi1SK/wURGShAu4iC9bPF62+y0E7K6ZPkhiYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ByyR0tHh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ByyR0tHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14581F00A3A;
	Fri,  7 Aug 2026 02:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068120;
	bh=cpjRMoNw1ybD6/0audkoZ8KhAoOH6PlSzpjNQXoGnJ0=;
	h=Date:To:From:Subject;
	b=ByyR0tHh2b/nA/DU1ypkFJwIElam5k/zOlci/6E9zNXFidtVCBWDytqUs2IgtvJvL
	 qerV4GvMIYn6CTqh+8uVh/iN3rnvqYxaQTNBMaOZBRAzctq3HC3FaPT4rbGhFAxfu5
	 tx8h7U1waDRv/728MCNG+DVAidxgZqlapjfYeUag=
Date: Thu, 06 Aug 2026 19:02:00 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-kunit-skip-wrong-dest-walk-in-commit_dests_for.patch removed from -mm tree
Message-Id: <20260807020200.A14581F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core-kunit: skip wrong dest walk in commit_dests_for()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-kunit-skip-wrong-dest-walk-in-commit_dests_for.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core-kunit: skip wrong dest walk in commit_dests_for()
Date: Fri, 17 Jul 2026 17:14:39 -0700

damos_test_commit_dests_for() traverse damos action destinations after
damos_commit_dests().  It assumes damos_commit_dests() made expected
numbers of destinations for source and destination structures.  It might
not.  Because the traversal is made based on destination struct length, it
could do out of bounds access for source value expectation.

The consequent user impact (out-of-bound access ) is quite bad.  The
realistic user impact would be limited, though.  It would affect only test
run setups.

Fix it by exiting early for the number of regions test failure.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260718001442.87129-6-sj@kernel.org
Link: https://lore.kernel.org/20260713144757.39740-1-sj@kernel.org [1]
Fixes: eec573b8dd65 ("mm/damon/tests/core-kunit: add damos_commit_dests() test")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-core-kunit-skip-wrong-dest-walk-in-commit_dests_for
+++ a/mm/damon/tests/core-kunit.h
@@ -1008,6 +1008,8 @@ static void damos_test_commit_dests_for(
 	skip = false;
 
 	KUNIT_EXPECT_EQ(test, dst.nr_dests, src_nr_dests);
+	if (dst.nr_dests != src_nr_dests)
+		goto out;
 	for (i = 0; i < dst.nr_dests; i++) {
 		KUNIT_EXPECT_EQ(test, dst.node_id_arr[i], src_node_id_arr[i]);
 		KUNIT_EXPECT_EQ(test, dst.weight_arr[i], src_weight_arr[i]);
_

Patches currently in -mm which might be from sj@kernel.org are


