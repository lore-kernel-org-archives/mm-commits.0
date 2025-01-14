Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAB323D3D4
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837150; cv=none; b=urZYvFGoQZo+BdFFnlBrwBEvV/xSDG0PD0KAvcttXhrR0r4vWiNjBd3yncXAMI+DgY1zI5EDKR8RmOJQ4Z8biGMpKlaerxLkmXSQApKq5mVsebiYYEc0D6gs43BeWcomW6MF/HDs/XSnO05N1u9W3bQe1cnIGXtGJHki73oHL08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837150; c=relaxed/simple;
	bh=muhdwjFY/dLXN9O2Dtt+K3eKbi9qubuu958/qgZCIpg=;
	h=Date:To:From:Subject:Message-Id; b=SpXm2qnLdHSjZIAgmTdAYjIrL0r9nq0r7yN4F6Qa7/G5RO3KYgFfxNruP16F6rULKu+RUyWzWTjTC+RK9tzl/cZ3T5xOpPU6blcKbmbjO9E2WDfkwcAkzz3hEEdCAtHD31xw2eNb4KvgI+/vKsdG+UfofK/5XuiCnJgbi8ajnRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VrkHIfzs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VrkHIfzs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEBDC4CEDD;
	Tue, 14 Jan 2025 06:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837150;
	bh=muhdwjFY/dLXN9O2Dtt+K3eKbi9qubuu958/qgZCIpg=;
	h=Date:To:From:Subject:From;
	b=VrkHIfzsAa4lxYM6hfGZOf/mRls8PEHCGIZFzATEbTQ6wHJtRvM73QtmsqupdHgJh
	 GMks9KbnL+r+LW3bNV/fKnJGuFYy6+Iujj3KJJe2skDIoecFQRmkEgUOhNZBvWthUv
	 Ryedbgp+uRmWulMblmAPfNe23zoPkn7k+RI3Nhgw=
Date: Mon, 13 Jan 2025 22:45:49 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-use-damon_call-for-commit_schemes_quota_goals.patch removed from -mm tree
Message-Id: <20250114064550.6CEBDC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: use damon_call() for commit_schemes_quota_goals
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-use-damon_call-for-commit_schemes_quota_goals.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: use damon_call() for commit_schemes_quota_goals
Date: Fri, 3 Jan 2025 09:43:55 -0800

DAMON sysfs interface uses damon_callback with its own synchronization
facility to handle commit_schemes_quota_goals command.  But damon_call()
can support the use case without the additional synchronizations.  Convert
the code to use damon_call() instead.

Link: https://lkml.kernel.org/r/20250103174400.54890-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-use-damon_call-for-commit_schemes_quota_goals
+++ a/mm/damon/sysfs.c
@@ -1307,9 +1307,9 @@ static int damon_sysfs_commit_input(stru
 	return err;
 }
 
-static int damon_sysfs_commit_schemes_quota_goals(
-		struct damon_sysfs_kdamond *sysfs_kdamond)
+static int damon_sysfs_commit_schemes_quota_goals(void *data)
 {
+	struct damon_sysfs_kdamond *sysfs_kdamond = data;
 	struct damon_ctx *ctx;
 	struct damon_sysfs_context *sysfs_ctx;
 
@@ -1376,9 +1376,6 @@ static int damon_sysfs_cmd_request_callb
 			goto out;
 		err = damon_sysfs_commit_input(kdamond);
 		break;
-	case DAMON_SYSFS_CMD_COMMIT_SCHEMES_QUOTA_GOALS:
-		err = damon_sysfs_commit_schemes_quota_goals(kdamond);
-		break;
 	case DAMON_SYSFS_CMD_UPDATE_SCHEMES_TRIED_BYTES:
 		total_bytes_only = true;
 		fallthrough;
@@ -1543,6 +1540,10 @@ static int damon_sysfs_handle_cmd(enum d
 		return damon_sysfs_turn_damon_on(kdamond);
 	case DAMON_SYSFS_CMD_OFF:
 		return damon_sysfs_turn_damon_off(kdamond);
+	case DAMON_SYSFS_CMD_COMMIT_SCHEMES_QUOTA_GOALS:
+		return damon_sysfs_damon_call(
+				damon_sysfs_commit_schemes_quota_goals,
+				kdamond);
 	case DAMON_SYSFS_CMD_UPDATE_SCHEMES_STATS:
 		return damon_sysfs_damon_call(
 				damon_sysfs_upd_schemes_stats, kdamond);
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

