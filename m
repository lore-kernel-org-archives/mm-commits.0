Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C55CC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 19:56:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5841B61006
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 19:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243191AbhDPT4s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Apr 2021 15:56:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243468AbhDPT4k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Apr 2021 15:56:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 995A0613CC;
        Fri, 16 Apr 2021 19:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618602973;
        bh=jWjykeo8ZMB0blXHCRZSXNWFpx4SYXaOt/8t5lMsND0=;
        h=Date:From:To:Subject:From;
        b=iX6iapLMjdIcP4ETYSMClVFlVBqlmzjQZLSpdBejnjSz59kSM1EV3duuuS9Xdc4Y6
         cj4WYfydfdwf3mPHoCFlR18aC8V3x3e1jCqRRumZD2AtmPaXNGsMb0T44c1y04Keba
         AeA64uEgUh4cgGUS6ICv2LYiPTtcF5KLQUPzDJ9Q=
Date:   Fri, 16 Apr 2021 12:56:13 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        pasha.tatashin@soleen.com, mhocko@suse.com, mhocko@kernel.org,
        david@redhat.com, anshuman.khandual@arm.com, osalvador@suse.de
Subject:  +
 acpimemhotplug-enable-mhp_memmap_on_memory-when-supported.patch added to -mm
 tree
Message-ID: <20210416195613.d4zKM%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: acpi,memhotplug: anable MHP_MEMMAP_ON_MEMORY when supported
has been added to the -mm tree.  Its filename is
     acpimemhotplug-enable-mhp_memmap_on_memory-when-supported.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/acpimemhotplug-enable-mhp_memmap_on_memory-when-supported.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/acpimemhotplug-enable-mhp_memmap_on_memory-when-supported.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: acpi,memhotplug: anable MHP_MEMMAP_ON_MEMORY when supported

Let the caller check whether it can pass MHP_MEMMAP_ON_MEMORY by checking
 mhp_supports_memmap_on_memory().  MHP_MEMMAP_ON_MEMORY can only be set in
 case ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE is enabled, the architecture
 supports altmap, and the range to be added spans a single memory block.

Link: https://lkml.kernel.org/r/20210416112411.9826-6-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/acpi_memhotplug.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/acpi/acpi_memhotplug.c~acpimemhotplug-enable-mhp_memmap_on_memory-when-supported
+++ a/drivers/acpi/acpi_memhotplug.c
@@ -171,6 +171,7 @@ static int acpi_memory_enable_device(str
 	acpi_handle handle = mem_device->device->handle;
 	int result, num_enabled = 0;
 	struct acpi_memory_info *info;
+	mhp_t mhp_flags = MHP_NONE;
 	int node;
 
 	node = acpi_get_node(handle);
@@ -194,8 +195,10 @@ static int acpi_memory_enable_device(str
 		if (node < 0)
 			node = memory_add_physaddr_to_nid(info->start_addr);
 
+		if (mhp_supports_memmap_on_memory(info->length))
+			mhp_flags |= MHP_MEMMAP_ON_MEMORY;
 		result = __add_memory(node, info->start_addr, info->length,
-				      MHP_NONE);
+				      mhp_flags);
 
 		/*
 		 * If the memory block has been used by the kernel, add_memory()
_

Patches currently in -mm which might be from osalvador@suse.de are

x86-vmemmap-drop-handling-of-4k-unaligned-vmemmap-range.patch
x86-vmemmap-drop-handling-of-1gb-vmemmap-ranges.patch
x86-vmemmap-handle-unpopulated-sub-pmd-ranges.patch
x86-vmemmap-handle-unpopulated-sub-pmd-ranges-fix.patch
x86-vmemmap-optimize-for-consecutive-sections-in-partial-populated-pmds.patch
drivers-base-memory-introduce-memory_block_onlineoffline.patch
mmmemory_hotplug-relax-fully-spanned-sections-check.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range.patch
acpimemhotplug-enable-mhp_memmap_on_memory-when-supported.patch
mmmemory_hotplug-add-kernel-boot-option-to-enable-memmap_on_memory.patch
x86-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch
arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch

