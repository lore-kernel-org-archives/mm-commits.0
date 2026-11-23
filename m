Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795454447;
	b=F1LeI0wKVZDvLnd23SY+d5b9IS8NGnKjC+BvLFoydOiGjfQa7Z7F+Hr7YrJAI6OhxkgZ
	 1/cAJYlKIJ3M7p+2aP+ZqzySx5oKhX7iQ9k0z/JJ25hRY/2jmodKK60o8J/baFnVkc7ne
	 gFP6IdcsFmIe87JhZ3dMKYmERKAA1ULj56bHn08wZXBTaGTM4dBcJ5Ynq3NYqAwLDqbrE
	 Lsf5CmhZ/HFyrtAYotscf9UqehF8lV59WcocbgoriMupMlco8wLQ0nw+L5J6NFeTk0i/N
	 4ZzuhJTcabhEw2ona18vivaTPIpsur4HQNK8wyVypkiarIva/UPfcrVjKeu9evS9fLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795454447;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=wVI8jB8QwJYTbUQi2Z+yO7j/YRjOFGwSzVhxhUGUliM=;
	b=dYqOn/GXoQJbMcenYNA/oGbi+DZtPVFfACjn0QWGqJ4quz9OIqhbbbLhxTYWBXMWsbT1
	 4ivNOHkyaa9/Yr5E8LVPOoPlO+RHLWy1Pw7xSblC5EIn7oQS2+LLSHYcqwuKUBWTuXAVa
	 DsW2KqqDBTvSDiqfQGRTreQf/J+Gl02JGYGoT02c4N1BAxHHYUmWfaFq0nZ4gO2L3AFM6
	 pLeieY0DS62hkEaAhfDLqBC/OVq4UaNfC9OxGC1IX4eDllF/0HtPVMp/Bf2ctCw3xiuOh
	 rpb6qpRB2YISKZ7rpXJj+XJ0NZO+PqwVtzlej6T692iz8m+cJGYXkeVqlKXUzWI57Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WaLWe+FS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EAB606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 17:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WaLWe+FS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA5A1F000EB;
	Mon, 23 Nov 2026 17:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795454446;
	bh=wVI8jB8QwJYTbUQi2Z+yO7j/YRjOFGwSzVhxhUGUliM=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=WaLWe+FSeaXEoPi8LJYrCTCf7l9jc7wTQO1yUvdSf6w69L6ZmQ/mstI6vQvFeCKkg
	 Mg7Ny6yM+LWcTmXoKbhdm/UH0O0iKqtJ8aEFJB7Be3oAXWu7GzxMKcMqBgRgCWuj77
	 CtL16aev8C5XaS0quAXisCrW7ViR++zsRa9qjLUI=
Date: Mon, 23 Nov 2026 09:20:46 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,jm5905938@gmail.com,
	davidgow@davidgow.net,brendan.higgins@linux.dev,jasonangelov@ucla.edu,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123150929.81797-2-sj@kernel.org>
References: <20261123150929.81797-2-sj@kernel.org>
Subject: + mm-damon-tests-core-kunit-test-damos_filter_type_age_ms-in-damos_test_commit_filter.patch added to mm-new branch
Message-Id: <20261123172046.CBA5A1F000EB@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/tests/core-kunit: test DAMOS_FILTER_TYPE_AGE_MS in damos_test_commit_filter()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-test-damos_filter_type_age_ms-in-damos_test_commit_filter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-test-damos_filter_type_age_ms-in-damos_test_commit_filter.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Jason Angelov <jasonangelov@ucla.edu>
Subject: mm/damon/tests/core-kunit: test DAMOS_FILTER_TYPE_AGE_MS in damos_test_commit_filter()
Date: Mon, 23 Nov 2026 07:09:25 -0800

Patch series "mm/damon/tests: add KUnit coverage for age_ms filters", v3.

The DAMON core tests do not cover DAMOS_FILTER_TYPE_AGE_MS. Add tests for
committing valid and invalid age ranges, identifying the filter as
core-handled, and matching ages at and outside the range boundaries.

Region age is counted in aggregation intervals, but age_ms filter bounds
are in milliseconds. The interval-change test checks filter matching
after both increasing and decreasing the aggregation interval.


This patch (of 3):

Add kunit tests that commit DAMOS core filter type
DAMOS_FILTER_TYPE_AGE_MS.

Link: https://lore.kernel.org/20261123150929.81797-1-sj@kernel.org
Link: https://patch.msgid.link/20261123150929.81797-2-sj@kernel.org
Signed-off-by: Jason Angelov <jasonangelov@ucla.edu>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>

 mm/damon/tests/core-kunit.h |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-test-damos_filter_type_age_ms-in-damos_test_commit_filter
+++ a/mm/damon/tests/core-kunit.h
@@ -1271,6 +1271,10 @@ static void damos_test_commit_filter_for
 	KUNIT_EXPECT_EQ(test, dst->matching, src->matching);
 	KUNIT_EXPECT_EQ(test, dst->allow, src->allow);
 	switch (src->type) {
+	case DAMOS_FILTER_TYPE_AGE_MS:
+		KUNIT_EXPECT_EQ(test, dst->range_min, src->range_min);
+		KUNIT_EXPECT_EQ(test, dst->range_max, src->range_max);
+		break;
 	case DAMOS_FILTER_TYPE_MEMCG:
 		KUNIT_EXPECT_EQ(test, dst->memcg_id, src->memcg_id);
 		break;
@@ -1306,6 +1310,22 @@ static void damos_test_commit_filter(str
 
 	damos_test_commit_filter_for(test, &dst,
 			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_AGE_MS,
+			.matching = true,
+			.allow = true,
+			.range_min = 36,
+			.range_max = 14
+			}, true);
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_AGE_MS,
+			.matching = true,
+			.allow = true,
+			.range_min = 14,
+			.range_max = 36
+			}, false);
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
 			.type = DAMOS_FILTER_TYPE_ANON,
 			.matching = true,
 			.allow = true,
_

Patches currently in -mm which might be from jasonangelov@ucla.edu are

mm-damon-tests-core-kunit-test-damos_filter_type_age_ms-in-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-test-damos_filter_type_age_ms-in-damos_filter_for_ops.patch
mm-damon-tests-core-kunit-test-damos_filter_type_age_ms-interval-changes.patch

