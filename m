Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D27383A6
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706596908; cv=none; b=OBDYqFyuLRp76s+r89qeVstjXrWkIo5QYF24aPA3V8M0ye14GJHnqd1RtjzCio4sOIDPm0tMszAzyIrgqxOZL1uq6J0u/KcVxuWXkyfGH8BjEGhecLFcpeftUPWH0ZYAeHkxKnY8om1Y2rk5dKtX12WGMibeYpdFzDVRCPfi+8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706596908; c=relaxed/simple;
	bh=uhDJUWwVo+376rTCqyG2ZImAZecgIOlcMA3zCLLcyAI=;
	h=Date:To:From:Subject:Message-Id; b=bM/VPLHKLEDL5xsJ/whO5ebgS+BfASGv3SpCtOJUjy23HP1vHu+MNsiZvLdcQksLFiYu+4Y/blN1rz4JXbKqZGGe9lgT6lsZY8vUdiKf/cfzGKG5uGv3VvXrA0kOdvktiy7HCNThYQ7V7RSVDea9UM1on3pzJmWjxZ5UYtYXw+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IqoHWAMU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IqoHWAMU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DAAC433C7;
	Tue, 30 Jan 2024 06:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706596908;
	bh=uhDJUWwVo+376rTCqyG2ZImAZecgIOlcMA3zCLLcyAI=;
	h=Date:To:From:Subject:From;
	b=IqoHWAMU11PgKMs31+YXxEiQryOewHm5mCZ/Yp5BVtBYhBGmVkJ4MHw24QKfobjMX
	 R14nH4+OEBV1Nmneg3CMtCepCpQCb91L73Q3nxJbibs+AEWnYD9bZ4B8QSRiLoi7dj
	 n/bohf10GR/Vpu+Zf/7AaXiJ8LSuXJ6M9vOZvcGA=
Date: Mon, 29 Jan 2024 22:41:34 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-simplify-zswap_invalidate.patch added to mm-unstable branch
Message-Id: <20240130064146.98DAAC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: simplify zswap_invalidate()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-simplify-zswap_invalidate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-simplify-zswap_invalidate.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: simplify zswap_invalidate()
Date: Mon, 29 Jan 2024 20:36:45 -0500

The branching is awkward and duplicates code. The comment about
writeback is also misleading: yes, the entry might have been written
back. Or it might have never been stored in zswap to begin with due to
a rejection - zswap_invalidate() is called on all exiting swap entries.

Link: https://lkml.kernel.org/r/20240130014208.565554-10-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/mm/zswap.c~mm-zswap-simplify-zswap_invalidate
+++ a/mm/zswap.c
@@ -1739,15 +1739,10 @@ void zswap_invalidate(int type, pgoff_t
 	struct zswap_tree *tree = swap_zswap_tree(swp_entry(type, offset));
 	struct zswap_entry *entry;
 
-	/* find */
 	spin_lock(&tree->lock);
 	entry = zswap_rb_search(&tree->rbroot, offset);
-	if (!entry) {
-		/* entry was written back */
-		spin_unlock(&tree->lock);
-		return;
-	}
-	zswap_invalidate_entry(tree, entry);
+	if (entry)
+		zswap_invalidate_entry(tree, entry);
 	spin_unlock(&tree->lock);
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-zswap-fix-objcg-use-after-free-in-entry-destruction.patch
mm-zswap-rename-zswap_free_entry-to-zswap_entry_free.patch
mm-zswap-inline-and-remove-zswap_entry_find_get.patch
mm-zswap-move-zswap_invalidate_entry-to-related-functions.patch
mm-zswap-warn-when-referencing-a-dead-entry.patch
mm-zswap-clean-up-zswap_entry_put.patch
mm-zswap-rename-__zswap_load-to-zswap_decompress.patch
mm-zswap-break-out-zwap_compress.patch
mm-zswap-further-cleanup-zswap_store.patch
mm-zswap-simplify-zswap_invalidate.patch
mm-zswap-function-ordering-pool-alloc-free.patch
mm-zswap-function-ordering-pool-refcounting.patch
mm-zswap-function-ordering-zswap_pools.patch
mm-zswap-function-ordering-pool-params.patch
mm-zswap-function-ordering-public-lru-api.patch
mm-zswap-function-ordering-move-entry-sections-out-of-lru-section.patch
mm-zswap-function-ordering-move-entry-section-out-of-tree-section.patch
mm-zswap-function-ordering-compress-decompress-functions.patch
mm-zswap-function-ordering-per-cpu-compression-infra.patch
mm-zswap-function-ordering-writeback.patch
mm-zswap-function-ordering-shrink_memcg_cb.patch

