Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0194947C0EF;
	Tue, 13 Oct 2026 04:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865908; cv=none; b=uoWnraJUv4HHq95oYuWbWk7ax/QzhGu3g+/EB19DaWHUz4HTQ9pSChWyGLLjeUFXt1vyP0+lbEseCvsdzEu3SnjhGppY8ZxjyPiDFaU31OHAX1Xd+ID1lrpyZNbtVK37e5z293yMLEVpAeAx+nkWfK/EFC1xdepNPXMTF4/0Dn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865908; c=relaxed/simple;
	bh=v5vFRXZ/xxw18wdXNRVv4soeQbL4kMrYO2Fm7VaHnJ0=;
	h=Date:To:From:Subject:Message-Id; b=b35C+7iErY2X/X7pb9XZDWJw3M3JQg+oLJo0MkfnFIMlbjRXAHdrDsjYjP1WFbH9XAbZS+LqNihiiOViKmicbWUBdLW7yKsAoQHY6qQAdQuVIGtwsPAau57qC5mNvhU/SewIyZQtzDnycO8JU+LtlGeGVZ/vNg9+ZJDMK8Z8nig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gee8Rzye; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gee8Rzye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898E61F00893;
	Tue, 13 Oct 2026 04:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865906;
	bh=XD43hhkHqg+CBTdquhDXbjWYTkneemja10yk0oj/70A=;
	h=Date:To:From:Subject;
	b=gee8RzyejcKlbgZPh3frqbKtW/Q2aqAE0bVyqDjtFWiG8kjz72IBK3mZP1WMaYs9l
	 FGHZUPvgdLSrbjoW0hBhYMpvoQpJ0c16FJGxTaMDUNtLYG2QM7fJCI1V3NLv/cvxpF
	 TZyB+fzfbIqU60B/ARnNxWyCGzU2wmNZZ7W0YLkw=
Date: Mon, 12 Oct 2026 21:31:46 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,stable@vger.kernel.org,davidgow@davidgow.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-kunit-test-invalid-damos-filter-commits.patch removed from -mm tree
Message-Id: <20261013043146.898E61F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core-kunit: test invalid damos filter commits
has been removed from the -mm tree.  Its filename was
     mm-damon-core-kunit-test-invalid-damos-filter-commits.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core-kunit: test invalid damos filter commits
Date: Mon, 14 Sep 2026 07:23:25 -0700

Add test cases for testing the validation of damos filter arguments in
commit time.

Link: https://lore.kernel.org/20260914142327.92510-9-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/damon/tests/core-kunit.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-core-kunit-test-invalid-damos-filter-commits
+++ a/mm/damon/tests/core-kunit.h
@@ -1186,6 +1186,13 @@ static void damos_test_commit_filter(str
 			}, false);
 	damos_test_commit_filter_for(test, &dst,
 			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_HUGEPAGE_SIZE,
+			.matching = false,
+			.allow = false,
+			.sz_range = {.min = 456, .max = 123},
+			}, true);
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
 			.type = DAMOS_FILTER_TYPE_UNMAPPED,
 			.matching = true,
 			.allow = true,
@@ -1199,6 +1206,13 @@ static void damos_test_commit_filter(str
 			}, false);
 	damos_test_commit_filter_for(test, &dst,
 			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_ADDR,
+			.matching = false,
+			.allow = false,
+			.addr_range = {.start = 567, .end = 456},
+			}, true);
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
 			.type = DAMOS_FILTER_TYPE_TARGET,
 			.matching = true,
 			.allow = true,
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

