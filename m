Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE5B317148
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 05:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782709435; cv=none; b=l9j3SZZLHf8j9M41AkqJOUy3zdrQjxEHk2r9OMvZgnQRHPRtFnvMhxksmorIQJfDCrTTCBO+ilKDIMmkKZ3vFRWj28ffj2F7FlEisXuWzIwkgDsp5qRKVBYsXVoFpJ/hSCsNOso1FrrZPHZW+VFTrvRpPLVwi4hnnqd6hc3rrts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782709435; c=relaxed/simple;
	bh=nMyFGhvpIg3j06tziM+bjgm4uwM192nO//ItLFuf5S8=;
	h=Date:To:From:Subject:Message-Id; b=vBJbw+AHv+5NWEsCXfDXGrTI0FFgs1KemhhDDK4Xy56oAQJ11jLpsdAQcshe6djD+qEni85vb85wKRU3cGCweD2G8mfXL9RLSMis2Qhwp93Jwatnq1PuxFPn5HghT9/WNz+tgORUMa0qMyfAgGKyaa+XtV3l2FE5EhqRiA4ajUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4451D1F000E9;
	Mon, 29 Jun 2026 05:03:54 +0000 (UTC)
Date: Sun, 28 Jun 2026 22:03:53 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-add-a-kernel-doc-comment-for-damon_ctx-rnd_state.patch added to mm-hotfixes-unstable branch
Message-Id: <20260629050354.4451D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: add a kernel-doc comment for damon_ctx->rnd_state
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-add-a-kernel-doc-comment-for-damon_ctx-rnd_state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-add-a-kernel-doc-comment-for-damon_ctx-rnd_state.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: SJ Park <sj@kernel.org>
Subject: mm/damon: add a kernel-doc comment for damon_ctx->rnd_state
Date: Sun, 28 Jun 2026 15:08:04 -0700

Fix below kernel document build warning:

    WARNING: ../include/linux/damon.h:909 struct member 'rnd_state' not described in 'damon_ctx'

Link: https://lore.kernel.org/20260628220808.98931-3-sj@kernel.org
Fixes: 9012c4e647df ("mm/damon: replace damon_rand() with a per-ctx lockless PRNG")
Signed-off-by: SJ Park <sj@kernel.org>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Closes: https://lore.kernel.org/4df95955-b255-4e5a-90c4-35db02f3111f@infradead.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-add-a-kernel-doc-comment-for-damon_ctx-rnd_state
+++ a/include/linux/damon.h
@@ -847,6 +847,7 @@ struct damon_attrs {
  * @pause:	Pause kdamond main loop.
  * @adaptive_targets:	Head of monitoring targets (&damon_target) list.
  * @schemes:		Head of schemes (&damos) list.
+ * @rnd_state:	Per-ctx PRNG state for damon_rand().
  */
 struct damon_ctx {
 	struct damon_attrs attrs;
@@ -904,7 +905,6 @@ struct damon_ctx {
 	struct list_head adaptive_targets;
 	struct list_head schemes;
 
-	/* Per-ctx PRNG state for damon_rand(); kdamond is the sole consumer. */
 	struct rnd_state rnd_state;
 };
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-fix-dir-put-orders-in-access_pattern_add_dirs.patch
mm-damon-sysfs-schemes-put-stats-for-scheme_add_dirs-internal-error.patch
mm-damon-ops-common-handle-extreme-intervals-in-damon_hot_score.patch
maintainers-s-seongjae-sj.patch
mm-damon-add-a-kernel-doc-comment-for-damon_ctx-probes.patch
mm-damon-add-a-kernel-doc-comment-for-damon_ctx-rnd_state.patch
samples-damon-wsse-handle-damon_start-failure.patch
samples-damon-prcl-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_stop-failure.patch
samples-damon-wsse-stop-and-free-damon-ctx-when-damon_call-fails.patch
samples-damon-prcl-stop-and-free-damon-ctx-when-damon_call-fails.patch
mm-damon-sysfs-kobject_del-target-normal-context-and-kdamond-dirs.patch
mm-damon-sysfs-kobject_del-region-and-target-error-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-region-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-filter-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-quota-goal-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-action-destination-dirs.patch
mm-damon-sysfs-kobject_del-probe-dirs.patch
mm-damon-sysfs-kobject_del-probe-filter-dirs.patch
mm-damon-sysfs-kobject_del-probe-dirs-in-probes_addd_dir-error-path.patch
mm-damon-sysfs-schemes-kobject_del-region-for-populate_region-error.patch

