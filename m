Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E58C2E3399
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742619859; cv=none; b=bO5lr63PLW/DkCoA8078AuJ+BkMAtpqcXhzlR6H519ALWhhSJ5aK2J6bYk7XqDhDA3tuK0nQjYvmiVpiwyHctjTHBYmvUnb/F5LENom1GWvSh8YwCldvBSpKCuLuXv3poL3azHyC6BEG/reDH+AmZEPtwmvXqzqhJloNi7i68zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742619859; c=relaxed/simple;
	bh=BfyCiBNvtZbeAgJ6aovlLl+/VVPP2K/wcNBy5c7De+c=;
	h=Date:To:From:Subject:Message-Id; b=TE6Gs6f1rL5No+x6Dv3ZbNRZY2N3lFZQq+L8IpArz4aw8oDqCmkUcodG1YFy5sPudr/PfQrpeniMfQd9fkWws/8IDTVtW/asEmEtwiJFiDWmAi/mYLJGyAJc6FYcQtEqIQlFmowewwBVUBH6FOUzR3GEdMVZLseO9P9vE7kAnGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mfFtlEF6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mfFtlEF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75494C4CEDD;
	Sat, 22 Mar 2025 05:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742619859;
	bh=BfyCiBNvtZbeAgJ6aovlLl+/VVPP2K/wcNBy5c7De+c=;
	h=Date:To:From:Subject:From;
	b=mfFtlEF6245stsqjYjyhNlWBtAXGlVYQob5GEPOIyWqiU0HwRpF7HNPc0/alJ46lI
	 HYPNtOMH+03QNUfVNHJGYGlEuX63VCYOHwvyteBaY+wWzlxCOZ9xLPHdOepjWuvpaj
	 z/DDZracfGMJ8QjLIVJAW5fzJZVE6nXlgz6a1/N4=
Date: Fri, 21 Mar 2025 22:04:18 -0700
To: mm-commits@vger.kernel.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-remove-unnecessary-__maybe_unused-in-order_to_pindex.patch removed from -mm tree
Message-Id: <20250322050419.75494C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: remove unnecessary __maybe_unused in order_to_pindex()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-unnecessary-__maybe_unused-in-order_to_pindex.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Ye <liuye@kylinos.cn>
Subject: mm/page_alloc: remove unnecessary __maybe_unused in order_to_pindex()
Date: Wed, 19 Mar 2025 17:17:26 +0800

The `movable` variable is always used when `CONFIG_TRANSPARENT_HUGEPAGE`
is enabled, so the `__maybe_unused` attribute is not necessary.  This
patch removes it and keeps the variable declaration within the `#ifdef`
block for better clarity.

Link: https://lkml.kernel.org/r/20250319091726.401158-1-liuyerd@163.com
Signed-off-by: Liu Ye<liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-unnecessary-__maybe_unused-in-order_to_pindex
+++ a/mm/page_alloc.c
@@ -509,9 +509,9 @@ out:
 
 static inline unsigned int order_to_pindex(int migratetype, int order)
 {
-	bool __maybe_unused movable;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	bool movable;
 	if (order > PAGE_ALLOC_COSTLY_ORDER) {
 		VM_BUG_ON(order != HPAGE_PMD_ORDER);
 
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-page_alloc-replace-flag-check-with-pagehwpoison-in-check_new_page_bad.patch

