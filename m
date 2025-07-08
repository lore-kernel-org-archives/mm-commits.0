Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F116E3594C
	for <mm-commits@vger.kernel.org>; Tue,  8 Jul 2025 02:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751940296; cv=none; b=hv3ApMus+7SPSi0O6mgd0AM5bDh3E7r7T8xGKCxBIr+yZdjlYLYyhEiqnaNVS7ZNJLv5JMRCo08IQtOrM4PqliflwodDqM2s8mzXqY/6yp6ka91z8ULY9tw4LuN/p5pLwaPSt642+A9Y4KxfdkBW4lMIV+JVvFbvs6v+0Gz4oI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751940296; c=relaxed/simple;
	bh=C0X9CPpohPsUGYzcACtd4MWtCIJg13jyp3BxmGNRNzo=;
	h=Date:To:From:Subject:Message-Id; b=slXbQkTK9skia5tBq7IXSu6YqwULl1Mgvf77cpfeeyJ7AwGIMb2NTCgvcY4SS8rg1wysBrPWGk18UxCkgmvB6XYSJWbUrOvgfSE+Jh8RVtbLfbiRzd5ldnLPOFN7mk3UfTFqp2H/1hOHKsVk7h1g6iNgME8bd7Pzj5Mrtjjd980=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FJE1T3C2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FJE1T3C2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52347C4CEE3;
	Tue,  8 Jul 2025 02:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751940294;
	bh=C0X9CPpohPsUGYzcACtd4MWtCIJg13jyp3BxmGNRNzo=;
	h=Date:To:From:Subject:From;
	b=FJE1T3C2WpQ9StoHEBGqPeULT3T8z1NRBRXKZ9jghw7hXCB9frjn3iNNnWCPq6TJg
	 /mSACm7+aC0dGaRAKroZ0/aiFpUJYfwqKyRLvBhxiOqtE7r8Vb6sDpQ4RNNRiQBR8e
	 K/w7gd8oGWgd2kP8SGQ7vz/4dPnEJQQ4aYQ2Hx3Y=
Date: Mon, 07 Jul 2025 19:04:53 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,honggyu.kim@sk.com,yunjeong.mun@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-support-automatic-node-address-detection.patch added to mm-new branch
Message-Id: <20250708020454.52347C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon: support automatic node address detection
has been added to the -mm mm-new branch.  Its filename is
     samples-damon-support-automatic-node-address-detection.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-support-automatic-node-address-detection.patch

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
From: Yunjeong Mun <yunjeong.mun@sk.com>
Subject: samples/damon: support automatic node address detection
Date: Tue, 8 Jul 2025 08:59:18 +0900

This patch adds a new knob `detect_node_addresses`, which determines
whether the physical address range is set manually using the existing
knobs or automatically by the mtier module.  When `detect_node_addresses`
set to 'Y', mtier automatically converts node0 and node1 to their physical
addresses.  If set to 'N', it uses the existing 'node#_start_addr' and
'node#_end_addr' to define regions as before.

Link: https://lkml.kernel.org/r/20250707235919.513-1-yunjeong.mun@sk.com
Signed-off-by: Yunjeong Mun <yunjeong.mun@sk.com>
Suggested-by: Honggyu Kim <honggyu.kim@sk.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/mtier.c |   37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

--- a/samples/damon/mtier.c~samples-damon-support-automatic-node-address-detection
+++ a/samples/damon/mtier.c
@@ -47,8 +47,29 @@ static bool enabled __read_mostly;
 module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
 MODULE_PARM_DESC(enabled, "Enable or disable DAMON_SAMPLE_MTIER");
 
+static bool detect_node_addresses __read_mostly;
+module_param(detect_node_addresses, bool, 0600);
+
 static struct damon_ctx *ctxs[2];
 
+struct region_range {
+	phys_addr_t start;
+	phys_addr_t end;
+};
+
+static int nid_to_phys(int target_node, struct region_range *range)
+{
+	if (!node_online(target_node)) {
+		pr_err("NUMA node %d is not online\n", target_node);
+		return -EINVAL;
+	}
+
+	range->start = PFN_PHYS(node_start_pfn(target_node));
+	range->end  = PFN_PHYS(node_end_pfn(target_node));
+
+	return 0;
+}
+
 static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
 {
 	struct damon_ctx *ctx;
@@ -58,6 +79,8 @@ static struct damon_ctx *damon_sample_mt
 	struct damos *scheme;
 	struct damos_quota_goal *quota_goal;
 	struct damos_filter *filter;
+	struct region_range addr;
+	int ret;
 
 	ctx = damon_new_ctx();
 	if (!ctx)
@@ -87,9 +110,17 @@ static struct damon_ctx *damon_sample_mt
 	if (!target)
 		goto free_out;
 	damon_add_target(ctx, target);
-	region = damon_new_region(
-			promote ? node1_start_addr : node0_start_addr,
-			promote ? node1_end_addr : node0_end_addr);
+
+	if (detect_node_addresses) {
+		ret = promote ? nid_to_phys(1, &addr) : nid_to_phys(0, &addr);
+		if (ret)
+			goto free_out;
+	} else {
+		addr.start = promote ? node1_start_addr : node0_start_addr;
+		addr.end = promote ? node1_end_addr : node0_end_addr;
+	}
+
+	region = damon_new_region(addr.start, addr.end);
 	if (!region)
 		goto free_out;
 	damon_add_region(region, target);
_

Patches currently in -mm which might be from yunjeong.mun@sk.com are

samples-damon-mtier-add-parameters-for-node0-memory-usage.patch
samples-damon-support-automatic-node-address-detection.patch

