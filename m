Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6442C11E6
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489997; cv=none; b=iRHsEoem844s1hKoL60vcyugtiIW8PRxh7UhvWFTg5aQnj/xeLSlMs2UalThSx2wu3LOfgJdlcYoRaI1y8B+6qxtco4yN2xhrOf81k1MoAOgZnhitBinrnalBBtjJ0oamuUbAXIyIl5KRJvkD6Yf4iRrviMIPUXfGrPf/x2IWkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489997; c=relaxed/simple;
	bh=yE2lh33ccnkaBV/V3utuGhmOSzmaetnnXGPxrJDo1t0=;
	h=Date:To:From:Subject:Message-Id; b=fCiZCGn5CHM6WqIDp22NNbxjIUmsRTwrNm7bbaYnUwF+vXjMccUeEh4m3k52F9gufmV59uWokhD8cr2zYCKY7kdOR9HpsJHCZrkiNz6N73z1wSGmJgdgFEyKj3zlIT/mafut+Ma2SDKh7gsGlohsUUW7hEuJo1ZfiUtjpKm8oNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hnxOfhQi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hnxOfhQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C51C4CEE7;
	Sun, 21 Sep 2025 21:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489997;
	bh=yE2lh33ccnkaBV/V3utuGhmOSzmaetnnXGPxrJDo1t0=;
	h=Date:To:From:Subject:From;
	b=hnxOfhQih5Y/p5CSk+8HqBMYLxh2rXTA5XcsSXmtYKAyDDxhdUkdWAn7C5E7pKsKR
	 WVh1d+F9XbdKx5HYAAdCIlyWrkZwMeJUrrq4ogN/ZKEA/X1syZQ3Ugp42RLPFgNhjg
	 /eaqfyU+6CsCt41w/g8e/Gi4R5jLLbpSSc5arlUE=
Date: Sun, 21 Sep 2025 14:26:37 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,wangkefeng.wang@huawei.com,sj@kernel.org,yanquanmin1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-support-addr_unit-for-damon_reclaim.patch removed from -mm tree
Message-Id: <20250921212637.B0C51C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/reclaim: support addr_unit for DAMON_RECLAIM
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-support-addr_unit-for-damon_reclaim.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Quanmin Yan <yanquanmin1@huawei.com>
Subject: mm/damon/reclaim: support addr_unit for DAMON_RECLAIM
Date: Wed, 10 Sep 2025 19:32:21 +0800

Implement a sysfs file to expose addr_unit for DAMON_RECLAIM users. 
During parameter application, use the configured addr_unit parameter to
perform the necessary initialization.  Similar to the core layer, prevent
setting addr_unit to zero.

It is worth noting that when monitor_region_start and monitor_region_end
are unset (i.e., 0), their values will later be set to biggest_system_ram.
At that point, addr_unit may not be the default value 1.  Although we
could divide the biggest_system_ram value by addr_unit, changing addr_unit
without setting monitor_region_start/end should be considered a user
misoperation.  And biggest_system_ram is only within the 0~ULONG_MAX
range, system can clearly work correctly with addr_unit=1.  Therefore, if
monitor_region_start/end are unset, always silently reset addr_unit to 1.

Link: https://lkml.kernel.org/r/20250910113221.1065764-3-yanquanmin1@huawei.com
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: ze zuo <zuoze1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-support-addr_unit-for-damon_reclaim
+++ a/mm/damon/reclaim.c
@@ -129,6 +129,13 @@ static unsigned long monitor_region_end
 module_param(monitor_region_end, ulong, 0600);
 
 /*
+ * Scale factor for DAMON_RECLAIM to ops address conversion.
+ *
+ * This parameter must not be set to 0.
+ */
+static unsigned long addr_unit __read_mostly = 1;
+
+/*
  * Skip anonymous pages reclamation.
  *
  * If this parameter is set as ``Y``, DAMON_RECLAIM does not reclaim anonymous
@@ -194,6 +201,15 @@ static int damon_reclaim_apply_parameter
 	if (err)
 		return err;
 
+	/*
+	 * If monitor_region_start/end are unset, always silently
+	 * reset addr_unit to 1.
+	 */
+	if (!monitor_region_start && !monitor_region_end)
+		addr_unit = 1;
+	param_ctx->addr_unit = addr_unit;
+	param_ctx->min_sz_region = max(DAMON_MIN_REGION / addr_unit, 1);
+
 	if (!damon_reclaim_mon_attrs.aggr_interval) {
 		err = -EINVAL;
 		goto out;
@@ -294,6 +310,30 @@ static int damon_reclaim_turn(bool on)
 	return damon_call(ctx, &call_control);
 }
 
+static int damon_reclaim_addr_unit_store(const char *val,
+		const struct kernel_param *kp)
+{
+	unsigned long input_addr_unit;
+	int err = kstrtoul(val, 0, &input_addr_unit);
+
+	if (err)
+		return err;
+	if (!input_addr_unit)
+		return -EINVAL;
+
+	addr_unit = input_addr_unit;
+	return 0;
+}
+
+static const struct kernel_param_ops addr_unit_param_ops = {
+	.set = damon_reclaim_addr_unit_store,
+	.get = param_get_ulong,
+};
+
+module_param_cb(addr_unit, &addr_unit_param_ops, &addr_unit, 0600);
+MODULE_PARM_DESC(addr_unit,
+	"Scale factor for DAMON_RECLAIM to ops address conversion (default: 1)");
+
 static int damon_reclaim_enabled_store(const char *val,
 		const struct kernel_param *kp)
 {
_

Patches currently in -mm which might be from yanquanmin1@huawei.com are


