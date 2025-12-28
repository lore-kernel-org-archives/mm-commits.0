Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05762144C7
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 23:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766962917; cv=none; b=JWSLeyUaXH0D5TJ+03hurd7dC9UFahqdmsb3LbcESOzHJRy09gfuQkhT9F0ykwTxpnuMsfcJvSRsZsMA/qiFE34WIeXYaSN1LrfW6FqmqTC03+FGe1qdO68xZdvCJBbYs5GDX3G1KGyNH9GfjnbTXkTwW4VXVGQYqGQKEXBkHsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766962917; c=relaxed/simple;
	bh=Z0fIMQL5z+7gFmf+5wihIllfScRvC0xe3vq89TW2kik=;
	h=Date:To:From:Subject:Message-Id; b=ADMMEWnBCdQgPm61jaMkgysr0UmYjSd4OgGPlRSjbZgfwfNUtHfjlz3goRZGcJtIaEPbzmiPV+C50L4AvCdxIi5LGt4nfmumRJkzUIAL51MpuqqvtB6d+6HQ43C3SrSnQLM3ZenyqRGFUsf2yp7A6oQDr6UKIhWoXKDrJk5qprU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Th+2deNS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Th+2deNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350AAC4CEFB;
	Sun, 28 Dec 2025 23:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766962917;
	bh=Z0fIMQL5z+7gFmf+5wihIllfScRvC0xe3vq89TW2kik=;
	h=Date:To:From:Subject:From;
	b=Th+2deNSlarRFkzHbUIqy9sIQ+w4I+OZA7u+ajQNU01MepHlIG9TML5PAeDcCTkON
	 Eftr40voxixUlf+F7Z0Ni83oneip0BYpxQiu64ELHHhruq5YL1iwe7o/xMPOIPpI+C
	 XHc3KQtzsyYfFuVt8ERKJqrXwrFWptI+Wc4cM+5A=
Date: Sun, 28 Dec 2025 15:01:56 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,shu17az@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-add-a-test-case-for-region-merge-size-limit-in-damon_test_merge_regions_of.patch added to mm-new branch
Message-Id: <20251228230157.350AAC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/core-kunit: add a test case for region merge size limit in damon_test_merge_regions_of()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-add-a-test-case-for-region-merge-size-limit-in-damon_test_merge_regions_of.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-add-a-test-case-for-region-merge-size-limit-in-damon_test_merge_regions_of.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Shu Anzai <shu17az@gmail.com>
Subject: mm/damon/tests/core-kunit: add a test case for region merge size limit in damon_test_merge_regions_of()
Date: Wed, 24 Dec 2025 04:21:58 +0000

Add a test case in damon_test_merge_regions_of() to verify that two
adjacent regions are not merged if the resulting region would exceed the
specified size limit.

Link: https://lkml.kernel.org/r/20251224042200.2061847-4-shu17az@gmail.com
Signed-off-by: Shu Anzai <shu17az@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-add-a-test-case-for-region-merge-size-limit-in-damon_test_merge_regions_of
+++ a/mm/damon/tests/core-kunit.h
@@ -238,12 +238,12 @@ static void damon_test_merge_regions_of(
 {
 	struct damon_target *t;
 	struct damon_region *r;
-	unsigned long sa[] = {0, 100, 114, 122, 130, 156, 170, 184};
-	unsigned long ea[] = {100, 112, 122, 130, 156, 170, 184, 230};
-	unsigned int nrs[] = {0, 0, 10, 10, 20, 30, 1, 2};
+	unsigned long sa[] = {0, 100, 114, 122, 130, 156, 170, 184, 230};
+	unsigned long ea[] = {100, 112, 122, 130, 156, 170, 184, 230, 10170};
+	unsigned int nrs[] = {0, 0, 10, 10, 20, 30, 1, 2, 5};
 
-	unsigned long saddrs[] = {0, 114, 130, 156, 170};
-	unsigned long eaddrs[] = {112, 130, 156, 170, 230};
+	unsigned long saddrs[] = {0, 114, 130, 156, 170, 230};
+	unsigned long eaddrs[] = {112, 130, 156, 170, 230, 10170};
 	int i;
 
 	t = damon_new_target();
@@ -261,9 +261,9 @@ static void damon_test_merge_regions_of(
 	}
 
 	damon_merge_regions_of(t, 9, 9999);
-	/* 0-112, 114-130, 130-156, 156-170 */
-	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 5u);
-	for (i = 0; i < 5; i++) {
+	/* 0-112, 114-130, 130-156, 156-170, 170-230, 230-10170 */
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 6u);
+	for (i = 0; i < 6; i++) {
 		r = __nth_region_of(t, i);
 		KUNIT_EXPECT_EQ(test, r->ar.start, saddrs[i]);
 		KUNIT_EXPECT_EQ(test, r->ar.end, eaddrs[i]);
_

Patches currently in -mm which might be from shu17az@gmail.com are

mm-damon-tests-core-kunit-verify-the-age-field-in-damon_test_split_at.patch
mm-damon-tests-core-kunit-verify-the-age-and-nr_accesses_bp-fields-in-damon_test_merge_two.patch
mm-damon-tests-core-kunit-add-a-test-case-for-region-merge-size-limit-in-damon_test_merge_regions_of.patch
mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of.patch
mm-damon-tests-core-kunit-remove-a-redundant-test-case-and-add-a-new-test-case-in-damos_test_commit_quota_goal.patch

