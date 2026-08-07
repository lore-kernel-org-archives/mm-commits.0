Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2E13B841F;
	Fri,  7 Aug 2026 02:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068120; cv=none; b=KOKzrl18e3ca/1ZACfPB27ushtopgf0d+Z8fJh2gF0RgrgIqbH/lIGG4O21K3I/PtB3VdZnDZOUC1l23nJGy/tyPRI5IDkGKYuGj4ay38VdNitG4KHA+3wI7/wgrbyV+tnJSHgsvccPp4IUxd6MZLXQbw9pNedpPDQ8+dM4M6fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068120; c=relaxed/simple;
	bh=k6tpKcOK9ekYfNMPD+lyOHXU8SALuHmLFAwkZxBZ28M=;
	h=Date:To:From:Subject:Message-Id; b=on14VlZ3Gq//oz30y7KXQntieJ6EJEvY7ymRqBSOCghOp6kM8C9elNE3eFR2wuGP9HmpP3o1Fa3tvU2RMgKM1P1VFWWnY749/8+iGDL3i0VF3TtSsMoJmmrat5ETDaBYUrND+tUtQhfRPcU3SKIUOJamV7idwFVRK0Luh28fBCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J37o+Oai; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J37o+Oai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822F41F000E9;
	Fri,  7 Aug 2026 02:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068119;
	bh=jdnrqp/t4qRBRebKwJtlxfWAkxe2xeY3FIwYnoaQP1E=;
	h=Date:To:From:Subject;
	b=J37o+OaiOaXJkHOxcdY3iBb4WLTY11wI85w7XJhtnrOhnXfvzoBh9MWYbGsqRzGGh
	 WaEiFfu7y/kDLQH4ViyDepqx7FkeDe54F31gEMZ4zLZjZPXL1m9BMUGUybJ9Fz+qEM
	 CewvJQTVs3Pmt4Ud0EIOn2HmKk2Z7SiJFR2eAKH8=
Date: Thu, 06 Aug 2026 19:01:59 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-kunit-handle-region-split-failure-in-filter_out.patch removed from -mm tree
Message-Id: <20260807020159.822F41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core-kunit: handle region split failure in filter_out()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-kunit-handle-region-split-failure-in-filter_out.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core-kunit: handle region split failure in filter_out()
Date: Fri, 17 Jul 2026 17:14:38 -0700

damos_test_filter_out() test checks if damos_filter_match() of an address
filter splits the region as expected under a given condition.  But, the
test continued regardless of the split successes.  As a result, the later
part of the test could dereference invalid pointers that returned from
damon_next_region().  Further, it could corrupt memory from
damon_destroy_region().

The consequent user impact (memory corruption) is quite bad.  The
realistic user impact would be limited, though.  It would affect only test
run setups.

Fix it by exiting early for the number of regions test failure.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260718001442.87129-5-sj@kernel.org
Link: https://lore.kernel.org/20260714142352.100478-1-sj@kernel.org [1]
Fixes: 26713c890875 ("mm/damon/core-test: add a unit test for __damos_filter_out()")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: <stable@vger.kernel.org> # 6.6.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-core-kunit-handle-region-split-failure-in-filter_out
+++ a/mm/damon/tests/core-kunit.h
@@ -1365,6 +1365,8 @@ static void damos_test_filter_out(struct
 	KUNIT_EXPECT_EQ(test, r->ar.start, 1);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 2);
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
+	if (damon_nr_regions(t) != 2)
+		goto out;
 	r2 = damon_next_region(r);
 	KUNIT_EXPECT_EQ(test, r2->ar.start, 2);
 	KUNIT_EXPECT_EQ(test, r2->ar.end, 4);
@@ -1379,11 +1381,14 @@ static void damos_test_filter_out(struct
 	KUNIT_EXPECT_EQ(test, r->ar.start, 2);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 6);
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
+	if (damon_nr_regions(t) != 2)
+		goto out;
 	r2 = damon_next_region(r);
 	KUNIT_EXPECT_EQ(test, r2->ar.start, 6);
 	KUNIT_EXPECT_EQ(test, r2->ar.end, 8);
 	damon_destroy_region(r2, t);
 
+out:
 	damon_free_target(t);
 	damos_free_filter(f);
 }
_

Patches currently in -mm which might be from sj@kernel.org are


