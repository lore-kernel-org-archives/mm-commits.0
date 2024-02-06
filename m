Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A941CD26
	for <mm-commits@vger.kernel.org>; Tue,  6 Feb 2024 20:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707250758; cv=none; b=KCo9XwCPuTsIHiEPJCddlZ00qygrdxlj6kDVMYzi15HWAqUp7WFAnkmjAXM31WDuwGThEX6KrZjyCNv8TgrLvC3G5sDAYT7uH3RNBt+aM6/fNn0roc55Wryg9MN5UvxK5S71GwdoVERV9Xg1ljKlLSGKpYgs+92grCqDnEyeHQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707250758; c=relaxed/simple;
	bh=O6XPcXbxJ40GvxVpFAt7RdBJ8ThoybimvRIUzcB4+0o=;
	h=Date:To:From:Subject:Message-Id; b=q90hR7MFPPGwUGXQCrvhLUOPGFX05UP4yzo9emrpXquLyrLCxWwetRg/HZCPFSFMtVTzmSY6oLtZLwmOEdVgPp7r/Ry4Q55ZoqRn3TINru7hDs0BYpirybKKnOJRNeaHi3DPGU8lDYAhETE5I4ylHGDKV8/fk/Nj3jJ6AHLqWqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zkiWGmpj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zkiWGmpj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E25C433F1;
	Tue,  6 Feb 2024 20:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707250757;
	bh=O6XPcXbxJ40GvxVpFAt7RdBJ8ThoybimvRIUzcB4+0o=;
	h=Date:To:From:Subject:From;
	b=zkiWGmpjef72q9Cna2XRHJlkLaIpHjecpYf6pBQK8ZwBA0/WxvwoC0EFsrfIQgSk7
	 KYlIKtBA5MBlA8cN0cedSsfc7SKitSSrnHylcl3bEU6Pr4xLy6W13L36XwPS4pbxq6
	 FUn4A/z9TC0OB48DiWp+dlwx1ngGV3MipOpcoRbc=
Date: Tue, 06 Feb 2024 12:19:17 -0800
To: mm-commits@vger.kernel.org,xiongping1@xiaomi.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-handle-state-file-inputs-for-every-sampling-interval-if-possible.patch added to mm-unstable branch
Message-Id: <20240206201917.96E25C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: handle 'state' file inputs for every sampling interval if possible
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-handle-state-file-inputs-for-every-sampling-interval-if-possible.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-handle-state-file-inputs-for-every-sampling-interval-if-possible.patch

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
Subject: mm/damon/sysfs: handle 'state' file inputs for every sampling interval if possible
Date: Mon, 5 Feb 2024 18:51:58 -0800

DAMON sysfs interface need to access kdamond-touching data for some of
kdamond user commands.  It uses ->after_aggregation() kdamond callback to
safely access the data in the case.  It had to use the aggregation
interval callback because that was the only callback that users can access
complete monitoring results.

Since patch series "mm/damon: provide pseudo-moving sum based access
rate", which starts from commit 78fbfb155d20 ("mm/damon/core: define and
use a dedicated function for region access rate update"), DAMON provides
good-to-use quality moitoring results for every sampling interval.  It
aims to help users who need to quickly retrieve the monitoring results. 
When the aggregation interval is set too long and therefore waiting for
the aggregation interval can degrade user experience, or when the access
pattern is expected to be significantly changed[1] could be such cases.

However, because DAMON sysfs interface is still handling the commands per
aggregation interval, the end user cannot get the benefit.  Update DAMON
sysfs interface to handle kdamond commands for every sampling interval if
applicable.  Specifically, all kdamond data accessing commands except
'commit' command are applicable.

[1] https://lore.kernel.org/r/20240129121316.GA9706@cuiyangpei

Link: https://lkml.kernel.org/r/20240206025158.203097-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: xiongping1 <xiongping1@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-common.h  |    2 ++
 mm/damon/sysfs-schemes.c |   22 +++++++++-------------
 mm/damon/sysfs.c         |   21 ++++++++++++++++++---
 3 files changed, 29 insertions(+), 16 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-handle-state-file-inputs-for-every-sampling-interval-if-possible
+++ a/mm/damon/sysfs.c
@@ -1379,11 +1379,13 @@ static int damon_sysfs_commit_schemes_qu
  * damon_sysfs_cmd_request_callback() - DAMON callback for handling requests.
  * @c:		The DAMON context of the callback.
  * @active:	Whether @c is not deactivated due to watermarks.
+ * @after_aggr:	Whether this is called from after_aggregation() callback.
  *
  * This function is periodically called back from the kdamond thread for @c.
  * Then, it checks if there is a waiting DAMON sysfs request and handles it.
  */
-static int damon_sysfs_cmd_request_callback(struct damon_ctx *c, bool active)
+static int damon_sysfs_cmd_request_callback(struct damon_ctx *c, bool active,
+		bool after_aggregation)
 {
 	struct damon_sysfs_kdamond *kdamond;
 	bool total_bytes_only = false;
@@ -1401,6 +1403,8 @@ static int damon_sysfs_cmd_request_callb
 		err = damon_sysfs_upd_schemes_stats(kdamond);
 		break;
 	case DAMON_SYSFS_CMD_COMMIT:
+		if (!after_aggregation)
+			goto out;
 		err = damon_sysfs_commit_input(kdamond);
 		break;
 	case DAMON_SYSFS_CMD_COMMIT_SCHEMES_QUOTA_GOALS:
@@ -1418,6 +1422,7 @@ static int damon_sysfs_cmd_request_callb
 				goto keep_lock_out;
 			}
 		} else {
+			damos_sysfs_mark_finished_regions_updates(c);
 			/*
 			 * Continue regions updating if DAMON is till
 			 * active and the update for all schemes is not
@@ -1450,7 +1455,16 @@ static int damon_sysfs_after_wmarks_chec
 	 * after_wmarks_check() is called back while the context is deactivated
 	 * by watermarks.
 	 */
-	return damon_sysfs_cmd_request_callback(c, false);
+	return damon_sysfs_cmd_request_callback(c, false, false);
+}
+
+static int damon_sysfs_after_sampling(struct damon_ctx *c)
+{
+	/*
+	 * after_sampling() is called back only while the context is not
+	 * deactivated by watermarks.
+	 */
+	return damon_sysfs_cmd_request_callback(c, true, false);
 }
 
 static int damon_sysfs_after_aggregation(struct damon_ctx *c)
@@ -1459,7 +1473,7 @@ static int damon_sysfs_after_aggregation
 	 * after_aggregation() is called back only while the context is not
 	 * deactivated by watermarks.
 	 */
-	return damon_sysfs_cmd_request_callback(c, true);
+	return damon_sysfs_cmd_request_callback(c, true, true);
 }
 
 static struct damon_ctx *damon_sysfs_build_ctx(
@@ -1478,6 +1492,7 @@ static struct damon_ctx *damon_sysfs_bui
 	}
 
 	ctx->callback.after_wmarks_check = damon_sysfs_after_wmarks_check;
+	ctx->callback.after_sampling = damon_sysfs_after_sampling;
 	ctx->callback.after_aggregation = damon_sysfs_after_aggregation;
 	ctx->callback.before_terminate = damon_sysfs_before_terminate;
 	return ctx;
--- a/mm/damon/sysfs-common.h~mm-damon-sysfs-handle-state-file-inputs-for-every-sampling-interval-if-possible
+++ a/mm/damon/sysfs-common.h
@@ -49,6 +49,8 @@ int damon_sysfs_schemes_update_regions_s
 		struct damon_sysfs_schemes *sysfs_schemes,
 		struct damon_ctx *ctx, bool total_bytes_only);
 
+void damos_sysfs_mark_finished_regions_updates(struct damon_ctx *ctx);
+
 bool damos_sysfs_regions_upd_done(void);
 
 int damon_sysfs_schemes_update_regions_stop(struct damon_ctx *ctx);
--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-handle-state-file-inputs-for-every-sampling-interval-if-possible
+++ a/mm/damon/sysfs-schemes.c
@@ -127,17 +127,17 @@ static const struct kobj_type damon_sysf
  *
  * Once the tried regions update request is received, the request handling
  * start function (damon_sysfs_scheme_update_regions_start()) sets the status
- * of all schemes as 'idle' again, and register ->before_damos_apply() and
- * ->after_sampling() callbacks.
+ * of all schemes as 'idle' again, and register ->before_damos_apply()
+ * callback.
  *
  * Then, the first followup ->before_damos_apply() callback
  * (damon_sysfs_before_damos_apply()) sets the status 'started'.  The first
- * ->after_sampling() callback (damon_sysfs_after_sampling()) after the call
- * is called only after the scheme is completely applied
- * to the given snapshot.  Hence the callback knows the situation by showing
- * 'started' status, and sets the status as 'finished'.  Then,
- * damon_sysfs_before_damos_apply() understands the situation by showing the
- * 'finished' status and do nothing.
+ * ->after_sampling() or ->after_aggregation() callback
+ *  (damon_sysfs_cmd_request_callback()) after the call is called only after
+ *  the scheme is completely applied to the given snapshot.  Hence the callback
+ *  knows the situation by showing 'started' status, and sets the status as
+ *  'finished'.  Then, damon_sysfs_before_damos_apply() understands the
+ *  situation by showing the 'finished' status and do nothing.
  *
  * If DAMOS is not applied to any region due to any reasons including the
  * access pattern, the watermarks, the quotas, and the filters,
@@ -2118,7 +2118,7 @@ static int damon_sysfs_before_damos_appl
  * callback is registered, damon_sysfs_lock should be held to ensure the
  * regions directories exist.
  */
-static int damon_sysfs_after_sampling(struct damon_ctx *ctx)
+void damos_sysfs_mark_finished_regions_updates(struct damon_ctx *ctx)
 {
 	struct damon_sysfs_schemes *sysfs_schemes =
 		damon_sysfs_schemes_for_damos_callback;
@@ -2134,8 +2134,6 @@ static int damon_sysfs_after_sampling(st
 			sysfs_regions->upd_status =
 				DAMOS_TRIED_REGIONS_UPD_FINISHED;
 	}
-
-	return 0;
 }
 
 /* Called from damon_sysfs_cmd_request_callback under damon_sysfs_lock */
@@ -2208,7 +2206,6 @@ int damon_sysfs_schemes_update_regions_s
 	damos_tried_regions_init_upd_status(sysfs_schemes, ctx);
 	damos_regions_upd_total_bytes_only = total_bytes_only;
 	ctx->callback.before_damos_apply = damon_sysfs_before_damos_apply;
-	ctx->callback.after_sampling = damon_sysfs_after_sampling;
 	return 0;
 }
 
@@ -2237,7 +2234,6 @@ int damon_sysfs_schemes_update_regions_s
 {
 	damon_sysfs_schemes_for_damos_callback = NULL;
 	ctx->callback.before_damos_apply = NULL;
-	ctx->callback.after_sampling = NULL;
 	damon_sysfs_schemes_region_idx = 0;
 	return 0;
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-fix-wrong-damos-tried-regions-update-timeout-setup.patch
mm-damon-core-check-apply-interval-in-damon_do_apply_schemes.patch
docs-admin-guide-mm-damon-usage-use-sysfs-interface-for-tracepoints-example.patch
mm-damon-rename-config_damon_dbgfs-to-damon_dbgfs_deprecated.patch
mm-damon-dbgfs-implement-deprecation-notice-file.patch
mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro.patch
docs-admin-guide-mm-damon-usage-document-deprecated-file-of-damon-debugfs-interface.patch
selftets-damon-prepare-for-monitor_on-file-renaming.patch
mm-damon-dbgfs-rename-monitor_on-file-to-monitor_on_deprecated.patch
docs-admin-guide-mm-damon-usage-update-for-monitor_on-renaming.patch
docs-translations-damon-usage-update-for-monitor_on-renaming.patch
mm-damon-sysfs-handle-state-file-inputs-for-every-sampling-interval-if-possible.patch

