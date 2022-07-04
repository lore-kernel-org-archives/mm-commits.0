Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD78DC43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 00:03:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiGDADK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 20:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiGDADJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 20:03:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8860A60EC
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 17:03:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 277EDB80909
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 00:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21B7C341C6;
        Mon,  4 Jul 2022 00:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656892985;
        bh=Zwu78RNzvSJGoavK+w2kKPh3kGyKLa0yDIiYnjRee6E=;
        h=Date:To:From:Subject:From;
        b=Y7yeH7jI2oGxmDgXhNHlxmx5BzThq35m5HIEsX1g2kyoCk9pvUc8ld/rzeb8wlVsO
         YpAqxXpKyVq15wyKU3kWxjrlewPJ51kI/d2F0A3Sh0HuqQ7Ay6ouQf/N7cDOzuTDs1
         3ARySr/ccPeviL3ztZNfL1zgncJ153PdRKMh90dk=
Date:   Sun, 03 Jul 2022 17:03:05 -0700
To:     mm-commits@vger.kernel.org, paulmck@kernel.org, osalvador@suse.de,
        mike.kravetz@oracle.com, duanxiongchun@bytedance.com,
        david@redhat.com, corbet@lwn.net, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory-v5.patch removed from -mm tree
Message-Id: <20220704000305.B21B7C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory-v5
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory-v5.patch

This patch was dropped because it was folded into mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory.patch

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
mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory.patch
mm-hugetlb-remove-minimum_order-variable.patch
mm-hugetlb_vmemmap-delete-hugetlb_optimize_vmemmap_enabled.patch
mm-hugetlb_vmemmap-optimize-vmemmap_optimize_mode-handling.patch
mm-hugetlb_vmemmap-introduce-the-name-hvo.patch
mm-hugetlb_vmemmap-move-vmemmap-code-related-to-hugetlb-to-hugetlb_vmemmapc.patch
mm-hugetlb_vmemmap-replace-early_param-with-core_param.patch
mm-hugetlb_vmemmap-improve-hugetlb_vmemmap-code-readability.patch
mm-hugetlb_vmemmap-move-code-comments-to-vmemmap_deduprst.patch
mm-hugetlb_vmemmap-use-ptrs_per_pte-instead-of-pmd_size-page_size.patch
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

