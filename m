Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674A61C4A24
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 22:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766962600; cv=none; b=CSB+51rB9F6oW2ZiH1evTOa+CBrpGrOiQC0s8Ze541Rx0wlYfMvTpmKADkH5KN8OlbbJ9WfR9QbX+Bl8fDzQQRHaWMNb95bl3lkMAJn47EMByvuMl1LaN+ZZXfnxS2tu+GCn8bSKUS0EXA6/E/7Ls2HWMIExZp0Z4uuiHZ42KUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766962600; c=relaxed/simple;
	bh=fgGBbqKXls0+tD+JT6fS8tc6bQd7bz16ir8B5VQKByI=;
	h=Date:To:From:Subject:Message-Id; b=f5C/EGTw04o9lYR8YXQ6kkETixrqlCeY5/ggt9AFc1fhrQDic73zF8cefCIPyTCSjufZyE0UP8X2OHSmIyGVAOxRRzLbX7+66/UlMDIK7sRK0lLabuRMrKalc9Rl9qiUh3LPvV0OhVLp40a0uPDNlQqyJWg8/PDh9jCtfHRvHU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bjv8HFr+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bjv8HFr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B15C4CEFB;
	Sun, 28 Dec 2025 22:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766962599;
	bh=fgGBbqKXls0+tD+JT6fS8tc6bQd7bz16ir8B5VQKByI=;
	h=Date:To:From:Subject:From;
	b=bjv8HFr+cbuSWTL9oRcvc3hzzITPmvtqtGMhXwu7ezDmFTgvrSOqr6E40Y5RrSAU1
	 3d87f7uWrMNSv6cf5tZZM5vX1Tk/Njs72tcbbE0Wo4b/G0UuB9gfYwttz47JeJTQlk
	 VXAo6CsbBxV+9Jn6LhYv/da6Pz9U5eRzsJEXypF0=
Date: Sun, 28 Dec 2025 14:56:39 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,yosry.ahmed@linux.dev,willy@infradead.org,weixugc@google.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,nphamcs@gmail.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,david.laight.linux@gmail.com,david@kernel.org,chengming.zhou@linux.dev,axelrasmussen@google.com,chandna.sahil@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-vmscan-use-%pe-to-print-error-pointers.patch removed from -mm tree
Message-Id: <20251228225639.C2B15C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: use %pe to print error pointers
has been removed from the -mm tree.  Its filename was
     mm-vmscan-use-%pe-to-print-error-pointers.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Sahil Chandna <chandna.sahil@gmail.com>
Subject: mm/vmscan: use %pe to print error pointers
Date: Fri, 28 Nov 2025 12:31:43 +0530

Use the %pe printk format specifier to report error pointers directly
instead of printing PTR_ERR() as a long value.  This improves clarity,
produces more readable error messages.

This instance was flagged by the Coccinelle script
(misc/ptr_err_to_pe.cocci) as an opportunity to adopt %pe.

Found by: make coccicheck MODE=report M=mm/
No functional change intended

Link: https://lkml.kernel.org/r/2c842a64fddeb0fe0cac087783aaedd97edc3191.1764312627.git.chandna.sahil@gmail.com
Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-use-%pe-to-print-error-pointers
+++ a/mm/vmscan.c
@@ -7450,8 +7450,8 @@ void __meminit kswapd_run(int nid)
 		pgdat->kswapd = kthread_create_on_node(kswapd, pgdat, nid, "kswapd%d", nid);
 		if (IS_ERR(pgdat->kswapd)) {
 			/* failure at boot is fatal */
-			pr_err("Failed to start kswapd on node %d，ret=%ld\n",
-				   nid, PTR_ERR(pgdat->kswapd));
+			pr_err("Failed to start kswapd on node %d. ret=%pe\n",
+				   nid, pgdat->kswapd);
 			BUG_ON(system_state < SYSTEM_RUNNING);
 			pgdat->kswapd = NULL;
 		} else {
_

Patches currently in -mm which might be from chandna.sahil@gmail.com are

mm-zswap-use-%pe-to-print-error-pointers.patch

