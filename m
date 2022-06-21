Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09619C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jun 2022 21:07:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355877AbiFUVH0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Jun 2022 17:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355880AbiFUVHM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2022 17:07:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E72DB31367
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 13:54:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87C6461856
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 20:54:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41720C341C7;
        Tue, 21 Jun 2022 20:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655844888;
        bh=a4zH8at0tFeuXVVAPxlTpmbiIUSb2EVQvnOqT4F00O8=;
        h=Date:To:From:Subject:From;
        b=PtvuI2w2quRU+J0rThlqVft1j66VFQbNTjM5KwetAPJiUg6HEHKnlNwfNxadPmV10
         ZcTIEcfVB3GaDMKdYv4iX1l7Mgu79ZangmkAFy7yKk6ikR1aujzj/N3sjRNivCvVAD
         qz6vKlkXOf628iWYvzIlTJoPiornsbUb6w+x8xnc=
Date:   Tue, 21 Jun 2022 13:54:39 -0700
To:     mm-commits@vger.kernel.org, paulmck@kernel.org, osalvador@suse.de,
        mike.kravetz@oracle.com, duanxiongchun@bytedance.com,
        david@redhat.com, corbet@lwn.net, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-enumerate-all-supported-section-flags-v5.patch added to mm-unstable branch
Message-Id: <20220621205446.41720C341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory_hotplug-enumerate-all-supported-section-flags-v5
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-enumerate-all-supported-section-flags-v5.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-enumerate-all-supported-section-flags-v5.patch

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
@@ -1439,16 +1439,13 @@ enum {
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

