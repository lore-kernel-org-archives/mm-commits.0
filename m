Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8036134A9
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720291580; cv=none; b=KQuulPQDfZuf6INi3fSieMohNuvwXS7N0xYS9kMRKTf6rUOscQuzFpfX1q5HCBid8WKRb4c86CQjKlSeHmRIaB4e0wRnmQGmioUjnhy5mPYsmpR2w2GB1bsXdcxh+iJbwd873BqabUd/UfkKQVjAE8kMAtR8DD45RgIU1Jb98K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720291580; c=relaxed/simple;
	bh=jkvxpnyKncKFJDppU2XdSaQ34CIoGdB9NZ2MBzoeA7c=;
	h=Date:To:From:Subject:Message-Id; b=ovF75eQzTtlxZVLwNJtYnx3vw9OuI1CSh4LD1tpw651vCr1W/9YjPYEJ/R7dtqYP5sa8YACI9OUWnuy0hCmOn3ATKKzvpEwaLlAX2EABpB5h/B+A7WhFRKxPsAuRiOb0hSsBrHw0mRfCXEFRnQpLOog2+7eYjQ/u9okIZqzqOyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s9DBS2kz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s9DBS2kz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C7EC2BD10;
	Sat,  6 Jul 2024 18:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720291579;
	bh=jkvxpnyKncKFJDppU2XdSaQ34CIoGdB9NZ2MBzoeA7c=;
	h=Date:To:From:Subject:From;
	b=s9DBS2kz/L6vOZrkR4xLsSW7dD2oXZHeqlSdo/ZUg4pd0CHG9K9lPBkeWzPXb+mB5
	 CTV34tLEbBnglovxLhtKTOHPcJ8ZWWcrSQeJ64OHUwwHzYtsn9Xxhg7GzwZCAN88EL
	 0D3z3ReXjQ3CNSYvsk0KsR4qZaRHIALxJBVPkJH0=
Date: Sat, 06 Jul 2024 11:46:19 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,shakeel.butt@linux.dev,nphamcs@gmail.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chengming.zhou@linux.dev,ak@linux.intel.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v6.patch removed from -mm tree
Message-Id: <20240706184619.B0C7EC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v6
has been removed from the -mm tree.  Its filename was
     mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v6.patch

This patch was dropped because it was folded into mm-store-zero-pages-to-be-swapped-out-in-a-bitmap.patch

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
@@ -2653,7 +2653,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	free_percpu(p->cluster_next_cpu);
 	p->cluster_next_cpu = NULL;
 	vfree(swap_map);
-	bitmap_free(p->zeromap);
+	kvfree(p->zeromap);
 	kvfree(cluster_info);
 	/* Destroy swap account information */
 	swap_cgroup_swapoff(p->type);
@@ -3180,7 +3180,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 		goto bad_swap_unlock_inode;
 	}
 
-	p->zeromap = bitmap_zalloc(maxpages, GFP_KERNEL);
+	p->zeromap = kvzalloc(DIV_ROUND_UP(maxpages, 8), GFP_KERNEL);
 	if (!p->zeromap) {
 		error = -ENOMEM;
 		goto bad_swap_unlock_inode;
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

mm-store-zero-pages-to-be-swapped-out-in-a-bitmap.patch
mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7.patch
mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v8.patch
mm-remove-code-to-handle-same-filled-pages.patch

