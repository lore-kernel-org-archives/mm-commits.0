Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23039C43381
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 00:51:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E62AA64FC4
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 00:51:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhCKAvO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Mar 2021 19:51:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:54864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229718AbhCKAu7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Mar 2021 19:50:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A18864FBA;
        Thu, 11 Mar 2021 00:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615423859;
        bh=SWF3uKFaaR84TNHwX9FVLe5utwVfXMvUVWu7yGha66k=;
        h=Date:From:To:Subject:From;
        b=qGgPMrwHIR7NQUulW7WROFhzSrUMUMc9G+fj0vVAqeOSbxp3yOx3rVimcMP6/h5Qc
         NLRXF8kOf5JlvPLk0lfd1ItEZJExLDX5nNHkxWWQHO2LU1SDJmWK34KRrQBbtgUUVe
         G6KhuTCNJNF1K4gMHz/gRKViiMDGRT6mmAQ966/k=
Date:   Wed, 10 Mar 2021 16:50:58 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, david@redhat.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, vbabka@suse.cz
Subject:  +
 acpimemhotplug-enable-mhp_memmap_on_memory-when-supported.patch added to
 -mm tree
Message-ID: <20210311005058.SoQ4HzpBO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: acpi,memhotplug: enable MHP_MEMMAP_ON_MEMORY when supported
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
Subject: acpi,memhotplug: enable MHP_MEMMAP_ON_MEMORY when supported

Let the caller check whether it can pass MHP_MEMMAP_ON_MEMORY by checking
mhp_supports_memmap_on_memory().  MHP_MEMMAP_ON_MEMORY can only be set in
case ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE is enabled, the architecture
supports altmap, and the range to be added spans a single memory block.

Link: https://lkml.kernel.org/r/20210309175546.5877-3-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
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
x86-vmemmap-optimize-for-consecutive-sections-in-partial-populated-pmds.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range.patch
acpimemhotplug-enable-mhp_memmap_on_memory-when-supported.patch
mmmemory_hotplug-add-kernel-boot-option-to-enable-memmap_on_memory.patch
x86-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch
arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch

