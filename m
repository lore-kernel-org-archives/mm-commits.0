Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FCC23774
	for <mm-commits@vger.kernel.org>; Tue, 24 Jun 2025 03:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750734484; cv=none; b=Wt0xd96+3tgt1mTBiQ51hbKblFFYPdVY9NsEKc1UVqBMiviJK1MbeqMl2MExDbK5b1T8qgY1EsqiLU+uLT5BFPL9ZKBSrvIEUI8ssPqnX32LRpkNVao8YX+VIwKBpBmHQba6LvF1GQk+NWPyk5/pCNha5NgCqYde7RbcXHPdZUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750734484; c=relaxed/simple;
	bh=LfmJfLjD1dpAx0KJTmJy0ZelciqE0DcFJjTy8x5sgh8=;
	h=Date:To:From:Subject:Message-Id; b=NPhPJbnXSS/1/5AhVzGgyaojlW2/sYxpGusggO3G0XKrilAQDGT32lhIds2RM184QcgAypapGcDx6Mq2LxXerFjcbOmjrDFufvXfRVduEve843liU6OzE5GV9OhwjTTJl0anL4/jCBbgVbgA+7wnyST4/bz1AvEBA7qjH43Lpqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GJv7v4tw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GJv7v4tw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB84C4CEEA;
	Tue, 24 Jun 2025 03:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750734483;
	bh=LfmJfLjD1dpAx0KJTmJy0ZelciqE0DcFJjTy8x5sgh8=;
	h=Date:To:From:Subject:From;
	b=GJv7v4twR/l3vVxO3isFU8TSWlTtamvm7/mwg2cIF6aEgtSIU2OlXtq/xjljXYncy
	 uMRAhpA6Cq+YeWjDw+wZN5nKJmtuoeu+aB8qQ9tGG8Rgv/FpoXo2td40vpW7Z8q7aV
	 YcTv2CJlSVnfisYrf34JjK8OXoGD7qwmSwmtoT28=
Date: Mon, 23 Jun 2025 20:08:02 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,pabeni@redhat.com,kuba@kernel.org,jiri@resnulli.us,davem@davemloft.net,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] lib-test_objagg-split-test_hints_case-into-two-functions.patch removed from -mm tree
Message-Id: <20250624030803.5FB84C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: test_objagg: split test_hints_case() into two functions
has been removed from the -mm tree.  Its filename was
     lib-test_objagg-split-test_hints_case-into-two-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Stehen Rothwell <sfr@canb.auug.org.au>
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

