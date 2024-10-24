Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55C8178362
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 06:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729750530; cv=none; b=cwI8RiLawtdxxLFZ/g1LZQwrzSa+vhHdapw2nL1m4QT2E+0LUS3Spfl7dCGH6AB0lOyvo2/fBX//0+GvAhSJ/zgxeC+VzOri3cxzucaiDEgI3WVIteTOnC46y+xKZcjHhPY+CyWsBQNaU1qgSrqkImEYHTNvjF7IL+V1AXqqAno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729750530; c=relaxed/simple;
	bh=2hFFnHaNQ+CxzFbM/rbODqK1fQKI0T1Ci8iPPiUQkgM=;
	h=Date:To:From:Subject:Message-Id; b=se+4woONXtYascH+rCTx0ij3T37a0IwUeEdtkqUowFX3gQy/PU4sKVKrScyDBMnxif5xZMzz81gNJWZ1Pr7Ff4CkrAQfk1FL8NMrT6qfF2j3HJDRhrmWULPeicIiyu78SZntP4FsDEMXEpuC9FiCcLDPPfExu5cJptg8ZrZWiUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z2NPdoRu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z2NPdoRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9205AC4CEE7;
	Thu, 24 Oct 2024 06:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729750530;
	bh=2hFFnHaNQ+CxzFbM/rbODqK1fQKI0T1Ci8iPPiUQkgM=;
	h=Date:To:From:Subject:From;
	b=z2NPdoRug9kFyta+0uYKNQrVWkm/9EvKgpTsXVOvuWdoS9A526eRiEv4mtU/IoMWM
	 bGVe+3RUsRbFmMRMjgl7yyAL2uvAjxAXdfLUz5zz7lsb9Vd8bgnVHj9ZFYzqVwwjAx
	 mdwbS6amdAplErJdKjYYu+ueUaPBZn9VIdL+4ep4=
Date: Wed, 23 Oct 2024 23:15:30 -0700
To: mm-commits@vger.kernel.org,yuji2.ishikawa@toshiba.co.jp,rppt@kernel.org,anshuman.khandual@arm.com,nobuhiro1.iwamatsu@toshiba.co.jp,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-numa_clear_kernel_node_hotplug-add-numa_no_node-check-for-node-id.patch removed from -mm tree
Message-Id: <20241024061530.9205AC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: numa_clear_kernel_node_hotplug: Add NUMA_NO_NODE check for node id
has been removed from the -mm tree.  Its filename was
     mm-numa_clear_kernel_node_hotplug-add-numa_no_node-check-for-node-id.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: mm: numa_clear_kernel_node_hotplug: Add NUMA_NO_NODE check for node id
Date: Wed, 16 Oct 2024 18:21:01 +0900

The acquired memory blocks for reserved may include blocks outside of
memory management.  In this case, the nid variable is set to NUMA_NO_NODE
(-1), so an error occurs in node_set().  This adds a check using
numa_valid_node() to numa_clear_kernel_node_hotplug() that skips
node_set() when nid is set to NUMA_NO_NODE.

Link: https://lkml.kernel.org/r/1729070461-13576-1-git-send-email-nobuhiro1.iwamatsu@toshiba.co.jp
Fixes: 87482708210f ("mm: introduce numa_memblks")
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Suggested-by: Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/numa_memblks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/numa_memblks.c~mm-numa_clear_kernel_node_hotplug-add-numa_no_node-check-for-node-id
+++ a/mm/numa_memblks.c
@@ -349,7 +349,7 @@ static void __init numa_clear_kernel_nod
 	for_each_reserved_mem_region(mb_region) {
 		int nid = memblock_get_region_node(mb_region);
 
-		if (nid != MAX_NUMNODES)
+		if (numa_valid_node(nid))
 			node_set(nid, reserved_nodemask);
 	}
 
_

Patches currently in -mm which might be from nobuhiro1.iwamatsu@toshiba.co.jp are


