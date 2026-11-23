Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795454450;
	b=k3qIb1kH+3hl0BGUO0LTvKwWExS8QrZVRxvObN68zF7P1wrlKu+vitvvGa/HRDb0HwEJ
	 nw0S0zQyJUgegdD/qx60KfB2M8p/dMNvQ7w+CtYwS9MFVM/DFEoU1chYRsHN/tU810Y/x
	 VOHxpzDIjwqwiO6UYdng7WuphAT1bzc8m+EX2UCDA5anb2FyjmBORUbWSkhdsimztvPsS
	 XWiADfFV+K90ICjvi/3F8mFPU1h9+lxevnr7QKUyPqnQ/4gqU5SIPiWE5LwaSK+p1lv76
	 +B2fvkt5Y0KVb+mJ18Uvu+/6FBCt9MEChWE+BT6yB/4SJP+R/Y0haUK2c7mbgYuXQaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795454450;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=4fPG9xJ6IK3L1mkgR6zPy87pnhkXzvHcHXmuu7Qz45I=;
	b=SF6OTshaYQkl/+zZgnJ2EAU/EPwhraCrMcXOh2w86nYoQT7tdO8se2C965oots2XiHaB
	 V4Hj7uvgI5PMLVGmeVQ6efEWQArV24Ykla+XX2UzWeLFut0yBgFIYeLacbC9coPP8K/8A
	 6Yns0Ja0jaB6gEqI3Cnm2CPsJT8wk9Bic6fab/PuFwrqeJVuZpPwj4N3vuDWBcUiQDVxO
	 AAH7rD0vzHA1Cz5DeZhg4sQck386fWA9v9aooAZHUo5PVhQBLIn/GI6cQfoWW7HZwQTD1
	 kfyiLL33C/6ZdTLOj1x2KDH8k8Di7AohscxG++9Rypxes/BfP55vacFgz7F9xhievsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jTmOIe7d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7027B606A31F
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 17:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jTmOIe7d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19D01F000D1;
	Mon, 23 Nov 2026 17:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795454449;
	bh=4fPG9xJ6IK3L1mkgR6zPy87pnhkXzvHcHXmuu7Qz45I=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=jTmOIe7dLBrWu3HaUJfPxT+494EqQgh2ExtmUvah61XcCy3nBG7SiQEpOUABvTXzL
	 24emoAj40BQWP/oOChKRB7GZOCE9T43GX7DuSa83tu7DzqTVbfi5lPCyLRPEdEWHyW
	 hhSm619nerPq2rhQM3rC3kg9nPrfPfPq1/1jsDWo=
Date: Mon, 23 Nov 2026 09:20:49 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,jm5905938@gmail.com,
	davidgow@davidgow.net,brendan.higgins@linux.dev,jasonangelov@ucla.edu,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123150929.81797-3-sj@kernel.org>
References: <20261123150929.81797-3-sj@kernel.org>
Subject: + mm-damon-tests-core-kunit-test-damos_filter_type_age_ms-in-damos_filter_for_ops.patch added to mm-new branch
Message-Id: <20261123172049.C19D01F000D1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/tests/core-kunit: test DAMOS_FILTER_TYPE_AGE_MS in damos_filter_for_ops()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-test-damos_filter_type_age_ms-in-damos_filter_for_ops.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-test-damos_filter_type_age_ms-in-damos_filter_for_ops.patch

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
From: Jason Angelov <jasonangelov@ucla.edu>
Subject: mm/damon/tests/core-kunit: test DAMOS_FILTER_TYPE_AGE_MS in damos_filter_for_ops()
Date: Mon, 23 Nov 2026 07:09:26 -0800

DAMOS_FILTER_TYPE_AGE_MS is core filter, not ops filter.
Add kunit test covering this rejection.

Link: https://patch.msgid.link/20261123150929.81797-3-sj@kernel.org
Signed-off-by: Jason Angelov <jasonangelov@ucla.edu>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>

 mm/damon/tests/core-kunit.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-test-damos_filter_type_age_ms-in-damos_filter_for_ops
+++ a/mm/damon/tests/core-kunit.h
@@ -1832,6 +1832,12 @@ static void damon_test_valid_probe_param
 	damon_destroy_ctx(ctx);
 }
 
+static void damos_test_age_ms_filter_is_core(struct kunit *test)
+{
+	KUNIT_EXPECT_FALSE(test,
+			damos_filter_for_ops(DAMOS_FILTER_TYPE_AGE_MS));
+}
+
 static void damos_test_filter_out(struct kunit *test)
 {
 	struct damon_target *t;
@@ -2593,6 +2599,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_commit_ctx),
 	KUNIT_CASE(damon_test_commit_ctx_keeps_quota),
 	KUNIT_CASE(damon_test_valid_probe_params),
+	KUNIT_CASE(damos_test_age_ms_filter_is_core),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damos_test_apply_scheme_filtered_sz),
 	KUNIT_CASE(damos_test_apply_scheme_filter_sz_unchanged),
_

Patches currently in -mm which might be from jasonangelov@ucla.edu are

mm-damon-tests-core-kunit-test-damos_filter_type_age_ms-in-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-test-damos_filter_type_age_ms-in-damos_filter_for_ops.patch
mm-damon-tests-core-kunit-test-damos_filter_type_age_ms-interval-changes.patch

