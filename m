Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037DB1D54FA;
	Sat, 14 Feb 2026 17:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771088919; cv=none; b=NdZM1ttACWkt7WEDQRKkfykugf1whfv2oF2s7w+RB6zg8ygIDLWjBX1eXI1WXzvT29A4ZQNpxsZAj17KktbZzc5XqS9C2sCTscdXKFBTANdWyPs9tmAYky2JS7LOGO90B2Y940buuGOQCzUneEai3FwFpg2UGOSQV9UlV+vUSs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771088919; c=relaxed/simple;
	bh=WLxojpvFkihbh2F5J4jmA4uuqMuar9HCoUphkvqFeS0=;
	h=Date:To:From:Subject:Message-Id; b=hgc3vVa8DXWyLOaXbnk7kB5snpaiaNELsKqxMZBy2wdvvy6OkE64f4P/L6C97DT5iByUfIIZYVBRKwIGBgQmRkXnjxFAkTG/3ibF3lsMPK9fZ5mTRi5ldFKXAuvEQejz5uWb9PaqW6CEc5RMQAhTzpN8ZysR4dFO6bFVNzWdfYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zF/5yCSQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zF/5yCSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C5AC16AAE;
	Sat, 14 Feb 2026 17:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771088918;
	bh=WLxojpvFkihbh2F5J4jmA4uuqMuar9HCoUphkvqFeS0=;
	h=Date:To:From:Subject:From;
	b=zF/5yCSQGpj6VeeXo48UyDZxVGvjynFWMfGs6aQ+vmTEFlRwf1S45VwLX35V61F0l
	 tPFq1heWbbLmghE3j2e7N13hoNimUOLTwsHjcn0DLSksJYNMyFO03Nihv1gH4YnB77
	 QJSDAYYKf5DBwt0hm7EotfHFQYooh84fbKE1/eqU=
Date: Sat, 14 Feb 2026 09:08:38 -0800
To: mm-commits@vger.kernel.org,wangyinfeng@phytium.com.cn,stable@vger.kernel.org,rppt@kernel.org,jonathan.cameron@huawei.com,gourry@gourry.net,david@kernel.org,dan.j.williams@intel.com,cuichao1753@phytium.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-numa_memblks-identify-the-accurate-numa-id-of-cfmw.patch removed from -mm tree
Message-Id: <20260214170838.97C5AC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: numa_memblks: identify the accurate NUMA ID of CFMW
has been removed from the -mm tree.  Its filename was
     mm-numa_memblks-identify-the-accurate-numa-id-of-cfmw.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


