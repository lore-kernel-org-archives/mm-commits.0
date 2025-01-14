Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880E023D3C8
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837149; cv=none; b=dnN8iFShNQgdExMVHSPfgFN4jMPayJhfe8nc0k0rofMjTiD/1E/ZRxfQPCxn56boh3duR1pfD8oD4FZG5kP5CbdglCb9z/6Km+ZdLUp8pKVlXJ8EPYiEFPoRosSNCXw6fBvpqKuqARIhyKm57aCcLYEdHBAdT16RyDy5GCJEdWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837149; c=relaxed/simple;
	bh=3P3jHZYZfFHQd+oOUDi7LUsE5znUSbmjrdkF5i2nsTc=;
	h=Date:To:From:Subject:Message-Id; b=ohs21i//KB9V6KThBWqL6Dh0ZikTinsC+qiMYX44MLhPaDtA0Mr1hshWauXE9uTwXByt86UIzwPGXF0fnLD8F0usUqvmPH9BOl+TOaC9VHWGkudDcuH4Ef5JZyP0TsXFBdit7q44AnccbSBlAtcPAZPuBssQZUH/1b5YxtVIo2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n+VGl5Ml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n+VGl5Ml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA40C4CEDD;
	Tue, 14 Jan 2025 06:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837149;
	bh=3P3jHZYZfFHQd+oOUDi7LUsE5znUSbmjrdkF5i2nsTc=;
	h=Date:To:From:Subject:From;
	b=n+VGl5MlcXWoba2Z95X2UZ00lEkoi6F3/fW1GlooPJRp4Y8FYae+uJIRKK1Zbqfpa
	 bZchKRecRJ9YojWhJRrniYLSZcHlFkaqPA/t0uI+wAPSw+rAgJXkijn85+wxg0pHRw
	 mf1wN6GMuG/ivzX2AUVTGDs3pYy13Sv104SKtQDI=
Date: Mon, 13 Jan 2025 22:45:48 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-use-damon_call-for-update_schemes_stats.patch removed from -mm tree
Message-Id: <20250114064549.5DA40C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: use damon_call() for update_schemes_stats
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-use-damon_call-for-update_schemes_stats.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

