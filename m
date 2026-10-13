Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9508048423D
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865975; cv=none; b=f40sIRWt42llC45ujwoQ8itU2Du6sqIVy3nyFiC3oXrwsu1oU21unYywiblj4xeKfGphHWIbMJ69dtWd5gjqXKq17vTEzRW4i01Bz7kd3DDSuNVQogdS2RtwzUuwFnrXds+tJkJASn0PreCYyQpyGsdV/uy4QCz8wN0o10uYguM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865975; c=relaxed/simple;
	bh=AN3ULLNX9s52BQaY2dXsa/tPmAiGkbL379MjAR2ux34=;
	h=Date:To:From:Subject:Message-Id; b=uAmfYntfF+Y006/zl2MgNnB6S/NgkCTFDUJeJsnV9RgjFSoi3bAKC2ltRF8vmygbxPBM0EfLxc++6LrRoCrC4/6tNKIZIR6l2cniqn9Fy0PMOI4POvfGcO3fODYHWfUXU5GgM7IH1bnV7WmOcUdfC8nobWBNIg0PK1kvPN/pb/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DTGknZ23; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DTGknZ23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCC71F00898;
	Tue, 13 Oct 2026 04:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865974;
	bh=3F2Wt2dpHqXXO47zcg/+TTEZSHGJIHfnkeGUtPlty+Y=;
	h=Date:To:From:Subject;
	b=DTGknZ23MNgKbNjB9+Hqm8RelNVkbh1Q+veamziQV+mBwYKPlJDatfuZMaylEdfVL
	 utM45wzjUT384gZGLaqZ3dI7JvRL/7vEGDOhnV0DrRU445SSfNCd3/zDs+sRneXDh7
	 RfqF3biTXSfkuksz3jovb7G+feMMRpdyTX2nUEnY=
Date: Mon, 12 Oct 2026 21:32:54 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,gutierrez.asier@huawei-partners.com,david@kernel.org,davidgow@davidgow.net,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-add-probe_hits_wsum-damos-filter-commit-test.patch removed from -mm tree
Message-Id: <20261013043254.6BCC71F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: add probe_hits_wsum damos filter commit test
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-add-probe_hits_wsum-damos-filter-commit-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: add probe_hits_wsum damos filter commit test
Date: Thu, 17 Sep 2026 07:22:06 -0700

DAMOS filter commit kunit test lacks test cases for probe_hits_wsum
filter type.  Add test cases for probe_hits_wsum type DAMOS filter
commit.

Link: https://lore.kernel.org/20260917142210.90829-9-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/damon/tests/core-kunit.h |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-add-probe_hits_wsum-damos-filter-commit-test
+++ a/mm/damon/tests/core-kunit.h
@@ -1166,6 +1166,10 @@ static void damos_test_commit_filter_for
 		KUNIT_EXPECT_EQ(test, dst->sz_range.min, src->sz_range.min);
 		KUNIT_EXPECT_EQ(test, dst->sz_range.max, src->sz_range.max);
 		break;
+	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
+		KUNIT_EXPECT_EQ(test, dst->range_min, src->range_min);
+		KUNIT_EXPECT_EQ(test, dst->range_max, src->range_max);
+		break;
 	default:
 		break;
 	}
@@ -1239,6 +1243,22 @@ static void damos_test_commit_filter(str
 			.allow = true,
 			.target_idx = 6,
 			}, false);
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
+			.matching = false,
+			.allow = true,
+			.range_min = 12,
+			.range_max = 34,
+			}, false);
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
+			.matching = false,
+			.allow = true,
+			.range_min = 34,
+			.range_max = 12,
+			}, true);
 }
 
 static void damos_test_help_initailize_scheme(struct damos *scheme)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damos_quota_goal-complement.patch
mm-damon-core-add-complement-argument-to-damos_new_quota_goal.patch
mm-damon-sysfs-schemes-support-quota-goal-complement-flag.patch
mm-damon-tests-core-kunit-test-quota_goal-complement-commit.patch
selftests-damon-sysfssh-test-quota-goal-complement-flag-file.patch
docs-mm-damon-design-document-damos-quota-goal-complement-flag.patch
docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file.patch
docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file.patch

