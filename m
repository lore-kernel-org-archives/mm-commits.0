Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821C2143723
	for <mm-commits@vger.kernel.org>; Sat,  4 Jan 2025 02:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735958720; cv=none; b=R+sKe+EgAHmeoqMXhEljX49oSsI8oPsIjEqr/3xd3wOWXb19CB8tTQ+JDi8PSn2tBTvkZIgRSMRTtyRGy2QTY6E1rZ6TzNAVQ6JL3TFiRn5oI+TezIc046CWMQBDUHJRYfj8swoz75kDGqFcgpl3z/LluNi0987aMuO3KkHbxjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735958720; c=relaxed/simple;
	bh=iBEC0jIYSTmJvThXBdmYdZTabq8SaTJUdLPeijV9ytQ=;
	h=Date:To:From:Subject:Message-Id; b=Zym08SLiOC2rhh+19IzkNO53NJjh3+HUX4sVwnfgrp0fcnZcpDau6ADm4dTXD7SiuYui3KIU2ZJOT0PFNV8KW9gjFqBkl/nIAxhTcd0uaVCuJEY+SG17LLSRM1rrW+yl86d5HRmTHgurXpE5JP9c5kOFaBzvmwVPZPC7Hnntsvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EB+QGIU5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EB+QGIU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E431C4CEDD;
	Sat,  4 Jan 2025 02:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735958720;
	bh=iBEC0jIYSTmJvThXBdmYdZTabq8SaTJUdLPeijV9ytQ=;
	h=Date:To:From:Subject:From;
	b=EB+QGIU5bq7YFggy9KZwvMgEVVU21eqQigfaHAUdQXmLAotjoS7bpJnABFiB7Qt0l
	 fS5mt0qKcFe9kMXQv6O4nUagSVbJa54vFBmrYfPhapHtIXNneRoGZSGZxPNi86gVK+
	 h2Nhi+FaHRW0uDXGJfbkTDUyTiyQ9/nNort9qgLs=
Date: Fri, 03 Jan 2025 18:45:19 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-use-damon_call-for-update_schemes_effective_quotas.patch added to mm-unstable branch
Message-Id: <20250104024520.4E431C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: use damon_call() for update_schemes_effective_quotas
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-use-damon_call-for-update_schemes_effective_quotas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-use-damon_call-for-update_schemes_effective_quotas.patch

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
Subject: mm/damon/sysfs: use damon_call() for update_schemes_effective_quotas
Date: Fri, 3 Jan 2025 09:43:56 -0800

DAMON sysfs interface uses damon_callback with its own synchronization
facility to handle update_schemes_effective_quotas command.  But
damon_call() can support the use case without the additional
synchronizations.  Convert the code to use damon_call() instead.

Link: https://lkml.kernel.org/r/20250103174400.54890-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-use-damon_call-for-update_schemes_effective_quotas
+++ a/mm/damon/sysfs.c
@@ -1327,20 +1327,18 @@ static int damon_sysfs_commit_schemes_qu
 /*
  * damon_sysfs_upd_schemes_effective_quotas() - Update schemes effective quotas
  * sysfs files.
- * @kdamond:	The kobject wrapper that associated to the kdamond thread.
+ * @data:	The kobject wrapper that associated to the kdamond thread.
  *
  * This function reads the schemes' effective quotas of specific kdamond and
  * update the related values for sysfs files.  This function should be called
  * from DAMON callbacks while holding ``damon_syfs_lock``, to safely access the
  * DAMON contexts-internal data and DAMON sysfs variables.
  */
-static int damon_sysfs_upd_schemes_effective_quotas(
-		struct damon_sysfs_kdamond *kdamond)
+static int damon_sysfs_upd_schemes_effective_quotas(void *data)
 {
+	struct damon_sysfs_kdamond *kdamond = data;
 	struct damon_ctx *ctx = kdamond->damon_ctx;
 
-	if (!ctx)
-		return -EINVAL;
 	damos_sysfs_update_effective_quotas(
 			kdamond->contexts->contexts_arr[0]->schemes, ctx);
 	return 0;
@@ -1400,9 +1398,6 @@ static int damon_sysfs_cmd_request_callb
 			damon_sysfs_schemes_regions_updating = false;
 		}
 		break;
-	case DAMON_SYSFS_CMD_UPDATE_SCHEMES_EFFECTIVE_QUOTAS:
-		err = damon_sysfs_upd_schemes_effective_quotas(kdamond);
-		break;
 	default:
 		break;
 	}
@@ -1550,6 +1545,10 @@ static int damon_sysfs_handle_cmd(enum d
 	case DAMON_SYSFS_CMD_CLEAR_SCHEMES_TRIED_REGIONS:
 		return damon_sysfs_schemes_clear_regions(
 			kdamond->contexts->contexts_arr[0]->schemes);
+	case DAMON_SYSFS_CMD_UPDATE_SCHEMES_EFFECTIVE_QUOTAS:
+		return damon_sysfs_damon_call(
+				damon_sysfs_upd_schemes_effective_quotas,
+				kdamond);
 	default:
 		break;
 	}
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

