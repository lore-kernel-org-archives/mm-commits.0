Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA732153E0
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188257; cv=none; b=LPPQgIsZ4twPfe5ZD0Qy9os5fKYX5CJtjMn4nTabzDTuh9A3dbCRnWsWGdeYhkvUawH7IJKVPTpfGQ/G+GK2Z0Yj+Nwa0SxhuY6f2FoUc/S9I+pu11pIzDlONMZ5uQsxWmlTxz6RC+K+k7XEKw0PWC1qzHW76PYNns9friXnI2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188257; c=relaxed/simple;
	bh=t7iq/5uan5Ubgj0WHgilsg5t2RIubivVeROubI1MxFY=;
	h=Date:To:From:Subject:Message-Id; b=HE5lZ1Tb3PhhVsRBqxRrS01XMC0ZjjaHJ0MlfqrBk/97Xcdy02HhN+VbkqiA1g/77Q3jMlLciZlxOdqOdl9QkeWlT4KCrnmxEFpfpHINM1lI9+6xNN9k+ETgOPfpY8eABz8MenR0Us3v0GlNKAzNoNXV13V1tRNRMGCnDTwAqSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ua3L6SNz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ua3L6SNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F646C4CEEC;
	Mon, 17 Mar 2025 05:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188257;
	bh=t7iq/5uan5Ubgj0WHgilsg5t2RIubivVeROubI1MxFY=;
	h=Date:To:From:Subject:From;
	b=ua3L6SNzxgiXnPPGmUVDSOy4rn8EVFaMYjJBKeMAb5CLzJu/COtfkfTG6MWkiazAE
	 NZHJyejRr3NfhGMjk09Z+H+yeKM92a08MKFxsJWzNnP4sSF2zOR9Uz9YrQQotjINX2
	 XPWouwCwGU3E/FwRGnvpLlohqGIW45nsEirhY6hk=
Date: Sun, 16 Mar 2025 22:10:57 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-unset-damos-walk_completed-after-confimed-set.patch removed from -mm tree
Message-Id: <20250317051057.9F646C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: unset damos->walk_completed after confimed set
has been removed from the -mm tree.  Its filename was
     mm-damon-core-unset-damos-walk_completed-after-confimed-set.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: unset damos->walk_completed after confimed set
Date: Mon, 10 Feb 2025 10:27:34 -0800

Patch series "mm/damon/core: fix wrong and/or useless damos_walk()
behaviors".

damos_walk() can finish working earlier or later than expected, and start
earlier than practical.  First two behaviors are clearly wrong behavior
(doesn't follow the documentation) and all three behaviors are only making
the feature useless.  Fix those.


This patch (of 3):

damos->walk_completed is only set, not unset.  This can cause next
damos_walk() finish earlier than expected.  Unset it after all
walk_completed is confirmed.

Link: https://lkml.kernel.org/r/20250210182737.134994-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250210182737.134994-2-sj@kernel.org
Fixes: bf0eaba0ff9c ("mm/damon/core: implement damos_walk()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-unset-damos-walk_completed-after-confimed-set
+++ a/mm/damon/core.c
@@ -1494,6 +1494,9 @@ static void damos_walk_complete(struct d
 		if (!siter->walk_completed)
 			return;
 	}
+	damon_for_each_scheme(siter, ctx)
+		siter->walk_completed = false;
+
 	complete(&control->completion);
 	mutex_lock(&ctx->walk_control_lock);
 	ctx->walk_control = NULL;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories.patch
mm-damon-sysfs-schemes-implement-core_filters-and-ops_filters-directories.patch
mm-damon-sysfs-schemes-commit-filters-in-coreops_filters-directories.patch
mm-damon-core-expose-damos_filter_for_ops-to-damon-kernel-api-callers.patch
mm-damon-sysfs-schemes-record-filters-of-which-layer-should-be-added-to-the-given-filters-directory.patch
mm-damon-sysfs-schemes-return-error-when-for-attempts-to-install-filters-on-wrong-sysfs-directory.patch
docs-abi-damon-document-coreops_filters-directories.patch
docs-admin-guide-mm-damon-usage-update-for-coreops_filters-directories.patch
mm-damon-sysfs-validate-user-inputs-from-damon_sysfs_commit_input.patch
mm-damon-core-invoke-kdamond_call-after-merging-is-done-if-possible.patch
mm-damon-core-make-damon_set_attrs-be-safe-to-be-called-from-damon_call.patch
mm-damon-sysfs-handle-commit-command-using-damon_call.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-code-from-damon_sysfs_handle_cmd.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request_callback-and-its-callers.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-and-its-readers.patch
mm-damon-sysfs-schemes-remove-obsolete-comment-for-damon_sysfs_schemes_clear_regions.patch
mm-damon-remove-damon_callback-private.patch
mm-damon-remove-before_start-of-damon_callback.patch
mm-damon-remove-damon_callback-after_sampling.patch
mm-damon-remove-damon_callback-before_damos_apply.patch
mm-damon-remove-damon_operations-reset_aggregated.patch
mm-damon-sysfs-schemes-avoid-wformat-security-warning-on-damon_sysfs_access_pattern_add_range_dir.patch
mm-madvise-use-is_memory_failure-from-madvise_do_behavior.patch
mm-madvise-split-out-populate-behavior-check-logic.patch
mm-madvise-deduplicate-madvise_do_behavior-skip-case-handlings.patch
mm-madvise-remove-len-parameter-of-madvise_do_behavior.patch

