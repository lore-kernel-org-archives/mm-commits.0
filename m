Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316A89443;
	Sat, 28 Mar 2026 00:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774658359; cv=none; b=ZNRDyNWtt14W6zIPxQ6evHr6Ado2Zy+0VuD9zVvOPLnwVS021R7/3nHM/YA8RZYXqvs0rpjIrKPdlCKm1bf0obp2Fh7De2C74a7R/Au/mfnAuG6aIL5Om/aTpdfGX/wGICo4zVwIaw79EV2ljp4IruEn3jDRYHErMJtx6yc6+Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774658359; c=relaxed/simple;
	bh=iNwKRnNqQvSnURVsvBbhw1/uVUJVdmhggt42ZZe7g0o=;
	h=Date:To:From:Subject:Message-Id; b=IqfUNu8zxDJgieed764nxAGXyhKaGf3sGIcSzIg8O7EOPcR4ZQO7ySGz+xkUXv4AwKCCUiI+/DhbjMSXZJoH9XUCoAK5wyDPXPthDqA3B3bmGX+fXgA5Z4rZJMfyoKnIFReWWeiWJE5KmtSbJYG5+Rkxv4AGYj5Ov1BbGIPeHl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SP+TfDxK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SP+TfDxK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED94C19423;
	Sat, 28 Mar 2026 00:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774658359;
	bh=iNwKRnNqQvSnURVsvBbhw1/uVUJVdmhggt42ZZe7g0o=;
	h=Date:To:From:Subject:From;
	b=SP+TfDxKRgO/eoC+1ztQtRtIcvmibQie9eq1ypvRmec28DJ+oGz1YTAogqxQn2xd2
	 plteDZbyLe0DnqOsAE0xJCIC00xUmvPa1JvyYPGZZCUIXncYxBcCNQQT6JbTjY8foz
	 QVNxGy28IeSYM+hcuVxrnvBso1FRA9tfdT8Z6xuc=
Date: Fri, 27 Mar 2026 17:39:18 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-sysfs-check-contexts-nr-before-accessing-contexts_arr.patch removed from -mm tree
Message-Id: <20260328003918.EED94C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: check contexts->nr before accessing contexts_arr[0]
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-check-contexts-nr-before-accessing-contexts_arr.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Josh Law <objecting@objecting.org>
Subject: mm/damon/sysfs: check contexts->nr before accessing contexts_arr[0]
Date: Sat, 21 Mar 2026 10:54:25 -0700

Multiple sysfs command paths dereference contexts_arr[0] without first
verifying that kdamond->contexts->nr == 1.  A user can set nr_contexts to
0 via sysfs while DAMON is running, causing NULL pointer dereferences.

In more detail, the issue can be triggered by privileged users like
below.

First, start DAMON and make contexts directory empty
(kdamond->contexts->nr == 0).

    # damo start
    # cd /sys/kernel/mm/damon/admin/kdamonds/0
    # echo 0 > contexts/nr_contexts

Then, each of below commands will cause the NULL pointer dereference.

    # echo update_schemes_stats > state
    # echo update_schemes_tried_regions > state
    # echo update_schemes_tried_bytes > state
    # echo update_schemes_effective_quotas > state
    # echo update_tuned_intervals > state

Guard all commands (except OFF) at the entry point of
damon_sysfs_handle_cmd().

Link: https://lkml.kernel.org/r/20260321175427.86000-3-sj@kernel.org
Fixes: 0ac32b8affb5 ("mm/damon/sysfs: support DAMOS stats")
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[5.18+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-check-contexts-nr-before-accessing-contexts_arr
+++ a/mm/damon/sysfs.c
@@ -1749,6 +1749,9 @@ static int damon_sysfs_update_schemes_tr
 static int damon_sysfs_handle_cmd(enum damon_sysfs_cmd cmd,
 		struct damon_sysfs_kdamond *kdamond)
 {
+	if (cmd != DAMON_SYSFS_CMD_OFF && kdamond->contexts->nr != 1)
+		return -EINVAL;
+
 	switch (cmd) {
 	case DAMON_SYSFS_CMD_ON:
 		return damon_sysfs_turn_damon_on(kdamond);
_

Patches currently in -mm which might be from objecting@objecting.org are

mm-damon-core-document-damos_commit_dests-failure-semantics.patch
lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch
lib-glob-fix-grammar-and-replace-non-inclusive-terminology.patch
lib-glob-add-explicit-include-for-exporth.patch
lib-glob-replace-bitwise-or-with-logical-operation-on-boolean.patch
lib-glob-clean-up-bool-abuse-in-pointer-arithmetic.patch
lib-uuid-fix-typo-reversion-to-revision-in-comment.patch
lib-inflate-fix-memory-leak-in-inflate_fixed-on-inflate_codes-failure.patch
lib-inflate-fix-memory-leak-in-inflate_dynamic-on-inflate_codes-failure.patch
lib-inflate-fix-grammar-in-comment-variable-to-variables.patch
lib-inflate-fix-typo-this-results-to-the-results-in-comment.patch
lib-bug-fix-inconsistent-capitalization-in-bug-message.patch
lib-bug-remove-unnecessary-variable-initializations.patch
lib-decompress_bunzip2-fix-32-bit-shift-undefined-behavior.patch
lib-ts_bm-fix-integer-overflow-in-pattern-length-calculation.patch
lib-ts_kmp-fix-integer-overflow-in-pattern-length-calculation.patch
lib-glob-initialize-back_str-to-silence-uninitialized-variable-warning.patch
lib-bch-fix-signed-left-shift-undefined-behavior.patch
lib-bch-fix-signed-shift-overflow-in-build_mod8_tables.patch
lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch

