Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFB2455177
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 21:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786139464; cv=none; b=KFPI7MwgxXfZIg0vlrz2FU1Dp/E5WoUH81M4zO4dBotEGTmWPHLn49/lL99p2l8DABpmDzf1xCYNXZwCIZYRzLhFBU7vp1z2K8QgNmmXuMiQDwtR5FvHrySqtBa69MGntZzFmkwXLxSVqab7uVSbEZVk/xVPR0HGe4l2lIhv6Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786139464; c=relaxed/simple;
	bh=yyGVVqHZ/XcI4q40czyHLJSli4GojlhdAVW46aJ5bgQ=;
	h=Date:To:From:Subject:Message-Id; b=JLW51yK60HmgeaGKyqqAAlRx0a4auVcftWUIlwwgdc3XvuOrXPJ3omUF+LzquqoQJ1mQ/aNLwqIeqkGLY/YwbgyRUCt7GKwd34r7gmSTWKDCQKNnmGm9JIIMteyxT0RpDd8NTgOw4HcucYtnRNLyXZz7DxqSdvrNg0n0KnOEFWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zbUQ+UI4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zbUQ+UI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13981F000E9;
	Fri,  7 Aug 2026 21:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786139462;
	bh=qtbZjo5cOo/KttodL6CXQm6zkc1JbR7CS6MDJwXkXZw=;
	h=Date:To:From:Subject;
	b=zbUQ+UI4902QV2E9hTFdt5TurrPymnzv8fmBc4sYJN46AtkOZT7mgMeA2sEnroFP0
	 zcRE/IkDIl/1hz1TVuZgZAYUYVcO/EexkN7vNGnyb6GOQHXL88/e3VsuQ1LN5w7CSH
	 dFFxn+AMRTwhdvsOgcTIGqCCErT88hZZeDz21MIs=
Date: Fri, 07 Aug 2026 14:51:02 -0700
To: mm-commits@vger.kernel.org,souravpanda@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb_cma-support-percentage-based-hugetlb_cma-reservation.patch removed from -mm tree
Message-Id: <20260807215102.C13981F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb_cma: support percentage-based hugetlb_cma reservation
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_cma-support-percentage-based-hugetlb_cma-reservation.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Sourav Panda <souravpanda@google.com>
Subject: mm/hugetlb_cma: support percentage-based hugetlb_cma reservation
Date: Wed, 29 Jul 2026 16:31:48 +0000

Currently, hugetlb_cma reservation only supports absolute sizes (e.g.,
hugetlb_cma=2G or hugetlb_cma=0:1G,1:1G).  This can be restrictive in
heterogeneous environments or when deploying common kernel command lines
across machines with different memory capacities.

Add support for percentage-based hugetlb_cma reservation (e.g.,
hugetlb_cma=20% or hugetlb_cma=0:20%,1:10%).

The percentage is calculated against the total memory (for global
settings) or against the node-specific memory (for node-specific settings)
using memblock APIs during early boot.

Link: https://lore.kernel.org/20260729163148.3271755-1-souravpanda@google.com
Signed-off-by: Sourav Panda <souravpanda@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    7 
 mm/hugetlb_cma.c                                |  128 +++++++++++++-
 2 files changed, 125 insertions(+), 10 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~mm-hugetlb_cma-support-percentage-based-hugetlb_cma-reservation
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -2064,8 +2064,11 @@ Kernel parameters
 	hugetlb_cma=	[HW,CMA,EARLY] The size of a CMA area used for allocation
 			of gigantic hugepages. Or using node format, the size
 			of a CMA area per node can be specified.
-			Format: nn[KMGTPE] or (node format)
-				<node>:nn[KMGTPE][,<node>:nn[KMGTPE]]
+			The size can be an absolute value (e.g., 2G) or a
+			percentage of the total memory or node memory (e.g., 20%).
+			Format: nn[KMGTPE] or nn% or (node format)
+				<node>:nn[KMGTPE][,<node>:nn[KMGTPE]] or
+				<node>:nn%[,<node>:nn%]
 
 			The size must be a multiple of the gigantic page size.
 			When using node format, this applies to each per-node size.
--- a/mm/hugetlb_cma.c~mm-hugetlb_cma-support-percentage-based-hugetlb_cma-reservation
+++ a/mm/hugetlb_cma.c
@@ -9,6 +9,9 @@
 #include <asm/setup.h>
 
 #include <linux/hugetlb.h>
+#include <linux/memblock.h>
+#include <linux/math.h>
+#include <linux/math64.h>
 #include "internal.h"
 #include "hugetlb_cma.h"
 
@@ -18,6 +21,28 @@ static unsigned long hugetlb_cma_size_in
 static bool hugetlb_cma_only __ro_after_init;
 static unsigned long hugetlb_cma_size __ro_after_init;
 
+static unsigned int hugetlb_cma_percent __initdata;
+static unsigned int hugetlb_cma_percent_in_node[MAX_NUMNODES] __initdata;
+
+#ifdef CONFIG_NUMA
+static phys_addr_t __init memblock_node_memory_size(int nid)
+{
+	struct memblock_region *reg;
+	phys_addr_t size = 0;
+
+	for_each_mem_region(reg) {
+		if (reg->nid == nid)
+			size += reg->size;
+	}
+	return size;
+}
+#else
+static phys_addr_t __init memblock_node_memory_size(int nid)
+{
+	return memblock_phys_mem_size();
+}
+#endif
+
 void hugetlb_cma_free_frozen_folio(struct folio *folio)
 {
 	WARN_ON_ONCE(!cma_release_frozen(hugetlb_cma[folio_nid(folio)],
@@ -93,14 +118,28 @@ static int __init cmdline_parse_hugetlb_
 			break;
 
 		if (s[count] == ':') {
+			char *next;
+
 			if (tmp >= MAX_NUMNODES)
 				break;
 			nid = array_index_nospec(tmp, MAX_NUMNODES);
 
 			s += count + 1;
-			tmp = memparse(s, &s);
-			hugetlb_cma_size_in_node[nid] = tmp;
-			hugetlb_cma_size += tmp;
+			tmp = memparse(s, &next);
+			if (*next == '%') {
+				if (tmp > 100) {
+					pr_warn("hugetlb_cma: invalid percentage %lu for node %d\n",
+						tmp, nid);
+					break;
+				}
+				hugetlb_cma_percent_in_node[nid] = tmp;
+				hugetlb_cma_size_in_node[nid] = 0;
+				s = next + 1;
+			} else {
+				hugetlb_cma_size_in_node[nid] = tmp;
+				hugetlb_cma_percent_in_node[nid] = 0;
+				s = next;
+			}
 
 			/*
 			 * Skip the separator if have one, otherwise
@@ -111,7 +150,28 @@ static int __init cmdline_parse_hugetlb_
 			else
 				break;
 		} else {
-			hugetlb_cma_size = memparse(p, &p);
+			char *next;
+
+			tmp = memparse(p, &next);
+			if (*next == '%') {
+				if (tmp > 100) {
+					pr_warn("hugetlb_cma: invalid percentage %lu\n", tmp);
+				} else {
+					hugetlb_cma_percent = tmp;
+					hugetlb_cma_size = 0;
+					for (nid = 0; nid < MAX_NUMNODES; nid++) {
+						hugetlb_cma_size_in_node[nid] = 0;
+						hugetlb_cma_percent_in_node[nid] = 0;
+					}
+				}
+			} else {
+				hugetlb_cma_size = tmp;
+				hugetlb_cma_percent = 0;
+				for (nid = 0; nid < MAX_NUMNODES; nid++) {
+					hugetlb_cma_size_in_node[nid] = 0;
+					hugetlb_cma_percent_in_node[nid] = 0;
+				}
+			}
 			break;
 		}
 	}
@@ -137,8 +197,36 @@ void __init hugetlb_cma_reserve(void)
 {
 	unsigned long size, reserved, per_node, order, gigantic_page_size;
 	bool node_specific_cma_alloc = false;
+	bool has_node_specific_param = false;
 	int nid;
 
+	for (nid = 0; nid < MAX_NUMNODES; nid++) {
+		if (hugetlb_cma_size_in_node[nid] || hugetlb_cma_percent_in_node[nid]) {
+			has_node_specific_param = true;
+			break;
+		}
+	}
+
+	if (has_node_specific_param) {
+		hugetlb_cma_size = 0;
+		for (nid = 0; nid < MAX_NUMNODES; nid++) {
+			if (hugetlb_cma_percent_in_node[nid]) {
+				phys_addr_t node_gfp_mem = memblock_node_memory_size(nid);
+				u64 s;
+
+				s = mul_u64_u32_div((u64)node_gfp_mem,
+						    hugetlb_cma_percent_in_node[nid],
+						    100);
+
+				hugetlb_cma_size_in_node[nid] = s;
+			}
+			hugetlb_cma_size += hugetlb_cma_size_in_node[nid];
+		}
+	} else if (hugetlb_cma_percent) {
+		hugetlb_cma_size = mul_u64_u32_div((u64)memblock_phys_mem_size(),
+						   hugetlb_cma_percent, 100);
+	}
+
 	if (!hugetlb_cma_size)
 		return;
 
@@ -157,6 +245,20 @@ void __init hugetlb_cma_reserve(void)
 	VM_WARN_ON(order <= MAX_PAGE_ORDER);
 	gigantic_page_size = PAGE_SIZE << order;
 
+	if (hugetlb_cma_percent) {
+		hugetlb_cma_size = ALIGN_DOWN(hugetlb_cma_size, PAGE_SIZE << order);
+	} else if (has_node_specific_param) {
+		hugetlb_cma_size = 0;
+		for (nid = 0; nid < MAX_NUMNODES; nid++) {
+			if (hugetlb_cma_percent_in_node[nid]) {
+				hugetlb_cma_size_in_node[nid] =
+					ALIGN_DOWN(hugetlb_cma_size_in_node[nid],
+						   PAGE_SIZE << order);
+			}
+			hugetlb_cma_size += hugetlb_cma_size_in_node[nid];
+		}
+	}
+
 	hugetlb_bootmem_set_nodes();
 
 	for (nid = 0; nid < MAX_NUMNODES; nid++) {
@@ -197,8 +299,14 @@ void __init hugetlb_cma_reserve(void)
 		per_node = DIV_ROUND_UP(hugetlb_cma_size,
 					nodes_weight(hugetlb_bootmem_nodes));
 		per_node = round_up(per_node, gigantic_page_size);
-		pr_info("hugetlb_cma: reserve %lu MiB, up to %lu MiB per node\n",
-			hugetlb_cma_size / SZ_1M, per_node / SZ_1M);
+		if (hugetlb_cma_percent)
+			pr_info("hugetlb_cma: reserve %lu MiB (%u%%), up to %lu MiB per node\n",
+				hugetlb_cma_size / SZ_1M, hugetlb_cma_percent,
+				per_node / SZ_1M);
+		else
+			pr_info("hugetlb_cma: reserve %lu MiB, up to %lu MiB per node\n",
+				hugetlb_cma_size / SZ_1M,
+				per_node / SZ_1M);
 	}
 
 	reserved = 0;
@@ -233,8 +341,12 @@ void __init hugetlb_cma_reserve(void)
 		}
 
 		reserved += size;
-		pr_info("hugetlb_cma: reserved %lu MiB on node %d\n",
-			size / SZ_1M, nid);
+		if (hugetlb_cma_percent_in_node[nid])
+			pr_info("hugetlb_cma: reserved %lu MiB (%u%%) on node %d\n",
+				size / SZ_1M, hugetlb_cma_percent_in_node[nid], nid);
+		else
+			pr_info("hugetlb_cma: reserved %lu MiB on node %d\n",
+				size / SZ_1M, nid);
 
 		if (reserved >= hugetlb_cma_size)
 			break;
_

Patches currently in -mm which might be from souravpanda@google.com are

mm-hugetlb_cma-fix-null-nodemask-dereference-in-hugetlb_cma_alloc_frozen_folio.patch

