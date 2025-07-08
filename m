Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583A8225A32
	for <mm-commits@vger.kernel.org>; Tue,  8 Jul 2025 02:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751940121; cv=none; b=jbBwExWsVIUklY3IwwCVm+DtmGtxs53yMERUYqIDNfiJJRbVoEzbEV70pjMb9V6hYFHFBeWIhzh/FatO9XbGXHVwXV+DPZvyU+YdI9G824UU+icoPxwy2F3w1gn0DxAuYjsDr8dHqBL9d9Q4T1dPW2YG/Qmz9ovebYXfycaUOxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751940121; c=relaxed/simple;
	bh=FOTpxZ9fBW7SImg29m0CnNXDNTYVGeAn39tOyBdx1zo=;
	h=Date:To:From:Subject:Message-Id; b=iyzgnPf4+uDL8g67nPd6yeL/r5rdO76j5eCEQv1IBmGPqqT9Qvj55Jurzh1+LbXc1+1FDW9xcjsuVPW9O2rf7iYgjut4o3aqoFhvtK4WG5m2WhkFcEPv3T9bOzmc2neOouSsEKJWWOdbcfKWYC3XbxzTZVuwusB4vNI7qCX2MJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TXGag029; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TXGag029"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D165BC4CEE3;
	Tue,  8 Jul 2025 02:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751940120;
	bh=FOTpxZ9fBW7SImg29m0CnNXDNTYVGeAn39tOyBdx1zo=;
	h=Date:To:From:Subject:From;
	b=TXGag029KfgIFzis5pyIxD38tItgOxfYBwzawa4IxoSaNfI4DzY0xVV6i9Ba76Qjx
	 kcs+tVYjpXoWFuxncrdE0rUH11aSl9uXnX9vb6iSZiarpEckCqIlM0ji/ITEuToY0Y
	 09gQ5ZNBUjsZDVQWnh0t9uXkqxZXQlIrb+5FddCc=
Date: Mon, 07 Jul 2025 19:02:00 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,honggyu.kim@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-change-enable-parameters-to-enabled.patch added to mm-new branch
Message-Id: <20250708020200.D165BC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon: change enable parameters to enabled
has been added to the -mm mm-new branch.  Its filename is
     samples-damon-change-enable-parameters-to-enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-change-enable-parameters-to-enabled.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Honggyu Kim <honggyu.kim@sk.com>
Subject: samples/damon: change enable parameters to enabled
Date: Mon, 7 Jul 2025 11:45:47 +0900

The damon_{lru_sort,reclaim,stat} kernel modules use "enabled" parameter
knobs as follows.

  /sys/module/damon_lru_sort/parameters/enabled
  /sys/module/damon_reclaim/parameters/enabled
  /sys/module/damon_stat/parameters/enabled

However, other sample modules of damon use "enable" parameter knobs so
it'd be better to rename them from "enable" to "enabled" to keep the
consistency with other damon modules.

Before:
  /sys/module/damon_sample_wsse/parameters/enable
  /sys/module/damon_sample_prcl/parameters/enable
  /sys/module/damon_sample_mtier/parameters/enable

After:
  /sys/module/damon_sample_wsse/parameters/enabled
  /sys/module/damon_sample_prcl/parameters/enabled
  /sys/module/damon_sample_mtier/parameters/enabled

There is no functional changes in this patch.

Link: https://lkml.kernel.org/r/20250707024548.1964-1-honggyu.kim@sk.com
Signed-off-by: Honggyu Kim <honggyu.kim@sk.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/mtier.c |   22 +++++++++++-----------
 samples/damon/prcl.c  |   22 +++++++++++-----------
 samples/damon/wsse.c  |   22 +++++++++++-----------
 3 files changed, 33 insertions(+), 33 deletions(-)

--- a/samples/damon/mtier.c~samples-damon-change-enable-parameters-to-enabled
+++ a/samples/damon/mtier.c
@@ -38,14 +38,14 @@ module_param(node0_mem_free_bp, ulong, 0
 static int damon_sample_mtier_enable_store(
 		const char *val, const struct kernel_param *kp);
 
-static const struct kernel_param_ops enable_param_ops = {
+static const struct kernel_param_ops enabled_param_ops = {
 	.set = damon_sample_mtier_enable_store,
 	.get = param_get_bool,
 };
 
-static bool enable __read_mostly;
-module_param_cb(enable, &enable_param_ops, &enable, 0600);
-MODULE_PARM_DESC(enable, "Enable of disable DAMON_SAMPLE_MTIER");
+static bool enabled __read_mostly;
+module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
+MODULE_PARM_DESC(enabled, "Enable or disable DAMON_SAMPLE_MTIER");
 
 static struct damon_ctx *ctxs[2];
 
@@ -167,23 +167,23 @@ static bool init_called;
 static int damon_sample_mtier_enable_store(
 		const char *val, const struct kernel_param *kp)
 {
-	bool enabled = enable;
+	bool is_enabled = enabled;
 	int err;
 
-	err = kstrtobool(val, &enable);
+	err = kstrtobool(val, &enabled);
 	if (err)
 		return err;
 
-	if (enable == enabled)
+	if (enabled == is_enabled)
 		return 0;
 
 	if (!init_called)
 		return 0;
 
-	if (enable) {
+	if (enabled) {
 		err = damon_sample_mtier_start();
 		if (err)
-			enable = false;
+			enabled = false;
 		return err;
 	}
 	damon_sample_mtier_stop();
@@ -195,10 +195,10 @@ static int __init damon_sample_mtier_ini
 	int err = 0;
 
 	init_called = true;
-	if (enable) {
+	if (enabled) {
 		err = damon_sample_mtier_start();
 		if (err)
-			enable = false;
+			enabled = false;
 	}
 	return 0;
 }
--- a/samples/damon/prcl.c~samples-damon-change-enable-parameters-to-enabled
+++ a/samples/damon/prcl.c
@@ -22,14 +22,14 @@ module_param(target_pid, int, 0600);
 static int damon_sample_prcl_enable_store(
 		const char *val, const struct kernel_param *kp);
 
-static const struct kernel_param_ops enable_param_ops = {
+static const struct kernel_param_ops enabled_param_ops = {
 	.set = damon_sample_prcl_enable_store,
 	.get = param_get_bool,
 };
 
-static bool enable __read_mostly;
-module_param_cb(enable, &enable_param_ops, &enable, 0600);
-MODULE_PARM_DESC(enable, "Enable of disable DAMON_SAMPLE_WSSE");
+static bool enabled __read_mostly;
+module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
+MODULE_PARM_DESC(enabled, "Enable or disable DAMON_SAMPLE_PRCL");
 
 static struct damon_ctx *ctx;
 static struct pid *target_pidp;
@@ -119,23 +119,23 @@ static bool init_called;
 static int damon_sample_prcl_enable_store(
 		const char *val, const struct kernel_param *kp)
 {
-	bool enabled = enable;
+	bool is_enabled = enabled;
 	int err;
 
-	err = kstrtobool(val, &enable);
+	err = kstrtobool(val, &enabled);
 	if (err)
 		return err;
 
-	if (enable == enabled)
+	if (enabled == is_enabled)
 		return 0;
 
 	if (!init_called)
 		return 0;
 
-	if (enable) {
+	if (enabled) {
 		err = damon_sample_prcl_start();
 		if (err)
-			enable = false;
+			enabled = false;
 		return err;
 	}
 	damon_sample_prcl_stop();
@@ -147,10 +147,10 @@ static int __init damon_sample_prcl_init
 	int err = 0;
 
 	init_called = true;
-	if (enable) {
+	if (enabled) {
 		err = damon_sample_prcl_start();
 		if (err)
-			enable = false;
+			enabled = false;
 	}
 	return 0;
 }
--- a/samples/damon/wsse.c~samples-damon-change-enable-parameters-to-enabled
+++ a/samples/damon/wsse.c
@@ -23,14 +23,14 @@ module_param(target_pid, int, 0600);
 static int damon_sample_wsse_enable_store(
 		const char *val, const struct kernel_param *kp);
 
-static const struct kernel_param_ops enable_param_ops = {
+static const struct kernel_param_ops enabled_param_ops = {
 	.set = damon_sample_wsse_enable_store,
 	.get = param_get_bool,
 };
 
-static bool enable __read_mostly;
-module_param_cb(enable, &enable_param_ops, &enable, 0600);
-MODULE_PARM_DESC(enable, "Enable or disable DAMON_SAMPLE_WSSE");
+static bool enabled __read_mostly;
+module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
+MODULE_PARM_DESC(enabled, "Enable or disable DAMON_SAMPLE_WSSE");
 
 static struct damon_ctx *ctx;
 static struct pid *target_pidp;
@@ -99,23 +99,23 @@ static bool init_called;
 static int damon_sample_wsse_enable_store(
 		const char *val, const struct kernel_param *kp)
 {
-	bool enabled = enable;
+	bool is_enabled = enabled;
 	int err;
 
-	err = kstrtobool(val, &enable);
+	err = kstrtobool(val, &enabled);
 	if (err)
 		return err;
 
-	if (enable == enabled)
+	if (enabled == is_enabled)
 		return 0;
 
-	if (enable) {
+	if (enabled) {
 		if (!init_called)
 			return 0;
 
 		err = damon_sample_wsse_start();
 		if (err)
-			enable = false;
+			enabled = false;
 		return err;
 	}
 	damon_sample_wsse_stop();
@@ -127,10 +127,10 @@ static int __init damon_sample_wsse_init
 	int err = 0;
 
 	init_called = true;
-	if (enable) {
+	if (enabled) {
 		err = damon_sample_wsse_start();
 		if (err)
-			enable = false;
+			enabled = false;
 	}
 	return err;
 }
_

Patches currently in -mm which might be from honggyu.kim@sk.com are

samples-damon-fix-damon-sample-prcl-for-start-failure.patch
samples-damon-fix-damon-sample-wsse-for-start-failure.patch
samples-damon-fix-damon-sample-mtier-for-start-failure.patch
mm-damon-fix-divide-by-zero-in-damon_get_intervals_score.patch
samples-damon-change-enable-parameters-to-enabled.patch

