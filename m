Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5A134677A
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966120; cv=none; b=GT2/+/MZs/iW/Tla1Yimth4JwVeq1qqRc4ws8wJrrDttWvw+UzO88snaIoTR/ypjLdTCb/qq2RihecC71GRUDzYrixFdsrBDv9+uZJhKKQ5kfRWUBvgyw3HgpeB62fmhgPe2eLNXAAf4uA7Xmc0flMUFZr7yJKBjKAiWfz8GY2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966120; c=relaxed/simple;
	bh=VrL3v2Sr/UrTh2vIIzWgYWKuiHwrRNrDoRWwPaZxzbU=;
	h=Date:To:From:Subject:Message-Id; b=NvAUDh4c2TSach3bPmRsG5lL2K6CCjV/JDgqdLMUufA8wDchki9ltUWZ7pJBrDAzNvN3ps4Pw8y4pnYMWatwkXlsRep3z4MGgJUHCPSCQae7cwEhJJ46tZcB6fn8lYgvvLX6XGpONA8cSRNC0nuwl54RnEaxoc3hKKUWscTnk5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NV7As3La; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NV7As3La"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C467FC16AAE;
	Wed, 21 Jan 2026 03:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966119;
	bh=VrL3v2Sr/UrTh2vIIzWgYWKuiHwrRNrDoRWwPaZxzbU=;
	h=Date:To:From:Subject:From;
	b=NV7As3LaPmoBBdXMS8C4BPsBrFJKSkWg/FiyYmaEON3cBjtFYAjvoiP0pvtLnCFbx
	 RW++vDPZ/jWO7tHczHmVZclyIxoBu3aW7sXmrtD2HdpxrW+CUAKVwpt4sZNEWyJ3yq
	 Mtw8Ce3COXe+8YTFjsuYr6Vc2yStN4BTtKPZYpqc=
Date: Tue, 20 Jan 2026 19:28:39 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,shu17az@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-verify-the-age-and-nr_accesses_bp-fields-in-damon_test_merge_two.patch removed from -mm tree
Message-Id: <20260121032839.C467FC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: verify the 'age' and 'nr_accesses_bp' fields in damon_test_merge_two()
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-verify-the-age-and-nr_accesses_bp-fields-in-damon_test_merge_two.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shu Anzai <shu17az@gmail.com>
Subject: mm/damon/tests/core-kunit: verify the 'age' and 'nr_accesses_bp' fields in damon_test_merge_two()
Date: Wed, 24 Dec 2025 04:21:57 +0000

Extend damon_test_merge_two() to verify the 'age' and 'nr_accesses_bp'
fields.

Link: https://lkml.kernel.org/r/20251224042200.2061847-3-shu17az@gmail.com
Signed-off-by: Shu Anzai <shu17az@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-verify-the-age-and-nr_accesses_bp-fields-in-damon_test_merge_two
+++ a/mm/damon/tests/core-kunit.h
@@ -192,6 +192,7 @@ static void damon_test_merge_two(struct
 	}
 	r->nr_accesses = 10;
 	r->nr_accesses_bp = 100000;
+	r->age = 9;
 	damon_add_region(r, t);
 	r2 = damon_new_region(100, 300);
 	if (!r2) {
@@ -200,12 +201,15 @@ static void damon_test_merge_two(struct
 	}
 	r2->nr_accesses = 20;
 	r2->nr_accesses_bp = 200000;
+	r2->age = 21;
 	damon_add_region(r2, t);
 
 	damon_merge_two_regions(t, r, r2);
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 300ul);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, 16u);
+	KUNIT_EXPECT_EQ(test, r->nr_accesses_bp, 160000u);
+	KUNIT_EXPECT_EQ(test, r->age, 17u);
 
 	i = 0;
 	damon_for_each_region(r3, t) {
_

Patches currently in -mm which might be from shu17az@gmail.com are


