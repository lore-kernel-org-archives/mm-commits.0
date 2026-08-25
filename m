Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926AB366049
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622880; cv=none; b=CtYzQFDymABsdl3hmuVQ9NNWgcPBRONtO3LirWLO+t21FusSuKy/nYBJ4ERaIo0/bhzhNPjN6wA8g1izyeDOmkuRt9kZL5DzvjPlzCimyD7UtKL9hh1aAT0PKZL+5sJYEH2PyQQ7Tzv1HBNTj3uptKr/ETuB5hvdtj+vzAaKv7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622880; c=relaxed/simple;
	bh=Mc/Q3zgdnII1wCQ/BUFXH8nN4bWSUVfP8igmUJIn3qU=;
	h=Date:To:From:Subject:Message-Id; b=e9YdbY6ba105uqFyRd+U7N3XjGePIcPI/8MU2nEjSlNOaRIoIZYtJuW6OGRJf2npX+RG5qBgpTq/bOspaHdXBg9xjsqaoLbUP/QThVUCxdlz+orj+GzWbmWAnxpCwMbqAiFyvLCIS0xh1jLEmaPOtrVnLlNZfz6ECw5E79SctRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rVGR0hO/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rVGR0hO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516B91F000E9;
	Tue, 25 Aug 2026 01:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622873;
	bh=tDS5v87dzyS1YoKhVcHTVrCLQp5WWHQ4yAP05z6esGc=;
	h=Date:To:From:Subject;
	b=rVGR0hO/Fe29mKut1I9zMvaxZd+2dGmWfeqwwJRgB5+fqEw6Y4RpzSRclta8yc/dD
	 3YG8h+r5PRkNx5ZEfKtlHlgu+6JGIFvviFLvXvi0YAoLjmriTjwRpUcSrmEJt3YPbA
	 O3PsBFrWt9//3viTGei+Upg4C4uKxRsdh9xRE2kE=
Date: Mon, 24 Aug 2026 18:54:32 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,surenb@google.com,rientjes@google.com,osalvador@suse.de,muchun.song@linux.dev,gthelen@google.com,fvdl@google.com,david@kernel.org,souravpanda@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_cma-support-percentage-based-hugetlb_cma-reservation.patch removed from -mm tree
Message-Id: <20260825015433.516B91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb_cma: support percentage-based hugetlb_cma reservation
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_cma-support-percentage-based-hugetlb_cma-reservation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sourav Panda <souravpanda@google.com>
Subject: mm/hugetlb_cma: support percentage-based hugetlb_cma reservation
Date: Fri, 7 Aug 2026 04:00:03 +0000

Currently, hugetlb_cma reservation only supports absolute sizes (e.g.,
hugetlb_cma=2G or hugetlb_cma=0:1G,1:1G).  This can be restrictive in
heterogeneous environments or when deploying common kernel command lines
across machines with different memory capacities.

Add support for percentage-based hugetlb_cma reservation (e.g.,
hugetlb_cma=20% or hugetlb_cma=0:20%,1:10%).

The percentage is calculated against the total memory (for global
settings) or against the node-specific memory (for node-specific settings)
using memblock APIs during early boot.

Link: https://lore.kernel.org/20260807040003.2156630-1-souravpanda@google.com
Signed-off-by: Sourav Panda <souravpanda@google.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |   10 
 mm/hugetlb_cma.c                                |  142 +++++++++++++-
 2 files changed, 142 insertions(+), 10 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~mm-hugetlb_cma-support-percentage-based-hugetlb_cma-reservation
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -2064,8 +2064,14 @@ Kernel parameters
 	hugetlb_cma=	[HW,CMA,EARLY] The size of a CMA area used for allocation
 			of gigantic hugepages. Or using node format, the size
 			of a CMA area per node can be specified.
-			Format: nn[KMGTPE] or (node format)
-				<node>:nn[KMGTPE][,<node>:nn[KMGTPE]]
+			The size can be an absolute value (e.g., 2G) or a
+			percentage of the total memory or node memory (e.g., 20%).
+			Percentage-derived sizes are rounded down to a multiple of
+			the architecture's gigantic hugepage size and may become
+			zero.
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
@@ -90,14 +115,31 @@ static int __init cmdline_parse_hugetlb_
 			break;
 
 		if (s[count] == ':') {
+			char *next;
+
 			if (tmp >= MAX_NUMNODES)
 				break;
 			nid = array_index_nospec(tmp, MAX_NUMNODES);
 
+			hugetlb_cma_size = 0;
+			hugetlb_cma_percent = 0;
+
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
@@ -108,7 +150,28 @@ static int __init cmdline_parse_hugetlb_
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
@@ -134,8 +197,36 @@ void __init hugetlb_cma_reserve(void)
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
 
@@ -154,6 +245,32 @@ void __init hugetlb_cma_reserve(void)
 	VM_WARN_ON(order <= MAX_PAGE_ORDER);
 	gigantic_page_size = PAGE_SIZE << order;
 
+	if (hugetlb_cma_percent) {
+		unsigned long orig_size = hugetlb_cma_size;
+
+		hugetlb_cma_size = ALIGN_DOWN(hugetlb_cma_size, PAGE_SIZE << order);
+		if (orig_size && !hugetlb_cma_size)
+			pr_warn("hugetlb_cma: reservation size rounded down to 0 from %lu MiB (%u%%)\n",
+				orig_size / SZ_1M, hugetlb_cma_percent);
+	} else if (has_node_specific_param) {
+		hugetlb_cma_size = 0;
+		for (nid = 0; nid < MAX_NUMNODES; nid++) {
+			if (hugetlb_cma_percent_in_node[nid]) {
+				unsigned long orig_size = hugetlb_cma_size_in_node[nid];
+
+				hugetlb_cma_size_in_node[nid] =
+					ALIGN_DOWN(hugetlb_cma_size_in_node[nid],
+						   PAGE_SIZE << order);
+				if (orig_size && !hugetlb_cma_size_in_node[nid])
+					pr_warn("hugetlb_cma: reservation size rounded down to 0 from %lu MiB (%u%%) on node %d\n",
+						orig_size / SZ_1M,
+						hugetlb_cma_percent_in_node[nid],
+						nid);
+			}
+			hugetlb_cma_size += hugetlb_cma_size_in_node[nid];
+		}
+	}
+
 	hugetlb_bootmem_set_nodes();
 
 	for (nid = 0; nid < MAX_NUMNODES; nid++) {
@@ -194,8 +311,13 @@ void __init hugetlb_cma_reserve(void)
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
+				hugetlb_cma_size / SZ_1M, per_node / SZ_1M);
 	}
 
 	reserved = 0;
@@ -230,8 +352,12 @@ void __init hugetlb_cma_reserve(void)
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

