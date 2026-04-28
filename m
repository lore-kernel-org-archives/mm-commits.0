Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7350A441024
	for <mm-commits@vger.kernel.org>; Tue, 28 Apr 2026 14:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777385369; cv=none; b=O+rlbqkUjS2/C05qB4EYGpXe98KyRCLA6rcQd5eM+UbNX++G/3paZN2PU395zTh2yUmQ+gvsQvC7JST3GKyAknosXS9m7fgMpG2JbO0wMvdMaVFi4iSGXnJuXOnA1HQM0eVW2+c13aLjRHdW4fBB4HItTz7TLJpGSTFdjWsN4pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777385369; c=relaxed/simple;
	bh=d7lFmAesumy+Fr0Etp4lOMXroO1jmZRYMmdlzcY3JTg=;
	h=Date:To:From:Subject:Message-Id; b=W5dwA88WJRFkE+KVpgsVv30BFdv5SI1MMQ2xEV7zu4iCYueD2RlSuArpfLpx6a/f4bKmJPD1ysMBoriRRAxreuFBN+oKO1yP9iS70CHKJDffFKuHuuk/igGXyWx4cVMLUmkEJcK/UwyOfg/Ihw/+XrqcODnjmjCC63qyeTPB9t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jfzt0YFH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jfzt0YFH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB1AC2BCAF;
	Tue, 28 Apr 2026 14:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777385369;
	bh=d7lFmAesumy+Fr0Etp4lOMXroO1jmZRYMmdlzcY3JTg=;
	h=Date:To:From:Subject:From;
	b=Jfzt0YFHZ0rp4VxUhzenig55BQd3jLVgrahH94pzLuodhdP90N+4YzqW6mBJ4+qnQ
	 ZLYMyJ5OER+DY4mmuKabb/dA9GlF7TRbb3T5VBupOMQVY8fo641yEcMKWyPTn9Uiwb
	 Ut9/rvrVxtbwXr+BdM2vZShsfT/NzzS2aoTOkwjg=
Date: Tue, 28 Apr 2026 07:09:28 -0700
To: mm-commits@vger.kernel.org,zhen.ni@easystack.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_owner-add-print_mode-filter.patch removed from -mm tree
Message-Id: <20260428140929.2CB1AC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: add print_mode filter
has been removed from the -mm tree.  Its filename was
     mm-page_owner-add-print_mode-filter.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zhen Ni <zhen.ni@easystack.cn>
Subject: mm/page_owner: add print_mode filter
Date: Sun, 19 Apr 2026 23:55:39 +0800

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
Link: https://lore.kernel.org/20260419155540.376847-3-zhen.ni@easystack.cn
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

mm-page_owner-add-numa-node-filter-with-nodelist-support.patch
mm-page_owner-fix-%pgp-format-specifier-argument-type.patch

