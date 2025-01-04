Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C6313211F
	for <mm-commits@vger.kernel.org>; Sat,  4 Jan 2025 02:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735958712; cv=none; b=RkMRIGf/cvKCopX93gmlPtraXzFw0N9E6ZAcqEO/silFtmGyRUJ6EpnjQqNcbcZzj0rwTZi1Xe+axrIZxljzx59L3mJ1wQ/HG988fGQuHHclNzkYi55eWDbb086qzwy6TSi/TwaKXO8HR1EuF65u7hqeMplDN6ct3zXOT3n1MdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735958712; c=relaxed/simple;
	bh=6evItJjTV0zFhR03W/wwBhb50wjBhHdQj9JGii0ED4c=;
	h=Date:To:From:Subject:Message-Id; b=o4ObLr+cHCGqwd770LK8fTkIzARDcoKBasST2JWSZ0/Vj2/KYvvWyQd/rxdWDEmfioIJU8mth+Dz9yBREKBTg7lDpBoX6xht7TY/aqBTyRp2PYAY2RIWoNZPyG872WTer33jYwoqAz9VwT38rzuoZsb+mhtC0Tt1e5AWmdqafh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wvp+/q1C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wvp+/q1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D77C4CED6;
	Sat,  4 Jan 2025 02:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735958712;
	bh=6evItJjTV0zFhR03W/wwBhb50wjBhHdQj9JGii0ED4c=;
	h=Date:To:From:Subject:From;
	b=Wvp+/q1Cl1RuoHv330MO4wd1eqGt75mqVeHiTP7sh9ijSOvXybA6N9HVa2PP2dsNd
	 zFjvgy2IZ3oScPjaHevZs1o+9QYVbluO+Ml5UYkOMGrN7q4TdvElf2+V1ujhFjzRjC
	 +UrW1wLAFIo+YDK/waazRwJI/4RYTviXd/Qsx5wY=
Date: Fri, 03 Jan 2025 18:45:11 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-handle-clear_schemes_tried_regions-from-damon-sysfs-context.patch added to mm-unstable branch
Message-Id: <20250104024512.00D77C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: handle clear_schemes_tried_regions from DAMON sysfs context
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-handle-clear_schemes_tried_regions-from-damon-sysfs-context.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-handle-clear_schemes_tried_regions-from-damon-sysfs-context.patch

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
Subject: mm/damon/sysfs: handle clear_schemes_tried_regions from DAMON sysfs context
Date: Fri, 3 Jan 2025 09:43:52 -0800

DAMON sysfs interface handles clear_schemes_tried_regions request from the
DAMON callback context (damon_sysfs_cmd_request_callback()), which is
designed to be used for safe access to the related DAMON context internal
data.  But no DAMON context internal data is accessed for the work. 
Directly handle it from DAMON sysfs interface context, namely
damon_sysfs_handle_cmd().

Link: https://lkml.kernel.org/r/20250103174400.54890-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    2 +-
 mm/damon/sysfs.c         |   17 +++--------------
 2 files changed, 4 insertions(+), 15 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-handle-clear_schemes_tried_regions-from-damon-sysfs-context
+++ a/mm/damon/sysfs.c
@@ -1254,17 +1254,6 @@ static int damon_sysfs_upd_schemes_regio
 	return damon_sysfs_schemes_update_regions_stop(ctx);
 }
 
-static int damon_sysfs_clear_schemes_regions(
-		struct damon_sysfs_kdamond *kdamond)
-{
-	struct damon_ctx *ctx = kdamond->damon_ctx;
-
-	if (!ctx)
-		return -EINVAL;
-	return damon_sysfs_schemes_clear_regions(
-			kdamond->contexts->contexts_arr[0]->schemes);
-}
-
 static inline bool damon_sysfs_kdamond_running(
 		struct damon_sysfs_kdamond *kdamond)
 {
@@ -1417,9 +1406,6 @@ static int damon_sysfs_cmd_request_callb
 			damon_sysfs_schemes_regions_updating = false;
 		}
 		break;
-	case DAMON_SYSFS_CMD_CLEAR_SCHEMES_TRIED_REGIONS:
-		err = damon_sysfs_clear_schemes_regions(kdamond);
-		break;
 	case DAMON_SYSFS_CMD_UPDATE_SCHEMES_EFFECTIVE_QUOTAS:
 		err = damon_sysfs_upd_schemes_effective_quotas(kdamond);
 		break;
@@ -1549,6 +1535,9 @@ static int damon_sysfs_handle_cmd(enum d
 		return damon_sysfs_turn_damon_on(kdamond);
 	case DAMON_SYSFS_CMD_OFF:
 		return damon_sysfs_turn_damon_off(kdamond);
+	case DAMON_SYSFS_CMD_CLEAR_SCHEMES_TRIED_REGIONS:
+		return damon_sysfs_schemes_clear_regions(
+			kdamond->contexts->contexts_arr[0]->schemes);
 	default:
 		break;
 	}
--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-handle-clear_schemes_tried_regions-from-damon-sysfs-context
+++ a/mm/damon/sysfs-schemes.c
@@ -2260,7 +2260,7 @@ static void damos_tried_regions_init_upd
 	}
 }
 
-/* Called from damon_sysfs_cmd_request_callback under damon_sysfs_lock */
+/* Called while damon_sysfs_lock is hold */
 int damon_sysfs_schemes_update_regions_start(
 		struct damon_sysfs_schemes *sysfs_schemes,
 		struct damon_ctx *ctx, bool total_bytes_only)
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

