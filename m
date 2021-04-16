Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82CD0C43460
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 18:12:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5775E611AB
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 18:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237802AbhDPSMw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Apr 2021 14:12:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236084AbhDPSMv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Apr 2021 14:12:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FE87613B0;
        Fri, 16 Apr 2021 18:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618596744;
        bh=8sKU394inG1ptMR6jqMIGWYRKWFKHnrcs7QH+uIL2Iw=;
        h=Date:From:To:Subject:From;
        b=2ojuqGwe9+M18WIsYzIea9xHnBKZ6BsMgf88DtFm26fPzsuvCehveTFnI+o3B4B20
         D3npNaNC3SSB1Fi5lSw5083QIDEEgFt+BNrt1RGGyfRLCXEyoeDvw9dWpCV9h0Pgfb
         JXIbgVtPNMeVoHArXhbjRmOmWcOouwUlszXPP9Vc=
Date:   Fri, 16 Apr 2021 11:12:24 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        pasha.tatashin@soleen.com, osalvador@suse.de, mhocko@kernel.org,
        david@redhat.com, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
Subject:  [to-be-updated]
 mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
 removed from -mm tree
Message-ID: <20210416181224.zVeZ5%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix
has been removed from the -mm tree.  Its filename was
     mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix

typo & code cleanup, per David

Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory_hotplug.c~mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix
+++ a/mm/memory_hotplug.c
@@ -1097,7 +1097,7 @@ bool mhp_supports_memmap_on_memory(unsig
 	 * Besides having arch support and the feature enabled at runtime, we
 	 * need a few more assumptions to hold true:
 	 *
-	 * a) We span a single memory block: memory onlining/offlinin;g happens
+	 * a) We span a single memory block: memory onlining/offlining happens
 	 *    in memory block granularity. We don't want the vmemmap of online
 	 *    memory blocks to reside on offline memory blocks. In the future,
 	 *    we might want to support variable-sized memory blocks to make the
@@ -1123,7 +1123,7 @@ bool mhp_supports_memmap_on_memory(unsig
 	       IS_ENABLED(CONFIG_MHP_MEMMAP_ON_MEMORY) &&
 	       size == memory_block_size_bytes() &&
 	       IS_ALIGNED(vmemmap_size, PMD_SIZE) &&
-	       IS_ALIGNED(remaining_size, (pageblock_nr_pages << PAGE_SHIFT));
+	       IS_ALIGNED(remaining_size, pageblock_nr_pages << PAGE_SHIFT);
 }
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

scripts-a-new-script-for-checking-duplicate-struct-declaration-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
mm-vmalloc-remove-unmap_kernel_range-fix-fix.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix.patch
mm-vmscan-add-shrinker_info_protected-helper-fix.patch
mm-drop-redundant-arch_enable__migration-fix.patch
mm-drop-redundant-arch_enable__migration-fix-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

