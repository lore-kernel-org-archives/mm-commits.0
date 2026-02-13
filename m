Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FF4361664;
	Fri, 13 Feb 2026 17:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771002432; cv=none; b=PxRKQFYhQlfP/coVDTKLoj4Uj9EPjp69ApSxnibX7kToPGxq5/nOmMQ2WzIFcreVNRlAk2RxONRq4lGCoAG6LTY2VS6ObFPBiGnS3VrXqZirGEWczfRnpP/J0BEHuFq4bI11vtYKCEGOvzED8CMhZVI3Jm4bq3r/M6cw8zF6cg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771002432; c=relaxed/simple;
	bh=kHBQbqFGK0eAQDRVoZ2p4B0ZdFqrsSug9Zz1q37ddv4=;
	h=Date:To:From:Subject:Message-Id; b=OGRnpg7nxmrMSZjZBYNynmFqdlKJszFc9peSmkbVahL1CJ/vWuomdrjo5EKEkqWqbuA7iY5jJigWxZlG0EPsPlVyVxlCVYVE35DjdcmbYaqVeiD28LecS01a4M9EJxZZ7md+cl/N/QJsctPpcOKvHOnX0vclrvTruPCZn7fY7u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wgMUSJSZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wgMUSJSZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F3FC116C6;
	Fri, 13 Feb 2026 17:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771002432;
	bh=kHBQbqFGK0eAQDRVoZ2p4B0ZdFqrsSug9Zz1q37ddv4=;
	h=Date:To:From:Subject:From;
	b=wgMUSJSZoMfF890twhI2i5mgLehyMoYSmUtIm+KB1IUNP8yyPE3VSs9cKhVDO59RI
	 iH3mAGhnw+4DWcKhuPCwH+VHJLVKSVSGb4J9OB/ccDJkhJ8yOP41KBWHMTGzrCBMSZ
	 4qqI+O3cVaKuOJRgz7XgxAGfH+FhBOoEHUFREQJU=
Date: Fri, 13 Feb 2026 09:07:11 -0800
To: mm-commits@vger.kernel.org,wangyinfeng@phytium.com.cn,stable@vger.kernel.org,rppt@kernel.org,jonathan.cameron@huawei.com,gourry@gourry.net,david@kernel.org,dan.j.williams@intel.com,cuichao1753@phytium.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-numa_memblks-identify-the-accurate-numa-id-of-cfmw.patch added to mm-new branch
Message-Id: <20260213170712.46F3FC116C6@smtp.kernel.org>
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
Date: Wed, 11 Feb 2026 18:33:20 +0800

In some physical memory layout designs, the address space of CFMW (CXL
Fixed Memory Window) resides between multiple segments of system memory
belonging to the same NUMA node.  In numa_cleanup_meminfo, these multiple
segments of system memory are merged into a larger numa_memblk.  When
identifying which NUMA node the CFMW belongs to, it may be incorrectly
assigned to the NUMA node of the merged system memory.

When a CXL RAM region is created in userspace, the memory capacity of the
newly created region is not added to the CFMW-dedicated NUMA node. 
Instead, it is accumulated into an existing NUMA node (e.g., NUMA0
containing RAM).  This makes it impossible to clearly distinguish between
the two types of memory, which may affect memory-tiering applications.

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

To address this scenario, accurately identifying the correct NUMA node can
be achieved by checking whether the region belongs to both numa_meminfo
and numa_reserved_meminfo.

While this issue is only observed in a QEMU configuration, and no known
end users are impacted by this problem, it is likely that some firmware
implementation is leaving memory map holes in a CXL Fixed Memory Window. 
CXL hotplug depends on mapping free window capacity, and it seems to be
only a coincidence to have not hit this problem yet.

Link: https://lkml.kernel.org/r/20260213060347.2389818-2-cuichao1753@phytium.com.cn
Link: https://lkml.kernel.org/r/20260211103320.2064211-2-cuichao1753@phytium.com.cn
Fixes: 779dd20cfb56 ("cxl/region: Add region creation support")
Signed-off-by: Cui Chao <cuichao1753@phytium.com.cn>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Wang Yinfeng <wangyinfeng@phytium.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/numa_memblks.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/numa_memblks.c~mm-numa_memblks-identify-the-accurate-numa-id-of-cfmw
+++ a/mm/numa_memblks.c
@@ -570,15 +570,16 @@ static int meminfo_to_nid(struct numa_me
 int phys_to_target_node(u64 start)
 {
 	int nid = meminfo_to_nid(&numa_meminfo, start);
+	int reserved_nid = meminfo_to_nid(&numa_reserved_meminfo, start);
 
 	/*
-	 * Prefer online nodes, but if reserved memory might be
-	 * hot-added continue the search with reserved ranges.
+	 * Prefer online nodes unless the address is also described
+	 * by reserved ranges, in which case use the reserved nid.
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

