Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9011E362156
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966122; cv=none; b=kyn0oHns2cZygeGeerqomFerqYmY8C7xAZncEc8fAUsTkux1YVwEHRafvcwUR8KUIG6+gKo3+xe9M0dltAiNOZNvL/dF93OX6XKmCdBv+Y2ls+qpYF2GknAgDP2vAVksa2CVbqTqEA6upLzEVrZ9iBd17aj6isVj9r6vNnabbWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966122; c=relaxed/simple;
	bh=z8Gruf/qywgsKRaXE3s/SwypI25f9WKLDF6fuaFbiAE=;
	h=Date:To:From:Subject:Message-Id; b=D2ELgjb3KgFf/Lx5g90mGUwmiW3y4Mdg1HH8R6UldEOeOSSS3SGSbJnaZ0gEXuexgegnkvUO/J1ZOVmaiJIVrp5My7eMvaBP+5ouKloOynnyosCUgtJGh0psET3mlDeZvk4znLuUba91KK/62q0NKyy6nn7eshXsknhgTji38Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RFrXwEdI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RFrXwEdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110E5C16AAE;
	Wed, 21 Jan 2026 03:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966122;
	bh=z8Gruf/qywgsKRaXE3s/SwypI25f9WKLDF6fuaFbiAE=;
	h=Date:To:From:Subject:From;
	b=RFrXwEdIruDfq/4qmvEbMSz7FYf8m+jux2CI0Ts0E28LlVuBVYR6tIS1453wYVN3w
	 KwHK0+hD2hUB3kTt8Icul7UcSgrlNmj6FAF8LBoxCAulbfBBx2d2O22hLKH6eo7Ets
	 zo4i1XEwJqQsstY8cgQ1Q93rw7anBHOtifoy3AUQ=
Date: Tue, 20 Jan 2026 19:28:41 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,shu17az@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of.patch removed from -mm tree
Message-Id: <20260121032842.110E5C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: add test cases for multiple regions in damon_test_split_regions_of()
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shu Anzai <shu17az@gmail.com>
Subject: mm/damon/tests/core-kunit: add test cases for multiple regions in damon_test_split_regions_of()
Date: Wed, 24 Dec 2025 04:21:59 +0000

Extend damon_test_split_regions_of() to verify that it correctly handles
multiple regions with various 'min_sz_region'.

[sj@kernel.org: remove braces in damon_test_split_regions_of()]
  Link: https://lkml.kernel.org/r/20251224153125.69194-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20251224042200.2061847-5-shu17az@gmail.com
Signed-off-by: Shu Anzai <shu17az@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of
+++ a/mm/damon/tests/core-kunit.h
@@ -275,6 +275,9 @@ static void damon_test_split_regions_of(
 {
 	struct damon_target *t;
 	struct damon_region *r;
+	unsigned long sa[] = {0, 300, 500};
+	unsigned long ea[] = {220, 400, 700};
+	int i;
 
 	t = damon_new_target();
 	if (!t)
@@ -301,6 +304,23 @@ static void damon_test_split_regions_of(
 	damon_split_regions_of(t, 4, 1);
 	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 4u);
 	damon_free_target(t);
+
+	t = damon_new_target();
+	if (!t)
+		kunit_skip(test, "third target alloc fail");
+	for (i = 0; i < ARRAY_SIZE(sa); i++) {
+		r = damon_new_region(sa[i], ea[i]);
+		if (!r) {
+			damon_free_target(t);
+			kunit_skip(test, "region alloc fail");
+		}
+		damon_add_region(r, t);
+	}
+	damon_split_regions_of(t, 4, 5);
+	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 12u);
+	damon_for_each_region(r, t)
+		KUNIT_EXPECT_GE(test, damon_sz_region(r) % 5ul, 0ul);
+	damon_free_target(t);
 }
 
 static void damon_test_ops_registration(struct kunit *test)
_

Patches currently in -mm which might be from shu17az@gmail.com are


