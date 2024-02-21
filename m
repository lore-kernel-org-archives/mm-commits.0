Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5E51292F2
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 22:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708554393; cv=none; b=AW6FAaPR735i8a3ZtBsUM/wFQsXmVUy/vorRaN9a2Xu+YZ7IAldeA8qzD8bLiv/GTEC1JM4nNQwuIQ+xRSjlvNA8cNWIP702zpFxz9s8tJsveZWEvNAhZy0LSWGemTK9SgCytnsVE6uuwxhduhm40lFvC3uvy9nXNLnfHgAHEbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708554393; c=relaxed/simple;
	bh=wTI5cgsWZqShcMs9phVqp5x7xMBzIRTuBEq344Kjrc0=;
	h=Date:To:From:Subject:Message-Id; b=uaSQ67/IO4vh4+RxPgmUFMddcmGKP9oluS+UeMOywvLxPE2wZKkOGJpBEiVOLJViA1xB/fy6ix3aOMX9nezdubob6LY45wUbRq1wwrw0yCefSKvHtu8q+5UrKdPQw7Xwq0NCFgfdRHxUYNbV8iaXBk2YtKYlVkRPq533IwuRIcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z4bBPifd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z4bBPifd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C491C43330;
	Wed, 21 Feb 2024 22:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708554392;
	bh=wTI5cgsWZqShcMs9phVqp5x7xMBzIRTuBEq344Kjrc0=;
	h=Date:To:From:Subject:From;
	b=z4bBPifdMv7GYbfNEsUv2OLFFYfhQPo4Lq9eHnJu+3nxLQZMPn1zvIwgeBLzTc6z3
	 Zsi93PLkVjzxh2C5/HcwU+F86IxcdZfNib6pc7+Ev8ZH9AFceVALbwSpHRs/zIJIQB
	 pOC1A6BkXlZmssLjzmuJ21cKU4+olY9eWci5p+4s=
Date: Wed, 21 Feb 2024 14:26:31 -0800
To: mm-commits@vger.kernel.org,rafael@kernel.org,gregkh@linuxfoundation.org,luochunsheng@ustc.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] meminfo-provide-estimated-per-nodes-available-memory.patch removed from -mm tree
Message-Id: <20240221222632.0C491C43330@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: meminfo: provide estimated per-node's available memory
has been removed from the -mm tree.  Its filename was
     meminfo-provide-estimated-per-nodes-available-memory.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Chunsheng Luo <luochunsheng@ustc.edu>
Subject: meminfo: provide estimated per-node's available memory
Date: Sun, 4 Feb 2024 03:34:14 -0500

The system offers an estimate of the per-node's available memory, in
addition to the system's available memory provided by /proc/meminfo.

Like commit 34e431b0ae39 ("/proc/meminfo: provide estimated available
memory"), it is more convenient to provide such an estimate in
/sys/bus/node/devices/nodex/meminfo.  If things change in the future, we
only have to change it in one place.

Shown below:
/sys/bus/node/devices/node1/meminfo:
Node 1 MemTotal:        4084480 kB
Node 1 MemFree:         3348820 kB
Node 1 MemAvailable:    3647972 kB
Node 1 MemUsed:          735660 kB
....

Link: https://github.com/numactl/numactl/issues/210
Link: https://lkml.kernel.org/r/20240204083414.107799-1-luochunsheng@ustc.edu
Signed-off-by: Chunsheng Luo <luochunsheng@ustc.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    4 +++
 include/linux/mm.h  |    1 
 mm/show_mem.c       |   43 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+)

--- a/drivers/base/node.c~meminfo-provide-estimated-per-nodes-available-memory
+++ a/drivers/base/node.c
@@ -372,11 +372,13 @@ static ssize_t node_read_meminfo(struct
 	int len = 0;
 	int nid = dev->id;
 	struct pglist_data *pgdat = NODE_DATA(nid);
+	long available;
 	struct sysinfo i;
 	unsigned long sreclaimable, sunreclaimable;
 	unsigned long swapcached = 0;
 
 	si_meminfo_node(&i, nid);
+	available = si_mem_node_available(nid);
 	sreclaimable = node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B);
 	sunreclaimable = node_page_state_pages(pgdat, NR_SLAB_UNRECLAIMABLE_B);
 #ifdef CONFIG_SWAP
@@ -385,6 +387,7 @@ static ssize_t node_read_meminfo(struct
 	len = sysfs_emit_at(buf, len,
 			    "Node %d MemTotal:       %8lu kB\n"
 			    "Node %d MemFree:        %8lu kB\n"
+			    "Node %d MemAvailable:   %8lu kB\n"
 			    "Node %d MemUsed:        %8lu kB\n"
 			    "Node %d SwapCached:     %8lu kB\n"
 			    "Node %d Active:         %8lu kB\n"
@@ -397,6 +400,7 @@ static ssize_t node_read_meminfo(struct
 			    "Node %d Mlocked:        %8lu kB\n",
 			    nid, K(i.totalram),
 			    nid, K(i.freeram),
+			    nid, K(available),
 			    nid, K(i.totalram - i.freeram),
 			    nid, K(swapcached),
 			    nid, K(node_page_state(pgdat, NR_ACTIVE_ANON) +
--- a/include/linux/mm.h~meminfo-provide-estimated-per-nodes-available-memory
+++ a/include/linux/mm.h
@@ -3202,6 +3202,7 @@ static inline void show_mem(void)
 extern long si_mem_available(void);
 extern void si_meminfo(struct sysinfo * val);
 extern void si_meminfo_node(struct sysinfo *val, int nid);
+extern long si_mem_node_available(int nid);
 #ifdef __HAVE_ARCH_RESERVED_KERNEL_PAGES
 extern unsigned long arch_reserved_kernel_pages(void);
 #endif
--- a/mm/show_mem.c~meminfo-provide-estimated-per-nodes-available-memory
+++ a/mm/show_mem.c
@@ -86,6 +86,49 @@ void si_meminfo(struct sysinfo *val)
 EXPORT_SYMBOL(si_meminfo);
 
 #ifdef CONFIG_NUMA
+long si_mem_node_available(int nid)
+{
+	int zone_type;
+	long available;
+	unsigned long pagecache;
+	unsigned long wmark_low = 0;
+	unsigned long reclaimable;
+	pg_data_t *pgdat = NODE_DATA(nid);
+
+	for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++)
+		wmark_low += low_wmark_pages((&pgdat->node_zones[zone_type]));
+
+	/*
+	 * Estimate the amount of memory available for userspace allocations,
+	 * without causing swapping for mbind process.
+	 */
+	available = sum_zone_node_page_state(nid, NR_FREE_PAGES) - pgdat->totalreserve_pages;
+
+	/*
+	 * Not all the page cache can be freed, otherwise the system will
+	 * start swapping or thrashing. Assume at least half of the page
+	 * cache, or the low watermark worth of cache, needs to stay.
+	 */
+	pagecache = node_page_state(pgdat, NR_ACTIVE_FILE) +
+		node_page_state(pgdat, NR_INACTIVE_FILE);
+	pagecache -= min(pagecache / 2, wmark_low);
+	available += pagecache;
+
+	/*
+	 * Part of the reclaimable slab and other kernel memory consists of
+	 * items that are in use, and cannot be freed. Cap this estimate at the
+	 * low watermark.
+	 */
+	reclaimable = node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) +
+		node_page_state(pgdat, NR_KERNEL_MISC_RECLAIMABLE);
+	reclaimable -= min(reclaimable / 2, wmark_low);
+	available += reclaimable;
+
+	if (available < 0)
+		available = 0;
+	return available;
+}
+
 void si_meminfo_node(struct sysinfo *val, int nid)
 {
 	int zone_type;		/* needs to be signed */
_

Patches currently in -mm which might be from luochunsheng@ustc.edu are


