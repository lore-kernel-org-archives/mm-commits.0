Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A86D7C48BDF
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 01:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 986BA613B1
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 01:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhFPB0R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Jun 2021 21:26:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231831AbhFPB0Q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Jun 2021 21:26:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 561AE6137D;
        Wed, 16 Jun 2021 01:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623806651;
        bh=Cwq6W9yiFn6kEvmMv86He3UjQESiIWQieCGZ4UAvp7k=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=KmHSEw4RecV9geYmRj6G7pJY9py/mvtjeA09XVM/F+PLPFh7xN2FaRd+6gGi2SqRU
         8VB7scCyAFi0Ln1ewVtjlFhk/icaDyVG8OrF3ql7tFnsHzTnKMToSb9QzU7yuqWoJs
         PFZU6lSXhpLZtGWN/Bo6HxIgURWfpaCqJt+2BlWo=
Date:   Tue, 15 Jun 2021 18:24:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, k-hagio-ab@nec.com,
        linux-mm@kvack.org, miles.chen@mediatek.com,
        mm-commits@vger.kernel.org, rppt@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 18/18] mm/sparse: fix check_usemap_section_nr
 warnings
Message-ID: <20210616012410.BpXfvlbxU%akpm@linux-foundation.org>
In-Reply-To: <20210615182248.9a0ba90e8e66b9f4a53c0d23@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miles Chen <miles.chen@mediatek.com>
Subject: mm/sparse: fix check_usemap_section_nr warnings

I see a "virt_to_phys used for non-linear address" warning from
check_usemap_section_nr() on arm64 platforms.

In current implementation of NODE_DATA, if CONFIG_NEED_MULTIPLE_NODES=y,
pglist_data is dynamically allocated and assigned to node_data[].

For example, in arch/arm64/include/asm/mmzone.h:
extern struct pglist_data *node_data[];
\#define NODE_DATA(nid)          (node_data[(nid)])

If CONFIG_NEED_MULTIPLE_NODES=n, pglist_data is defined as a global
variable named "contig_page_data".

For example, in include/linux/mmzone.h:
extern struct pglist_data contig_page_data;
\#define NODE_DATA(nid)          (&contig_page_data)

If CONFIG_DEBUG_VIRTUAL is not enabled, __pa() can handle both
dynamically allocated linear addresses and symbol addresses.
However, if (CONFIG_DEBUG_VIRTUAL=y && CONFIG_NEED_MULTIPLE_NODES=n)
,we can see the "virt_to_phys used for non-linear address"
warning because that &contig_page_data is not a linear address on arm64.

To fix it, create a small function to handle both translation.

Warning message:
[    0.000000] ------------[ cut here ]------------
[    0.000000] virt_to_phys used for non-linear address: (____ptrval____) (contig_page_data+0x0/0x1c00)
[    0.000000] WARNING: CPU: 0 PID: 0 at arch/arm64/mm/physaddr.c:15 __virt_to_phys+0x58/0x68
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Tainted: G        W         5.13.0-rc1-00074-g1140ab592e2e #3
[    0.000000] Hardware name: linux,dummy-virt (DT)
[    0.000000] pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO BTYPE=--)
[    0.000000] pc : __virt_to_phys+0x58/0x68
[    0.000000] lr : __virt_to_phys+0x54/0x68
[    0.000000] sp : ffff800011833e70
[    0.000000] x29: ffff800011833e70 x28: 00000000418a0018 x27: 0000000000000000
[    0.000000] x26: 000000000000000a x25: ffff800011b70000 x24: ffff800011b70000
[    0.000000] x23: fffffc0001c00000 x22: ffff800011b70000 x21: 0000000047ffffb0
[    0.000000] x20: 0000000000000008 x19: ffff800011b082c0 x18: ffffffffffffffff
[    0.000000] x17: 0000000000000000 x16: ffff800011833bf9 x15: 0000000000000004
[    0.000000] x14: 0000000000000fff x13: ffff80001186a548 x12: 0000000000000000
[    0.000000] x11: 0000000000000000 x10: 00000000ffffffff x9 : 0000000000000000
[    0.000000] x8 : ffff8000115c9000 x7 : 737520737968705f x6 : ffff800011b62ef8
[    0.000000] x5 : 0000000000000000 x4 : 0000000000000001 x3 : 0000000000000000
[    0.000000] x2 : 0000000000000000 x1 : ffff80001159585e x0 : 0000000000000058
[    0.000000] Call trace:
[    0.000000]  __virt_to_phys+0x58/0x68
[    0.000000]  check_usemap_section_nr+0x50/0xfc
[    0.000000]  sparse_init_nid+0x1ac/0x28c
[    0.000000]  sparse_init+0x1c4/0x1e0
[    0.000000]  bootmem_init+0x60/0x90
[    0.000000]  setup_arch+0x184/0x1f0
[    0.000000]  start_kernel+0x78/0x488
[    0.000000] ---[ end trace f68728a0d3053b60 ]---

Link: https://lkml.kernel.org/r/1623058729-27264-1-git-send-email-miles.chen@mediatek.com
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Kazu <k-hagio-ab@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/mm/sparse.c~mm-sparse-fix-check_usemap_section_nr-warnings
+++ a/mm/sparse.c
@@ -344,6 +344,15 @@ size_t mem_section_usage_size(void)
 	return sizeof(struct mem_section_usage) + usemap_size();
 }
 
+static inline phys_addr_t pgdat_to_phys(struct pglist_data *pgdat)
+{
+#ifndef CONFIG_NEED_MULTIPLE_NODES
+	return __pa_symbol(pgdat);
+#else
+	return __pa(pgdat);
+#endif
+}
+
 #ifdef CONFIG_MEMORY_HOTREMOVE
 static struct mem_section_usage * __init
 sparse_early_usemaps_alloc_pgdat_section(struct pglist_data *pgdat,
@@ -362,7 +371,7 @@ sparse_early_usemaps_alloc_pgdat_section
 	 * from the same section as the pgdat where possible to avoid
 	 * this problem.
 	 */
-	goal = __pa(pgdat) & (PAGE_SECTION_MASK << PAGE_SHIFT);
+	goal = pgdat_to_phys(pgdat) & (PAGE_SECTION_MASK << PAGE_SHIFT);
 	limit = goal + (1UL << PA_SECTION_SHIFT);
 	nid = early_pfn_to_nid(goal >> PAGE_SHIFT);
 again:
@@ -390,7 +399,7 @@ static void __init check_usemap_section_
 	}
 
 	usemap_snr = pfn_to_section_nr(__pa(usage) >> PAGE_SHIFT);
-	pgdat_snr = pfn_to_section_nr(__pa(pgdat) >> PAGE_SHIFT);
+	pgdat_snr = pfn_to_section_nr(pgdat_to_phys(pgdat) >> PAGE_SHIFT);
 	if (usemap_snr == pgdat_snr)
 		return;
 
_
