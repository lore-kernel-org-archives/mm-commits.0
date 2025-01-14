Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400751C1F15
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836911; cv=none; b=J40wC4Cn4OBbsCyeg8eJzVMmz7D09wU2yMNOTfFKJ/N6AdO8Oc8zG3WEtKZhMnfiCxd0JMJGXC3yEvteLclDCw0n4dsR5gSBIKsmcfwJDJUEc/yVAvdXwi7KXk3RC1X8EwTpEeA7KHFCMq+9Gz2ruyTbzSR3zDGJrdMSbeb3NE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836911; c=relaxed/simple;
	bh=UsbckAwBFu0fEiZc/QsSyGLXFpVyM30MCkYr449WMFg=;
	h=Date:To:From:Subject:Message-Id; b=hK7VgwqncE1vt74bzMlU4Em2WtomYuo5O3ZHSVQbsBSGMoIYAWx7ZQ91m+B3Qj6/z4CnRNE0bB6UMWWi2f9vimkslbpin5rzrUKBF3f+QV069qc/zofnzT6sLA2hsq63xSyWVuV8WPDX1y/ZXxsXD7bJtSeVyspJXH0ldOoqoWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kGjmduU6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kGjmduU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B3BC4CEDD;
	Tue, 14 Jan 2025 06:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836910;
	bh=UsbckAwBFu0fEiZc/QsSyGLXFpVyM30MCkYr449WMFg=;
	h=Date:To:From:Subject:From;
	b=kGjmduU6nF9Nhzvuar0XV+Q2TwGn+hWBjxZ1coMOTeHNbOBFWYi9/RNHhfJ2GK4O5
	 18DFKXfH8ffeImzU3rVDi6oGT6OHo9kB7NhywUUz+7ljtxEaHFrGSRBZO6q4M4Yfxx
	 LCLoPkRIUz5l3WjPngApXEHlACFSNfu/ebvP8L+E=
Date: Mon, 13 Jan 2025 22:41:50 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-add-lru_stop-to-comment-about-dropping-the-lru-lock.patch removed from -mm tree
Message-Id: <20250114064150.C1B3BC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: add LRU_STOP to comment about dropping the lru lock
has been removed from the -mm tree.  Its filename was
     mm-zswap-add-lru_stop-to-comment-about-dropping-the-lru-lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alice Ryhl <aliceryhl@google.com>
Subject: mm/zswap: add LRU_STOP to comment about dropping the lru lock
Date: Wed, 27 Nov 2024 13:53:29 +0000

This function has been able to return LRU_STOP since commit b49547ade38a
("mm/zswap: stop lru list shrinking when encounter warm region").  To
reduce confusion, update the comment to also list LRU_STOP as an option.

Link: https://lkml.kernel.org/r/20241127-lru-stop-comment-v1-1-f54a7cba9429@google.com
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-add-lru_stop-to-comment-about-dropping-the-lru-lock
+++ a/mm/zswap.c
@@ -1186,7 +1186,7 @@ static enum lru_status shrink_memcg_cb(s
 
 	/*
 	 * It's safe to drop the lock here because we return either
-	 * LRU_REMOVED_RETRY or LRU_RETRY.
+	 * LRU_REMOVED_RETRY, LRU_RETRY or LRU_STOP.
 	 */
 	spin_unlock(&l->lock);
 
_

Patches currently in -mm which might be from aliceryhl@google.com are


