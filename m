Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795540599;
	b=CKpdHVIlMnaGU5+ds587yKETqrSCQKFOvfnBvutgPUjGDA/3lNb6v4/EKUiZBPyvYXfr
	 NDo1Up75VLkRow422SFw0Oh3qpMyryiI7Z35WTya9b8TxLaZYZrd/2V4tVMpVK15N+olw
	 Vf/COtsGI/rJY4HDGZ793A+7wpm2IIGAfyhw3hPTBoU+pbwjRh5odaPRrVQRBr0pFJWf3
	 aweY03PkxzHFnp4KyP3B9evb64Pw+CUFpootZiKhAxFpCZeEfPVlbW5uIGkqmy6YVBaFh
	 tMd4RjkBj3FvzJ8sL0jxXVhpQgLHzkLsfV7E6AjvvbCYJRkXdk0KSpLAoEbQTdHv13Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795540599;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=xnqvJ3abOogUorm/c47Ofq6PQXTd2q/AJNpgZ/dGaUA=;
	b=he6PM8mDviZaKjIF0iYluW33M2ztFvX2w1bbEc9CVA3gMooZUqOfHPV+pvHYQi61lAis
	 Bi8sVaoSPEyYogO3+SNdYYBvh8KPObimKA9RLCQod0k9O6vFKHBlrfTG1lj9jK0PnnC+D
	 bHwAnd/lFAjpkZT985rWvMxfPyGSjVg1wbvy/Rjb0K4oqv9d02ZfWLnxXwCmVw3pNMf2F
	 J6SA0f+8l22/dLmKgHQq4fyYEehDSRzQkopFAsCahSxgU8bo1JoYtkUu+mNjAGRNcuq49
	 AeZI+ATmv18ysB7GNTAEsnrUKxw6R6zX+nQnxEzM0TJlDhF5qrnFJIvxZWzpcwVK3cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MAVuMGGr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D6D606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 17:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MAVuMGGr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E8D1F000C4;
	Tue, 24 Nov 2026 17:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795540599;
	bh=xnqvJ3abOogUorm/c47Ofq6PQXTd2q/AJNpgZ/dGaUA=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=MAVuMGGrCdcTHTXDKw+1lUB/3521DW3u+ykY3d4Zcd1tmIKFd/+9J2ZEPESCg77oI
	 TgWfizVAgMYnLYnXr8RNsF0zJGOyjjxKH3tnZlydQ6Q40eYQmPOsn6cCpbnF7G3ykq
	 w1qt8yLt3e0UmC9ebJ2oQ9NOemI1Wk1KhJ1fqpK8=
Date: Tue, 24 Nov 2026 09:16:38 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,lienze@kylinos.cn,
	jm5905938@gmail.com,davidgow@davidgow.net,brendan.higgins@linux.dev,
	saileshnandanavanam@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124153021.90142-5-sj@kernel.org>
References: <20261124153021.90142-5-sj@kernel.org>
Subject: + mm-damon-tests-core-kunit-add-test-for-damon_call.patch added to mm-new branch
Message-Id: <20261124171638.D1E8D1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/tests/core-kunit: add test for damon_call()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-core-kunit-add-test-for-damon_call.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-core-kunit-add-test-for-damon_call.patch

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
Subject: mm/damon/tests/core-kunit: add test for damon_call()
Date: Tue, 24 Nov 2026 07:30:20 -0800

A newly allocated damon_ctx has call_controls_obsolete set, meaning no
kdamond is available to handle call requests.  damon_call() should
return -ECANCELED in that case instead of queueing the request and
waiting forever.  When call_controls_obsolete is unset and
damon_call_control->repeat is set, damon_call() should return 0
without waiting for kdamond.  Add a kunit test for the two cases.

Link: https://patch.msgid.link/20261124153021.90142-5-sj@kernel.org
Signed-off-by: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Enze Li <lienze@kylinos.cn>

 mm/damon/tests/core-kunit.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-add-test-for-damon_call
+++ a/mm/damon/tests/core-kunit.h
@@ -2724,6 +2724,27 @@ static void damos_test_sz_ops_filter_pas
 	damon_destroy_ctx(c);
 }
 
+static void damon_test_call(struct kunit *test)
+{
+	struct damon_ctx *ctx;
+	struct damon_call_control control = {};
+	int ret;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc fail");
+
+	ret = damon_call(ctx, &control);
+	KUNIT_EXPECT_EQ(test, ret, -ECANCELED);
+
+	ctx->call_controls_obsolete = false;
+	control.repeat = true;
+	ret = damon_call(ctx, &control);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+
+	damon_destroy_ctx(ctx);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -2771,6 +2792,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damos_test_esz_goal_temporal),
 	KUNIT_CASE(damon_test_last_region_quota_reset),
 	KUNIT_CASE(damos_test_sz_ops_filter_passed_last),
+	KUNIT_CASE(damon_test_call),
 	{},
 };
 
_

Patches currently in -mm which might be from saileshnandanavanam@gmail.com are

mm-damon-tests-core-kunit-add-test-for-damon_call.patch

