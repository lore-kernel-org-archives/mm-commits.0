Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4D222126C
	for <mm-commits@vger.kernel.org>; Mon,  8 Sep 2025 22:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757371302; cv=none; b=TVoiRqWoDmSBYzspq58ioAa9UxA1R/Ccy63PP7RZ79JAMorCtjEIiOxR1pV0In+sxjsqx0Mz86XmXM7LqVE6hKm17Q1MvyrMbsKi2zXsMIYH+ygPy4cMrVwr5k7Dz06xv+hBc60237kxtcphvWylhOwwsYHYn1JqrXmlnQgf11U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757371302; c=relaxed/simple;
	bh=no0Q1QjWE79swc14GMrunGZ6DVTmsG52Uf2YvZNwoOg=;
	h=Date:To:From:Subject:Message-Id; b=JjQh+wANJ1x4x4LbsCWWrFMGqwY2mmvMxVA008zg2VYqiOGMU/3m9nFdOlRS/i/axKkyA+6R746W/HJLZ4QSqxatdu4r4AvswBOptE5qfBS9vZ30d4MktTxZiFi/ifNC+dPxmIWNvrHZhmeykR3xXNg47AQGs77AHsccqrtzOMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ReyuP5SM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ReyuP5SM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F97CC4CEF1;
	Mon,  8 Sep 2025 22:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757371302;
	bh=no0Q1QjWE79swc14GMrunGZ6DVTmsG52Uf2YvZNwoOg=;
	h=Date:To:From:Subject:From;
	b=ReyuP5SMRtENRVUjOPdpLpWocJaecGRD6f87N0P2EzL+gXFbjk6P5u86m6chrexQi
	 Rbma1PlwfeZdchufdKIqKT8O9gYR/BKVYCoIwuIsii+DalsEIu/PflkS2XerRb872Y
	 X5avKyrcdeoQghrAeCBP+CkoiJ/gYcwgz0ZNRRdo=
Date: Mon, 08 Sep 2025 15:41:41 -0700
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-use-dynamically-allocated-repeat-mode-damon_call_control.patch added to mm-hotfixes-unstable branch
Message-Id: <20250908224142.4F97CC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: use dynamically allocated repeat mode damon_call_control
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-sysfs-use-dynamically-allocated-repeat-mode-damon_call_control.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-use-dynamically-allocated-repeat-mode-damon_call_control.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: use dynamically allocated repeat mode damon_call_control
Date: Mon, 8 Sep 2025 13:15:13 -0700

Patch series "mm/damon/sysfs: fix refresh_ms control overwriting on
multi-kdamonds usages".

Automatic esssential DAMON/DAMOS status update feature of DAMON sysfs
interface (refresh_ms) is broken [1] for multiple DAMON contexts
(kdamonds) use case, since it uses a global single damon_call_control
object for all created DAMON contexts.  The fields of the object,
particularly the list field is over-written for the contexts and it makes
unexpected results including user-space hangup and kernel crashes [2]. 
Fix it by extending damon_call_control for the use case and updating the
usage on DAMON sysfs interface to use per-context dynamically allocated
damon_call_control object.


This patch (of 2):

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

mm-damon-core-introduce-damon_call_control-dealloc_on_cancel.patch
mm-damon-sysfs-use-dynamically-allocated-repeat-mode-damon_call_control.patch
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

