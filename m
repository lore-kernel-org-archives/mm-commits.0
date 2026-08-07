Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B603B19A3;
	Fri,  7 Aug 2026 02:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068119; cv=none; b=ddL1R07PkJbcyDaA0rwddVxwd8wZIRqcGFXtKKhOhPgGHctVACcNJaMuZpsoojuBYZEEhXfzx+/lWb7TzCjgHg8+z6KPga7h4V6SVa17+R1vWSw6LwrBlXbV5RUQQ8KZOKLCNxLmCIhwJH2ioYG5FPOVC7uym7q3KFaAxvhPuj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068119; c=relaxed/simple;
	bh=5BKd/HlQ7pTfACzGtoFbLpMCtJTye/8CgnAJm+YB0hw=;
	h=Date:To:From:Subject:Message-Id; b=c0grdAgS5zE1V06BzBDJSwvVo9EO47YrjqUqCWk2h6hIYFEBIAvfyOJwcyuDLaUfFAk0ZkFVa0lAonqq92WpZeNB+15QEKep/YNZAvGj+KWNnIk1OY6CioaIcSHJYNFizLUQL5FuFJaxVDJp6hoU166FUXiXP405XErdpb3kry0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x+w2GFy5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x+w2GFy5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1C81F00A3A;
	Fri,  7 Aug 2026 02:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068118;
	bh=yxLQCokI8ASBHJbYKU903rAWXc5EJ+AqGfpmSTbPKko=;
	h=Date:To:From:Subject;
	b=x+w2GFy5+682cnDouUef61En3sz73Z2IChKq/xoKrhFzxU9dc2KjUiLAi8IPNrIE8
	 b5LLgomm+Theb8OsX2wy74Gue4gD+LZxAQPiUdcetjuV5cXSKR//XafnmdTXHLYZx8
	 nYmOO11GMjGnStOaCiS6oCKXQaI2PnaHGJKryLzQ=
Date: Thu, 06 Aug 2026 19:01:57 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-kunit-check-region-count-in-three_regions-test.patch removed from -mm tree
Message-Id: <20260807020158.5D1C81F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/vaddr-kunit: check region count in three_regions test
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-kunit-check-region-count-in-three_regions-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/vaddr-kunit: check region count in three_regions test
Date: Fri, 17 Jul 2026 17:14:37 -0700

damon_do_test_apply_three_regions() iterates regions after
damon_set_regions() call assuming the function would succeed at setting
the number of regions the same to the expected one.  It might have failed.
In this case, __nth_region_of() in the iteration could return NULL and
NULL dereference can happen in the test.

The consequent user impact (NULL dereference) is quite bad.  The realistic
user impact would be limited, though.  It would affect only test run
setups.

Fix it by testing if the number of regions was also changed as expected
and exit early for the failure.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260718001442.87129-4-sj@kernel.org
Link: https://lore.kernel.org/20260713144757.39740-1-sj@kernel.org [1]
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/vaddr-kunit.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/damon/tests/vaddr-kunit.h~mm-damon-vaddr-kunit-check-region-count-in-three_regions-test
+++ a/mm/damon/tests/vaddr-kunit.h
@@ -158,12 +158,17 @@ static void damon_do_test_apply_three_re
 		kunit_skip(test, "second damon_set_regions() fail");
 	}
 
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), nr_expected / 2);
+	if (damon_nr_regions(t) != nr_expected / 2)
+		goto out;
+
 	for (i = 0; i < nr_expected / 2; i++) {
 		r = __nth_region_of(t, i);
 		KUNIT_EXPECT_EQ(test, r->ar.start, expected[i * 2]);
 		KUNIT_EXPECT_EQ(test, r->ar.end, expected[i * 2 + 1]);
 	}
 
+out:
 	damon_destroy_target(t, NULL);
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are


