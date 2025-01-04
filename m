Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3C7143C7E
	for <mm-commits@vger.kernel.org>; Sat,  4 Jan 2025 02:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735958717; cv=none; b=Sy6pjrbggGFNgHMwfnM2+rcIfqw2kiqt7jLveI0Ca1AQJrymo6PxwOrtv6nZITLxYr5hZ4spvb/uC/0bfI+cVrMX+xLlIgA7UYzc2dgZ7ExxUzGgOHW1RI5xGTzzSUnA0TvfGpSywvGykTOfu1kHEGgoWkK93F/lAruLhp0wLcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735958717; c=relaxed/simple;
	bh=pS6EQ8O0c6/gmHBuFQSJ5hII1IYD+4fESesnMvxWCH0=;
	h=Date:To:From:Subject:Message-Id; b=rmfeIjVGdkU8n9P0pG252BwM/KbqYU0AKKAzgB2+S+tE/0PZOLxxh5/fEwuf4Ls1EHeJndB9BD/1Fz676rgRyyX5LGpDqFONa2iWcKn1kUlnj5uVXV80IMJpRkOvYoTW9tgVDU3N+1seB2LrW4NIwEkAr0KdgzwNtSr9p3BZ9tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rej/KWFv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rej/KWFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E32C4CED6;
	Sat,  4 Jan 2025 02:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735958716;
	bh=pS6EQ8O0c6/gmHBuFQSJ5hII1IYD+4fESesnMvxWCH0=;
	h=Date:To:From:Subject:From;
	b=Rej/KWFvio5/XDe5DKO1FSVPCXZ3UG9yinRsat7irl+fm6BOd/8VGzE7AvtqiL6HO
	 cQ+Q8/Y7pSZsqE9DG4rmreuHMVkqjhM+VIPq8m0D2l8vX5kFdJ0l+XYl8o5tJT5+/F
	 /yQgjj0BOEIyOaW7Ba3zqAIYtg3PaJv6HxGWONts=
Date: Fri, 03 Jan 2025 18:45:15 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-use-damon_call-for-update_schemes_stats.patch added to mm-unstable branch
Message-Id: <20250104024516.79E32C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: use damon_call() for update_schemes_stats
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-use-damon_call-for-update_schemes_stats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-use-damon_call-for-update_schemes_stats.patch

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
Subject: mm/damon/sysfs: use damon_call() for update_schemes_stats
Date: Fri, 3 Jan 2025 09:43:54 -0800

DAMON sysfs interface uses damon_callback with its own synchronization
facility to handle update_schemes_stats kdamond command.  But damon_call()
can support the use case without the additional synchronizations.  Convert
the code to use damon_call() instead.

Link: https://lkml.kernel.org/r/20250103174400.54890-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-use-damon_call-for-update_schemes_stats
+++ a/mm/damon/sysfs.c
@@ -1214,19 +1214,19 @@ static void damon_sysfs_before_terminate
 
 /*
  * damon_sysfs_upd_schemes_stats() - Update schemes stats sysfs files.
- * @kdamond:	The kobject wrapper that associated to the kdamond thread.
+ * @data:	The kobject wrapper that associated to the kdamond thread.
  *
  * This function reads the schemes stats of specific kdamond and update the
  * related values for sysfs files.  This function should be called from DAMON
- * callbacks while holding ``damon_syfs_lock``, to safely access the DAMON
- * contexts-internal data and DAMON sysfs variables.
+ * worker thread,to safely access the DAMON contexts-internal data.  Caller
+ * should also ensure holding ``damon_syfs_lock``, and ->damon_ctx of @data is
+ * not NULL but a valid pointer, to safely access DAMON sysfs variables.
  */
-static int damon_sysfs_upd_schemes_stats(struct damon_sysfs_kdamond *kdamond)
+static int damon_sysfs_upd_schemes_stats(void *data)
 {
+	struct damon_sysfs_kdamond *kdamond = data;
 	struct damon_ctx *ctx = kdamond->damon_ctx;
 
-	if (!ctx)
-		return -EINVAL;
 	damon_sysfs_schemes_update_stats(
 			kdamond->contexts->contexts_arr[0]->schemes, ctx);
 	return 0;
@@ -1371,9 +1371,6 @@ static int damon_sysfs_cmd_request_callb
 	if (!kdamond || kdamond->damon_ctx != c)
 		goto out;
 	switch (damon_sysfs_cmd_request.cmd) {
-	case DAMON_SYSFS_CMD_UPDATE_SCHEMES_STATS:
-		err = damon_sysfs_upd_schemes_stats(kdamond);
-		break;
 	case DAMON_SYSFS_CMD_COMMIT:
 		if (!after_aggregation)
 			goto out;
@@ -1511,6 +1508,18 @@ static int damon_sysfs_turn_damon_off(st
 	 */
 }
 
+static int damon_sysfs_damon_call(int (*fn)(void *data),
+		struct damon_sysfs_kdamond *kdamond)
+{
+	struct damon_call_control call_control = {};
+
+	if (!kdamond->damon_ctx)
+		return -EINVAL;
+	call_control.fn = fn;
+	call_control.data = kdamond;
+	return damon_call(kdamond->damon_ctx, &call_control);
+}
+
 /*
  * damon_sysfs_handle_cmd() - Handle a command for a specific kdamond.
  * @cmd:	The command to handle.
@@ -1529,12 +1538,14 @@ static int damon_sysfs_handle_cmd(enum d
 {
 	bool need_wait = true;
 
-	/* Handle commands that doesn't access DAMON context-internal data */
 	switch (cmd) {
 	case DAMON_SYSFS_CMD_ON:
 		return damon_sysfs_turn_damon_on(kdamond);
 	case DAMON_SYSFS_CMD_OFF:
 		return damon_sysfs_turn_damon_off(kdamond);
+	case DAMON_SYSFS_CMD_UPDATE_SCHEMES_STATS:
+		return damon_sysfs_damon_call(
+				damon_sysfs_upd_schemes_stats, kdamond);
 	case DAMON_SYSFS_CMD_CLEAR_SCHEMES_TRIED_REGIONS:
 		return damon_sysfs_schemes_clear_regions(
 			kdamond->contexts->contexts_arr[0]->schemes);
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

