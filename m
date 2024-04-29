Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D720F83A15
	for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2024 17:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714411165; cv=none; b=lsUlLvGZ6BhLwyN/7/gSTQkHVaOf0tDK49pKVRUgiJgXrZTsqwlpI2j23qL52lMnO+43gxAT3m7OFx8NBChWUz3bnG3bUmRhniLFH/wNPWHD6bRSqtbIZGsMphEmlSGI83Ts7/b29hsm8l6dyKbReHwcH63Ngb4Ph0cQL6ELp2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714411165; c=relaxed/simple;
	bh=DibO7cfcpRibJe38A3On4UByZLQVBHNknRui9aRslqc=;
	h=Date:To:From:Subject:Message-Id; b=dXixYhyeGejOwopVx36VS+l6oTYNe+lIJg8QrPrSN60OvRXQ2ZCvOo9NfiGcfcbj88EYjyprLOHFV41JaDuXqFP0kGHVc4lM5q8Fu12WnqTVipTDFcTUxoTD9c0R77a6GL9uwD3S8z+z6nNj082x42AbB32WZhE34dAFsMjOry4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gs0h196Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gs0h196Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22709C113CD;
	Mon, 29 Apr 2024 17:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714411165;
	bh=DibO7cfcpRibJe38A3On4UByZLQVBHNknRui9aRslqc=;
	h=Date:To:From:Subject:From;
	b=gs0h196ZZWffMCkDMO1djNX+XSicw87gzLeiyESdLbFRtC/3UEzsQ4xzf5W9PGWEK
	 iOR8gpTDoFc8SkyEPl9wPG2A+JqAvahsbvFTjD/rY5ssrROwiwYwES60sVV4Zz/bcE
	 7GIgZJE4HK6GNn0ntCbfWfN55odfpwuuFNMCy6ZY=
Date: Mon, 29 Apr 2024 10:19:23 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cleanup-workingset_nodes-in-workingset.patch added to mm-unstable branch
Message-Id: <20240429171925.22709C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: cleanup WORKINGSET_NODES in workingset
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cleanup-workingset_nodes-in-workingset.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cleanup-workingset_nodes-in-workingset.patch

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: mm: cleanup WORKINGSET_NODES in workingset
Date: Fri, 26 Apr 2024 17:37:33 -0700

WORKINGSET_NODES is not exposed in the memcg stats and thus there is no
need to use the memcg specific stat update functions for it.  In future if
we decide to expose WORKINGSET_NODES in the memcg stats, we can revert
this patch.

Link: https://lkml.kernel.org/r/20240427003733.3898961-8-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
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

memcg-simple-cleanup-of-stats-update-functions.patch
memcg-reduce-memory-size-of-mem_cgroup_events_index.patch
memcg-dynamically-allocate-lruvec_stats.patch
memcg-reduce-memory-for-the-lruvec-and-memcg-stats.patch
memcg-cleanup-__mod_memcg_lruvec_state.patch
memcg-pr_warn_once-for-unexpected-events-and-stats.patch
memcg-use-proper-type-for-mod_memcg_state.patch
mm-cleanup-workingset_nodes-in-workingset.patch

