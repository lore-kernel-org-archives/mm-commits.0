Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210332EAB72
	for <mm-commits@vger.kernel.org>; Thu, 11 Sep 2025 23:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757631609; cv=none; b=BrYgnHpNcyfj6tYH6hRutdBAGokR7ve5y5DTiAEG2Iil+rx5qFUoQunkgxQs5cShFRPwYQzg8fOVpBZWZucLAHEf53vD6OfhFFVLQYT2UxJRqhPpU+7KtIFyVxFOXfka8B1IMFu9KzlILUbkbeJJXafHDnj1afXIyRdBPl/DN5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757631609; c=relaxed/simple;
	bh=CoI54q7wxIvrK+gLsXHwWa6PtMlj04s3rujY1+dstEI=;
	h=Date:To:From:Subject:Message-Id; b=ct6msJ7u3tnaMH6gsNhsZvcX2zPypgJq1soEKNs4VbIjsqbS8eVg8ayaH3h7lEUKS8xsFUL87eDTGC7O+kOBkwA2PA1UwS6R6vkxcEeJMnjZh7/OfTuvAD7BeD4phho+ye2IRotvHvUyiLN1E0yUse9n0U22RG6PL+ocZDYWa2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AIS2RTLu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AIS2RTLu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E845C4CEF1;
	Thu, 11 Sep 2025 23:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757631608;
	bh=CoI54q7wxIvrK+gLsXHwWa6PtMlj04s3rujY1+dstEI=;
	h=Date:To:From:Subject:From;
	b=AIS2RTLuG2XHv1NCWJYAbdhhdBuyRoEcGzzrzGD4qfiyKI7rNTf8y79Uk3iPZdZ/6
	 9P9pOktO8QtbCcQUWBo7WuVCW6VvK/+oGSAIg70bB//iyPZCawAioq1/xvspSEvnbE
	 SokMGFwGiLgDbBguxHm7+Bg7UqOE/2CPclUErs6k=
Date: Thu, 11 Sep 2025 16:00:07 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,wangkefeng.wang@huawei.com,sj@kernel.org,yanquanmin1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-lru_sort-support-addr_unit-for-damon_lru_sort.patch added to mm-new branch
Message-Id: <20250911230008.5E845C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/lru_sort: support addr_unit for DAMON_LRU_SORT
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-lru_sort-support-addr_unit-for-damon_lru_sort.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-lru_sort-support-addr_unit-for-damon_lru_sort.patch

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
Subject: mm/damon/lru_sort: support addr_unit for DAMON_LRU_SORT
Date: Wed, 10 Sep 2025 19:32:20 +0800

Patch series "mm/damon: add addr_unit for DAMON_LRU_SORT and
DAMON_RECLAIM".

In DAMON_LRU_SORT and DAMON_RECLAIM, damon_ctx is independent of the core.
Add addr_unit to these modules to support systems like ARM32 with LPAE.


This patch (of 2):

Implement a sysfs file to expose addr_unit for DAMON_LRU_SORT users. 
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

Link: https://lkml.kernel.org/r/20250910113221.1065764-1-yanquanmin1@huawei.com
Link: https://lkml.kernel.org/r/20250910113221.1065764-2-yanquanmin1@huawei.com
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: ze zuo <zuoze1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-support-addr_unit-for-damon_lru_sort
+++ a/mm/damon/lru_sort.c
@@ -112,6 +112,13 @@ static unsigned long monitor_region_end
 module_param(monitor_region_end, ulong, 0600);
 
 /*
+ * Scale factor for DAMON_LRU_SORT to ops address conversion.
+ *
+ * This parameter must not be set to 0.
+ */
+static unsigned long addr_unit __read_mostly = 1;
+
+/*
  * PID of the DAMON thread
  *
  * If DAMON_LRU_SORT is enabled, this becomes the PID of the worker thread.
@@ -198,6 +205,15 @@ static int damon_lru_sort_apply_paramete
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
 	if (!damon_lru_sort_mon_attrs.sample_interval) {
 		err = -EINVAL;
 		goto out;
@@ -290,6 +306,30 @@ static int damon_lru_sort_turn(bool on)
 	return damon_call(ctx, &call_control);
 }
 
+static int damon_lru_sort_addr_unit_store(const char *val,
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
+	.set = damon_lru_sort_addr_unit_store,
+	.get = param_get_ulong,
+};
+
+module_param_cb(addr_unit, &addr_unit_param_ops, &addr_unit, 0600);
+MODULE_PARM_DESC(addr_unit,
+	"Scale factor for DAMON_LRU_SORT to ops address conversion (default: 1)");
+
 static int damon_lru_sort_enabled_store(const char *val,
 		const struct kernel_param *kp)
 {
_

Patches currently in -mm which might be from yanquanmin1@huawei.com are

mm-damon-add-damon_ctx-min_sz_region.patch
mm-damon-lru_sort-support-addr_unit-for-damon_lru_sort.patch
mm-damon-reclaim-support-addr_unit-for-damon_reclaim.patch

