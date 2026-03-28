Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6567A39FCE
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 16:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774715715; cv=none; b=TG21ts1EfbNePbpnOnMtGd0CxG7Xdjv+9U+ZyD0vdxggYT58zg3cVasnSgURL3GCdnuRXXC+7JeqM2rf9gklm+m04dasCuf9O2lvA2cB3dQiENJ/mrs7mnYnZf0TH1MojzkDvFsfsAP62e+L9/JYxZ/0TkLwngUM38/lPGiQMHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774715715; c=relaxed/simple;
	bh=dV4zSL3fdiXsWxvTBvv7ExY6uS9EPW/XI9KU0pce1Nc=;
	h=Date:To:From:Subject:Message-Id; b=e270Lzkzu1DE7XKmCmwsQjZwlcmhwjY/A8r7lstjv4TslFMAxFyz8oR07gIXYjsWdFuDfWDJHg/Z7Uf7KYaeJ2VnRU2AIzLzFa8IuBYO7H0UgiCvkUwYQnFc4allHcelRV0t7eVm3dFaaNv/T5qVgoCtcHMpqAndIzBpUkJHx68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LrQrGqnn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LrQrGqnn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0289C4CEF7;
	Sat, 28 Mar 2026 16:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774715715;
	bh=dV4zSL3fdiXsWxvTBvv7ExY6uS9EPW/XI9KU0pce1Nc=;
	h=Date:To:From:Subject:From;
	b=LrQrGqnn71qK9+dsABR3PwaBdRJqFKibnDELVaF6PDyoUUwWZXznuNCam1T04lqbU
	 hS+ptKTl+EreGEVzj6IcxDCL+tTO+2a9jnwofNFYHJmFH6z47CE4ZENuVqsde2+rFv
	 mNKrfPzfd5G1PDP5QwMyeod5s2fc02AD905Aozts=
Date: Sat, 28 Mar 2026 09:35:14 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,geliang@kernel.org,chrisl@kernel.org,baohua@kernel.org,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation-v5.patch removed from -mm tree
Message-Id: <20260328163514.F0289C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation-v5
has been removed from the -mm tree.  Its filename was
     mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation-v5.patch

This patch was dropped because it was folded into mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation.patch

------------------------------------------------------
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation-v5
Date: Thu, 12 Mar 2026 10:30:24 +0800


initialize `flags', per Chris

Link: https://lkml.kernel.org/r/20260312023024.903143-1-hui.zhu@linux.dev
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Reviewed-by: Youngjun Park <youngjun.park@lge.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation-v5
+++ a/mm/swapfile.c
@@ -602,7 +602,7 @@ static struct swap_cluster_info *isolate
 		struct swap_info_struct *si, struct list_head *list)
 {
 	struct swap_cluster_info *ci, *found = NULL;
-	u8 flags;
+	u8 flags = CLUSTER_FLAG_NONE;
 
 	spin_lock(&si->lock);
 	list_for_each_entry(ci, list, list) {
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are

mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation.patch
zsmalloc-return-ebusy-for-zspage-migration-lock-contention.patch
mm-memcontrol-batch-memcg-charging-in-__memcg_slab_post_alloc_hook.patch

