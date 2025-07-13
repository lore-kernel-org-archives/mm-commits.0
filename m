Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9130221CC51
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450116; cv=none; b=ThJ2E4HjCB9/Apnsvt0rB4o+s2MEx871R/Sn3lu6YhLsMEEFgUzjLcPlDfAgElpJMztuX/kn23Q6VcLs6HhQXMufFEju/P7cioh5+N+T4L/KWZZjuMPQkLKPyu4sGcZIkZkXkVlaf17W8lEjWVrCoM+wcfigvhk627YCsVPvtDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450116; c=relaxed/simple;
	bh=B2pd9A/CQuufkiZbxaMYwJkq9Ng71dMIofcVMEDaiGc=;
	h=Date:To:From:Subject:Message-Id; b=Iblvwhdivh+tYBW5Riw8aLrl3gM+sbVzmCM+P/PA2arQBs9v9DEAxy6kcuUegsOQ8WgcyyUL1mCMqNligo5r30bq7BZ/3BWqn5l8Mu8etV5nnqRSx5TVeVZgxl90BTu49vRKqr2Nsf/s3gv6mRI+1ZhXsrxYU5bxw/am3GXYVME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UV8zUYj6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UV8zUYj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C94C4CEE3;
	Sun, 13 Jul 2025 23:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450116;
	bh=B2pd9A/CQuufkiZbxaMYwJkq9Ng71dMIofcVMEDaiGc=;
	h=Date:To:From:Subject:From;
	b=UV8zUYj605QhO+ScOAltW3p7VrQbPtOtT/3zH3EpV787cZGEJRvOst0NaWe6/USh8
	 JvuJzUcMFtMs+hg2NhOnZgrIM4FPC/BLOtLsaLLLQT81R4xBeLP5UUtOi1g/weXYUi
	 EgpeFl527nA+t/L1SOq8OQIqQQYLD9Qww8ukSI6Y=
Date: Sun, 13 Jul 2025 16:41:55 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] samples-damon-prcl-fix-boot-time-enable-crash.patch removed from -mm tree
Message-Id: <20250713234156.68C94C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon/prcl: fix boot time enable crash
has been removed from the -mm tree.  Its filename was
     samples-damon-prcl-fix-boot-time-enable-crash.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: samples/damon/prcl: fix boot time enable crash
Date: Sun, 6 Jul 2025 12:32:03 -0700

If 'enable' parameter of the 'prcl' DAMON sample module is set at boot
time via the kernel command line, memory allocation is tried before the
slab is initialized.  As a result kernel NULL pointer dereference BUG can
happen.  Fix it by checking the initialization status.

Link: https://lkml.kernel.org/r/20250706193207.39810-3-sj@kernel.org
Fixes: 2aca254620a8 ("samples/damon: introduce a skeleton of a smaple DAMON module for proactive reclamation")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/prcl.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/samples/damon/prcl.c~samples-damon-prcl-fix-boot-time-enable-crash
+++ a/samples/damon/prcl.c
@@ -109,6 +109,8 @@ static void damon_sample_prcl_stop(void)
 		put_pid(target_pidp);
 }
 
+static bool init_called;
+
 static int damon_sample_prcl_enable_store(
 		const char *val, const struct kernel_param *kp)
 {
@@ -134,6 +136,14 @@ static int damon_sample_prcl_enable_stor
 
 static int __init damon_sample_prcl_init(void)
 {
+	int err = 0;
+
+	init_called = true;
+	if (enable) {
+		err = damon_sample_prcl_start();
+		if (err)
+			enable = false;
+	}
 	return 0;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

samples-damon-wsse-rename-to-have-damon_sample_-prefix.patch
samples-damon-prcl-rename-to-have-damon_sample_-prefix.patch
samples-damon-mtier-rename-to-have-damon_sample_-prefix.patch
mm-damon-sysfs-use-damon-core-api-damon_is_running.patch
mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate.patch
docs-mm-damon-maintainer-profile-update-for-mm-new-tree.patch
mm-damon-add-struct-damos_migrate_dests.patch
mm-damon-core-add-damos-migrate_dests-field.patch
mm-damon-sysfs-schemes-implement-damos-action-destinations-directory.patch
mm-damon-sysfs-schemes-set-damos-migrate_dests.patch
docs-abi-damon-document-schemes-dests-directory.patch
docs-admin-guide-mm-damon-usage-document-dests-directory.patch
mm-damon-accept-parallel-damon_call-requests.patch
mm-damon-core-introduce-repeat-mode-damon_call.patch
mm-damon-stat-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-reclaim-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-lru_sort-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-prcl-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-wsse-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-core-do-not-call-opscleanup-when-destroying-targets.patch
mm-damon-core-add-cleanup_target-ops-callback.patch
mm-damon-vaddr-put-pid-in-cleanup_target.patch
mm-damon-sysfs-remove-damon_sysfs_destroy_targets.patch
mm-damon-core-destroy-targets-when-kdamond_fn-finish.patch
mm-damon-sysfs-remove-damon_sysfs_before_terminate.patch
mm-damon-core-remove-damon_callback.patch

