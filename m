Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FBE3C43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 00:02:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbiGDACk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 20:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbiGDACk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 20:02:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2924660FA
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 17:02:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA53961255
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 00:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178DEC341CA;
        Mon,  4 Jul 2022 00:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656892958;
        bh=TPMwt1003wczsieZlzUei4kErBVDh9QpHnJAUGiifkQ=;
        h=Date:To:From:Subject:From;
        b=ur5BBXxA4CYV4gUHeVSI9n1n7S8D8AHNmtORcZhCNwAFHfN8iuHqFBj3xuyuQzSpe
         9Vmu+boTZDgtJ/12mvoBx7CCje+NRKEdl9PIs9pGrEFlLUWCCme8asZsxTw7FJWTPz
         8j6z6cbZIs7kJU4F4rKnZAUMm0lCikjgSS1ynOog=
Date:   Sun, 03 Jul 2022 17:02:37 -0700
To:     mm-commits@vger.kernel.org, paulmck@kernel.org, osalvador@suse.de,
        mike.kravetz@oracle.com, duanxiongchun@bytedance.com,
        david@redhat.com, corbet@lwn.net, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memory_hotplug-enumerate-all-supported-section-flags-v5.patch removed from -mm tree
Message-Id: <20220704000238.178DEC341CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-memory_hotplug-enumerate-all-supported-section-flags-v5
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-enumerate-all-supported-section-flags-v5.patch

This patch was dropped because it was folded into mm-memory_hotplug-enumerate-all-supported-section-flags.patch

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm-memory_hotplug-enumerate-all-supported-section-flags-v5
Date: Mon, 20 Jun 2022 19:06:15 +0800

replace enum with defines per David
 
Link: https://lkml.kernel.org/r/20220620110616.12056-2-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/include/linux/mmzone.h~mm-memory_hotplug-enumerate-all-supported-section-flags-v5
+++ a/include/linux/mmzone.h
@@ -1435,16 +1435,13 @@ enum {
 	SECTION_MAP_LAST_BIT,
 };
 
-enum {
-	SECTION_MARKED_PRESENT		= BIT(SECTION_MARKED_PRESENT_BIT),
-	SECTION_HAS_MEM_MAP		= BIT(SECTION_HAS_MEM_MAP_BIT),
-	SECTION_IS_ONLINE		= BIT(SECTION_IS_ONLINE_BIT),
-	SECTION_IS_EARLY		= BIT(SECTION_IS_EARLY_BIT),
+#define SECTION_MARKED_PRESENT		BIT(SECTION_MARKED_PRESENT_BIT)
+#define SECTION_HAS_MEM_MAP		BIT(SECTION_HAS_MEM_MAP_BIT)
+#define SECTION_IS_ONLINE		BIT(SECTION_IS_ONLINE_BIT)
+#define SECTION_IS_EARLY		BIT(SECTION_IS_EARLY_BIT)
 #ifdef CONFIG_ZONE_DEVICE
-	SECTION_TAINT_ZONE_DEVICE	= BIT(SECTION_TAINT_ZONE_DEVICE_BIT),
+#define SECTION_TAINT_ZONE_DEVICE	BIT(SECTION_TAINT_ZONE_DEVICE_BIT)
 #endif
-};
-
 #define SECTION_MAP_MASK		(~(BIT(SECTION_MAP_LAST_BIT) - 1))
 #define SECTION_NID_SHIFT		SECTION_MAP_LAST_BIT
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memory_hotplug-enumerate-all-supported-section-flags.patch
mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory.patch
mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory-v5.patch
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

