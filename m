Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA24E7DA6A
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976889; cv=none; b=RpoAUlhBgVBA7RKSwFFpuVJMXX6JW4LQvVvwqTixuSxLrcPWcG1RP93fMbW6IX3bhtblYbZAnVWitUco7TLSms1IWpYoO9lEbh6hwgenslnavo3VFQxiw6R62Qa2vvsxOoSZll2z7zr7b32SE1A17dKQ1enHuGUEHMiAfbrkf6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976889; c=relaxed/simple;
	bh=A5Dprro/HSok5P+v4DDNh3NuOXC9DMluxaKyLH8PMzg=;
	h=Date:To:From:Subject:Message-Id; b=sxPnNUonevyrfbVr4b8dK75mD53emkf2jzgUwEGoSd7DejLUd0Mx5KncWNtArrbwNZelbiwd8VHWxzPxvBEmvji5xAYcIYFtFgJ5MkWtv/rWTUfLDxKiWSwRfgyaggomJtkZVo1PDwLy2G6fSwdJC1t3Ghhogav+3NBhO78+i6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TIqjD2Ba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TIqjD2Ba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEEF3C4CEE3;
	Sun, 20 Jul 2025 02:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976889;
	bh=A5Dprro/HSok5P+v4DDNh3NuOXC9DMluxaKyLH8PMzg=;
	h=Date:To:From:Subject:From;
	b=TIqjD2BasRCnAmYqmSJgnIw9DbAem/0Np3qQk+NYJssX3vGYlsx9Ef0fffJu/PxKq
	 /pDBuchc7e9FP1oJ6ibo3zbqcQdgS2cElAI5YnAB3Z7A8NeYFqgznDCfZbkj/4qs7v
	 gLSTac8YKZXBxC00i+kXI/1sCi37BuPDrI37LMzY=
Date: Sat, 19 Jul 2025 19:01:29 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,honggyu.kim@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] samples-damon-change-enable-parameters-to-enabled.patch removed from -mm tree
Message-Id: <20250720020129.AEEF3C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon: change enable parameters to enabled
has been removed from the -mm tree.  Its filename was
     samples-damon-change-enable-parameters-to-enabled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
 
@@ -167,20 +167,20 @@ static bool init_called;
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
 
-	if (enable) {
+	if (enabled) {
 		err = damon_sample_mtier_start();
 		if (err)
-			enable = false;
+			enabled = false;
 		return err;
 	}
 	damon_sample_mtier_stop();
@@ -192,10 +192,10 @@ static int __init damon_sample_mtier_ini
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
@@ -119,20 +119,20 @@ static bool init_called;
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
 
-	if (enable) {
+	if (enabled) {
 		err = damon_sample_prcl_start();
 		if (err)
-			enable = false;
+			enabled = false;
 		return err;
 	}
 	damon_sample_prcl_stop();
@@ -144,10 +144,10 @@ static int __init damon_sample_prcl_init
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
@@ -99,20 +99,20 @@ static bool init_called;
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
 		err = damon_sample_wsse_start();
 		if (err)
-			enable = false;
+			enabled = false;
 		return err;
 	}
 	damon_sample_wsse_stop();
@@ -124,10 +124,10 @@ static int __init damon_sample_wsse_init
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


