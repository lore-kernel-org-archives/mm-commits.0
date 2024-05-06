Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BCD39AF4
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957154; cv=none; b=MqUyXT63KnN3pLutXdCeKK0c5+iryv+wZWh2gNWB0ejFXLTla/WrB3ZbnKimVk6tgA18q2BSP1XJiZBSwtyp43WHpCxyS9/JUOMQzeZ+cUPUQCayHwG1viWCwFIOcQhEVB7r3/llR9Mf8bcnUvn0XVbNIOt6hO1QIwvfRwHedUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957154; c=relaxed/simple;
	bh=LVGbHTBKJBKPt1apIbBX6FNrZX6xyC/lk9F7wuD8eL4=;
	h=Date:To:From:Subject:Message-Id; b=XkAv+3AImIfxdjIfGS8u9YdjcMehZuw/TDV3xkAqg8TH6h8NTXyvPzxOoDxkyW/ZqxX+h66Gmy2uJOW8RvbxvF/2E3xLQhoy1bJ1xwazj+dUt6iWigbbskQXaJHdDdTQpglr+PxDM8K0chIceI/f286e0FLkr6VzM18qaYoz8kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HeSCFLnF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HeSCFLnF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F58AC113CC;
	Mon,  6 May 2024 00:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957154;
	bh=LVGbHTBKJBKPt1apIbBX6FNrZX6xyC/lk9F7wuD8eL4=;
	h=Date:To:From:Subject:From;
	b=HeSCFLnFRh4wnhbK5Q68QmD9YDgpgG3aRJo7SFXMwcHEUGTw7Cdwpbqw7r5caYGsb
	 7sg2GTVYmYgwuddJ1PISIpQZtUnJi89qBbbEFkX9p5OajSvf4d4a/hDPVs5eQb/n4V
	 iayB5ixqAslw9y/jmaj0Kst7j56cK2wpa7dKx3Pk=
Date: Sun, 05 May 2024 17:59:13 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cleanup-workingset_nodes-in-workingset.patch removed from -mm tree
Message-Id: <20240506005914.2F58AC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: cleanup WORKINGSET_NODES in workingset
has been removed from the -mm tree.  Its filename was
     mm-cleanup-workingset_nodes-in-workingset.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: mm: cleanup WORKINGSET_NODES in workingset
Date: Wed, 1 May 2024 10:26:15 -0700

WORKINGSET_NODES is not exposed in the memcg stats and thus there is no
need to use the memcg specific stat update functions for it.  In future if
we decide to expose WORKINGSET_NODES in the memcg stats, we can revert
this patch.

Link: https://lkml.kernel.org/r/20240501172617.678560-7-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/workingset.c~mm-cleanup-workingset_nodes-in-workingset
+++ a/mm/workingset.c
@@ -618,6 +618,7 @@ struct list_lru shadow_nodes;
 void workingset_update_node(struct xa_node *node)
 {
 	struct address_space *mapping;
+	struct page *page = virt_to_page(node);
 
 	/*
 	 * Track non-empty nodes that contain only shadow entries;
@@ -633,12 +634,12 @@ void workingset_update_node(struct xa_no
 	if (node->count && node->count == node->nr_values) {
 		if (list_empty(&node->private_list)) {
 			list_lru_add_obj(&shadow_nodes, &node->private_list);
-			__inc_lruvec_kmem_state(node, WORKINGSET_NODES);
+			__inc_node_page_state(page, WORKINGSET_NODES);
 		}
 	} else {
 		if (!list_empty(&node->private_list)) {
 			list_lru_del_obj(&shadow_nodes, &node->private_list);
-			__dec_lruvec_kmem_state(node, WORKINGSET_NODES);
+			__dec_node_page_state(page, WORKINGSET_NODES);
 		}
 	}
 }
@@ -742,7 +743,7 @@ static enum lru_status shadow_lru_isolat
 	}
 
 	list_lru_isolate(lru, item);
-	__dec_lruvec_kmem_state(node, WORKINGSET_NODES);
+	__dec_node_page_state(virt_to_page(node), WORKINGSET_NODES);
 
 	spin_unlock(lru_lock);
 
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


