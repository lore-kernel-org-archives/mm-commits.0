Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60C9221DB6;
	Sun, 13 Jul 2025 23:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450118; cv=none; b=g1ggzRPQxDng0cLZeOr3+y5jLpCEw0UdX+IZps6L7wzO42ntfLPUwDZ1zK3N+Bxf/LGD3NNWQKUTxSVod8uIN7DXPZuNzIAPZudAkcH7yndd5CR1OyRU22YW9AHTgc87tZnKgY/WAnwo89EGrVU+Kn73PkTECGRX4Z/1g9PMDh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450118; c=relaxed/simple;
	bh=KEebHWc4k0T1KPC0EnxVALZCl+BzzJ24PpU1xLI4lyw=;
	h=Date:To:From:Subject:Message-Id; b=DICLqfp9/5/9WAV//Nw+J0PMOqDbAE+AKOGcYZvyhxDwLb2fJJLw9EzPgsqPwp1LvpAnuVRuVmUyQAa0q5/vEMe5bDAWLjEenErs+l6Gwzag5bv7FyMacZg2Mw9unptW8X93rB403GrkGVuK2oyI/t6cxyUB9+ChM45R4KCmCMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=juYCDnbj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="juYCDnbj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C97DC4CEE3;
	Sun, 13 Jul 2025 23:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450118;
	bh=KEebHWc4k0T1KPC0EnxVALZCl+BzzJ24PpU1xLI4lyw=;
	h=Date:To:From:Subject:From;
	b=juYCDnbjKnz8PXNBfIGqiu8A1Q2wguwmXeWWXQvq9B3AHqSsdGr7ljABz+oM4Gwqa
	 gBGSmvIibpQKBy6vDafzk8IcBhR82a0rTljPWuNBgkP1cjZh3l+b46AZIj6qNd+xrd
	 dGi1Su4M7EHI/NHBkSpSix3oqSwdp6GB+895SxmI=
Date: Sun, 13 Jul 2025 16:41:56 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] samples-damon-mtier-support-boot-time-enable-setup.patch removed from -mm tree
Message-Id: <20250713234158.7C97DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon/mtier: support boot time enable setup
has been removed from the -mm tree.  Its filename was
     samples-damon-mtier-support-boot-time-enable-setup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: samples/damon/mtier: support boot time enable setup
Date: Sun, 6 Jul 2025 12:32:04 -0700

If 'enable' parameter of the 'mtier' DAMON sample module is set at boot
time via the kernel command line, memory allocation is tried before the
slab is initialized.  As a result kernel NULL pointer dereference BUG can
happen.  Fix it by checking the initialization status.

Link: https://lkml.kernel.org/r/20250706193207.39810-4-sj@kernel.org
Fixes: 82a08bde3cf7 ("samples/damon: implement a DAMON module for memory tiering")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/mtier.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/samples/damon/mtier.c~samples-damon-mtier-support-boot-time-enable-setup
+++ a/samples/damon/mtier.c
@@ -157,6 +157,8 @@ static void damon_sample_mtier_stop(void
 	damon_destroy_ctx(ctxs[1]);
 }
 
+static bool init_called;
+
 static int damon_sample_mtier_enable_store(
 		const char *val, const struct kernel_param *kp)
 {
@@ -182,6 +184,14 @@ static int damon_sample_mtier_enable_sto
 
 static int __init damon_sample_mtier_init(void)
 {
+	int err = 0;
+
+	init_called = true;
+	if (enable) {
+		err = damon_sample_mtier_start();
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

