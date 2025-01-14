Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E27243356
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837147; cv=none; b=ohPhv/k19corJI82BokIQZ8xtrKc+IFDpFDFiBZfGlEaLVarrw6issUbBCf+ZbX4dgJkzB9n/c2hJ2dgqK8Z9HMGK4M81jTpSQ6KG2Dat57V+D9Jdr4zN2C0G8r0+JcZ0GRmtsBNdhAC3W7GeY4GoIxdJo0+rBw9Cj2e5ojwL1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837147; c=relaxed/simple;
	bh=CQr3Qbjn6EMZjCrPxSS5n10YUir2fbIv6J3qODaxQOU=;
	h=Date:To:From:Subject:Message-Id; b=D6bwHwbzDnoeTUCLst/Kd5e4+DHj9VaZbXncGnmYs5B0oi8O+WtrB+A4s2Ta5/Huk+5RoFmrprjMY7eBzKUmxnhSJ46QMfP9pe45GJWL0PN7j0vPT9A9M3lPtpVT17CahlF6CFCjpmTMSGMvA7DBqSxJCzF25LT1ULUFaawiUPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=STtEAF8d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="STtEAF8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0D5C4CEDD;
	Tue, 14 Jan 2025 06:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837147;
	bh=CQr3Qbjn6EMZjCrPxSS5n10YUir2fbIv6J3qODaxQOU=;
	h=Date:To:From:Subject:From;
	b=STtEAF8dLPFFLelBTUu90IcmUkbGNZivmxnkzVzTaPWrBwZ8lZhR8Tq+Fun2I7dhl
	 8eV6yXfKWN6qZa3NsPaLEKS8qMRYy6LNaetD3pnng4+O93+IZzvP4ELiAT4yN4yPd6
	 G5+BoBeMG6glzZapVoJYeOj2aooNdiz5bPz7imFU=
Date: Mon, 13 Jan 2025 22:45:46 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-handle-clear_schemes_tried_regions-from-damon-sysfs-context.patch removed from -mm tree
Message-Id: <20250114064547.4D0D5C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: handle clear_schemes_tried_regions from DAMON sysfs context
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-handle-clear_schemes_tried_regions-from-damon-sysfs-context.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

