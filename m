Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D595F2C159A
	for <mm-commits@vger.kernel.org>; Wed, 29 Apr 2026 12:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777464690; cv=none; b=qCEUm4cxxMQRYl+S8qprK7FMgAhT2IjFpktFQ+1P/hz+7A9HgEEBvgKBV598/eMm+WuhkNfayZ5AaWVHgP2DsBfX7u/bhTMDS3z6llpkh81EbUhuC82n579tiNvdyVpPhBUGm06B2ooCdQHHFo+pYFWjWs/zK+jEva6t6AhE5ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777464690; c=relaxed/simple;
	bh=yApGABksqKZ2rYtm0kj1n13mBpPQ4insz9xjhY30VlM=;
	h=Date:To:From:Subject:Message-Id; b=A96XaAh646rmszPtj1rD/VIgKXm+7GW3RHHEvo+joACVR1huw4qYPTc0Xx3sWmtcpzED3fB0nZuRAvUQLun73softspgjhZCROP/3MXfqM3OoZgqVmZLoLs5VErZyR8Lq2vT6yB/7HVTJs0uhhtYt/XrlAr0ctFhINZaKQujFv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XCg/h2aA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XCg/h2aA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0F9C2BCB3;
	Wed, 29 Apr 2026 12:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777464690;
	bh=yApGABksqKZ2rYtm0kj1n13mBpPQ4insz9xjhY30VlM=;
	h=Date:To:From:Subject:From;
	b=XCg/h2aA/PR68YQTGE8lyL9DllNX88lAaKcLJJEjPxJ6us0ZIp/75QVZJdCYq1+Ej
	 Z1lvCiLewEd8PUBglqIVZj2Twzg7r0d5y38zKImcCpB/OkF09wXZwlg/DB+PhGcuco
	 4dRy9I/H1KdPdMpHpr+T3AT12q9UQraN8HTeyMFo=
Date: Wed, 29 Apr 2026 05:11:30 -0700
To: mm-commits@vger.kernel.org,zhen.ni@easystack.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_owner-add-filter-infrastructure.patch removed from -mm tree
Message-Id: <20260429121130.8E0F9C2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: add filter infrastructure
has been removed from the -mm tree.  Its filename was
     mm-page_owner-add-filter-infrastructure.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zhen Ni <zhen.ni@easystack.cn>
Subject: mm/page_owner: add filter infrastructure
Date: Tue, 28 Apr 2026 15:11:09 +0800

Patch series "mm/page_owner: add filter infrastructure for print_mode and
NUMA filtering", v3.

This patch series introduces filtering capabilities to the page_owner
feature to address storage and performance challenges in production
environments.


This patch (of 4):

Add data structure for page_owner filtering functionality and create
debugfs directory for filter controls.

This adds:
- enum page_owner_print_mode with values for full_stack and stack_handle
- struct page_owner_filter with print_mode and nid_mask fields
- Static owner_filter instance initialized with default values
- page_owner_filter debugfs directory

The filter infrastructure will be used to add print_mode and NUMA node
filtering capabilities in subsequent commits.

Link: https://lore.kernel.org/20260428071112.1420380-1-zhen.ni@easystack.cn
Link: https://lore.kernel.org/linux-mm/20260417154638.22370-2-zhen.ni@easystack.cn/
Link: https://lore.kernel.org/20260428071112.1420380-2-zhen.ni@easystack.cn
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
Suggested-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zhen Ni <zhen.ni@easystack.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-page_owner-add-filter-infrastructure
+++ a/mm/page_owner.c
@@ -54,6 +54,21 @@ struct stack_print_ctx {
 	u8 flags;
 };
 
+enum page_owner_print_mode {
+	PAGE_OWNER_PRINT_FULL_STACK,
+	PAGE_OWNER_PRINT_STACK_HANDLE,
+};
+
+struct page_owner_filter {
+	enum page_owner_print_mode print_mode;
+	nodemask_t nid_mask;
+};
+
+static struct page_owner_filter owner_filter = {
+	.print_mode = PAGE_OWNER_PRINT_FULL_STACK,
+	.nid_mask = NODE_MASK_NONE,
+};
+
 static bool page_owner_enabled __initdata;
 DEFINE_STATIC_KEY_FALSE(page_owner_inited);
 
@@ -973,7 +988,7 @@ DEFINE_SIMPLE_ATTRIBUTE(page_owner_thres
 
 static int __init pageowner_init(void)
 {
-	struct dentry *dir;
+	struct dentry *dir, *filter_dir;
 
 	if (!static_branch_unlikely(&page_owner_inited)) {
 		pr_info("page_owner is disabled\n");
@@ -981,6 +996,9 @@ static int __init pageowner_init(void)
 	}
 
 	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_fops);
+
+	filter_dir = debugfs_create_dir("page_owner_filter", NULL);
+
 	dir = debugfs_create_dir("page_owner_stacks", NULL);
 	debugfs_create_file("show_stacks", 0400, dir,
 			    (void *)(STACK_PRINT_FLAG_STACK |
_

Patches currently in -mm which might be from zhen.ni@easystack.cn are

mm-page_owner-add-print_mode-filter.patch
mm-page_owner-add-numa-node-filter-with-nodelist-support.patch
mm-page_owner-fix-%pgp-format-specifier-argument-type.patch

