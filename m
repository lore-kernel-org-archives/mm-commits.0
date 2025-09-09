Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985AD16DC28
	for <mm-commits@vger.kernel.org>; Tue,  9 Sep 2025 02:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757385883; cv=none; b=WvTMVng2o6FRWSOLEt5XHvjbxEIVTPOshS8Ii+5ojaw8PCgz8HbSnch0LlyNXy1nfA4CnE6BpBcYl5Jh6O9UVIaT0sCne7jPhGB/iJmibrJBq/9fmlmc3suh0NH0DQwZmAu7AOU9lrsNaU4s7SgVMKZ59MwBbdJ8oVPDQYb3Cik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757385883; c=relaxed/simple;
	bh=vGUvbRJIYDmlzWSNPWxBVXok9oKzdnLu+sdhjbuqVxE=;
	h=Date:To:From:Subject:Message-Id; b=Fp97tZYgqmBBy77hWkbAIOEkKf/0P0qdYs5zb31tIpfArYvXoczQQ3Z13LHVC9I7a3PBUPS87YTIMEl4xw82uSzOCMz5vydz+94FGxCfwlyBE40kWK3dybyk85NUmCugnauszl2I6Vvh98aOz+BOQ7EnY9mKPQ88X91fBB3Tmr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RfCFOAjX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RfCFOAjX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C29C4CEF1;
	Tue,  9 Sep 2025 02:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757385883;
	bh=vGUvbRJIYDmlzWSNPWxBVXok9oKzdnLu+sdhjbuqVxE=;
	h=Date:To:From:Subject:From;
	b=RfCFOAjXl++7W4WDhW9/l3dx11LXzwSzWXBJOEwxLDXvnC/dnujt+Odhn4LYl5rC8
	 1qIr1HHqdEE6S5C264TMRCdc2XwT91WVl5f+gDTXlnW1A7XeWfEGIWi1PzoP5gOoH5
	 ucWV5yDVDi+sdcNIMDvPjdKETOOkXTe0jA1X0Vqs=
Date: Mon, 08 Sep 2025 19:44:42 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,hughd@google.com,baolin.wang@linux.alibaba.com,liuyun01@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-remove-unused-entry_order-after-large-swapin-rework.patch added to mm-new branch
Message-Id: <20250909024443.08C29C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem: remove unused entry_order after large swapin rework
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-remove-unused-entry_order-after-large-swapin-rework.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-remove-unused-entry_order-after-large-swapin-rework.patch

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
@@ -2187,7 +2187,7 @@ static int shmem_split_large_entry(struc
 {
 	struct address_space *mapping = inode->i_mapping;
 	XA_STATE_ORDER(xas, &mapping->i_pages, index, 0);
-	int split_order = 0, entry_order;
+	int split_order = 0;
 	int i;
 
 	/* Convert user data gfp flags to xarray node gfp flags */
@@ -2205,15 +2205,12 @@ static int shmem_split_large_entry(struc
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

mm-shmem-remove-unused-entry_order-after-large-swapin-rework.patch

