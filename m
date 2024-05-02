Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBB615B117
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 15:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714664164; cv=none; b=IBDTaHLivuJBG++qmNJ5fQsA9xHV4YXFMr2hZUntrE2vL1dbMvCxTkjbR09ClKPoMWOZSzfCYIa/GcRVeBqD9QaodMR/2EcnUhFdmTp8ErlKRtq1rS6yPP2OiWyxBk85bUduECljcDsP4m3as1eeOuR/cHakuC3FYMjT3tIQiBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714664164; c=relaxed/simple;
	bh=+EK7DYjD9XFTUzGoZnFV+ekZwAoWHyfPWLfCdbc5KNM=;
	h=Date:To:From:Subject:Message-Id; b=Nu4DVyTgsvehuAIw3MZoIk1/z5j31zpmUlnffJSFkFMAs/26AOLGikCSLAdzlOyPgC9fuQujmRbWT6KPRtOex86vcH3a5J819VRaoZFAPCEBG8og+Z46iwZwnTBaS6z4kOV8fqL92qUSIcj/zNebUuxzQ5ix+P74WDZmtUtMtug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IUH7t2Ye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IUH7t2Ye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE98AC113CC;
	Thu,  2 May 2024 15:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714664164;
	bh=+EK7DYjD9XFTUzGoZnFV+ekZwAoWHyfPWLfCdbc5KNM=;
	h=Date:To:From:Subject:From;
	b=IUH7t2Yec6zuMBRMadduFuqDxdgAk/mQqLCdlv5j7R7h+Ox0q9nyYSitQBNryxHW4
	 e6N51ibaRvcF6sCZ/5MqTawphTulq/8cT6GWWuxLUL2D5yN03hJEwhcXssrQFiL+Rc
	 Nn9Ikrk/Pi47hDVODUADW6e6IgXttvEM34pCMTTs=
Date: Thu, 02 May 2024 08:36:02 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cleanup-workingset_nodes-in-workingset.patch added to mm-unstable branch
Message-Id: <20240502153603.EE98AC113CC@smtp.kernel.org>
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

memcg-simple-cleanup-of-stats-update-functions.patch
memcg-reduce-memory-size-of-mem_cgroup_events_index.patch
memcg-dynamically-allocate-lruvec_stats.patch
memcg-reduce-memory-for-the-lruvec-and-memcg-stats.patch
memcg-cleanup-__mod_memcg_lruvec_state.patch
mm-cleanup-workingset_nodes-in-workingset.patch
memcg-warn-for-unexpected-events-and-stats.patch
memcg-use-proper-type-for-mod_memcg_state.patch

