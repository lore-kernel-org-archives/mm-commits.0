Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FBF49A3A0
	for <mm-commits@vger.kernel.org>; Mon, 28 Sep 2026 22:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790635869; cv=none; b=q71SKKt/Gv8cJvYQtT8B7dTImx3KpKnxQklOaO2+nHC2jiOiufISDkSaKBbsn0mUqlJK4FVtiskytiRxGdbj/q4jA9HGiXE/RBQo4J7BJtH8nRZ5daHzbstqWlqAs9B0UdlXCNcI+vBipx0nO1enYKqqsSmjQpT6ikXyy3prTBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790635869; c=relaxed/simple;
	bh=TZKRGGrIiOHk1KKO4fcz5LQFGMyqvsmgncpmI7I4NGw=;
	h=Date:To:From:Subject:Message-Id; b=geRM78I8794FtbPkRNMPHciWxLAz1MQCM87d2bMYrymGXOaMefjkeAo7QPVPPXmbeEM4T8x5TXdzeMHaY4nT+OX8w9G/4fk9CVNDgWdjWcbpW5yV5+Wyf5Me2TQKkoqm+/fQsfo8BLkQxiT3THe4XInhTZNDdmtPmbkyu8RuyKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mSBoPHZf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mSBoPHZf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B500E1F000FF;
	Mon, 28 Sep 2026 22:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790635867;
	bh=SzKvOIorwlfDN3DLIApJhkwYEGof+XXw+41/Ys27q/E=;
	h=Date:To:From:Subject;
	b=mSBoPHZfk1Ia2+64b/LPUIr65mUSVe/GOGq9x025N8hm6kB1sVtYve7wp8BRgN6w0
	 JrDwX+USGTkMHCCjD2044QBU2bT2y/mdwHdeePLmR66r6wcgAqWV5kSKn51dLkJ4b1
	 KL+3EqBuHU6//hzo3bUlsA5HTp+Zaf/yV1gzrY6w=
Date: Mon, 28 Sep 2026 15:51:07 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-api-remove-unused-nr_damos_-enumerators.patch added to mm-new branch
Message-Id: <20260928225107.B500E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/api: remove unused NR_DAMOS_* enumerators
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-api-remove-unused-nr_damos_-enumerators.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-api-remove-unused-nr_damos_-enumerators.patch

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
From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: mm/damon/api: remove unused NR_DAMOS_* enumerators
Date: Mon, 28 Sep 2026 01:39:55 -0700

Patch series "mm/damon/core: cleanup code, reduce stack usage, and add
kunit".

Three various improvements.  Patch 1 from Zenghui Yu (Huawei) cleans up
unused enums.  Patch 2 from Arnd Bergmann reduces kdamond's stack usage. 
Patch 3 from Karl Mehltretter adds a kunit test for uninitialized PSI
quota goal stage logic.


This patch (of 3):

NR_DAMOS_ACTIONS, NR_DAMOS_QUOTA_GOAL_METRICS, and NR_DAMOS_WMARK_METRICS
are not referenced by any code.  Remove them.

They can be reintroduced if a real user comes up.

Link: https://lore.kernel.org/20260928083959.4030-1-sj@kernel.org
Link: https://lore.kernel.org/20260928083959.4030-2-sj@kernel.org
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
---

 include/linux/damon.h |    8 --------
 1 file changed, 8 deletions(-)

--- a/include/linux/damon.h~mm-damon-api-remove-unused-nr_damos_-enumerators
+++ a/include/linux/damon.h
@@ -117,7 +117,6 @@ struct damon_target {
  * @DAMOS_MIGRATE_HOT:  Migrate the regions prioritizing warmer regions.
  * @DAMOS_MIGRATE_COLD:	Migrate the regions prioritizing colder regions.
  * @DAMOS_STAT:		Do nothing but count the stat.
- * @NR_DAMOS_ACTIONS:	Total number of DAMOS actions
  *
  * The support of each action is up to running &struct damon_operations.
  * Refer to 'Operation Action' section of Documentation/mm/damon/design.rst for
@@ -137,7 +136,6 @@ enum damos_action {
 	DAMOS_MIGRATE_HOT,
 	DAMOS_MIGRATE_COLD,
 	DAMOS_STAT,		/* Do nothing but only record the stat */
-	NR_DAMOS_ACTIONS,
 };
 
 /**
@@ -154,9 +152,6 @@ enum damos_action {
  * @DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:	Scheme-eligible memory ratio of a
  *					node in basis points (0-10000).
  * @DAMOS_QUOTA_HUGEPAGE_MEM_BP:	Huge page to total used memory ratio.
- * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
- *
- * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsupported.
  */
 enum damos_quota_goal_metric {
 	DAMOS_QUOTA_USER_INPUT,
@@ -169,7 +164,6 @@ enum damos_quota_goal_metric {
 	DAMOS_QUOTA_INACTIVE_MEM_BP,
 	DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
 	DAMOS_QUOTA_HUGEPAGE_MEM_BP,
-	NR_DAMOS_QUOTA_GOAL_METRICS,
 };
 
 /**
@@ -313,12 +307,10 @@ struct damos_quota {
  *
  * @DAMOS_WMARK_NONE:		Ignore the watermarks of the given scheme.
  * @DAMOS_WMARK_FREE_MEM_RATE:	Free memory rate of the system in [0,1000].
- * @NR_DAMOS_WMARK_METRICS:	Total number of DAMOS watermark metrics
  */
 enum damos_wmark_metric {
 	DAMOS_WMARK_NONE,
 	DAMOS_WMARK_FREE_MEM_RATE,
-	NR_DAMOS_WMARK_METRICS,
 };
 
 /**
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

selftests-mm-fix-incorrect-skip-output-in-pkey_sighandler_tests.patch
mm-damon-core-remove-declaration-of-__damon_commit_ctx.patch
selftests-mm-remove-unreachable-returns-after-ksft-exit-helpers.patch
docs-mm-damon-design-fix-broken-ref-usage-and-a-typo.patch
selftests-mm-fix-size-truncation-in-pagemap_ioctl-test.patch
selftests-mm-mark-file-local-symbols-of-pagemap_ioctlc-static.patch
selftests-mm-init-page-sizes-early-in-pagemap_ioctl-test.patch
selftests-damon-stop-kdamond-on-error-exits-of-no-op-commit-test.patch
selftests-damon-ignore-test-generated-damon_dump_output.patch
mm-damon-api-remove-unused-nr_damos_-enumerators.patch

