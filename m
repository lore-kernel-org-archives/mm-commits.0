Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19EA23D7DB
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 20:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757794171; cv=none; b=Sce7snyhfnFgjxQUrghaQ8lN8YuL0aFUEMJ6oeR4Sx2z5tIOAFt1sF7PvgDFypn1mDsir5X/D0a7Y8pkJecT4SimqR2QdiOB6Zk+eOYbymK96e0R7fmDw3F6T06gPk1y2ksAZZ0wyFFPg3AV7U6m4ERO6/velkVAcjk0zGBvleo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757794171; c=relaxed/simple;
	bh=CCSuNxqFJeeh4aaFD21hDHI63NAGAdteGjLZRHdoOvY=;
	h=Date:To:From:Subject:Message-Id; b=LoFqCuHmDNil2WLFvPz/hZb8oLZJDuozNLSNks8UFDGHtgZEwQruVzYOwbM1nSMhvxS5J6bS28fOIUhSr9Zdp10V4atyft1vAWf+RhPmNYOF+Xc4YE9k4OM6hvJmKRVS548bp89oPTKwj+o2ikY5E2FaDSjzs6hNOH+FCFnL0vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LlcLz+7U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LlcLz+7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1ACC4CEEB;
	Sat, 13 Sep 2025 20:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757794171;
	bh=CCSuNxqFJeeh4aaFD21hDHI63NAGAdteGjLZRHdoOvY=;
	h=Date:To:From:Subject:From;
	b=LlcLz+7UPspgY1VSkNvBKe1mPxCRWSAQGyy8szOYjzXl8zz6nLDCViPhl1+Hq+pjS
	 LRoi6wsvXZTR0O7lvT64vUFT+MxV8J+cSS7rNWE8RBaHsuZ3/UmxqPq57imyanr1XG
	 4Rj/e3v2yo9vKlBp7hz3u++PkR4ekdJsVb2vDiVY=
Date: Sat, 13 Sep 2025 13:09:31 -0700
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-sysfs-use-dynamically-allocated-repeat-mode-damon_call_control.patch removed from -mm tree
Message-Id: <20250913200931.8D1ACC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: use dynamically allocated repeat mode damon_call_control
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-use-dynamically-allocated-repeat-mode-damon_call_control.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: use dynamically allocated repeat mode damon_call_control
Date: Mon, 8 Sep 2025 13:15:13 -0700

DAMON sysfs interface is using a single global repeat mode
damon_call_control variable for refresh_ms handling, for all DAMON
contexts.  As a result, when there are more than one context, the single
global damon_call_control is unexpectedly over-written (corrupted). 
Particularly the ->link field is overwritten by the multiple contexts and
this can cause a user hangup, and/or a kernel crash.  Fix it by using
dynamically allocated damon_call_control object per DAMON context.

Link: https://lkml.kernel.org/r/20250908201513.60802-3-sj@kernel.org
Link: https://lore.kernel.org/20250904011738.930-1-yunjeong.mun@sk.com [1]
Link: https://lore.kernel.org/20250905035411.39501-1-sj@kernel.org [2]
Fixes: d809a7c64ba8 ("mm/damon/sysfs: implement refresh_ms file internal work")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Yunjeong Mun <yunjeong.mun@sk.com>
Closes: https://lore.kernel.org/20250904011738.930-1-yunjeong.mun@sk.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-use-dynamically-allocated-repeat-mode-damon_call_control
+++ a/mm/damon/sysfs.c
@@ -1534,14 +1534,10 @@ static int damon_sysfs_repeat_call_fn(vo
 	return 0;
 }
 
-static struct damon_call_control damon_sysfs_repeat_call_control = {
-	.fn = damon_sysfs_repeat_call_fn,
-	.repeat = true,
-};
-
 static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 {
 	struct damon_ctx *ctx;
+	struct damon_call_control *repeat_call_control;
 	int err;
 
 	if (damon_sysfs_kdamond_running(kdamond))
@@ -1554,18 +1550,29 @@ static int damon_sysfs_turn_damon_on(str
 		damon_destroy_ctx(kdamond->damon_ctx);
 	kdamond->damon_ctx = NULL;
 
+	repeat_call_control = kmalloc(sizeof(*repeat_call_control),
+			GFP_KERNEL);
+	if (!repeat_call_control)
+		return -ENOMEM;
+
 	ctx = damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0]);
-	if (IS_ERR(ctx))
+	if (IS_ERR(ctx)) {
+		kfree(repeat_call_control);
 		return PTR_ERR(ctx);
+	}
 	err = damon_start(&ctx, 1, false);
 	if (err) {
+		kfree(repeat_call_control);
 		damon_destroy_ctx(ctx);
 		return err;
 	}
 	kdamond->damon_ctx = ctx;
 
-	damon_sysfs_repeat_call_control.data = kdamond;
-	damon_call(ctx, &damon_sysfs_repeat_call_control);
+	repeat_call_control->fn = damon_sysfs_repeat_call_fn;
+	repeat_call_control->data = kdamond;
+	repeat_call_control->repeat = true;
+	repeat_call_control->dealloc_on_cancel = true;
+	damon_call(ctx, repeat_call_control);
 	return err;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-store-page_size-compression-failed-page-as-is.patch
mm-zswap-store-page_size-compression-failed-page-as-is-fix.patch
mm-zswap-store-page_size-compression-failed-page-as-is-v5.patch
mm-zswap-store-page_size-compression-failed-page-as-is-fix-2.patch
mm-damon-core-add-damon_ctx-addr_unit.patch
mm-damon-paddr-support-addr_unit-for-access-monitoring.patch
mm-damon-paddr-support-addr_unit-for-damos_pageout.patch
mm-damon-paddr-support-addr_unit-for-damos_lru_prio.patch
mm-damon-paddr-support-addr_unit-for-migrate_hotcold.patch
mm-damon-paddr-support-addr_unit-for-damos_stat.patch
mm-damon-sysfs-implement-addr_unit-file-under-context-dir.patch
docs-mm-damon-design-document-address-unit-parameter.patch
docs-admin-guide-mm-damon-usage-document-addr_unit-file.patch
docs-abi-damon-document-addr_unit-file.patch

