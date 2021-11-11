Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00999C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFD9961247
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234313AbhKKCr7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:47:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:53042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234044AbhKKCr7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:47:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A4E06113B;
        Thu, 11 Nov 2021 02:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598710;
        bh=TH0U+8SGzeDtGNpbPX9KZYHT53/d0Ki1kp17FwcjuP0=;
        h=Date:From:To:Subject:From;
        b=Tv2geSQoE/DW6E/p7ND3z204+upm2DdZMFdrC3tC7obik2KvLPzvuOil+BqQbB+DA
         xhOVb/l3+IHs1v5ubFerE83k/ZmYb1Mx3nOTxOhI17TYWCt935/PnAzJ6M13Ba0L+y
         2KBTJL+7+tYC/w5HMOzthCrEKh04uIOTbK7PIV0Y=
Date:   Wed, 10 Nov 2021 18:45:10 -0800
From:   akpm@linux-foundation.org
To:     baolin.wang@linux.alibaba.com, corbet@lwn.net, guro@fb.com,
        mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 hugetlb-support-node-specified-when-using-cma-for-gigantic-hugepages.patch
 removed from -mm tree
Message-ID: <20211111024510.Um1CkQGd6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: support node specified when using cma for gigantic hugepages
has been removed from the -mm tree.  Its filename was
     hugetlb-support-node-specified-when-using-cma-for-gigantic-hugepages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: hugetlb: support node specified when using cma for gigantic hugepages

Now the size of CMA area for gigantic hugepages runtime allocation is
balanced for all online nodes, but we also want to specify the size of CMA
per-node, or only one node in some cases, which are similar with patch
[1].

For example, on some multi-nodes systems, each node's memory can be
different, allocating the same size of CMA for each node is not suitable
for the low-memory nodes.  Meanwhile some workloads like DPDK mentioned by
Zhenguo in patch [1] only need hugepages in one node.

On the other hand, we have some machines with multiple types of memory,
like DRAM and PMEM (persistent memory).  On this system, we may want to
specify all the hugepages only on DRAM node, or specify the proportion of
DRAM node and PMEM node, to tuning the performance of the workloads.

Thus this patch adds node format for 'hugetlb_cma' parameter to support
specifying the size of CMA per-node.  An example is as follows:

hugetlb_cma=0:5G,2:5G

which means allocating 5G size of CMA area on node 0 and node 2
respectively.  And the users should use the node specific sysfs file to
allocate the gigantic hugepages if specified the CMA size on that node.

[1]
https://lkml.kernel.org/r/20211005054729.86457-1-yaozhenguo1@gmail.com

Link: https://lkml.kernel.org/r/bb790775ca60bb8f4b26956bb3f6988f74e075c7.1634261144.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    6 
 mm/hugetlb.c                                    |   86 ++++++++++++--
 2 files changed, 81 insertions(+), 11 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~hugetlb-support-node-specified-when-using-cma-for-gigantic-hugepages
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1587,8 +1587,10 @@
 			registers.  Default set by CONFIG_HPET_MMAP_DEFAULT.
 
 	hugetlb_cma=	[HW,CMA] The size of a CMA area used for allocation
-			of gigantic hugepages.
-			Format: nn[KMGTPE]
+			of gigantic hugepages. Or using node format, the size
+			of a CMA area per node can be specified.
+			Format: nn[KMGTPE] or (node format)
+				<node>:nn[KMGTPE][,<node>:nn[KMGTPE]]
 
 			Reserve a CMA area of given size and allocate gigantic
 			hugepages using the CMA allocator. If enabled, the
--- a/mm/hugetlb.c~hugetlb-support-node-specified-when-using-cma-for-gigantic-hugepages
+++ a/mm/hugetlb.c
@@ -50,6 +50,7 @@ struct hstate hstates[HUGE_MAX_HSTATE];
 
 #ifdef CONFIG_CMA
 static struct cma *hugetlb_cma[MAX_NUMNODES];
+static unsigned long hugetlb_cma_size_in_node[MAX_NUMNODES] __initdata;
 static bool hugetlb_cma_page(struct page *page, unsigned int order)
 {
 	return cma_pages_valid(hugetlb_cma[page_to_nid(page)], page,
@@ -6762,7 +6763,38 @@ static bool cma_reserve_called __initdat
 
 static int __init cmdline_parse_hugetlb_cma(char *p)
 {
-	hugetlb_cma_size = memparse(p, &p);
+	int nid, count = 0;
+	unsigned long tmp;
+	char *s = p;
+
+	while (*s) {
+		if (sscanf(s, "%lu%n", &tmp, &count) != 1)
+			break;
+
+		if (s[count] == ':') {
+			nid = tmp;
+			if (nid < 0 || nid >= MAX_NUMNODES)
+				break;
+
+			s += count + 1;
+			tmp = memparse(s, &s);
+			hugetlb_cma_size_in_node[nid] = tmp;
+			hugetlb_cma_size += tmp;
+
+			/*
+			 * Skip the separator if have one, otherwise
+			 * break the parsing.
+			 */
+			if (*s == ',')
+				s++;
+			else
+				break;
+		} else {
+			hugetlb_cma_size = memparse(p, &p);
+			break;
+		}
+	}
+
 	return 0;
 }
 
@@ -6771,6 +6803,7 @@ early_param("hugetlb_cma", cmdline_parse
 void __init hugetlb_cma_reserve(int order)
 {
 	unsigned long size, reserved, per_node;
+	bool node_specific_cma_alloc = false;
 	int nid;
 
 	cma_reserve_called = true;
@@ -6778,6 +6811,31 @@ void __init hugetlb_cma_reserve(int orde
 	if (!hugetlb_cma_size)
 		return;
 
+	for (nid = 0; nid < MAX_NUMNODES; nid++) {
+		if (hugetlb_cma_size_in_node[nid] == 0)
+			continue;
+
+		if (!node_state(nid, N_ONLINE)) {
+			pr_warn("hugetlb_cma: invalid node %d specified\n", nid);
+			hugetlb_cma_size -= hugetlb_cma_size_in_node[nid];
+			hugetlb_cma_size_in_node[nid] = 0;
+			continue;
+		}
+
+		if (hugetlb_cma_size_in_node[nid] < (PAGE_SIZE << order)) {
+			pr_warn("hugetlb_cma: cma area of node %d should be at least %lu MiB\n",
+				nid, (PAGE_SIZE << order) / SZ_1M);
+			hugetlb_cma_size -= hugetlb_cma_size_in_node[nid];
+			hugetlb_cma_size_in_node[nid] = 0;
+		} else {
+			node_specific_cma_alloc = true;
+		}
+	}
+
+	/* Validate the CMA size again in case some invalid nodes specified. */
+	if (!hugetlb_cma_size)
+		return;
+
 	if (hugetlb_cma_size < (PAGE_SIZE << order)) {
 		pr_warn("hugetlb_cma: cma area should be at least %lu MiB\n",
 			(PAGE_SIZE << order) / SZ_1M);
@@ -6785,20 +6843,30 @@ void __init hugetlb_cma_reserve(int orde
 		return;
 	}
 
-	/*
-	 * If 3 GB area is requested on a machine with 4 numa nodes,
-	 * let's allocate 1 GB on first three nodes and ignore the last one.
-	 */
-	per_node = DIV_ROUND_UP(hugetlb_cma_size, nr_online_nodes);
-	pr_info("hugetlb_cma: reserve %lu MiB, up to %lu MiB per node\n",
-		hugetlb_cma_size / SZ_1M, per_node / SZ_1M);
+	if (!node_specific_cma_alloc) {
+		/*
+		 * If 3 GB area is requested on a machine with 4 numa nodes,
+		 * let's allocate 1 GB on first three nodes and ignore the last one.
+		 */
+		per_node = DIV_ROUND_UP(hugetlb_cma_size, nr_online_nodes);
+		pr_info("hugetlb_cma: reserve %lu MiB, up to %lu MiB per node\n",
+			hugetlb_cma_size / SZ_1M, per_node / SZ_1M);
+	}
 
 	reserved = 0;
 	for_each_node_state(nid, N_ONLINE) {
 		int res;
 		char name[CMA_MAX_NAME];
 
-		size = min(per_node, hugetlb_cma_size - reserved);
+		if (node_specific_cma_alloc) {
+			if (hugetlb_cma_size_in_node[nid] == 0)
+				continue;
+
+			size = hugetlb_cma_size_in_node[nid];
+		} else {
+			size = min(per_node, hugetlb_cma_size - reserved);
+		}
+
 		size = round_up(size, PAGE_SIZE << order);
 
 		snprintf(name, sizeof(name), "hugetlb%d", nid);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-migrate-simplify-the-file-backed-pages-validation-when-migrating-its-mapping.patch

