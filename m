Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B882B13DBB6
	for <mm-commits@vger.kernel.org>; Sat,  4 Jan 2025 02:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735958718; cv=none; b=EdNuljqFEsFGwKaH327t/HybaXCBtk98yGKvUkzdzivN28QwIFnmLzpMFxaC21bxmRlK6tW/Hb0fyvmI46LWKgn6xw2qTC5Rj5HHHztKJaYvGfo7vUJNCitAHrIf389pLohof4i3N3+ptYpoAx9+OX2QS7Hxajbx8pvq84HEXJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735958718; c=relaxed/simple;
	bh=LXlgR657NtPkpAMVSZ9r/usfhZk6R/bv44VJxW03GK4=;
	h=Date:To:From:Subject:Message-Id; b=O2c3XsuPsyRdIPSc940ZGRpujBBGqLFdArwccRTwxJXEfC5UOTlGCrALC16ge+Sq1dyMtjOo7Ja4zdC2nXOqqqirAcpcFe8fjA7ArbYhG7HPIy9DMjvSlQvB0ezzWR7XKQ7eRasAUAxourG+ApVsgZQYRew1W+9wIJ/FOcuCKDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bfFiUjH2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bfFiUjH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA85C4CED6;
	Sat,  4 Jan 2025 02:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735958718;
	bh=LXlgR657NtPkpAMVSZ9r/usfhZk6R/bv44VJxW03GK4=;
	h=Date:To:From:Subject:From;
	b=bfFiUjH29faY+Y/zJWH7nQgVCsJ//SBmfbYvq+yiGVfxYr+hk5UIRtEWxXQIXr6RZ
	 Yk9qaSvGPV1I8bI8nqGunzujwOnKzMt8njmYgI3FcsRYDoASpfc81Q4Ky//gl9Oyc8
	 QmZ2nF8mlWxAG6Ts+ahhh/BzRGH4J4pZH9TcGAXI=
Date: Fri, 03 Jan 2025 18:45:17 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-use-damon_call-for-commit_schemes_quota_goals.patch added to mm-unstable branch
Message-Id: <20250104024518.6AA85C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: use damon_call() for commit_schemes_quota_goals
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-use-damon_call-for-commit_schemes_quota_goals.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-use-damon_call-for-commit_schemes_quota_goals.patch

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

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch
replace-free-hugepage-folios-after-migration-fix-2.patch
docs-admin-guide-mm-damon-usage-remove-damon-debugfs-interface-documentation.patch
docs-mm-damon-design-update-for-removal-of-damon-debugfs-interface.patch
selftests-damon-config-remove-configs-for-damon-debugfs-interface-selftests.patch
selftests-damon-remove-tests-for-damon-debugfs-interface.patch
kunit-configs-remove-configs-for-damon-debugfs-interface-tests.patch
mm-damon-remove-damon-debugfs-interface-kunit-tests.patch
mm-damon-remove-damon-debugfs-interface.patch
mm-damon-sysfs-schemes-remove-unnecessary-schemes-existence-check-in-damon_sysfs_schemes_clear_regions.patch
mm-damon-sysfs-handle-clear_schemes_tried_regions-from-damon-sysfs-context.patch
mm-damon-core-introduce-damon_call.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_stats.patch
mm-damon-sysfs-use-damon_call-for-commit_schemes_quota_goals.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_effective_quotas.patch
mm-damon-core-implement-damos_walk.patch
docs-mm-damon-design-document-damos-regions-walking.patch
mm-damon-sysfs-use-damos_walk-for-update_schemes_tried_bytesregions.patch
mm-damon-sysfs-remove-unused-code-for-schemes-tried-regions-update.patch

