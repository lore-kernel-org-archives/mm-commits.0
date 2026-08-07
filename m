Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DC43B19A3;
	Fri,  7 Aug 2026 02:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068124; cv=none; b=f8BhHvzPzMQNQhxhutNYG4hQtpIcPhqCrT7PvF5oOkQ5POfmqNNBw9bMnTpTPep0v10T0PdWVdX73HGEhuQvoizpcrNfQfyIJsaXQ2Wa+CTH36XIJmsr5vFPEJng4ZQwwYt8d5dHuiC+G6woUmgNNrdEAT8L6cP1hvIRK5e0PYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068124; c=relaxed/simple;
	bh=0rKPnUnTr2013+JzbI+gAv0dwKpunm5Kw/QZTktcGAU=;
	h=Date:To:From:Subject:Message-Id; b=sIOK4LoNOqI64qu4+/ypcDArOG9GmeiprZv6GkLqwRzTuEW96xH5BzMo9UQKUeYDg5YYRDzBzviZ+D0s2vxIzAqA9o+5HyH0lhfMMr5tZNfV1QllaI6goAlcQgcT2eoCL0UHkEXZ9pMaR46QoIqWbwvTPkANeZYkFM0MIKqlH3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tBrHiAao; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tBrHiAao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97411F00A3A;
	Fri,  7 Aug 2026 02:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068123;
	bh=JeuHNDqoX5JUe7lOm5c71h8IAbxGoSuRLNZKdd7+KQY=;
	h=Date:To:From:Subject;
	b=tBrHiAaokrHLhhaCPMkV9D4jmkk1uPX67qBtanvgwkjx0bGhq8v9YpzWqM75m3mga
	 bAb7Nt5wOZT6fbC+swG2FXsZ5JDNc1eAh/2RIdpDJ0ShCLCjTNOM28GA6Gl0jynBGk
	 xcbFi/iIBkvsG+lNZRKfJNKU+EsLi3ct7cDCbz9k=
Date: Thu, 06 Aug 2026 19:02:02 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-kunit-skip-wrong-region-walk-in-commit_target_regions.patch removed from -mm tree
Message-Id: <20260807020202.D97411F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core-kunit: skip wrong region walk in commit_target_regions()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-kunit-skip-wrong-region-walk-in-commit_target_regions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core-kunit: skip wrong region walk in commit_target_regions()
Date: Fri, 17 Jul 2026 17:14:41 -0700

damon_test_commit_target_regions_for() traverses expected values array
after damon_commit_target_regions() call.  It assumes
damon_commit_target_regions() made expected number of regions.  It might
not.  Because the traversal is made based on the region count, it could do
out of bounds access to the expectation value array.

The consequent user impact (out-of-bound access) is quite bad.  The
realistic user impact would be limited, though.  It would affect only test
run setups.

Fix it by testing if the number of regions was also changed as expected
and exit early for the failure.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260718001442.87129-8-sj@kernel.org
Link: https://lore.kernel.org/20260713144757.39740-1-sj@kernel.org [1]
Fixes: 603f67eb91e0 ("mm/damon/tests/core-kunit: add damon_commit_target_regions() test")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/damon/tests/core-kunit.h~mm-damon-core-kunit-skip-wrong-region-walk-in-commit_target_regions
+++ a/mm/damon/tests/core-kunit.h
@@ -1277,14 +1277,19 @@ static void damon_test_commit_target_reg
 		kunit_skip(test, "src target setup fail");
 	}
 	damon_commit_target_regions(dst_target, src_target, 1);
+
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(dst_target), nr_expect_regions);
+	if (damon_nr_regions(dst_target) != nr_expect_regions)
+		goto out;
+
 	i = 0;
 	damon_for_each_region(r, dst_target) {
 		KUNIT_EXPECT_EQ(test, r->ar.start, expect_start_end[i][0]);
 		KUNIT_EXPECT_EQ(test, r->ar.end, expect_start_end[i][1]);
 		i++;
 	}
-	KUNIT_EXPECT_EQ(test, damon_nr_regions(dst_target), nr_expect_regions);
-	KUNIT_EXPECT_EQ(test, i, nr_expect_regions);
+
+out:
 	damon_free_target(dst_target);
 	damon_free_target(src_target);
 }
_

Patches currently in -mm which might be from sj@kernel.org are


