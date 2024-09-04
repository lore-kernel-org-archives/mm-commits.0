Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF3780038
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423606; cv=none; b=sj7tn3VY3PXwgCVN4hvTd/071y7TW1xv9SQNqo+UrftsqCpqUyaHNjnAw23l8GnJ4QfsK9jzJO5Xpy2rIchOm4D8Qv8DpaABXfrdg4hTQVXdzM+lVFqCLbWCyxIXkEjc2C5NbGAHMra9PK2nmVXD3TlE3SS1mOZxR8RaYmhzy0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423606; c=relaxed/simple;
	bh=ZRvEzrbAFoGW84zh78w1gjR9mLp5HYpLsRRb5J3DDso=;
	h=Date:To:From:Subject:Message-Id; b=VYneZHxVCBLRsuQz4LjNwArLkjrH/Dup3xsvfyUSvqgtFJ9jA0ds9W2PhMzEagaTtFUYeCb3+1F+DIHzaEya7yUeyPWOm+Eojxy6/07pgYGfhJXl3wjKufqN48b3C+N/p/r7SclDTTOQFtDRRwuhWbb8mLPCPhcsgThtGDVQsd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=czu3KbRb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="czu3KbRb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5807C4CEC2;
	Wed,  4 Sep 2024 04:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423606;
	bh=ZRvEzrbAFoGW84zh78w1gjR9mLp5HYpLsRRb5J3DDso=;
	h=Date:To:From:Subject:From;
	b=czu3KbRbGg6vNkHl3QAiuzdhd9FkezzPcOKmbChb39qcSoav1ZzEZEESXlrY9c1/E
	 Y0M/QN1B7tP1XXolK4eBAGRkjWfm/L0sn4drsQ/mJqp7zn4bkBPUEMfxm7SpEGeRuU
	 +605aVDL6Slc1RFvm7ZGJoliHDNCRMb9E/q3s2Uw=
Date: Tue, 03 Sep 2024 21:20:05 -0700
To: mm-commits@vger.kernel.org,davidgow@google.com,brendanhiggins@google.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-dbgfs-test-skip-dbgfs_set_init_regions-test-if-paddr-is-not-registered.patch removed from -mm tree
Message-Id: <20240904042005.E5807C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/dbgfs-test: skip dbgfs_set_init_regions() test if PADDR is not registered
has been removed from the -mm tree.  Its filename was
     mm-damon-dbgfs-test-skip-dbgfs_set_init_regions-test-if-paddr-is-not-registered.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/dbgfs-test: skip dbgfs_set_init_regions() test if PADDR is not registered
Date: Mon, 26 Aug 2024 20:03:34 -0700

The test depends on registration of DAMON_OPS_PADDR.  It would be
registered only when CONFIG_DAMON_PADDR is set.  DAMON core kunit tests do
fake ops registration for such case.  However, the functions for such fake
ops registration is not available to DAMON debugfs interface.  Just skip
the test in the case.

Link: https://lkml.kernel.org/r/20240827030336.7930-8-sj@kernel.org
Fixes: 999b9467974f ("mm/damon/dbgfs-test: fix is_target_id() change")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs-test.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/damon/dbgfs-test.h~mm-damon-dbgfs-test-skip-dbgfs_set_init_regions-test-if-paddr-is-not-registered
+++ a/mm/damon/dbgfs-test.h
@@ -116,6 +116,11 @@ static void damon_dbgfs_test_set_init_re
 	int i, rc;
 	char buf[256];
 
+	if (!damon_is_registered_ops(DAMON_OPS_PADDR)) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "PADDR not registered");
+	}
+
 	damon_select_ops(ctx, DAMON_OPS_PADDR);
 
 	dbgfs_set_targets(ctx, 3, NULL);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-intorduce-per-context-region-priorities-histogram-buffer.patch
mm-damon-core-replace-per-quota-regions-priority-histogram-buffer-usage-with-per-context-one.patch
mm-damon-core-remove-per-scheme-region-priority-histogram-buffer.patch
revert-mm-damon-lru_sort-adjust-local-variable-to-dynamic-allocation.patch
docs-damon-use-damonitor-github-organization-instead-of-awslabs.patch
docs-damon-maintainer-profile-add-links-in-place.patch
docs-damon-maintainer-profile-document-google-calendar-for-bi-weekly-meetups.patch

