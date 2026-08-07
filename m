Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAED392836
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068095; cv=none; b=PiOKzS1W/wfo5OIQxXfltlPm2b46Tb2Xsguw+dy/g31nqbxYCfgvq4Zj9wtkJDHd3Am9heR7XyRj+w6PP0FMDMltYHeCpt8Uns+3F8PZLx8d3KPIEl9wOHwB1V2MgoByY+na+6P/DlEAN9QJoZIn8OGCWg7X27d4QTB11QN31OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068095; c=relaxed/simple;
	bh=7E2TeGl9TmPV1Pmj5vcN1WnXmQejq4/aYWQYdvf1950=;
	h=Date:To:From:Subject:Message-Id; b=u2izOYJdOm9J0IGx0XQd2oyPyp+zTFktm6vkupJw7wsgK5DqMGc+gu6A/KQokEZKxRibgT3rzh4hGOmqmo6pqxE2/0ivJso1M0NvLhIWunYarLsiuuvZQply850vYAulzxim97zybo2KcPCNBvt5zEpp3YVQUgNQ0oFzrBg/sNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ljyZduf6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ljyZduf6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44101F00AC4;
	Fri,  7 Aug 2026 02:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068091;
	bh=4l9mzr3c0Y76Idxri3Z8w691fecxnvJXo2z1BYz8AfU=;
	h=Date:To:From:Subject;
	b=ljyZduf6gJ1uoXAdQlHGg8l3Pw3OerHL3LqTF9P4MmCSa8yJMrOvo9+XSjIMtKTsD
	 hvKNezMVBR+nUfEffjEWa5u4E08x3m0XA8cFCpWJdEdKVlrQWCSqSv2pQzcv/v9MXx
	 oXkQEnXwC+f4hwMr+HTBkAKkwZNHmvVbWARUkRAs=
Date: Thu, 06 Aug 2026 19:01:31 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tj@kernel.org,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,mkoutny@suse.com,mhocko@suse.com,longman@redhat.com,ljs@kernel.org,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,brendan.jackman@linux.dev,bigeasy@linutronix.de,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-remove-a-couple-of-vm_bug_onst.patch removed from -mm tree
Message-Id: <20260807020131.D44101F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: remove a couple of VM_BUG_ON()st
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-a-couple-of-vm_bug_onst.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/page_alloc: remove a couple of VM_BUG_ON()st
Date: Wed, 15 Jul 2026 11:03:21 +0000

VM_BUG_ON() is out of favour and on the way to removal, since I recently
touched alloc_pages_node_noprof() I am removing that invocation, and also
removing the __folio_alloc_node_noprof() one for consistency.  If this
precondition is violated, the system will soon crash anyway.

Link: https://lore.kernel.org/20260715-spin-trylock-followup-v3-4-fc4d246f705d@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Suggested-by: Zi Yan <ziy@nvidia.com>
Link: https://lore.kernel.org/all/7F866265-3F2E-4765-B9D4-9AB898A9C4AC@nvidia.com/
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    1 -
 mm/page_alloc.c     |    1 -
 2 files changed, 2 deletions(-)

--- a/include/linux/gfp.h~mm-page_alloc-remove-a-couple-of-vm_bug_onst
+++ a/include/linux/gfp.h
@@ -255,7 +255,6 @@ static inline void warn_if_node_offline(
 static inline
 struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
 {
-	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
 	warn_if_node_offline(nid, gfp);
 
 	return __folio_alloc_noprof(gfp, order, nid, NULL);
--- a/mm/page_alloc.c~mm-page_alloc-remove-a-couple-of-vm_bug_onst
+++ a/mm/page_alloc.c
@@ -5426,7 +5426,6 @@ struct page *alloc_pages_node_noprof(int
 	if (nid == NUMA_NO_NODE)
 		nid = numa_mem_id();
 
-	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
 	warn_if_node_offline(nid, gfp_mask);
 
 	return __alloc_pages_noprof(gfp_mask, order, nid, NULL, ALLOC_DEFAULT);
_

Patches currently in -mm which might be from jackmanb@google.com are


