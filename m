Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E707C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26E7461260
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234383AbhKKCtW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:49:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:54190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234346AbhKKCtW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:49:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5ACC6103C;
        Thu, 11 Nov 2021 02:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598794;
        bh=SdPWBqYckav3luBnUmvwqAmdt54rtvMIEqYBWmzva/g=;
        h=Date:From:To:Subject:From;
        b=KIAGtVgFhF/ZNtwBUqPT9WWKB+sX3OK4d0RRaFxDWJAl6iHanbaaMpLR85wP+QgTW
         0d3tNKQebecWNTexb/pLmm0IZbTFr53nZ2+FVxaov/4sB9zG+CBaJGEX44Pzyt/tdL
         zB9Svl+Zaa9PiKivwNTa0P1nSlAO6YhHkuVJHg/k=
Date:   Wed, 10 Nov 2021 18:46:33 -0800
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, corbet@lwn.net, dan.carpenter@oracle.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, nathan@kernel.org, paulus@samba.org,
        rppt@kernel.org, willy@infradead.org, yaozhenguo1@gmail.com
Subject:  [merged]
 =?US-ASCII?Q?hugetlbfs-extend-the-definition-of-hugepages-parameter-to-s?=
 =?US-ASCII?Q?upport-node-allocation.patch?= removed from -mm tree
Message-ID: <20211111024633.DMbV36Emz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: extend the definition of hugepages parameter to support node allocation
has been removed from the -mm tree.  Its filename was
     hugetlbfs-extend-the-definition-of-hugepages-parameter-to-support-node-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhenguo Yao <yaozhenguo1@gmail.com>
Subject: hugetlbfs: extend the definition of hugepages parameter to support node allocation

We can specify the number of hugepages to allocate at boot.  But the
hugepages is balanced in all nodes at present.  In some scenarios, we only
need hugepages in one node.  For example: DPDK needs hugepages which are
in the same node as NIC.

If DPDK needs four hugepages of 1G size in node1 and system has 16 numa
nodes we must reserve 64 hugepages on the kernel cmdline.  But only four
hugepages are used.  The others should be free after boot.  If the system
memory is low(for example: 64G), it will be an impossible task.

So extend the hugepages parameter to support specifying hugepages on a
specific node.  For example add following parameter:

hugepagesz=1G hugepages=0:1,1:3

It will allocate 1 hugepage in node0 and 3 hugepages in node1.

Link: https://lkml.kernel.org/r/20211005054729.86457-1-yaozhenguo1@gmail.com
Signed-off-by: Zhenguo Yao <yaozhenguo1@gmail.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zhenguo Yao <yaozhenguo1@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    8 
 Documentation/admin-guide/mm/hugetlbpage.rst    |   12 +
 arch/powerpc/mm/hugetlbpage.c                   |    9 
 include/linux/hugetlb.h                         |    6 
 mm/hugetlb.c                                    |  153 +++++++++++---
 5 files changed, 155 insertions(+), 33 deletions(-)

--- a/arch/powerpc/mm/hugetlbpage.c~hugetlbfs-extend-the-definition-of-hugepages-parameter-to-support-node-allocation
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -229,17 +229,22 @@ static int __init pseries_alloc_bootmem_
 	m->hstate = hstate;
 	return 1;
 }
+
+bool __init hugetlb_node_alloc_supported(void)
+{
+	return false;
+}
 #endif
 
 
-int __init alloc_bootmem_huge_page(struct hstate *h)
+int __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 {
 
 #ifdef CONFIG_PPC_BOOK3S_64
 	if (firmware_has_feature(FW_FEATURE_LPAR) && !radix_enabled())
 		return pseries_alloc_bootmem_huge_page(h);
 #endif
-	return __alloc_bootmem_huge_page(h);
+	return __alloc_bootmem_huge_page(h, nid);
 }
 
 #ifndef CONFIG_PPC_BOOK3S_64
--- a/Documentation/admin-guide/kernel-parameters.txt~hugetlbfs-extend-the-definition-of-hugepages-parameter-to-support-node-allocation
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1601,9 +1601,11 @@
 			the number of pages of hugepagesz to be allocated.
 			If this is the first HugeTLB parameter on the command
 			line, it specifies the number of pages to allocate for
-			the default huge page size.  See also
-			Documentation/admin-guide/mm/hugetlbpage.rst.
-			Format: <integer>
+			the default huge page size. If using node format, the
+			number of pages to allocate per-node can be specified.
+			See also Documentation/admin-guide/mm/hugetlbpage.rst.
+			Format: <integer> or (node format)
+				<node>:<integer>[,<node>:<integer>]
 
 	hugepagesz=
 			[HW] The size of the HugeTLB pages.  This is used in
--- a/Documentation/admin-guide/mm/hugetlbpage.rst~hugetlbfs-extend-the-definition-of-hugepages-parameter-to-support-node-allocation
+++ a/Documentation/admin-guide/mm/hugetlbpage.rst
@@ -128,7 +128,9 @@ hugepages
 	implicitly specifies the number of huge pages of default size to
 	allocate.  If the number of huge pages of default size is implicitly
 	specified, it can not be overwritten by a hugepagesz,hugepages
-	parameter pair for the default size.
+	parameter pair for the default size.  This parameter also has a
+	node format.  The node format specifies the number of huge pages
+	to allocate on specific nodes.
 
 	For example, on an architecture with 2M default huge page size::
 
@@ -138,6 +140,14 @@ hugepages
 	indicating that the hugepages=512 parameter is ignored.  If a hugepages
 	parameter is preceded by an invalid hugepagesz parameter, it will
 	be ignored.
+
+	Node format example::
+
+		hugepagesz=2M hugepages=0:1,1:2
+
+	It will allocate 1 2M hugepage on node0 and 2 2M hugepages on node1.
+	If the node number is invalid,  the parameter will be ignored.
+
 default_hugepagesz
 	Specify the default huge page size.  This parameter can
 	only be specified once on the command line.  default_hugepagesz can
--- a/include/linux/hugetlb.h~hugetlbfs-extend-the-definition-of-hugepages-parameter-to-support-node-allocation
+++ a/include/linux/hugetlb.h
@@ -615,6 +615,7 @@ struct hstate {
 	unsigned long nr_overcommit_huge_pages;
 	struct list_head hugepage_activelist;
 	struct list_head hugepage_freelists[MAX_NUMNODES];
+	unsigned int max_huge_pages_node[MAX_NUMNODES];
 	unsigned int nr_huge_pages_node[MAX_NUMNODES];
 	unsigned int free_huge_pages_node[MAX_NUMNODES];
 	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
@@ -647,8 +648,9 @@ void restore_reserve_on_error(struct hst
 				unsigned long address, struct page *page);
 
 /* arch callback */
-int __init __alloc_bootmem_huge_page(struct hstate *h);
-int __init alloc_bootmem_huge_page(struct hstate *h);
+int __init __alloc_bootmem_huge_page(struct hstate *h, int nid);
+int __init alloc_bootmem_huge_page(struct hstate *h, int nid);
+bool __init hugetlb_node_alloc_supported(void);
 
 void __init hugetlb_add_hstate(unsigned order);
 bool __init arch_hugetlb_valid_size(unsigned long size);
--- a/mm/hugetlb.c~hugetlbfs-extend-the-definition-of-hugepages-parameter-to-support-node-allocation
+++ a/mm/hugetlb.c
@@ -77,6 +77,7 @@ static struct hstate * __initdata parsed
 static unsigned long __initdata default_hstate_max_huge_pages;
 static bool __initdata parsed_valid_hugepagesz = true;
 static bool __initdata parsed_default_hugepagesz;
+static unsigned int default_hugepages_in_node[MAX_NUMNODES] __initdata;
 
 /*
  * Protects updates to hugepage_freelists, hugepage_activelist, nr_huge_pages,
@@ -2963,33 +2964,39 @@ out_subpool_put:
 	return ERR_PTR(-ENOSPC);
 }
 
-int alloc_bootmem_huge_page(struct hstate *h)
+int alloc_bootmem_huge_page(struct hstate *h, int nid)
 	__attribute__ ((weak, alias("__alloc_bootmem_huge_page")));
-int __alloc_bootmem_huge_page(struct hstate *h)
+int __alloc_bootmem_huge_page(struct hstate *h, int nid)
 {
-	struct huge_bootmem_page *m;
+	struct huge_bootmem_page *m = NULL; /* initialize for clang */
 	int nr_nodes, node;
 
+	if (nid >= nr_online_nodes)
+		return 0;
+	/* do node specific alloc */
+	if (nid != NUMA_NO_NODE) {
+		m = memblock_alloc_try_nid_raw(huge_page_size(h), huge_page_size(h),
+				0, MEMBLOCK_ALLOC_ACCESSIBLE, nid);
+		if (!m)
+			return 0;
+		goto found;
+	}
+	/* allocate from next node when distributing huge pages */
 	for_each_node_mask_to_alloc(h, nr_nodes, node, &node_states[N_MEMORY]) {
-		void *addr;
-
-		addr = memblock_alloc_try_nid_raw(
+		m = memblock_alloc_try_nid_raw(
 				huge_page_size(h), huge_page_size(h),
 				0, MEMBLOCK_ALLOC_ACCESSIBLE, node);
-		if (addr) {
-			/*
-			 * Use the beginning of the huge page to store the
-			 * huge_bootmem_page struct (until gather_bootmem
-			 * puts them into the mem_map).
-			 */
-			m = addr;
-			goto found;
-		}
+		/*
+		 * Use the beginning of the huge page to store the
+		 * huge_bootmem_page struct (until gather_bootmem
+		 * puts them into the mem_map).
+		 */
+		if (!m)
+			return 0;
+		goto found;
 	}
-	return 0;
 
 found:
-	BUG_ON(!IS_ALIGNED(virt_to_phys(m), huge_page_size(h)));
 	/* Put them into a private list first because mem_map is not up yet */
 	INIT_LIST_HEAD(&m->list);
 	list_add(&m->list, &huge_boot_pages);
@@ -3029,12 +3036,61 @@ static void __init gather_bootmem_preall
 		cond_resched();
 	}
 }
+static void __init hugetlb_hstate_alloc_pages_onenode(struct hstate *h, int nid)
+{
+	unsigned long i;
+	char buf[32];
+
+	for (i = 0; i < h->max_huge_pages_node[nid]; ++i) {
+		if (hstate_is_gigantic(h)) {
+			if (!alloc_bootmem_huge_page(h, nid))
+				break;
+		} else {
+			struct page *page;
+			gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
+
+			page = alloc_fresh_huge_page(h, gfp_mask, nid,
+					&node_states[N_MEMORY], NULL);
+			if (!page)
+				break;
+			put_page(page); /* free it into the hugepage allocator */
+		}
+		cond_resched();
+	}
+	if (i == h->max_huge_pages_node[nid])
+		return;
+
+	string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
+	pr_warn("HugeTLB: allocating %u of page size %s failed node%d.  Only allocated %lu hugepages.\n",
+		h->max_huge_pages_node[nid], buf, nid, i);
+	h->max_huge_pages -= (h->max_huge_pages_node[nid] - i);
+	h->max_huge_pages_node[nid] = i;
+}
 
 static void __init hugetlb_hstate_alloc_pages(struct hstate *h)
 {
 	unsigned long i;
 	nodemask_t *node_alloc_noretry;
+	bool node_specific_alloc = false;
+
+	/* skip gigantic hugepages allocation if hugetlb_cma enabled */
+	if (hstate_is_gigantic(h) && hugetlb_cma_size) {
+		pr_warn_once("HugeTLB: hugetlb_cma is enabled, skip boot time allocation\n");
+		return;
+	}
+
+	/* do node specific alloc */
+	for (i = 0; i < nr_online_nodes; i++) {
+		if (h->max_huge_pages_node[i] > 0) {
+			hugetlb_hstate_alloc_pages_onenode(h, i);
+			node_specific_alloc = true;
+		}
+	}
 
+	if (node_specific_alloc)
+		return;
+
+	/* below will do all node balanced alloc */
 	if (!hstate_is_gigantic(h)) {
 		/*
 		 * Bit mask controlling how hard we retry per-node allocations.
@@ -3055,11 +3111,7 @@ static void __init hugetlb_hstate_alloc_
 
 	for (i = 0; i < h->max_huge_pages; ++i) {
 		if (hstate_is_gigantic(h)) {
-			if (hugetlb_cma_size) {
-				pr_warn_once("HugeTLB: hugetlb_cma is enabled, skip boot time allocation\n");
-				goto free;
-			}
-			if (!alloc_bootmem_huge_page(h))
+			if (!alloc_bootmem_huge_page(h, NUMA_NO_NODE))
 				break;
 		} else if (!alloc_pool_huge_page(h,
 					 &node_states[N_MEMORY],
@@ -3075,7 +3127,6 @@ static void __init hugetlb_hstate_alloc_
 			h->max_huge_pages, buf, i);
 		h->max_huge_pages = i;
 	}
-free:
 	kfree(node_alloc_noretry);
 }
 
@@ -3990,6 +4041,10 @@ static int __init hugetlb_init(void)
 			}
 			default_hstate.max_huge_pages =
 				default_hstate_max_huge_pages;
+
+			for (i = 0; i < nr_online_nodes; i++)
+				default_hstate.max_huge_pages_node[i] =
+					default_hugepages_in_node[i];
 		}
 	}
 
@@ -4050,6 +4105,10 @@ void __init hugetlb_add_hstate(unsigned
 	parsed_hstate = h;
 }
 
+bool __init __weak hugetlb_node_alloc_supported(void)
+{
+	return true;
+}
 /*
  * hugepages command line processing
  * hugepages normally follows a valid hugepagsz or default_hugepagsz
@@ -4061,6 +4120,10 @@ static int __init hugepages_setup(char *
 {
 	unsigned long *mhp;
 	static unsigned long *last_mhp;
+	int node = NUMA_NO_NODE;
+	int count;
+	unsigned long tmp;
+	char *p = s;
 
 	if (!parsed_valid_hugepagesz) {
 		pr_warn("HugeTLB: hugepages=%s does not follow a valid hugepagesz, ignoring\n", s);
@@ -4084,8 +4147,40 @@ static int __init hugepages_setup(char *
 		return 0;
 	}
 
-	if (sscanf(s, "%lu", mhp) <= 0)
-		*mhp = 0;
+	while (*p) {
+		count = 0;
+		if (sscanf(p, "%lu%n", &tmp, &count) != 1)
+			goto invalid;
+		/* Parameter is node format */
+		if (p[count] == ':') {
+			if (!hugetlb_node_alloc_supported()) {
+				pr_warn("HugeTLB: architecture can't support node specific alloc, ignoring!\n");
+				return 0;
+			}
+			node = tmp;
+			p += count + 1;
+			if (node < 0 || node >= nr_online_nodes)
+				goto invalid;
+			/* Parse hugepages */
+			if (sscanf(p, "%lu%n", &tmp, &count) != 1)
+				goto invalid;
+			if (!hugetlb_max_hstate)
+				default_hugepages_in_node[node] = tmp;
+			else
+				parsed_hstate->max_huge_pages_node[node] = tmp;
+			*mhp += tmp;
+			/* Go to parse next node*/
+			if (p[count] == ',')
+				p += count + 1;
+			else
+				break;
+		} else {
+			if (p != s)
+				goto invalid;
+			*mhp = tmp;
+			break;
+		}
+	}
 
 	/*
 	 * Global state is always initialized later in hugetlb_init.
@@ -4098,6 +4193,10 @@ static int __init hugepages_setup(char *
 	last_mhp = mhp;
 
 	return 1;
+
+invalid:
+	pr_warn("HugeTLB: Invalid hugepages parameter %s\n", p);
+	return 0;
 }
 __setup("hugepages=", hugepages_setup);
 
@@ -4159,6 +4258,7 @@ __setup("hugepagesz=", hugepagesz_setup)
 static int __init default_hugepagesz_setup(char *s)
 {
 	unsigned long size;
+	int i;
 
 	parsed_valid_hugepagesz = false;
 	if (parsed_default_hugepagesz) {
@@ -4187,6 +4287,9 @@ static int __init default_hugepagesz_set
 	 */
 	if (default_hstate_max_huge_pages) {
 		default_hstate.max_huge_pages = default_hstate_max_huge_pages;
+		for (i = 0; i < nr_online_nodes; i++)
+			default_hstate.max_huge_pages_node[i] =
+				default_hugepages_in_node[i];
 		if (hstate_is_gigantic(&default_hstate))
 			hugetlb_hstate_alloc_pages(&default_hstate);
 		default_hstate_max_huge_pages = 0;
_

Patches currently in -mm which might be from yaozhenguo1@gmail.com are


