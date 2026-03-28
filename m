Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B7433C18B
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 16:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774715710; cv=none; b=XEK1COLOgIeEXkm0O8INKz+tG/t1t5KPneyCjOaovPcFSNI13n+LmSoot4/pl2js728gzZkSDkTNQ8duTPmK/eesRL0b+WEjcupIb/4BugLH6ZS9gGrzxb1vfY44L7XxaMb4F0wBfzuIXNLXF/o97Zs3zjYOg0k3h9pXs6sWpn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774715710; c=relaxed/simple;
	bh=4U1m9BIwDVksIToD0gL8J5nu0iUoAElQiX0pY76DB88=;
	h=Date:To:From:Subject:Message-Id; b=YgnU39O7T6fJM0U+sre6tAzCxGdOh8FYdWF3i4n/Of5gy92JzATrL2IlZYI/8kXAyAQ5RjTIbXZrAqJGEGLVd0GhIwB2IkBNuLN2hqgmqkQjST4+gvBowFQ2nv1qKciFrB0jU96ywgQZ7MTna+Bic72L97LQ5rHPQKh/hDM76i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tob74fmv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tob74fmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63FC9C4CEF7;
	Sat, 28 Mar 2026 16:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774715709;
	bh=4U1m9BIwDVksIToD0gL8J5nu0iUoAElQiX0pY76DB88=;
	h=Date:To:From:Subject:From;
	b=Tob74fmvVqq007eOI9uzaV7BpT3syBjqLR6fh8U+FjLz4fc+XRa7Sk3I9WcvKhsTz
	 9VpvSXwX4tYpRHaZ1JdsXxcMAReYYFhONI3rCatSJS9Gmy+/a1GXXYjjX8OO0EaPSj
	 NiylgZY4ZzM6UMll+UPgZcLWqdeJEbL7+jf03FUI=
Date: Sat, 28 Mar 2026 09:35:08 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation-v4.patch removed from -mm tree
Message-Id: <20260328163509.63FC9C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation-v4
has been removed from the -mm tree.  Its filename was
     mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation-v4.patch

This patch was dropped because it was folded into mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation.patch

------------------------------------------------------
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation-v4
Date: Wed, 11 Mar 2026 10:22:41 +0800

remove redundant comment, per Barry

Link: https://lkml.kernel.org/r/20260311022241.177801-1-hui.zhu@linux.dev
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Reviewed-by: Youngjun Park <youngjun.park@lge.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation-v4
+++ a/mm/swapfile.c
@@ -623,10 +623,8 @@ static struct swap_cluster_info *isolate
 	spin_unlock(&si->lock);
 
 	if (found && !cluster_table_is_alloced(found)) {
-		/* Table of non-free cluster must be allocated. */
-		VM_WARN_ON_ONCE(flags != CLUSTER_FLAG_FREE);
-
 		/* Only an empty free cluster's swap table can be freed. */
+		VM_WARN_ON_ONCE(flags != CLUSTER_FLAG_FREE);
 		VM_WARN_ON_ONCE(list != &si->free_clusters);
 		VM_WARN_ON_ONCE(!cluster_is_empty(found));
 		return swap_cluster_alloc_table(si, found);
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are

mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation.patch
mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation-v5.patch
zsmalloc-return-ebusy-for-zspage-migration-lock-contention.patch
mm-memcontrol-batch-memcg-charging-in-__memcg_slab_post_alloc_hook.patch

