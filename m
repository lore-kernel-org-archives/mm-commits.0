Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC95A31F9A8
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465704; cv=none; b=psEVCMn0P8mzoWsOf1fhAGwltmIXrCZFfar71/05EO/hRBr9LYcvOiZrs6n63JqQ67s9QDERp7Wyubjl/eP4t7EhHwsgoH7Rm/GE8EU60dRqUduF/f6d8hcLb86bkmUL67QZxKlL7wWVKhIsHyDE0D6lhn3CcgH4Jm67AfEJOpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465704; c=relaxed/simple;
	bh=21b5UJveC2ShFKfFobjVUd36rkFYol34xnOF/Po0Y78=;
	h=Date:To:From:Subject:Message-Id; b=V1epoNtT8Iz0B5h50U7eSE+yhcLG8bL5AD8ivYkaC2dmGNthL9NJv9JA9ATwBXg5KjaB43ED0wKF3zAezr3N9CLBXOqZojW3KPT6BE3mMMg9uE5tlXqlXP6mX4snuO8i1/T5D8Z6ZERVcFgVMrzEf6HX5TOkBQ2Fti7JFqJtp24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oTyHm8Ac; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oTyHm8Ac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17711F000E9;
	Fri, 31 Jul 2026 02:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465701;
	bh=j3Go7M0PMGAEGHmO1AfZp4DNjWuZ0Bde3b9OeniRIIQ=;
	h=Date:To:From:Subject;
	b=oTyHm8AcJJOVYcUZBsiLjg2CmelqldnH9Gu0fqfqUNdFx4ZAHibXjnMHl+Uu2hIkW
	 47veIpTf/LKL9BuNJ1OtsddZInLHQG0gGlPyZ0Z9nyviJV7/JIwWy/Qorja4vNwXic
	 +aQHdXPGR3o2aksAvXJ7kDMxGmBtihVVRxnsm/08=
Date: Thu, 30 Jul 2026 19:41:41 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,rppt@kernel.org,plafer@proton.me,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,gutierrez.asier@huawei-partners.com,doehyunbaek@gmail.com,david@kernel.org,corbet@lwn.net,brendan.higgins@linux.dev,akinobu.mita@gmail.com,saileshnandanavanam@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-add-kunit-test-for-walk_control_obsolete-behavior.patch removed from -mm tree
Message-Id: <20260731024141.A17711F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: add KUnit test for walk_control_obsolete behavior
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-add-kunit-test-for-walk_control_obsolete-behavior.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Subject: mm/damon/tests/core-kunit: add KUnit test for walk_control_obsolete behavior
Date: Mon, 29 Jun 2026 07:55:36 -0700

Add a KUnit test to verify that damos_walk() rejects new requests when
walk_control_obsolete is set.

Commit 33c3f6c2b48c ("mm/damon/core: fix damos_walk() vs kdamond_fn() exit
race") introduced walk_control_obsolete to prevent a race condition where
new requests could be registered during kdamond shutdown and never
handled.

This test simulates the shutdown condition by setting
walk_control_obsolete and verifies that damos_walk() returns -ECANCELED
immediately.

This validates the invariant introduced by the fix and helps prevent
regressions.

Link: https://patch.msgid.link/20260612062337.2459-1-saileshnandanavanam@gmail.com
Link: https://lore.kernel.org/20260629145538.134832-6-sj@kernel.org
Suggested-by: SJ Park <sj@kernel.org>
Signed-off-by: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Doehyun Baek <doehyunbaek@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Philippe Laferriere <plafer@proton.me>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-add-kunit-test-for-walk_control_obsolete-behavior
+++ a/mm/damon/tests/core-kunit.h
@@ -1456,6 +1456,33 @@ static void damon_test_is_last_region(st
 	damon_free_target(t);
 }
 
+/*
+ * Verify that damos_walk() rejects new requests when
+ * walk_control_obsolete is set.
+ *
+ * This tests the invariant introduced by:
+ * commit 33c3f6c2b48c ("mm/damon/core: fix damos_walk() vs kdamond_fn() exit race")
+ */
+static void damon_test_walk_control_obsolete(struct kunit *test)
+{
+	struct damon_ctx *ctx;
+	struct damos_walk_control control = {};
+	int ret;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc fail");
+
+	/* Simulate shutdown phase */
+	ctx->walk_control_obsolete = true;
+
+	ret = damos_walk(ctx, &control);
+
+	KUNIT_EXPECT_EQ(test, ret, -ECANCELED);
+
+	damon_destroy_ctx(ctx);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -1485,6 +1512,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_set_filters_default_reject),
 	KUNIT_CASE(damon_test_apply_min_nr_regions),
 	KUNIT_CASE(damon_test_is_last_region),
+	KUNIT_CASE(damon_test_walk_control_obsolete),
 	{},
 };
 
_

Patches currently in -mm which might be from saileshnandanavanam@gmail.com are


