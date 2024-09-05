Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B7B1A4E6F
	for <mm-commits@vger.kernel.org>; Thu,  5 Sep 2024 21:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725571644; cv=none; b=u7/RD/AG+8EGCJnwnomCxLYxQlLvduXCyLmXBUZCVihPdp9cK1Dqh1YxRE+K/ta3gGGq5W+I2L2grqnSnIvHI6odGWLyL8prj2UiKqkFwM2Cmb14JqyH/xKnEuLctvSsbcji9vtdXlYrHBPSQRUEfYKeLwgNqQTN2fG3BNNPyJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725571644; c=relaxed/simple;
	bh=HXVZOxuGepgwRA56ixNJNc6icXeMbS3MKSJjrlHS8RU=;
	h=Date:To:From:Subject:Message-Id; b=oxOYBtjvpkqPn60irCdvZgyj0h2vjCzujC27poWBWnU7P6rP8VVDq+h4UOKWrq4rp5/0di1l4KlDsvTCwDUbn6UQCZSYHjgUnFi/q7EAobwzHQUe3bvOkkSp2XlAq4VLfSNNeJ1ySNke2SSM1Hvd9wb4Sxr0qQRiPKG5kOvKhOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SHxdQnhr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SHxdQnhr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48746C4CEC3;
	Thu,  5 Sep 2024 21:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725571644;
	bh=HXVZOxuGepgwRA56ixNJNc6icXeMbS3MKSJjrlHS8RU=;
	h=Date:To:From:Subject:From;
	b=SHxdQnhrY2PATPT0uu4x44qdXygkaHyWmE7rIzgCfSX8YfzYuv6rtOSGDnnos8w/Z
	 EfuLdoy/e6OJBPE9Ujae5Oaalux67wrv/V/bFh9OzCkgnojNbYMWrgCC0WIIijYW8z
	 oZ2d2WeXinEZBot2ydqTtLLTb/wBTjRL7bAn2YBc=
Date: Thu, 05 Sep 2024 14:27:23 -0700
To: mm-commits@vger.kernel.org,linux@roeck-us.net,davidgow@google.com,brendanhiggins@google.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-skip-damon_test_nr_accesses_to_accesses_bp-if-aggr_interval-is-zero.patch added to mm-unstable branch
Message-Id: <20240905212724.48746C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/core-kunit: skip damon_test_nr_accesses_to_accesses_bp() if aggr_interval is zero
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-tests-core-kunit-skip-damon_test_nr_accesses_to_accesses_bp-if-aggr_interval-is-zero.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-skip-damon_test_nr_accesses_to_accesses_bp-if-aggr_interval-is-zero.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: skip damon_test_nr_accesses_to_accesses_bp() if aggr_interval is zero
Date: Thu, 5 Sep 2024 09:24:23 -0700

The aggregation interval of test purpose damon_attrs for
damon_test_nr_accesses_to_accesses_bp() becomes zero on 32 bit
architecture, since size of int and long types are same.  As a result,
damon_nr_accesses_to_accesses_bp() call with the test data triggers
divide-by-zero exception.  damon_nr_accesses_to_accesses_bp() shouldn't
be called with such data, and the non-test code avoids that by checking
the case on damon_update_monitoring_results().  Skip the test code in
the case, and add an explicit caution of the case on the comment for the
test target function.

Link: https://lkml.kernel.org/r/20240905162423.74053-1-sj@kernel.org
Fixes: 5e06ad590096 ("mm/damon/core-test: test max_nr_accesses overflow caused divide-by-zero")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/c771b962-a58f-435b-89e4-1211a9323181@roeck-us.net
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c             |    8 +++++++-
 mm/damon/tests/core-kunit.h |   12 ++++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-tests-core-kunit-skip-damon_test_nr_accesses_to_accesses_bp-if-aggr_interval-is-zero
+++ a/mm/damon/core.c
@@ -552,7 +552,13 @@ static unsigned int damon_accesses_bp_to
 	return accesses_bp * damon_max_nr_accesses(attrs) / 10000;
 }
 
-/* convert nr_accesses to access ratio in bp (per 10,000) */
+/*
+ * Convert nr_accesses to access ratio in bp (per 10,000).
+ *
+ * Callers should ensure attrs.aggr_interval is not zero, like
+ * damon_update_monitoring_results() does .  Otherwise, divide-by-zero would
+ * happen.
+ */
 static unsigned int damon_nr_accesses_to_accesses_bp(
 		unsigned int nr_accesses, struct damon_attrs *attrs)
 {
--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-skip-damon_test_nr_accesses_to_accesses_bp-if-aggr_interval-is-zero
+++ a/mm/damon/tests/core-kunit.h
@@ -320,6 +320,18 @@ static void damon_test_nr_accesses_to_ac
 		.aggr_interval = ((unsigned long)UINT_MAX + 1) * 10
 	};
 
+	/*
+	 * In some cases such as 32bit architectures where UINT_MAX is
+	 * ULONG_MAX, attrs.aggr_interval becomes zero.  Calling
+	 * damon_nr_accesses_to_accesses_bp() in the case will cause
+	 * divide-by-zero.  Such case is prohibited in normal execution since
+	 * the caution is documented on the comment for the function, and
+	 * damon_update_monitoring_results() does the check.  Skip the test in
+	 * the case.
+	 */
+	if (!attrs.aggr_interval)
+		kunit_skip(test, "aggr_interval is zero.");
+
 	KUNIT_EXPECT_EQ(test, damon_nr_accesses_to_accesses_bp(123, &attrs), 0);
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-intorduce-per-context-region-priorities-histogram-buffer.patch
mm-damon-core-replace-per-quota-regions-priority-histogram-buffer-usage-with-per-context-one.patch
mm-damon-core-remove-per-scheme-region-priority-histogram-buffer.patch
revert-mm-damon-lru_sort-adjust-local-variable-to-dynamic-allocation.patch
docs-damon-use-damonitor-github-organization-instead-of-awslabs.patch
docs-damon-maintainer-profile-add-links-in-place.patch
docs-damon-maintainer-profile-document-google-calendar-for-bi-weekly-meetups.patch
mm-damon-tests-vaddr-kunit-init-maple-tree-without-mt_flags_lock_extern.patch
mm-damon-tests-core-kunit-skip-damon_test_nr_accesses_to_accesses_bp-if-aggr_interval-is-zero.patch

