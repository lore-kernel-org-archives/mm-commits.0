Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFB52C47094
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 22:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9684361029
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 22:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhFGWYh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 18:24:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230197AbhFGWYh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 18:24:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B51E461040;
        Mon,  7 Jun 2021 22:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623104555;
        bh=zb6tfeD2TVMx7iwbA/FPeB87EZbfZvfXMJKfb40OT9k=;
        h=Date:From:To:Subject:From;
        b=UHzr1xBlHJ1JM74861EE9YZUc5C3nFoWWc7F1E1hDhzvD9OZeYZ/MBB0lGnKASrK2
         I6c5f9dIo0uLiwEeGetT1vZSTDUsxYydlnZdz7WX6BMlpKxHg9An9zIuaMwBEJ0I6/
         bkk6e9V3Lu5vs8C8/PA6V7FXzSiHTAR7uPFf5ixM=
Date:   Mon, 07 Jun 2021 15:22:35 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, k-hagio-ab@nec.com, miles.chen@mediatek.com,
        mm-commits@vger.kernel.org, rppt@kernel.org
Subject:  + mm-sparse-fix-check_usemap_section_nr-warnings.patch
 added to -mm tree
Message-ID: <20210607222235.1RydoZzO-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparse: fix check_usemap_section_nr warnings
has been added to the -mm tree.  Its filename is
     mm-sparse-fix-check_usemap_section_nr-warnings.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-sparse-fix-check_usemap_section_nr-warnings.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-sparse-fix-check_usemap_section_nr-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from miles.chen@mediatek.com are

mm-sparse-fix-check_usemap_section_nr-warnings.patch

