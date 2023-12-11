Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94266468D
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ywHcvLCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F308C433C8;
	Mon, 11 Dec 2023 00:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256116;
	bh=1pqWlVvlQVip6+C45H2nfEhWFuNoNMFhsElYl1KCmh4=;
	h=Date:To:From:Subject:From;
	b=ywHcvLCfzuIsRxIasf/l42KIDk5IKMeECFZ0EgWsKycVyXg71ZboqxHg7NvohQoKr
	 UD5bTquvE6qRmNsakJTpubvmvnxehDvXATE0jegRixUJzpygbqLyZoKSRFbO9CCi9c
	 JmTQlskxQrnFNWnbQigdQ3j2ONJw9ztscgSsuaaw=
Date: Sun, 10 Dec 2023 16:55:15 -0800
To: mm-commits@vger.kernel.org,davidgow@google.com,brendanhiggins@google.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-test-test-damon_split_region_ats-access-rate-copying.patch removed from -mm tree
Message-Id: <20231211005516.5F308C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core-test: test damon_split_region_at()'s access rate copying
has been removed from the -mm tree.  Its filename was
     mm-damon-core-test-test-damon_split_region_ats-access-rate-copying.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core-test: test damon_split_region_at()'s access rate copying
Date: Sun, 19 Nov 2023 17:15:29 +0000

damon_split_region_at() should set access rate related fields of the
resulting regions same.  It may forgotten, and actually there was the
mistake before.  Test it with the unit test case for the function.

Link: https://lkml.kernel.org/r/20231119171529.66863-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core-test.h |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/mm/damon/core-test.h~mm-damon-core-test-test-damon_split_region_ats-access-rate-copying
+++ a/mm/damon/core-test.h
@@ -122,18 +122,25 @@ static void damon_test_split_at(struct k
 {
 	struct damon_ctx *c = damon_new_ctx();
 	struct damon_target *t;
-	struct damon_region *r;
+	struct damon_region *r, *r_new;
 
 	t = damon_new_target();
 	r = damon_new_region(0, 100);
+	r->nr_accesses_bp = 420000;
+	r->nr_accesses = 42;
+	r->last_nr_accesses = 15;
 	damon_add_region(r, t);
 	damon_split_region_at(t, r, 25);
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 25ul);
 
-	r = damon_next_region(r);
-	KUNIT_EXPECT_EQ(test, r->ar.start, 25ul);
-	KUNIT_EXPECT_EQ(test, r->ar.end, 100ul);
+	r_new = damon_next_region(r);
+	KUNIT_EXPECT_EQ(test, r_new->ar.start, 25ul);
+	KUNIT_EXPECT_EQ(test, r_new->ar.end, 100ul);
+
+	KUNIT_EXPECT_EQ(test, r->nr_accesses_bp, r_new->nr_accesses_bp);
+	KUNIT_EXPECT_EQ(test, r->nr_accesses, r_new->nr_accesses);
+	KUNIT_EXPECT_EQ(test, r->last_nr_accesses, r_new->last_nr_accesses);
 
 	damon_free_target(t);
 	damon_destroy_ctx(c);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-make-damon_start-waits-until-kdamond_fn-starts.patch
mm-damon-core-implement-goal-oriented-feedback-driven-quota-auto-tuning.patch
mm-damon-core-implement-goal-oriented-feedback-driven-quota-auto-tuning-fix.patch
mm-damon-sysfs-schemes-implement-files-for-scheme-quota-goals-setup.patch
mm-damon-sysfs-schemes-commit-damos-quota-goals-user-input-to-damos.patch
mm-damon-sysfs-schemes-implement-a-command-for-scheme-quota-goals-only-commit.patch
mm-damon-core-test-add-a-unit-test-for-the-feedback-loop-algorithm.patch
selftests-damon-test-quota-goals-directory.patch
docs-mm-damon-design-document-damos-quota-auto-tuning.patch
docs-abi-damon-document-damos-quota-goals.patch
docs-admin-guide-mm-damon-usage-document-for-quota-goals.patch

