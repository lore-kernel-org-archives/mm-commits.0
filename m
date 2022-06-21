Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B721C43334
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jun 2022 21:07:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356020AbiFUVHh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Jun 2022 17:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356078AbiFUVHW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2022 17:07:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9110D3632A
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 13:54:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4F0F61828
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 20:54:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85CB0C3411C;
        Tue, 21 Jun 2022 20:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655844898;
        bh=BVCpr8I7Ssx4gjuUjTCwHDxbyvvEoJfCMtca0aghllE=;
        h=Date:To:From:Subject:From;
        b=M0FaFcA2N3R6K2ydZJ8zKZS1hUZ5Yqh4MFDimJRdKPXRU3FuofG5BmnpNTdskiys+
         AaYyLwdl83mR0t0wUqK6liWg6Ie33+Ui1Pw0y6mrJt6vp15GEs/Zat+cFFtBa3B+XL
         5uaSTYS5p2yzJ8k9xgA7v5hWsmRsUapvFQR1Ckc0=
Date:   Tue, 21 Jun 2022 13:54:49 -0700
To:     mm-commits@vger.kernel.org, paulmck@kernel.org, osalvador@suse.de,
        mike.kravetz@oracle.com, duanxiongchun@bytedance.com,
        david@redhat.com, corbet@lwn.net, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory-v5.patch added to mm-unstable branch
Message-Id: <20220621205456.85CB0C3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory-v5
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory-v5.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory-v5.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory-v5
Date: Mon, 20 Jun 2022 19:06:16 +0800

walk vmemmap page tables to avoid false-positive

Link: https://lkml.kernel.org/r/20220620110616.12056-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Co-developed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |   69 ++++++++++++++++++++++++++---------------
 1 file changed, 44 insertions(+), 25 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory-v5
+++ a/mm/hugetlb_vmemmap.c
@@ -10,6 +10,7 @@
  */
 #define pr_fmt(fmt)	"HugeTLB: " fmt
 
+#include <linux/memory.h>
 #include "hugetlb_vmemmap.h"
 
 /*
@@ -99,34 +100,52 @@ int hugetlb_vmemmap_alloc(struct hstate
 static unsigned int vmemmap_optimizable_pages(struct hstate *h,
 					      struct page *head)
 {
-	struct mem_section *ms;
-	struct page *vmemmap_page;
-	unsigned long pfn = page_to_pfn(head);
-
 	if (READ_ONCE(vmemmap_optimize_mode) == VMEMMAP_OPTIMIZE_OFF)
 		return 0;
 
-	ms = __pfn_to_section(pfn);
-	vmemmap_page = sparse_decode_mem_map(ms->section_mem_map,
-					     pfn_to_section_nr(pfn));
-	/*
-	 * Only the vmemmap pages' vmemmap may be marked as VmemmapSelfHosted.
-	 *
-	 * Due to HugeTLB alignment requirements, and the vmemmap pages being
-	 * at the start of the hotplugged memory region. Checking any vmemmap
-	 * page's vmemmap is fine.
-	 *
-	 * [      hotplugged memory     ]
-	 * [ vmemmap ][  usable memory  ]
-	 *   ^   |      |            |
-	 *   +---+      |            |
-	 *     ^        |            |
-	 *     +--------+            |
-	 *         ^                 |
-	 *         +-----------------+
-	 */
-	if (PageVmemmapSelfHosted(vmemmap_page))
-		return 0;
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG)) {
+		pmd_t *pmdp, pmd;
+		struct page *vmemmap_page;
+		unsigned long vaddr = (unsigned long)head;
+
+		/*
+		 * Only the vmemmap page's vmemmap page can be self-hosted.
+		 * Walking the page tables to find the backing page of the
+		 * vmemmap page.
+		 */
+		pmdp = pmd_off_k(vaddr);
+		/*
+		 * The READ_ONCE() is used to stabilize *pmdp in a register or
+		 * on the stack so that it will stop changing under the code.
+		 * The only concurrent operation where it can be changed is
+		 * split_vmemmap_huge_pmd() (*pmdp will be stable after this
+		 * operation).
+		 */
+		pmd = READ_ONCE(*pmdp);
+		if (pmd_leaf(pmd))
+			vmemmap_page = pmd_page(pmd) + pte_index(vaddr);
+		else
+			vmemmap_page = pte_page(*pte_offset_kernel(pmdp, vaddr));
+		/*
+		 * Due to HugeTLB alignment requirements and the vmemmap pages
+		 * being at the start of the hotplugged memory region in
+		 * memory_hotplug.memmap_on_memory case. Checking any vmemmap
+		 * page's vmemmap page if it is marked as VmemmapSelfHosted is
+		 * sufficient.
+		 *
+		 * [                  hotplugged memory                  ]
+		 * [        section        ][...][        section        ]
+		 * [ vmemmap ][              usable memory               ]
+		 *   ^   |     |                                        |
+		 *   +---+     |                                        |
+		 *     ^       |                                        |
+		 *     +-------+                                        |
+		 *          ^                                           |
+		 *          +-------------------------------------------+
+		 */
+		if (PageVmemmapSelfHosted(vmemmap_page))
+			return 0;
+	}
 
 	return hugetlb_optimize_vmemmap_pages(h);
 }
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memory_hotplug-enumerate-all-supported-section-flags.patch
mm-memory_hotplug-enumerate-all-supported-section-flags-v5.patch
mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory.patch
mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory-v5.patch
mm-hugetlb-remove-minimum_order-variable.patch
mm-memcontrol-remove-dead-code-and-comments.patch
mm-rename-unlock_page_lruvec_irq-_irqrestore-to-lruvec_unlock_irq-_irqrestore.patch
mm-memcontrol-prepare-objcg-api-for-non-kmem-usage.patch
mm-memcontrol-make-lruvec-lock-safe-when-lru-pages-are-reparented.patch
mm-vmscan-rework-move_pages_to_lru.patch
mm-thp-make-split-queue-lock-safe-when-lru-pages-are-reparented.patch
mm-memcontrol-make-all-the-callers-of-foliopage_memcg-safe.patch
mm-memcontrol-introduce-memcg_reparent_ops.patch
mm-memcontrol-use-obj_cgroup-apis-to-charge-the-lru-pages.patch
mm-lru-add-vm_warn_on_once_folio-to-lru-maintenance-function.patch
mm-lru-use-lruvec-lock-to-serialize-memcg-changes.patch

