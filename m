Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAA11EE007
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119247; cv=none; b=jW+4sxl0blM58/l+kfO25iETY3wmdA6l7Y5TswIEJFSjY+g850JLkklYEdFItP3BxPs39IkfbP3zEcb9NSQpI1lKv+EJN8Jt6Z3IK4dJ5GpmpCKgTjkjo26/9R3pHynGgxNyYFeMNMOZ324ztRBMlYjBk0lwuf8RzemTcc18aX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119247; c=relaxed/simple;
	bh=mtpDVMEH9g5pzvBtwuoi0e8605oveZ+H9tc1sCj0KpY=;
	h=Date:To:From:Subject:Message-Id; b=bg+oIV5YcYTZJkiQIMFK9onTSJbWFnPNIr8FtmUsR+qs8aBgjVsYjXY/bTp/3BdpmWuqOx/Eb1XiOrQv1m0Rl8Zs+enoClRy9USv2uIURrLYfFF82yRMNrbGNB5jzng4gkYXqW6vG9XaF3gwjMvTfuyjCa0NZ49ShBBeHYp9g7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OaZ797yq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OaZ797yq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53E4C4CEE4;
	Tue, 13 May 2025 06:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119246;
	bh=mtpDVMEH9g5pzvBtwuoi0e8605oveZ+H9tc1sCj0KpY=;
	h=Date:To:From:Subject:From;
	b=OaZ797yqwa5tpaTeVF5gW8SNtRKFB0BGrT4xUSwzzQw2x7N3YRmx/JbqlY9j3XUPd
	 tOMumevEIorKB9+wESsi5GfEtT6d0ykANwQyZemaRzOOOn9BrcMS0ICJjm5WYPvfWl
	 vcSnWwOz6zs7rSJUoawH9YNrL532tpggQ1XTRfHM=
Date: Mon, 12 May 2025 23:54:05 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rppt@kernel.org,riel@surriel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,anshuman.khandual@arm.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-numa-remove-unnecessary-local-variable-in-alloc_node_data.patch removed from -mm tree
Message-Id: <20250513065405.E53E4C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/numa: remove unnecessary local variable in alloc_node_data()
has been removed from the -mm tree.  Its filename was
     mm-numa-remove-unnecessary-local-variable-in-alloc_node_data.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/numa: remove unnecessary local variable in alloc_node_data()
Date: Sun, 27 Apr 2025 18:04:42 +0800

The temporary local variable 'nd' is redundant.  Directly assign the
virtual address to node_data[nid] to simplify the code.

No functional change.

Link: https://lkml.kernel.org/r/20250427100442.958352-4-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/numa.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/numa.c~mm-numa-remove-unnecessary-local-variable-in-alloc_node_data
+++ a/mm/numa.c
@@ -13,7 +13,6 @@ void __init alloc_node_data(int nid)
 {
 	const size_t nd_size = roundup(sizeof(pg_data_t), SMP_CACHE_BYTES);
 	u64 nd_pa;
-	void *nd;
 	int tnid;
 
 	/* Allocate node data.  Try node-local memory and then any node. */
@@ -21,7 +20,6 @@ void __init alloc_node_data(int nid)
 	if (!nd_pa)
 		panic("Cannot allocate %zu bytes for node %d data\n",
 		      nd_size, nid);
-	nd = __va(nd_pa);
 
 	/* report and initialize */
 	pr_info("NODE_DATA(%d) allocated [mem %#010Lx-%#010Lx]\n", nid,
@@ -30,7 +28,7 @@ void __init alloc_node_data(int nid)
 	if (tnid != nid)
 		pr_info("    NODE_DATA(%d) on node %d\n", nid, tnid);
 
-	node_data[nid] = nd;
+	node_data[nid] = __va(nd_pa);
 	memset(NODE_DATA(nid), 0, sizeof(pg_data_t));
 }
 
_

Patches currently in -mm which might be from liuye@kylinos.cn are


