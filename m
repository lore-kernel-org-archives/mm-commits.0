Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD272C08DF
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489980; cv=none; b=WtIr3TIKgDvUFTHA7aALjsxzjY4FkwmtE7Fk3LjFW84sdkkPfLKk0Ti8N+P0/Ui+zVWfjt2RCRiBgMfVBF53BlcWZ+Dn+zXIO5b7Ve3qxHfvzfcH4IyTQPwyC8JZcsfy9FYRaqMuQPnr3/R9C1PVzzj8Q/STMGULSYaqyx0YiHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489980; c=relaxed/simple;
	bh=TRmnNB2CgFDXGbZYSVheGltX0fnUrw4vb8FD0gyzT5M=;
	h=Date:To:From:Subject:Message-Id; b=CQ9qQd0rl/fPRAhaGSE0l/zHfxPfScTBWCgzl3jNGD1l3KUWnFnYuVNqp4qfzT8iRoojnYtduDIuC1AubSz4cld7lTOS/RBb19AYtKhK2opLXcD2peYOOy58KzMe1D7R6VCP5eHneSNfO6Fjm+x/G7i4FiqUI9B50gd5uN0vVDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I62Fv2wu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I62Fv2wu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C1CC4CEE7;
	Sun, 21 Sep 2025 21:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489980;
	bh=TRmnNB2CgFDXGbZYSVheGltX0fnUrw4vb8FD0gyzT5M=;
	h=Date:To:From:Subject:From;
	b=I62Fv2wulZcNG2/a7b+cHUatcwSnMpkh7175ZR7WGo2zGB9C2F90Vl4UrtexVsMxZ
	 oLqI72u444RVjlxApSw+5SiBtz/UnK/5rbvWBfyX0EdkSH+Xwvk6L/GQt/d4Xy9s5p
	 Vhgilc8mxDObe8/16yLl9FluvY0JP/oj1DMN2Q6o=
Date: Sun, 21 Sep 2025 14:26:19 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,hughd@google.com,baolin.wang@linux.alibaba.com,liuyun01@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-remove-unused-entry_order-after-large-swapin-rework.patch removed from -mm tree
Message-Id: <20250921212620.23C1CC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shmem: remove unused entry_order after large swapin rework
has been removed from the -mm tree.  Its filename was
     mm-shmem-remove-unused-entry_order-after-large-swapin-rework.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jackie Liu <liuyun01@kylinos.cn>
Subject: mm/shmem: remove unused entry_order after large swapin rework
Date: Mon, 8 Sep 2025 14:26:14 +0800

After commit 93c0476e7057 ("mm/shmem, swap: rework swap entry and index
calculation for large swapin"), xas_get_order() will never return a
non-zero value for `entry_order` in shmem_split_large_entry().  As a
result, the local variable `entry_order` is effectively unused.

Clean up the code by removing `entry_order` and directly using
`cur_order`.  This change is purely a refactor and has no functional
impact.

No functional change intended.

Link: https://lkml.kernel.org/r/20250908062614.89880-1-liu.yun@linux.dev
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/mm/shmem.c~mm-shmem-remove-unused-entry_order-after-large-swapin-rework
+++ a/mm/shmem.c
@@ -2173,7 +2173,7 @@ static int shmem_split_large_entry(struc
 {
 	struct address_space *mapping = inode->i_mapping;
 	XA_STATE_ORDER(xas, &mapping->i_pages, index, 0);
-	int split_order = 0, entry_order;
+	int split_order = 0;
 	int i;
 
 	/* Convert user data gfp flags to xarray node gfp flags */
@@ -2191,15 +2191,12 @@ static int shmem_split_large_entry(struc
 			goto unlock;
 		}
 
-		entry_order = xas_get_order(&xas);
-
-		if (!entry_order)
+		cur_order = xas_get_order(&xas);
+		if (!cur_order)
 			goto unlock;
 
 		/* Try to split large swap entry in pagecache */
-		cur_order = entry_order;
-		swap_index = round_down(index, 1 << entry_order);
-
+		swap_index = round_down(index, 1 << cur_order);
 		split_order = xas_try_split_min_order(cur_order);
 
 		while (cur_order > 0) {
_

Patches currently in -mm which might be from liuyun01@kylinos.cn are


