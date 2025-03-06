Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB91367
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 00:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741220076; cv=none; b=GanNTnLv5Au/HoDXrX1n8i/zkXN7p9rNACZXiT49A8UJ4hcqTLomamidcDgTLGtaNK8lOA0ddCAjrgVoXeQnAaGhNo1UnIyDdMT6feyv4m6iOj4eSBM/3tBsuybBeh3y8zyGXnEX46qSBbcIJUrB7hURnjS9cLpz0WR32jAu+20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741220076; c=relaxed/simple;
	bh=bYT7//u5NDzG/myEU/dJUedaIVWwQenbCVXb0Mk28f0=;
	h=Date:To:From:Subject:Message-Id; b=hSXJqaRChQI4OhqpiAZjyjjLuYcRa6UBK0gZCK700LCiWDdrETmbbm6hYHY85WSMaK6EhoQI2e8nqka6+PpZDP4CkR3sHUAzs7iFmvb1hc/03QTw0ysxFUJn6jzKkVAOPPmC4OE5fgu7JgQtmgUH4Zfdnug5vEDFHu3h3sGXTz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X8BFjLEl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X8BFjLEl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2C3C4CED1;
	Thu,  6 Mar 2025 00:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741220075;
	bh=bYT7//u5NDzG/myEU/dJUedaIVWwQenbCVXb0Mk28f0=;
	h=Date:To:From:Subject:From;
	b=X8BFjLEltGgMyViUlxqNmD+PbxAJioz9KxmCib2tec1dtPIwsfuPi6kJdU7k5/yHl
	 7trw7v76Ghk6PWeoVHMip78I+J5uh6R4h9yAraBXosaJBljPt+ybyZGpx3o7gipSmM
	 NWP8XcY5gV4JB3bVT5N+UZUaeAmZ8VP5ZTj2tJRU=
Date: Wed, 05 Mar 2025 16:14:34 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,roman.gushchin@linux.dev,muchun.song@linux.dev,david@fromorbit.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinker-fix-name-consistency-issue-in-shrinker_debugfs_rename.patch added to mm-unstable branch
Message-Id: <20250306001435.7B2C3C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shrinker: fix name consistency issue in shrinker_debugfs_rename()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shrinker-fix-name-consistency-issue-in-shrinker_debugfs_rename.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinker-fix-name-consistency-issue-in-shrinker_debugfs_rename.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Liu Ye <liuye@kylinos.cn>
Subject: mm/shrinker: fix name consistency issue in shrinker_debugfs_rename()
Date: Wed, 5 Mar 2025 15:17:59 +0800

After calling debugfs_change_name function, the return value should be
checked and the old name restored.  If debugfs_change_name fails, the new
name memory should be freed.  The effect is that the shrinker->name is not
consistent with the name displayed in debugfs.

Link: https://lkml.kernel.org/r/20250305071759.661055-1-liuye@kylinos.cn
Signed-off-by: Liu Ye <liuye@kylinos.cn>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by：Qi Zheng <zhengqi.arch@bytedance.co
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shrinker_debug.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/shrinker_debug.c~mm-shrinker-fix-name-consistency-issue-in-shrinker_debugfs_rename
+++ a/mm/shrinker_debug.c
@@ -214,10 +214,14 @@ int shrinker_debugfs_rename(struct shrin
 	ret = debugfs_change_name(shrinker->debugfs_entry, "%s-%d",
 			shrinker->name, shrinker->debugfs_id);
 
+	if (ret) {
+		shrinker->name = old;
+		kfree_const(new);
+	} else {
+		kfree_const(old);
+	}
 	mutex_unlock(&shrinker_mutex);
 
-	kfree_const(old);
-
 	return ret;
 }
 EXPORT_SYMBOL(shrinker_debugfs_rename);
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-memfd-fix-spelling-and-grammatical-issues.patch
mm-folio_queue-delete-__folio_order-and-use-folio_order-directly.patch
mm-vmalloc-move-free_vm_areaarea-from-the-__vmalloc_area_node-function-to-the-__vmalloc_node_range_noprof-function.patch
mm-shrinker-fix-name-consistency-issue-in-shrinker_debugfs_rename.patch

