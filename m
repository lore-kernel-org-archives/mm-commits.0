Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7332E286D60
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127176; cv=none; b=RaLvP/UG1J0hGhFHi85ze1ISbC/4upK/eeBtVya6Y98+VttaWrdYVrtUm8NhJYk55JTLnmzzm6rEq07m8vV5lKa82bfFtLq9moNP4u0i6KMgqnh8s9A7Xq3ZaLoXGlWGq9/QyCxO5ETT8b6Fzyj4oSbRx9fOCOqw/UgNmy900W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127176; c=relaxed/simple;
	bh=pSRrcUdRgQZFi1mcO+/pWDS10ggCR+Bm4N/t+IsU+4w=;
	h=Date:To:From:Subject:Message-Id; b=dfAxhs8UNP+QIj4K4tl4H/4lDumkkWSkvPg4W0L3amxwJV4aYacNCkv4ge1E7PPD+agMvc2k2XF9avdzbNiqGvVrnZkzSn42RMH9Vvy+6c8CRbgG+J6KdNCD8iZdHYGxs9x2IC3EjTCaquZ7jgttZHDLdVicRKEQBuNepasN9og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PEDocyQl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PEDocyQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48725C4CEE3;
	Thu, 10 Jul 2025 05:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127176;
	bh=pSRrcUdRgQZFi1mcO+/pWDS10ggCR+Bm4N/t+IsU+4w=;
	h=Date:To:From:Subject:From;
	b=PEDocyQlLBn9hzyIEvqe6GK4teE4F5szsMZlf2fRgilzX5U35sr69U8hIQuARPLIv
	 KPAi7CrCuL8JJp+b3W48GVCFPUfumRbx2GnICi6exCvRtSxbVaYnNPC+fMAxuy3HZ1
	 RxPBLyF/u8Z9cf+fjU8AQLP8HZYzBBHVBG2E90ys=
Date: Wed, 09 Jul 2025 22:59:35 -0700
To: mm-commits@vger.kernel.org,jiri@resnulli.us,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-test_objagg-split-test_hints_case-into-two-functions.patch removed from -mm tree
Message-Id: <20250710055936.48725C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: test_objagg: split test_hints_case() into two functions
has been removed from the -mm tree.  Its filename was
     lib-test_objagg-split-test_hints_case-into-two-functions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -908,50 +908,22 @@ static int check_expect_hints_stats(stru
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
@@ -983,7 +955,48 @@ err_world2_obj_get:
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


