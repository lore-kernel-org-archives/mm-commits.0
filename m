Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CBC24EAB1
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744860; cv=none; b=TIMUpx4jspoCmBrU+x8NuykdwllEbz0km8JXk3wjAePGhruX6Y2Lmo3wDnFB0wAyVtXBmrq8skvqnzRp8q9oMnzZwn8PILU7BcX2o63eozsS3uAof5GztiDmFlKVoQe7TWf79566145M94Pm/6vu1W0xp7vCA31TljFEEmKo9R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744860; c=relaxed/simple;
	bh=3o+0IiLnmhJdENB05HNAvCGiyEWEWXQHc4t0uepg1PM=;
	h=Date:To:From:Subject:Message-Id; b=SY8yCL46L81+n32/Ud5la+H1odYBIlnttVpSl6QcNUVGlnPOuK5DGgNO6AWWpNFASsYJCRduTT2JgQcuTkb6dI2rQ5yEb2oyrDIE1eSVjBCQ8G4ZnFebLxpmSpuREDnw2RWbOq5ZwfghW2LmKHuUIfUhQoxaX3XLNoOrBoc9/ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HMgsepPX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HMgsepPX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70992C4CEF7;
	Sun, 29 Mar 2026 00:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744860;
	bh=3o+0IiLnmhJdENB05HNAvCGiyEWEWXQHc4t0uepg1PM=;
	h=Date:To:From:Subject:From;
	b=HMgsepPXrl7wXMigDgQ4tpzSwj9My+PkJzbp0+WW82JUdUszHvozsCt7J/YxqbYuw
	 9vwT5xK5O3NzFa1FjqMPgQt47r92JdRTr7XzNJpUp8eIO5pC0ClwT22BEHdiSvagxb
	 q0bSDrAbYPqGCD7/qHExSPRzDuEeTWDSRPwPg1E4=
Date: Sat, 28 Mar 2026 17:40:59 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,gaoxu2@honor.com,bgeffon@google.com,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-unify-and-harden-algo-priority-params-handling.patch removed from -mm tree
Message-Id: <20260329004100.70992C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: unify and harden algo/priority params handling
has been removed from the -mm tree.  Its filename was
     zram-unify-and-harden-algo-priority-params-handling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: unify and harden algo/priority params handling
Date: Wed, 11 Mar 2026 17:42:49 +0900

We have two functions that accept algo= and priority= params -
algorithm_params_store() and recompress_store().  This patch unifies and
hardens handling of those parameters.

There are 4 possible cases:

- only priority= provided [recommended]
  We need to verify that provided priority value is
  within permitted range for each particular function.

- both algo= and priority= provided
  We cannot prioritize one over another.  All we should
  do is to verify that zram is configured in the way
  that user-space expects it to be.  Namely that zram
  indeed has compressor algo= setup at given priority=.

- only algo= provided [not recommended]
  We should lookup priority in compressors list.

- none provided [not recommended]
  Just use function's defaults.

Link: https://lkml.kernel.org/r/20260311084312.1766036-7-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Suggested-by: Minchan Kim <minchan@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: gao xu <gaoxu2@honor.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |  106 +++++++++++++++++++-------------
 1 file changed, 66 insertions(+), 40 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-unify-and-harden-algo-priority-params-handling
+++ a/drivers/block/zram/zram_drv.c
@@ -1619,6 +1619,37 @@ static void zram_debugfs_register(struct
 static void zram_debugfs_unregister(struct zram *zram) {};
 #endif
 
+/* Only algo parameter given, lookup by algo name */
+static int lookup_algo_priority(struct zram *zram, const char *algo,
+				u32 min_prio)
+{
+	s32 prio;
+
+	for (prio = min_prio; prio < ZRAM_MAX_COMPS; prio++) {
+		if (!zram->comp_algs[prio])
+			continue;
+
+		if (!strcmp(zram->comp_algs[prio], algo))
+			return prio;
+	}
+
+	return -EINVAL;
+}
+
+/* Both algo and priority parameters given, validate them */
+static int validate_algo_priority(struct zram *zram, const char *algo, u32 prio)
+{
+	if (prio >= ZRAM_MAX_COMPS)
+		return -EINVAL;
+	/* No algo at given priority */
+	if (!zram->comp_algs[prio])
+		return -EINVAL;
+	/* A different algo at given priority */
+	if (strcmp(zram->comp_algs[prio], algo))
+		return -EINVAL;
+	return 0;
+}
+
 static void comp_algorithm_set(struct zram *zram, u32 prio, const char *alg)
 {
 	zram->comp_algs[prio] = alg;
@@ -1691,6 +1722,7 @@ static ssize_t algorithm_params_store(st
 	char *args, *param, *val, *algo = NULL, *dict_path = NULL;
 	struct deflate_params deflate_params;
 	struct zram *zram = dev_to_zram(dev);
+	bool prio_param = false;
 	int ret;
 
 	deflate_params.winbits = ZCOMP_PARAM_NOT_SET;
@@ -1703,6 +1735,7 @@ static ssize_t algorithm_params_store(st
 			return -EINVAL;
 
 		if (!strcmp(param, "priority")) {
+			prio_param = true;
 			ret = kstrtoint(val, 10, &prio);
 			if (ret)
 				return ret;
@@ -1738,24 +1771,22 @@ static ssize_t algorithm_params_store(st
 	if (init_done(zram))
 		return -EBUSY;
 
-	/* Lookup priority by algorithm name */
-	if (algo) {
-		s32 p;
-
-		prio = -EINVAL;
-		for (p = ZRAM_PRIMARY_COMP; p < ZRAM_MAX_COMPS; p++) {
-			if (!zram->comp_algs[p])
-				continue;
+	if (prio_param) {
+		if (prio < ZRAM_PRIMARY_COMP || prio >= ZRAM_MAX_COMPS)
+			return -EINVAL;
+	}
 
-			if (!strcmp(zram->comp_algs[p], algo)) {
-				prio = p;
-				break;
-			}
-		}
+	if (algo && prio_param) {
+		ret = validate_algo_priority(zram, algo, prio);
+		if (ret)
+			return ret;
 	}
 
-	if (prio < ZRAM_PRIMARY_COMP || prio >= ZRAM_MAX_COMPS)
-		return -EINVAL;
+	if (algo && !prio_param) {
+		prio = lookup_algo_priority(zram, algo, ZRAM_PRIMARY_COMP);
+		if (prio < 0)
+			return -EINVAL;
+	}
 
 	ret = comp_params_store(zram, prio, level, dict_path, &deflate_params);
 	return ret ? ret : len;
@@ -2396,9 +2427,6 @@ static int recompress_slot(struct zram *
 	void *src;
 	int ret = 0;
 
-	if (!zram->comps[prio])
-		return -EINVAL;
-
 	handle_old = get_slot_handle(zram, index);
 	if (!handle_old)
 		return -EINVAL;
@@ -2500,10 +2528,11 @@ static ssize_t recompress_store(struct d
 	char *args, *param, *val, *algo = NULL;
 	u64 num_recomp_pages = ULLONG_MAX;
 	struct zram_pp_ctl *ctl = NULL;
-	u32 prio = ZRAM_SECONDARY_COMP;
-	struct zram_pp_slot *pps;
+	s32 prio = ZRAM_SECONDARY_COMP;
 	u32 mode = 0, threshold = 0;
+	struct zram_pp_slot *pps;
 	struct page *page = NULL;
+	bool prio_param = false;
 	ssize_t ret;
 
 	args = skip_spaces(buf);
@@ -2551,7 +2580,8 @@ static ssize_t recompress_store(struct d
 		}
 
 		if (!strcmp(param, "priority")) {
-			ret = kstrtouint(val, 10, &prio);
+			prio_param = true;
+			ret = kstrtoint(val, 10, &prio);
 			if (ret)
 				return ret;
 			continue;
@@ -2565,30 +2595,26 @@ static ssize_t recompress_store(struct d
 	if (!init_done(zram))
 		return -EINVAL;
 
-	if (algo) {
-		bool found = false;
-
-		for (; prio < ZRAM_MAX_COMPS; prio++) {
-			if (!zram->comp_algs[prio])
-				continue;
-
-			if (!strcmp(zram->comp_algs[prio], algo)) {
-				found = true;
-				break;
-			}
-		}
+	if (prio_param) {
+		if (prio < ZRAM_SECONDARY_COMP || prio >= ZRAM_MAX_COMPS)
+			return -EINVAL;
+	}
 
-		if (!found) {
-			ret = -EINVAL;
-			goto out;
-		}
+	if (algo && prio_param) {
+		ret = validate_algo_priority(zram, algo, prio);
+		if (ret)
+			return ret;
 	}
 
-	if (prio < ZRAM_SECONDARY_COMP || prio >= ZRAM_MAX_COMPS) {
-		ret = -EINVAL;
-		goto out;
+	if (algo && !prio_param) {
+		prio = lookup_algo_priority(zram, algo, ZRAM_SECONDARY_COMP);
+		if (prio < 0)
+			return -EINVAL;
 	}
 
+	if (!zram->comps[prio])
+		return -EINVAL;
+
 	page = alloc_page(GFP_KERNEL);
 	if (!page) {
 		ret = -ENOMEM;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


