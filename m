Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8F03C109B
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 18:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782757622; cv=none; b=JlYkm/dMuRiIHZk4D1iI6Du3m4HsZFU2uw71rcMZNGqyk7iznKDYLAh9timfueEIwrZsnapG909UlsmF/RLmWeHdF1W0doY5zmU/RzF3jtBoa6yWOpyAMM5+Qq3petGu1dWPV58O11Jlw0Td4t5nHbTKCY5w6p2Vup09TllEohQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782757622; c=relaxed/simple;
	bh=9Sfl7qCp1iDFPhyc8g2a0nWaFk5rC49aZPMHTRqgNN4=;
	h=Date:To:From:Subject:Message-Id; b=QM6qUVoMkTQ+VcucI1a7Bz0UU0J9EAY5LeIoXHB3/bONJHD2Vsr3xRZFJpM6DRPb8Yslr6KSu3QpNywScyq5BBdo2OM5eKtoI/HVXfMGljqG/WPmGSrgFF/QP3W6bhsqVl27NqHoE4cH2GLfPody3qMw6xHNCbx7wmhd0QtLUiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Enj6elv2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Enj6elv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF411F000E9;
	Mon, 29 Jun 2026 18:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782757619;
	bh=D4+/oZKvegS7a/HiRKxZNC/t9nSnzFu9IMgZERrpwzg=;
	h=Date:To:From:Subject;
	b=Enj6elv2kXpYw6SIqnsnQBnjwS3kKWj3/MhELCAD1iewnMgwF3xFmSai8O8PHl9nk
	 5dt9TE/RpXeP2TxiLZkXPZKF8x5SYuHdS9JZcDOqqrFM697L7WcGNiUVfTOF3zCRJm
	 seeXlsa2DK+vUertkAm0Hg2uE0WsccU/8FcMuM6c=
Date: Mon, 29 Jun 2026 11:26:59 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kkernel.org,sj@kernel.org,rppt@kernel.org,plafer@proton.me,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,gutierrez.asier@huawei-partners.com,doehyunbaek@gmail.com,david@kernel.org,corbet@lwn.net,brendan.higgins@linux.dev,akinobu.mita@gmail.com,saileshnandanavanam@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-core-kunit-add-kunit-test-for-walk_control_obsolete-behavior.patch added to mm-new branch
Message-Id: <20260629182659.7EF411F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests/core-kunit: add KUnit test for walk_control_obsolete behavior
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-add-kunit-test-for-walk_control_obsolete-behavior.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-add-kunit-test-for-walk_control_obsolete-behavior.patch

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
Cc: SJ Park <sj@kkernel.org>
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

mm-damon-tests-core-kunit-add-kunit-test-for-walk_control_obsolete-behavior.patch

