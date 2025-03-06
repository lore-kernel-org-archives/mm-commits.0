Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77AB019E971
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 05:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741239471; cv=none; b=ZVPf1FfPd6pAJ4kx5gw5oBmsN/hMowAwG86xnyJGjeUODH3KztXqUUt9xGy7ZZ1kEOLZMBEEtOt3oTtv7LKKgZRyeuZLrvfp8O5XGRtCqqeBpxj0U1LODUrrsLQDIrYIcPmAdsYpFsKAq3ZE6/HSYuEklfneOEJu41EaC9rnhyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741239471; c=relaxed/simple;
	bh=P/QfvxjxOPRlkSqx13dWg5IdtJSxCUNiSrqGFQLI0Fc=;
	h=Date:To:From:Subject:Message-Id; b=a1Uy0Jbt+qIFOKkj6E6FB+kl0SHuOa9L2N+qqdxcTUT8T+Rf1Po7rXD5OOTmgOYbrPoYj4WImQIt6rt21N/b7xjIhipGcvhlV2Ifh9InZonJQeH20TIfzD4sXGhr9ZCdbSe+2dYMv/ymo+TzlCmnhcg6Y7CQo7UIo9GSVC9Ks2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kgdE+yM2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kgdE+yM2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E64C4CEE9;
	Thu,  6 Mar 2025 05:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741239471;
	bh=P/QfvxjxOPRlkSqx13dWg5IdtJSxCUNiSrqGFQLI0Fc=;
	h=Date:To:From:Subject:From;
	b=kgdE+yM2DpRu2F0CblQHLMk6ts1vWkXk/PQ7xw0BDt+rYwW1JFsP7H8bY75ifkR6D
	 1pB4AFm6v4soPzaXWukL2thZpLYmuzIqOrp6J4DD1v3YUl8WigFTQWYUG+oWNu0TZW
	 8b4xh8T1yef+dNHfQVijh0KhHNAqo8RN+SGtnEiU=
Date: Wed, 05 Mar 2025 21:37:50 -0800
To: mm-commits@vger.kernel.org,revest@chromium.org,pengfei.xu@intel.com,mcgrof@kernel.org,hughd@google.com,david@redhat.com,dave@stgolabs.net,brauner@kernel.org,baolin.wang@linux.alibaba.com,rcn@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-shmem-remove-unnecessary-warning-in-shmem_writepage.patch removed from -mm tree
Message-Id: <20250306053751.47E64C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: remove unnecessary warning in shmem_writepage()
has been removed from the -mm tree.  Its filename was
     mm-shmem-remove-unnecessary-warning-in-shmem_writepage.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ricardo Cañuelo Navarro <rcn@igalia.com>
Subject: mm: shmem: remove unnecessary warning in shmem_writepage()
Date: Wed, 26 Feb 2025 13:26:27 +0100

Although the scenario where shmem_writepage() is called with info->flags &
VM_LOCKED is unlikely to happen, it's still possible, as evidenced by
syzbot [1].  However, the warning in this case isn't necessary because the
situation is already handled correctly [2].

[2] https://lore.kernel.org/lkml/8afe1f7f-31a2-4fc0-1fbd-f9ba8a116fe3@google.com/

Link: https://lkml.kernel.org/r/20250226-20250221-warning-in-shmem_writepage-v1-1-5ad19420e17e@igalia.com
Fixes: 9a976f0c847b ("shmem: skip page split if we're not reclaiming")
Signed-off-by: Ricardo Cañuelo Navarro <rcn@igalia.com>
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Closes: https://lore.kernel.org/lkml/ZZ9PShXjKJkVelNm@xpf.sh.intel.com/ [1]
Suggested-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Florent Revest <revest@chromium.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Florent Revest <revest@chromium.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-remove-unnecessary-warning-in-shmem_writepage
+++ a/mm/shmem.c
@@ -1548,7 +1548,7 @@ static int shmem_writepage(struct page *
 	if (WARN_ON_ONCE(!wbc->for_reclaim))
 		goto redirty;
 
-	if (WARN_ON_ONCE((info->flags & VM_LOCKED) || sbinfo->noswap))
+	if ((info->flags & VM_LOCKED) || sbinfo->noswap)
 		goto redirty;
 
 	if (!total_swap_pages)
_

Patches currently in -mm which might be from rcn@igalia.com are


