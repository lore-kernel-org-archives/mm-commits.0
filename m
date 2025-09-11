Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBAA2EAB72
	for <mm-commits@vger.kernel.org>; Thu, 11 Sep 2025 23:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757631610; cv=none; b=oeipZUVG2I1S9sZOumfUBo9j3aEApHzoqOoUyYJwEQ5p1Kcssy1TeVX6AhmGMFCcJHteykspAZx+ds51Un+Q+ANTXjD3XWRUmOzzYimCtezhqG0XoXfUaxkINaAWUpg09/qO/6Ydzrmxsji9NtaqAtUxTJfFq/Lnk3t01HXsigA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757631610; c=relaxed/simple;
	bh=/HKcFKRmOh6towbmtIifAAisUrCtePLKsl3VzW92ek0=;
	h=Date:To:From:Subject:Message-Id; b=ZQTk6AjpBS3lTn9qWj5aA6z9sc58PYvBrwKpClgOkpvNqCdzqeldzclnCNrkKH0/nuKV3CJVRXrPfPoBOgmtUBVqqK0IkKNLP7So2DJqH33+Z25ivNKPhs/ISoaUrSLO/HEC01cpoVsiRUY3knxpUJMI7W/qYwIIPIqrNmTc0yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bIknhWHh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bIknhWHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFB1C4CEF1;
	Thu, 11 Sep 2025 23:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757631609;
	bh=/HKcFKRmOh6towbmtIifAAisUrCtePLKsl3VzW92ek0=;
	h=Date:To:From:Subject:From;
	b=bIknhWHhAc4OZepvwqEVA17Qe2UD+FFTvMjPg70H4DfGv2Y+r4pr7JHCC4vhGoSq/
	 mfiL898ZIEzHqnjiFd6R4t0IXL1u5dnnz7/HyLJYaBJqlxgqBBGSs9ipgivkbGexkh
	 dSA8sCShbacDqkLZnFiI2TdwfqxdTCNHdravlUKE=
Date: Thu, 11 Sep 2025 16:00:09 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,wangkefeng.wang@huawei.com,sj@kernel.org,yanquanmin1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaim-support-addr_unit-for-damon_reclaim.patch added to mm-new branch
Message-Id: <20250911230009.ACFB1C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/reclaim: support addr_unit for DAMON_RECLAIM
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-reclaim-support-addr_unit-for-damon_reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-reclaim-support-addr_unit-for-damon_reclaim.patch

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

mm-damon-add-damon_ctx-min_sz_region.patch
mm-damon-lru_sort-support-addr_unit-for-damon_lru_sort.patch
mm-damon-reclaim-support-addr_unit-for-damon_reclaim.patch

