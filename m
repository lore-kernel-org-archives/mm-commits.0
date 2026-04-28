Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A202EC0A4
	for <mm-commits@vger.kernel.org>; Tue, 28 Apr 2026 14:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777385825; cv=none; b=aDMN0uSV9W3HLFqgpjqP0TCL6qtzWMPb3HGz/uWx61BngX7atIfJNMZLO6Bd22jJbKgjYiRa6oqXZHKELsG5/sUZ4ZI+StitnkK19mVdLX2nYsffRQeKSbJqqRYVDv96nrDb3HpsIpeMX07FfFWMEuEqvGbdTbH/aDQ4X6xwlBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777385825; c=relaxed/simple;
	bh=hSzmcOxi9y+B696RjA/G+yClygAX3XmyO2rRuMehYmw=;
	h=Date:To:From:Subject:Message-Id; b=mEnd+UOe9WAICEqw/nLMqtSSfPQpNZBIt+QFIQ7j9NVbbAGUMQkNmheBYZUceHSoq4nH9ZBvl89feY5qxse0x5Blv8UJ+idx6hLm2VnKIj9QDMD3+yBZKHaTky7dUH25ajSAd4GVwBmqXcXwsHn2S4WjBeCA8GYfp8u8qckG2G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D6BcRw1Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D6BcRw1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B0AC2BCAF;
	Tue, 28 Apr 2026 14:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777385825;
	bh=hSzmcOxi9y+B696RjA/G+yClygAX3XmyO2rRuMehYmw=;
	h=Date:To:From:Subject:From;
	b=D6BcRw1QdTilakhkkUtKs6As+4zx0AXk+/8lmXYQ5a8LVjQJKVCqLafu3tuegG7Nw
	 yyVA0fJ1q57/1KfPPlxm/GIBkDTz+uzJEGVxHrTAJ75uMObnYGTlIZK7N1dIOCn/bW
	 PzqrlDhyqd/KtcEkNhY9AgicB3yoijOCVKLYRKHg=
Date: Tue, 28 Apr 2026 07:17:04 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,zhen.ni@easystack.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-add-filter-infrastructure.patch added to mm-new branch
Message-Id: <20260428141705.50B0AC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: add filter infrastructure
has been added to the -mm mm-new branch.  Its filename is
     mm-page_owner-add-filter-infrastructure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-add-filter-infrastructure.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-page_owner-add-filter-infrastructure.patch
mm-page_owner-add-print_mode-filter.patch
mm-page_owner-add-numa-node-filter-with-nodelist-support.patch
mm-page_owner-document-page_owner-filter-features.patch
mm-page_owner-fix-%pgp-format-specifier-argument-type.patch

