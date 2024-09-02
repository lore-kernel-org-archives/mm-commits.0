Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199CA2D613
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247673; cv=none; b=tRXuzFCvRqOozQd7WBh0nsnEDI1RhfRHweDo+2T36JQVo+idtt3sHgL/O+0oIrPg/bcsMiJlXOLmbmlOhk2uM36ry/ReUKxJY21+o8iwDspXl7olCNd/N2GcF5l2pJU9VApDuEWPgcWD859ATPyQnB9lDKLb2BquceOExjpyz9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247673; c=relaxed/simple;
	bh=2Xvd7XcBonP9UUpPl59cJu/1jRnUhtYrXn5dhjrSHC4=;
	h=Date:To:From:Subject:Message-Id; b=OImp2/A9DMWojRxvdUObpPtmnoWomVtee/jO0ElXeqPfARAGzioMthctSHO/qOzJZWIFyMLIB/6IwOAYADhWbY1KVpc3c+m1h4xATkuHhlIU0HpYo7Ra26g07ZGiAZ9+U0Sz54XYBxYpcuP+QPV9y7gAXDZ+4NGWAC7Gz6XNWhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nq3SL9Q1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nq3SL9Q1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3543C4CEC2;
	Mon,  2 Sep 2024 03:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247673;
	bh=2Xvd7XcBonP9UUpPl59cJu/1jRnUhtYrXn5dhjrSHC4=;
	h=Date:To:From:Subject:From;
	b=Nq3SL9Q1FGgd1Wfa1Qd2NJLVJknTf9oh5OSePTqX/+XVtewl9LcC7zNLypkV0jcrC
	 sPEXBrxlGArFNKzR+Jum5q9zbPCvUaTRjOxiZY+5xBDJhiycHnk7JBOh3kt88SXUWI
	 VR7eoI0QSVsEnkJOq64DyktUczmKnhd8ie1k1neU=
Date: Sun, 01 Sep 2024 20:27:52 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,wangkefeng.wang@huawei.com,lorenzo.stoakes@oracle.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memory-tiering-read-last_cpupid-correctly-in-do_huge_pmd_numa_page.patch removed from -mm tree
Message-Id: <20240902032752.E3543C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memory tiering: read last_cpupid correctly in do_huge_pmd_numa_page()
has been removed from the -mm tree.  Its filename was
     memory-tiering-read-last_cpupid-correctly-in-do_huge_pmd_numa_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: memory tiering: read last_cpupid correctly in do_huge_pmd_numa_page()
Date: Wed, 24 Jul 2024 09:01:13 -0400

Patch series "Various memory tiering fixes", v3.


This patch (of 3):

last_cpupid is only available when memory tiering is off or the folio is
in toptier node.  Complete the check to read last_cpupid when it is
available.

Before the fix, the default last_cpupid will be used even if memory
tiering mode is turned off at runtime instead of the actual value.  This
can prevent task_numa_fault() from getting right numa fault stats, but
should not cause any crash.  User might see performance changes after the
fix.

Link: https://lkml.kernel.org/r/20240724130115.793641-1-ziy@nvidia.com
Link: https://lkml.kernel.org/r/20240724130115.793641-2-ziy@nvidia.com
Fixes: 33024536bafd ("memory tiering: hot page selection with hint page fault latency")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: David Hildenbrand <david@redhat.com>
Closes: https://lore.kernel.org/linux-mm/9af34a6b-ca56-4a64-8aa6-ade65f109288@redhat.com/
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~memory-tiering-read-last_cpupid-correctly-in-do_huge_pmd_numa_page
+++ a/mm/huge_memory.c
@@ -1707,7 +1707,8 @@ vm_fault_t do_huge_pmd_numa_page(struct
 	 * For memory tiering mode, cpupid of slow memory page is used
 	 * to record page access time.  So use default value.
 	 */
-	if (node_is_toptier(nid))
+	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) ||
+	    node_is_toptier(nid))
 		last_cpupid = folio_last_cpupid(folio);
 	target_nid = numa_migrate_prep(folio, vmf, haddr, nid, &flags);
 	if (target_nid == NUMA_NO_NODE)
_

Patches currently in -mm which might be from ziy@nvidia.com are


