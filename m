Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B155262BE
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 01:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753406043; cv=none; b=PY/uetQmRX4ENPX1xcQ9Ce1hsqHU5exeQkOPTN583woUyttQMkh/st6dOyk3MLoHxMyuCikR3GFDYozfqXqPoVxRJW31z/aqtLLNoTanycxqTjzxZDiBZwueVDM0Cjokric0pU4wgsR6HSGkbC3K3J/uYZY51Dyg6qp4ikaLdoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753406043; c=relaxed/simple;
	bh=fdpNFdt4azQ9qXUoV5su+jH82DKI1fc4OPX8FMTYRvc=;
	h=Date:To:From:Subject:Message-Id; b=LlMafUFCxAmpI2m38HdrX/WxaZ/V7aAVdqM8TD5tpHSrcft2EsgkSi4RBbiQKjmCQ1khU+4R2/P8tb6h5iWo+Nv+KEwjk4vMkjyJxi4EXp65YQOSrneLz6eardLZyBIZZoJtgTfNCPs1eJsd4sSDVC66IaTHw25uxuaqnvCs5EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u3WKa4oz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u3WKa4oz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970F2C4CEED;
	Fri, 25 Jul 2025 01:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753406042;
	bh=fdpNFdt4azQ9qXUoV5su+jH82DKI1fc4OPX8FMTYRvc=;
	h=Date:To:From:Subject:From;
	b=u3WKa4ozZKLKJrmZeoIjyBBUlnYUBEHKyFOpUOg+8MjmFbS3ZevsFa2IDroND26EN
	 KXf8DDXyPuEkyjxLGrlzhGb18LUTJxdK0Mu2PmLYXCAZMN3JfaxvTaj5KuFlqjcc7W
	 RBcl920udan+zvh/T0U5q5UDFdj3chqgcdgIoPBk=
Date: Thu, 24 Jul 2025 18:14:01 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryncsn@gmail.com,rientjes@google.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,21cnbao@gmail.com,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shmem-writeout-free-swap-if-swap_writeout-reactivates-fix.patch removed from -mm tree
Message-Id: <20250725011402.970F2C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shmem: writeout free swap if swap_writeout() reactivates fix
has been removed from the -mm tree.  Its filename was
     mm-shmem-writeout-free-swap-if-swap_writeout-reactivates-fix.patch

This patch was dropped because it was folded into mm-shmem-writeout-free-swap-if-swap_writeout-reactivates.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/shmem: writeout free swap if swap_writeout() reactivates fix
Date: Fri, 18 Jul 2025 17:56:52 -0700 (PDT)

Per Baolin: use shmem_recalc_inode() rather than open coding.

Link: https://lkml.kernel.org/r/101a7d89-290c-545d-8a6d-b1174ed8b1e5@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/shmem.c~mm-shmem-writeout-free-swap-if-swap_writeout-reactivates-fix
+++ a/mm/shmem.c
@@ -1692,9 +1692,7 @@ try_split:
 				__GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
 		/* Swap entry might be erased by racing shmem_free_swap() */
 		if (!error) {
-			spin_lock(&info->lock);
-			info->swapped -= nr_pages;
-			spin_unlock(&info->lock);
+			shmem_recalc_inode(inode, 0, -nr_pages);
 			swap_free_nr(folio->swap, nr_pages);
 		}
 
_

Patches currently in -mm which might be from hughd@google.com are

mm-optimize-lru_note_cost-by-adding-lru_note_cost_unlock_irq.patch
mm-shmem-hold-shmem_swaplist-spinlock-not-mutex-much-less.patch
mm-shmem-writeout-free-swap-if-swap_writeout-reactivates.patch

