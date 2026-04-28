Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C59302165
	for <mm-commits@vger.kernel.org>; Tue, 28 Apr 2026 14:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777385828; cv=none; b=YmtCxCmKAJ7Ow/6iWynZ9ZfdxUopcYB7u+h+0Hyr/RL87oR1pFGp0NENTs/SM+rZB8muJItXDnCByECT1a65iFr6ZKm9RScwUHA57bYdd9SuW/c/MCyx0F+IQQ9f22tG6ZVTTMFm0Sp689+OPCuNNok/i1me9JcHW4uj2DiVgdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777385828; c=relaxed/simple;
	bh=DbjG02pkAHkHtJVNH8RTSjMVabKgXxnldMHucSP4PMY=;
	h=Date:To:From:Subject:Message-Id; b=ARgHVn9AYvi0zMhSuomhQ2Po4EJFdUQ/cfQE04D2Cfn9rW1VOHvSaClEpHu/3mxKzFmxj76EExjnX/3TVnVuVK0i01AFNYXoxg6FzSnGObRYV6tYQdP4Sm+DZelca6n9NQvuZPUingY+nYmgcqAmeTfpXSaUjlDJG452K7sACT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fut2rjUQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fut2rjUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79CEEC2BCAF;
	Tue, 28 Apr 2026 14:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777385827;
	bh=DbjG02pkAHkHtJVNH8RTSjMVabKgXxnldMHucSP4PMY=;
	h=Date:To:From:Subject:From;
	b=fut2rjUQ1ASOx2sN6HprmYrFMyIm/yrKMBXcCHn+QyKSKSTLEWUM0YXMOgyGhqJdI
	 pD+VSgDillp/YtKKV3vGVouDOe6dD/DM6tsuoI1gIOUhFxEABLsso7g++QX0F+T2yL
	 /A6d7HL1F6kOzm2ZjV/+2/p26Sai0DlyjEMc4tBU=
Date: Tue, 28 Apr 2026 07:17:06 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,zhen.ni@easystack.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-add-print_mode-filter.patch added to mm-new branch
Message-Id: <20260428141707.79CEEC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: add print_mode filter
has been added to the -mm mm-new branch.  Its filename is
     mm-page_owner-add-print_mode-filter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-add-print_mode-filter.patch

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
Subject: mm/page_owner: add print_mode filter
Date: Tue, 28 Apr 2026 15:11:10 +0800

Add print_mode functionality to reduce page_owner output size by printing
only the stack handle instead of the full stack trace.

Example output with print_mode enabled:
  Page allocated via order 0, mask 0x42800(GFP_NOWAIT|__GFP_COMP),
  pid 1, tgid 1 (systemd), ts 349667370 ns
  PFN 0xa00a2 type Unmovable Block 1280 type Unmovable
  Flags 0x33fffe0000004124(referenced|lru|active|private|node=3|zone=0|
lastcpupid=0x1ffff)
  handle: 17432583
  Charged to memcg /

Print mode significantly reduces output size while preserving all other
page allocation information.  The correspondence between handles and stack
traces can be obtained through the show_stacks_handles interface.

Link: https://lore.kernel.org/linux-mm/20260417154638.22370-3-zhen.ni@easystack.cn/
Link: https://lore.kernel.org/20260428071112.1420380-3-zhen.ni@easystack.cn
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
Suggested-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-page_owner-add-print_mode-filter
+++ a/mm/page_owner.c
@@ -590,7 +590,13 @@ print_page_owner(char __user *buf, size_
 			migratetype_names[pageblock_mt],
 			&page->flags);
 
-	ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
+	/* Print mode: full stack or stack handle */
+	if (READ_ONCE(owner_filter.print_mode) == PAGE_OWNER_PRINT_STACK_HANDLE) {
+		ret += scnprintf(kbuf + ret, count - ret,
+				"handle: %d\n", handle);
+	} else {
+		ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
+	}
 	if (ret >= count)
 		goto err;
 
@@ -985,6 +991,24 @@ static int page_owner_threshold_set(void
 DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
 			&page_owner_threshold_set, "%llu");
 
+static int page_owner_print_mode_get(void *data, u64 *val)
+{
+	*val = READ_ONCE(owner_filter.print_mode);
+	return 0;
+}
+
+static int page_owner_print_mode_set(void *data, u64 val)
+{
+	if (val > PAGE_OWNER_PRINT_STACK_HANDLE)
+		return -EINVAL;
+	WRITE_ONCE(owner_filter.print_mode, val);
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(page_owner_print_mode_fops,
+			&page_owner_print_mode_get,
+			&page_owner_print_mode_set, "%lld");
+
 
 static int __init pageowner_init(void)
 {
@@ -998,6 +1022,8 @@ static int __init pageowner_init(void)
 	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_fops);
 
 	filter_dir = debugfs_create_dir("page_owner_filter", NULL);
+	debugfs_create_file("print_mode", 0600, filter_dir, NULL,
+			    &page_owner_print_mode_fops);
 
 	dir = debugfs_create_dir("page_owner_stacks", NULL);
 	debugfs_create_file("show_stacks", 0400, dir,
_

Patches currently in -mm which might be from zhen.ni@easystack.cn are

mm-page_owner-add-filter-infrastructure.patch
mm-page_owner-add-print_mode-filter.patch
mm-page_owner-add-numa-node-filter-with-nodelist-support.patch
mm-page_owner-document-page_owner-filter-features.patch
mm-page_owner-fix-%pgp-format-specifier-argument-type.patch

