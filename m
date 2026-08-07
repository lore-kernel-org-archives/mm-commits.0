Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B187E3B7752;
	Fri,  7 Aug 2026 02:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068118; cv=none; b=eCokpSXzGLALqprGzdSqD9xtPH0pjIjgI0T8DJzyxLm3I307wBtIgBVNU2B3o5WxJp1KZPwfcvTnwrvfWxuOm7Mgja1x44Usn4xGlbxWCRrhqwg87fub4Urtip0MPzvqN1jY9y6K1DogEwxcp9VCDYAl3B3y69QB2WHK5aDxgRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068118; c=relaxed/simple;
	bh=DOoen4xUtJYcaOOl5mLTxKomeqcTFxnzzXtgQsueCjs=;
	h=Date:To:From:Subject:Message-Id; b=uxj7BpSb/9QmaVLc6GzFwfFnS73fTsXwZYMQzVUnicMR2WBUazjGo3FXGYeIFfgbkJThC2c3UXr3MLC8DwE2CqFgFITFytOSPE6tJ1zu1j1qUzbooFasGQ67kaugW5RnDaAErtv++XWYxeVo1NnSS/sNMZQcEw2Uje4zrwR65MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TVIsMHDt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TVIsMHDt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDD61F000E9;
	Fri,  7 Aug 2026 02:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068117;
	bh=hrmpDvHhUcPWSK7xtdL0nQusY4fbi3zLAdjBsJt+EIU=;
	h=Date:To:From:Subject;
	b=TVIsMHDteN0TwqJcakaoXBpyeoHKgFJy5l7dTfJHd6LXqCoya0+qddZ3nACEkjk48
	 V1OnD0CJlw93SyGn6b/i3bLFpMMl6HiDUfIt9BcWml7oDnM9KWwEiqi8TkOOPGloYo
	 m8/mdQ1/xrfkG/cmOlhTQzIkJd9DjLdo/KRfO9s4=
Date: Thu, 06 Aug 2026 19:01:56 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-kunit-check-region-count-before-testing-in-split_at.patch removed from -mm tree
Message-Id: <20260807020157.3FDD61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core-kunit: check region count before testing in split_at()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-kunit-check-region-count-before-testing-in-split_at.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core-kunit: check region count before testing in split_at()
Date: Fri, 17 Jul 2026 17:14:36 -0700

damon_test_split_at() test next region that is assumed to be created by
damon_split_region_at() invocation.  But the split might fail.  In this
case, the succeeding test may dereference invalid pointers returned by
damon_next_region().

The invalid pointer may not cause a really bad user impact, because of the
implementation detail.  It would only read wrong contents in the belonging
damon_target struct.  Depending on the future change of the offset from
the link header to the accessing field, this could also be really
dangerous, though.  Still, the realistic user impact would be limited.  It
would affect only test run setups.

Fix it by testing if the number of regions was also changed as expected
and exit early for the failure.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260718001442.87129-3-sj@kernel.org
Link: https://lore.kernel.org/20260714142352.100478-1-sj@kernel.org [1]
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-core-kunit-check-region-count-before-testing-in-split_at
+++ a/mm/damon/tests/core-kunit.h
@@ -155,6 +155,10 @@ static void damon_test_split_at(struct k
 	r->age = 10;
 	damon_add_region(r, t);
 	damon_split_region_at(t, r, 25);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
+	if (damon_nr_regions(t) != 2)
+		goto out;
+
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 25ul);
 
@@ -166,6 +170,7 @@ static void damon_test_split_at(struct k
 	KUNIT_EXPECT_EQ(test, r->last_nr_accesses, r_new->last_nr_accesses);
 	KUNIT_EXPECT_EQ(test, r->age, r_new->age);
 
+out:
 	damon_free_target(t);
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are


