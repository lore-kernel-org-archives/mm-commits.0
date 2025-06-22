Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA7F13B58B
	for <mm-commits@vger.kernel.org>; Sun, 22 Jun 2025 22:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750630760; cv=none; b=ByGXHdxUzr9LlTlMhvKA8ZPsG/mEXLmXI3z2akIlDhZuzL20XCo3QBIr7WujRveZ4qvptzGFEaBarQ8IlZc4+wyqfnEKGJ8EhevbUW58OBgt/4lxzOEryAU3MZREdMSKtCsjbY0G07KK/6RJInJHei0PjBs64bgghJLcJWJiaW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750630760; c=relaxed/simple;
	bh=b49ABR9YzKEYj8cSp82Btm7Fqa7vBKgPvTHP4VffwuA=;
	h=Date:To:From:Subject:Message-Id; b=K+mRCe9bVFlcD6Ggo+FJZNeBgD7nfX4IMqiPTGeiaBbH7fzlzydOWumKOcWvoU+KsKj4bQScpJ7Npd2/L0FFIGI/R7Js9tnWmTBItsn1IIMc7pkOpEuajVCTzZzd7Oak/7u+y0U0XC39EKzc/Z64Pc62eRjaLN1QsNsvJS1vCdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1Uxo22HK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1Uxo22HK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C6AC4CEE3;
	Sun, 22 Jun 2025 22:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750630760;
	bh=b49ABR9YzKEYj8cSp82Btm7Fqa7vBKgPvTHP4VffwuA=;
	h=Date:To:From:Subject:From;
	b=1Uxo22HKs7IphcM1ZC6fQQ5352cVp6hYShazf9hbds3lZrIEmTVeX70hER33s3wRH
	 nzF2Bu84Yxvf2cLshsUOWsAB3S4KVI/+M4d+hzxNpAZfqdeYE4n9jXSPAsS0ox5LQs
	 OZSyHg8DU0ETmrHmla/dZP7tiFeAm3Hvc45ROSHw=
Date: Sun, 22 Jun 2025 15:19:19 -0700
To: mm-commits@vger.kernel.org,jiri@resnulli.us,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_objagg-split-test_hints_case-into-two-functions.patch added to mm-nonmm-unstable branch
Message-Id: <20250622221920.42C6AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: test_objagg: split test_hints_case() into two functions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-test_objagg-split-test_hints_case-into-two-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_objagg-split-test_hints_case-into-two-functions.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Arnd Bergmann <arnd@arndb.de>
Subject: lib: test_objagg: split test_hints_case() into two functions
Date: Fri, 20 Jun 2025 13:19:04 +0200

With sanitizers enabled, this function uses a lot of stack, causing a
harmless warning:

lib/test_objagg.c: In function 'test_hints_case.constprop':
lib/test_objagg.c:994:1: error: the frame size of 1440 bytes is larger than 1408 bytes [-Werror=frame-larger-than=]

Most of this is from the two 'struct world' structures.  Since most of the
work in this function is duplicated for the two, split it up into separate
functions that each use one of them.

The combined stack usage is still the same here, but there is no warning
any more, and the code is still safe because of the known call chain.

Link: https://lkml.kernel.org/r/20250620111907.3395296-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_objagg.c |   77 +++++++++++++++++++++++++-------------------
 1 file changed, 45 insertions(+), 32 deletions(-)

--- a/lib/test_objagg.c~lib-test_objagg-split-test_hints_case-into-two-functions
+++ a/lib/test_objagg.c
@@ -906,50 +906,22 @@ static int check_expect_hints_stats(stru
 	return err;
 }
 
-static int test_hints_case(const struct hints_case *hints_case)
+static int test_hints_case2(const struct hints_case *hints_case,
+			    struct objagg_hints *hints, struct objagg *objagg)
 {
 	struct objagg_obj *objagg_obj;
-	struct objagg_hints *hints;
 	struct world world2 = {};
-	struct world world = {};
 	struct objagg *objagg2;
-	struct objagg *objagg;
 	const char *errmsg;
 	int i;
 	int err;
 
-	objagg = objagg_create(&delta_ops, NULL, &world);
-	if (IS_ERR(objagg))
-		return PTR_ERR(objagg);
-
-	for (i = 0; i < hints_case->key_ids_count; i++) {
-		objagg_obj = world_obj_get(&world, objagg,
-					   hints_case->key_ids[i]);
-		if (IS_ERR(objagg_obj)) {
-			err = PTR_ERR(objagg_obj);
-			goto err_world_obj_get;
-		}
-	}
-
-	pr_debug_stats(objagg);
-	err = check_expect_stats(objagg, &hints_case->expect_stats, &errmsg);
-	if (err) {
-		pr_err("Stats: %s\n", errmsg);
-		goto err_check_expect_stats;
-	}
-
-	hints = objagg_hints_get(objagg, OBJAGG_OPT_ALGO_SIMPLE_GREEDY);
-	if (IS_ERR(hints)) {
-		err = PTR_ERR(hints);
-		goto err_hints_get;
-	}
-
 	pr_debug_hints_stats(hints);
 	err = check_expect_hints_stats(hints, &hints_case->expect_stats_hints,
 				       &errmsg);
 	if (err) {
 		pr_err("Hints stats: %s\n", errmsg);
-		goto err_check_expect_hints_stats;
+		return err;
 	}
 
 	objagg2 = objagg_create(&delta_ops, hints, &world2);
@@ -981,7 +953,48 @@ err_world2_obj_get:
 		world_obj_put(&world2, objagg, hints_case->key_ids[i]);
 	i = hints_case->key_ids_count;
 	objagg_destroy(objagg2);
-err_check_expect_hints_stats:
+
+	return err;
+}
+
+static int test_hints_case(const struct hints_case *hints_case)
+{
+	struct objagg_obj *objagg_obj;
+	struct objagg_hints *hints;
+	struct world world = {};
+	struct objagg *objagg;
+	const char *errmsg;
+	int i;
+	int err;
+
+	objagg = objagg_create(&delta_ops, NULL, &world);
+	if (IS_ERR(objagg))
+		return PTR_ERR(objagg);
+
+	for (i = 0; i < hints_case->key_ids_count; i++) {
+		objagg_obj = world_obj_get(&world, objagg,
+					   hints_case->key_ids[i]);
+		if (IS_ERR(objagg_obj)) {
+			err = PTR_ERR(objagg_obj);
+			goto err_world_obj_get;
+		}
+	}
+
+	pr_debug_stats(objagg);
+	err = check_expect_stats(objagg, &hints_case->expect_stats, &errmsg);
+	if (err) {
+		pr_err("Stats: %s\n", errmsg);
+		goto err_check_expect_stats;
+	}
+
+	hints = objagg_hints_get(objagg, OBJAGG_OPT_ALGO_SIMPLE_GREEDY);
+	if (IS_ERR(hints)) {
+		err = PTR_ERR(hints);
+		goto err_hints_get;
+	}
+
+	err = test_hints_case2(hints_case, hints, objagg);
+
 	objagg_hints_put(hints);
 err_hints_get:
 err_check_expect_stats:
_

Patches currently in -mm which might be from arnd@arndb.de are

crashdump-add-config_keys-dependency.patch
lib-test_hmm-reduce-stack-usage.patch
lib-test_objagg-split-test_hints_case-into-two-functions.patch

