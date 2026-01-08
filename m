Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA3C2253A1
	for <mm-commits@vger.kernel.org>; Thu,  8 Jan 2026 17:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767894524; cv=none; b=Ha4peXt3ANFatnjLa+DQD6qGGlNI056ZJdLZMGcccK3lJZv0SA8zeGE5nQETWJkExpSOo0ida8qMw6KvvTVllLP0dzFJiLyznI6v7NcmuEG/lVxmfXcdVSQ5WugOnIX5MSLlJifhZcEOKCuOopVXjOOSYSkDA4Xg1gnMTomOc0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767894524; c=relaxed/simple;
	bh=VNSnirK9LVgfpC2P7YKxMg9KVc57TRXlwEMABkY9+0w=;
	h=Date:To:From:Subject:Message-Id; b=UOlq4pZVmyXCUsIomDlr096u6FKDzKWbaBYWsKQWnkSkgVYey8boi/lUMY+vpDq8jm/7mNozj9u5tUli/zopRPUHhuNxOkQ6rvQjAkGD6qjSLCwsh0j/2EwalhM4l3a3v0MqB9V8fvHbnFs4ovdo6TY+B8+E6/f+wxiy/DIizjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uIbmPqNo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uIbmPqNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531DCC116C6;
	Thu,  8 Jan 2026 17:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767894524;
	bh=VNSnirK9LVgfpC2P7YKxMg9KVc57TRXlwEMABkY9+0w=;
	h=Date:To:From:Subject:From;
	b=uIbmPqNoGRwmHDgg+60R3doNQu9FVNQgQ2D7gqZnQuvz6A6Hb7zUdrY6nS1wkYL6R
	 Fev+8fJ1nmcbBMRQNMT+k7Cyxi7eXW8NVf6IDh4qRaaPTa8A189Sq/jKPgcTkhK+AB
	 wGxabc3h/P1bZp489bET8uCE2y0pm291092IsXmg=
Date: Thu, 08 Jan 2026 09:48:43 -0800
To: mm-commits@vger.kernel.org,wangyinfeng@phytium.com.cn,rppt@kernel.org,jonathan.cameron@huawei.com,cuichao1753@phytium.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-numa_memblks-identify-the-accurate-numa-id-of-cfmw.patch added to mm-new branch
Message-Id: <20260108174844.531DCC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: numa_memblks: identify the accurate NUMA ID of CFMW
has been added to the -mm mm-new branch.  Its filename is
     mm-numa_memblks-identify-the-accurate-numa-id-of-cfmw.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-numa_memblks-identify-the-accurate-numa-id-of-cfmw.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Cui Chao <cuichao1753@phytium.com.cn>
Subject: mm: numa_memblks: identify the accurate NUMA ID of CFMW
Date: Tue, 6 Jan 2026 11:10:42 +0800

In some physical memory layout designs, the address space of CFMW (CXL
Fixed Memory Window) resides between multiple segments of system memory
belonging to the same NUMA node.  In numa_cleanup_meminfo, these multiple
segments of system memory are merged into a larger numa_memblk.  When
identifying which NUMA node the CFMW belongs to, it may be incorrectly
assigned to the NUMA node of the merged system memory.

Example memory layout:

Physical address space:
    0x00000000 - 0x1FFFFFFF  System RAM (node0)
    0x20000000 - 0x2FFFFFFF  CXL CFMW (node2)
    0x40000000 - 0x5FFFFFFF  System RAM (node0)
    0x60000000 - 0x7FFFFFFF  System RAM (node1)

After numa_cleanup_meminfo, the two node0 segments are merged into one:
    0x00000000 - 0x5FFFFFFF  System RAM (node0) // CFMW is inside the range
    0x60000000 - 0x7FFFFFFF  System RAM (node1)

So the CFMW (0x20000000-0x2FFFFFFF) will be incorrectly assigned to node0.

To address this scenario, accurately identifying the correct NUMA node
can be achieved by checking whether the region belongs to both
numa_meminfo and numa_reserved_meminfo.

Link: https://lkml.kernel.org/r/20260106031042.1606729-2-cuichao1753@phytium.com.cn
Signed-off-by: Cui Chao <cuichao1753@phytium.com.cn>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Wang Yinfeng <wangyinfeng@phytium.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/numa_memblks.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/numa_memblks.c~mm-numa_memblks-identify-the-accurate-numa-id-of-cfmw
+++ a/mm/numa_memblks.c
@@ -568,15 +568,16 @@ static int meminfo_to_nid(struct numa_me
 int phys_to_target_node(u64 start)
 {
 	int nid = meminfo_to_nid(&numa_meminfo, start);
+	int reserved_nid = meminfo_to_nid(&numa_reserved_meminfo, start);
 
 	/*
 	 * Prefer online nodes, but if reserved memory might be
 	 * hot-added continue the search with reserved ranges.
 	 */
-	if (nid != NUMA_NO_NODE)
+	if (nid != NUMA_NO_NODE && reserved_nid == NUMA_NO_NODE)
 		return nid;
 
-	return meminfo_to_nid(&numa_reserved_meminfo, start);
+	return reserved_nid;
 }
 EXPORT_SYMBOL_GPL(phys_to_target_node);
 
_

Patches currently in -mm which might be from cuichao1753@phytium.com.cn are

mm-numa_memblks-identify-the-accurate-numa-id-of-cfmw.patch

