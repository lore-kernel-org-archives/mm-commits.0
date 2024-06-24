Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EA44597F
	for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 21:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719265259; cv=none; b=UqTVnMe+8K7pEgnNpIN5HrcQ+r6O2e4MqDxmZAAY9lmAEI1LR3SbfGoMD5XH2LNI5fr+Gmrhsj77v1XX+s3aYeRJeZeCIuGEud8EXmN7tXlm0ktFii99nvpgCnq9udzJds4TNZxJd8sTiuBXOdvyvKqoB88/nlvDNAiVMUAeqYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719265259; c=relaxed/simple;
	bh=u3GapniBwIBzlZ9btARBNv9XB16f93g0sjsmpiaS4Zo=;
	h=Date:To:From:Subject:Message-Id; b=ESi9ma33jhb72K2bbvc+8VPJcHvHXY1CnxKojgQtr2ODx6AiGKjep/qOWQq7UVMqj2g2Ou01YrG5nxa3gjiekWHLwB7BuoNp0BRC9LpoE09cnhI15xe6OexulQhJDqP5xry7v8as5QDUDQ1KOpEq4blsgCC5gJIA9TP+1ss7qMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lNbE+zLi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lNbE+zLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4E0C2BBFC;
	Mon, 24 Jun 2024 21:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719265258;
	bh=u3GapniBwIBzlZ9btARBNv9XB16f93g0sjsmpiaS4Zo=;
	h=Date:To:From:Subject:From;
	b=lNbE+zLiXDy9rgFAG7vu0C7zoRtgj2Yvaydx8EcIP40jHCd+kkrsGTJGymZaITi8B
	 kmoSnqRqcdNmdgofb1b3cgalsu7XDbQyt916FzJxAB4DY+a3NNNOv3UO60XfQ4HfTy
	 DB1kIGSrBAm9XCoAzPb5PHF3oCz1qUVRPaYYNy3s=
Date: Mon, 24 Jun 2024 14:40:57 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,shakeel.butt@linux.dev,nphamcs@gmail.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chengming.zhou@linux.dev,ak@linux.intel.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v6.patch added to mm-unstable branch
Message-Id: <20240624214058.7F4E0C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v6
has been added to the -mm mm-unstable branch.  Its filename is
     mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v6.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v6.patch

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
From: Usama Arif <usamaarif642@gmail.com>
Subject: mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v6
Date: Mon, 24 Jun 2024 15:01:28 +0100

Change bitmap_zalloc/free to kvzalloc/free as a very large swap file will
result in the allocation order to exceed MAX_PAGE_ORDER resulting in
bitmap_zalloc to fail.  

Link: https://lkml.kernel.org/r/20240624140427.1334871-2-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/swapfile.c~mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v6
+++ a/mm/swapfile.c
@@ -2643,7 +2643,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	free_percpu(p->cluster_next_cpu);
 	p->cluster_next_cpu = NULL;
 	vfree(swap_map);
-	bitmap_free(p->zeromap);
+	kvfree(p->zeromap);
 	kvfree(cluster_info);
 	/* Destroy swap account information */
 	swap_cgroup_swapoff(p->type);
@@ -3170,7 +3170,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 		goto bad_swap_unlock_inode;
 	}
 
-	p->zeromap = bitmap_zalloc(maxpages, GFP_KERNEL);
+	p->zeromap = kvzalloc(DIV_ROUND_UP(maxpages, 8), GFP_KERNEL);
 	if (!p->zeromap) {
 		error = -ENOMEM;
 		goto bad_swap_unlock_inode;
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

mm-do-not-start-end-writeback-for-pages-stored-in-zswap.patch
mm-store-zero-pages-to-be-swapped-out-in-a-bitmap.patch
mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v6.patch
mm-remove-code-to-handle-same-filled-pages.patch

