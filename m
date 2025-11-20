Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE4F34FF7B
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675109; cv=none; b=YsyOEq5ujBMwh2ZzN6DnViNHGsk2/2+0zxl7Qpcu54c/mCPak8z+gfqwNH7hya5IMEloiTqMnMYIbEgtS479PMCqDbF6kdYzLLHl13hPwG90Z9mDPVetjIW8A5XmPBTTcFdMykdEAObm2+cjxjr6vwLXoebr2ge8w7E+CsE75iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675109; c=relaxed/simple;
	bh=YfX1DIO8UIPYXq8YzXVETnAyJ/WSVeSSnq+SK3HIFDs=;
	h=Date:To:From:Subject:Message-Id; b=JyWKnfb4NPO8B6ijHjVZjpnsFam+4iyfqHKA2xaY4D7tPToN0wmG5eSZhrwZ54ZSf6X8JWziqJht7PrMBenFegC3rlmzKyu+OKFucK07eYP/pJ0MyCQVLGg9t402eJpwHgQ8AD4X0MVpZTKvyA3GENiNXrIJRJakF5BLh813i44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CHRKXhwE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CHRKXhwE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFEFC4CEF1;
	Thu, 20 Nov 2025 21:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675109;
	bh=YfX1DIO8UIPYXq8YzXVETnAyJ/WSVeSSnq+SK3HIFDs=;
	h=Date:To:From:Subject:From;
	b=CHRKXhwE7ONZvqvsvBUcpmzsgB0lkHIV7UrsfvmVr4KEwuC+mVdRGBGeG9eWAVCxF
	 60GLzADdt6rTWcKcayt8rYK+Ybo26Ug5UqlCwpKNfAgRJnus3soiofsopzHMMsUB1D
	 oqfPqy1qrCl9t3f8cHJby9otl8s+bPwcncgzR8yI=
Date: Thu, 20 Nov 2025 13:45:09 -0800
To: mm-commits@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-add-test-cases-to-damos_test_commit_filter.patch removed from -mm tree
Message-Id: <20251120214509.8CFEFC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: add test cases to damos_test_commit_filter()
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-add-test-cases-to-damos_test_commit_filter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: add test cases to damos_test_commit_filter()
Date: Tue, 11 Nov 2025 10:44:03 -0800

damos_test_commit_filter() is covering only a single test case.  Extend it
to cover multiple combinations of inputs.

Link: https://lkml.kernel.org/r/20251111184415.141757-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   53 ++++++++++++++++++++++++++++++----
 1 file changed, 47 insertions(+), 6 deletions(-)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-add-test-cases-to-damos_test_commit_filter
+++ a/mm/damon/tests/core-kunit.h
@@ -528,17 +528,58 @@ static void damos_test_commit_filter_for
 
 static void damos_test_commit_filter(struct kunit *test)
 {
-	struct damos_filter src_filter = {
-		.type = DAMOS_FILTER_TYPE_ANON,
-		.matching = true,
-		.allow = true};
-	struct damos_filter dst_filter = {
+	struct damos_filter dst = {
 		.type = DAMOS_FILTER_TYPE_ACTIVE,
 		.matching = false,
 		.allow = false,
 	};
 
-	damos_test_commit_filter_for(test, &dst_filter, &src_filter);
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_ANON,
+			.matching = true,
+			.allow = true,
+			});
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_MEMCG,
+			.matching = false,
+			.allow = false,
+			.memcg_id = 123,
+			});
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_YOUNG,
+			.matching = true,
+			.allow = true,
+			});
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_HUGEPAGE_SIZE,
+			.matching = false,
+			.allow = false,
+			.sz_range = {.min = 234, .max = 345},
+			});
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_UNMAPPED,
+			.matching = true,
+			.allow = true,
+			});
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_ADDR,
+			.matching = false,
+			.allow = false,
+			.addr_range = {.start = 456, .end = 567},
+			});
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_TARGET,
+			.matching = true,
+			.allow = true,
+			.target_idx = 6,
+			});
 }
 
 static void damos_test_filter_out(struct kunit *test)
_

Patches currently in -mm which might be from sj@kernel.org are


