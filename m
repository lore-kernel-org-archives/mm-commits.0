Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307C211CA0
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 01:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724807260; cv=none; b=HUqJZKQiqPS+uY+ZZhgRmq0564BFXHSGZE8vUFjQJqU3TbzLku9IMWplk0fRa9lKS+IqNNZZy7QOlEDk1FPQYMHmFIIFqNN3SSjoV+eroQTmQ/4Ev6FIU3cKB8Rj5YDmjmpJTk0ga3aXqQ5kj2iO1blq93/PpuY6/eNQbuBqfGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724807260; c=relaxed/simple;
	bh=gkvfotGmoh20BVVWRAEgLosHBxgoVy550ezEYh08WSs=;
	h=Date:To:From:Subject:Message-Id; b=lv7YHzf1gw0tgRvTgLb96H/ene8IfWK2fkdLPp+FmymUwAyzOkeoELrGmOoyTYFXDypvrQVjv3NEfhNybaiRMdi5BgqoHuK5utfQNmsZ6OoinT02MUkJ9SGsJsrizYzIUSZhmKpMFwJQ0tTFxMCVkb/c+6yNN6xb0sOaVu5FvzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kK5oTXfE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kK5oTXfE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D6EC4AF53;
	Wed, 28 Aug 2024 01:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724807260;
	bh=gkvfotGmoh20BVVWRAEgLosHBxgoVy550ezEYh08WSs=;
	h=Date:To:From:Subject:From;
	b=kK5oTXfEv34yvzAQZk1FIc2ludg+3NaMI24YiikeeJW0cf8QL/ZaAGf2JZLVKIRS+
	 +nfW2563rFUoKiRYOuPtEAuO0R4As+ERNNO8UT2XG5Zn9dX21xF/gfDC7NDq6yyaWR
	 8kPCJ5zsoVL8leL3x0hFzV/14+XXLPQ3UXw6eagg=
Date: Tue, 27 Aug 2024 18:07:39 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-replace-per-quota-regions-priority-histogram-buffer-usage-with-per-context-one.patch added to mm-unstable branch
Message-Id: <20240828010739.E5D6EC4AF53@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: replace per-quota regions priority histogram buffer usage with per-context one
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-replace-per-quota-regions-priority-histogram-buffer-usage-with-per-context-one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-replace-per-quota-regions-priority-histogram-buffer-usage-with-per-context-one.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm/damon/core: replace per-quota regions priority histogram buffer usage with per-context one
Date: Sun, 25 Aug 2024 21:23:21 -0700

Replace the usage of per-quota region priorities histogram buffer with the
per-context one.  After this change, the per-quota histogram is not used
by anyone, and hence it is ready to be removed.

Link: https://lkml.kernel.org/r/20240826042323.87025-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-replace-per-quota-regions-priority-histogram-buffer-usage-with-per-context-one
+++ a/mm/damon/core.c
@@ -1582,13 +1582,16 @@ static void damos_adjust_quota(struct da
 		return;
 
 	/* Fill up the score histogram */
-	memset(quota->histogram, 0, sizeof(quota->histogram));
+	memset(c->regions_score_histogram, 0,
+			sizeof(*c->regions_score_histogram) *
+			(DAMOS_MAX_SCORE + 1));
 	damon_for_each_target(t, c) {
 		damon_for_each_region(r, t) {
 			if (!__damos_valid_target(r, s))
 				continue;
 			score = c->ops.get_scheme_score(c, t, r, s);
-			quota->histogram[score] += damon_sz_region(r);
+			c->regions_score_histogram[score] +=
+				damon_sz_region(r);
 			if (score > max_score)
 				max_score = score;
 		}
@@ -1596,7 +1599,7 @@ static void damos_adjust_quota(struct da
 
 	/* Set the min score limit */
 	for (cumulated_sz = 0, score = max_score; ; score--) {
-		cumulated_sz += quota->histogram[score];
+		cumulated_sz += c->regions_score_histogram[score];
 		if (cumulated_sz >= quota->esz || !score)
 			break;
 	}
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-add-access_memory_even-to-gitignore.patch
selftests-damon-cleanup-__pycache__-with-make-clean.patch
selftests-damon-add-execute-permissions-to-test-scripts.patch
mm-damon-core-test-test-only-vaddr-case-on-ops-registration-test.patch
mm-damon-core-test-fix-damon_test_ops_registration-for-damon_vaddr-unset-case.patch
mm-damon-dbgfs-test-skip-dbgfs_set_targets-test-if-paddr-is-not-registered.patch
mm-damon-dbgfs-test-skip-dbgfs_set_init_regions-test-if-paddr-is-not-registered.patch
mm-damon-move-kunit-tests-to-tests-subdirectory-with-_kunit-suffix.patch
mm-damon-tests-add-kunitconfig-file-for-damon-kunit-tests.patch
mm-damon-core-intorduce-per-context-region-priorities-histogram-buffer.patch
mm-damon-core-replace-per-quota-regions-priority-histogram-buffer-usage-with-per-context-one.patch
mm-damon-core-remove-per-scheme-region-priority-histogram-buffer.patch
revert-mm-damon-lru_sort-adjust-local-variable-to-dynamic-allocation.patch

