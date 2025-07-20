Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030C2208CA
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976891; cv=none; b=Z3pIBRZ7nb7DjgoCe5gWI6IGfxdN6Er5jNGXa2UfPPzT+Md2iHneeNxdCoza9SXWUkfSHRGI4a8aiPRCYMbXA5ctbY2gEnSP7frJDGpZnxJME7Yjwy7Tc6jL8YwGBiuSMTrviXSHua2GWwdyyE+19xLRcKUtN4+QYfDG88WJAWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976891; c=relaxed/simple;
	bh=bj+8hz7M8iE3kA1ZfmIYl/qwWJ22aNDj8g+HkLWjxLo=;
	h=Date:To:From:Subject:Message-Id; b=WISTYyJWhYBonZzZ20UdwfiP+zfxvLuk/Z7u15hlxmYqBNuSo0FCaFUAKlgIYWebvwIQP7HO4GxHyTOx/JZZdIsO8UO+xM9aAsabHBHJBz6xF6wmT/GsZ3UuF3YXfqSJRaOzP67NYgdPPBja/Mpq6flNnxrNG9g5yipIkAq3tQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M7XBmUK8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M7XBmUK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA915C4CEE3;
	Sun, 20 Jul 2025 02:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976890;
	bh=bj+8hz7M8iE3kA1ZfmIYl/qwWJ22aNDj8g+HkLWjxLo=;
	h=Date:To:From:Subject:From;
	b=M7XBmUK8GyiNla8DaiuLuRTyWXVzuApDyqir4Es4v4KyZtpjFBI/4AEOVAQS3w0qQ
	 5w5NGb7z1CNUZlVayhcD660yD/AboxMT2g/W1GCaWo7xTRyQwUuXWtjUuRDclgHSsr
	 nS6qdCCYoZXpqy38xUAprZ6F4LMMB0GtDZRutapA=
Date: Sat, 19 Jul 2025 19:01:30 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,honggyu.kim@sk.com,yunjeong.mun@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] samples-damon-support-automatic-node-address-detection.patch removed from -mm tree
Message-Id: <20250720020130.CA915C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon: support automatic node address detection
has been removed from the -mm tree.  Its filename was
     samples-damon-support-automatic-node-address-detection.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


