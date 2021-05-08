Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40142C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11DB361402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbhEHWwM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:52:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhEHWwK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:52:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88F2461426;
        Sat,  8 May 2021 22:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514268;
        bh=ebTVg3+fcuFFhmBN7vNacJQ91TSvGWB5CtMLAgJqrWE=;
        h=Date:From:To:Subject:From;
        b=XjD0ST8OhzWRAvEW5SghQ1vDmE3kQjhhl3aY36jWU8AHtEoogDfb7GeycVZahr2Mp
         LB/TZ/BMjG7r53v7VZstsjV7gSow/jF+B0Lz6IvuvMvRqlXIN55w3CC36rNYdvQ613
         Otz/QSAc/ct/vRwSNLCvCLk5hjot5uvYVYya65xc=
Date:   Sat, 08 May 2021 15:51:08 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, david@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, vbabka@suse.cz
Subject:  [merged]
 acpimemhotplug-enable-mhp_memmap_on_memory-when-supported.patch removed
 from -mm tree
Message-ID: <20210508225108.v5oN9r8dj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: acpi,memhotplug: enable MHP_MEMMAP_ON_MEMORY when supported
has been removed from the -mm tree.  Its filename was
     acpimemhotplug-enable-mhp_memmap_on_memory-when-supported.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: acpi,memhotplug: enable MHP_MEMMAP_ON_MEMORY when supported

Let the caller check whether it can pass MHP_MEMMAP_ON_MEMORY by checking
mhp_supports_memmap_on_memory().  MHP_MEMMAP_ON_MEMORY can only be set in
case ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE is enabled, the architecture
supports altmap, and the range to be added spans a single memory block.

Link: https://lkml.kernel.org/r/20210421102701.25051-6-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
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


