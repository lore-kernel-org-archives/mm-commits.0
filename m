Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD22FA944
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 22:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764024770; cv=none; b=EgifoMLPG5t+6VKz005l0tDSi+s5OJa9cbx8NAg5J7niMMm1ZmopgPazUo88DPZb50+rETDyjLWke++NbtSuYwUer7P8NG0kSgoINYUZqFs/zCbR3i7DDkMPEm0JwYPp/9qcGauHn9sJs/fSXDUA9LNq+QyJJU35ws3x9jiAlDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764024770; c=relaxed/simple;
	bh=Km1HDEoE88l6fDDP2WTVqoehzibHbEEotx1EGU3DXWM=;
	h=Date:To:From:Subject:Message-Id; b=oQGSqC6AdQ/8neJswtL8VkBGoYB+g4QBERV1sHgcqPZqqRmmoRuzY4Q01yzzZLe/QRjqepzFOpAqAyp9R1ecRHkoHYPnL5wfP+ICpDkAK5P+6GbIlaxnOjSA2tmyf9xXNfXhk6auS3//2vPAWDIiJWuAFvDTwN58KsAsPElgvck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nPRfTgzM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nPRfTgzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762C9C4CEF1;
	Mon, 24 Nov 2025 22:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764024768;
	bh=Km1HDEoE88l6fDDP2WTVqoehzibHbEEotx1EGU3DXWM=;
	h=Date:To:From:Subject:From;
	b=nPRfTgzMYW0R6b39Nbl5KgMOyDEXmveBV51ewrcjcxsvS6UY7ViKGfZNA/YO928DF
	 +71/JQQlX0tPKviHnyMiTXJiT71VTOCI+rfzrizWSd4zk1lZxMiw42b1zXwbNllhuY
	 R80ogVUXNcRzRMSX+n/VaaNkB8ktXMA4JAN8ouMs=
Date: Mon, 24 Nov 2025 14:52:47 -0800
To: mm-commits@vger.kernel.org,balbirs@nvidia.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix-fix.patch removed from -mm tree
Message-Id: <20251124225248.762C9C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix-fix.patch

This patch was dropped because it was folded into mm-huge_memoryc-introduce-folio_split_unmapped.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix-fix
Date: Thu Nov 20 07:59:25 AM PST 2025

add `inline' to shmem_uncharge() stub, per Balbir

Cc: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/shmem_fs.h~mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix-fix
+++ a/include/linux/shmem_fs.h
@@ -143,7 +143,7 @@ static inline unsigned long shmem_swap_u
 	return 0;
 }
 
-static void shmem_uncharge(struct inode *inode, long pages)
+static inline void shmem_uncharge(struct inode *inode, long pages)
 {
 }
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-huge_memoryc-introduce-folio_split_unmapped.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch

