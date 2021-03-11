Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1239BC433E6
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 00:51:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D483464FCE
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 00:51:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhCKAvO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Mar 2021 19:51:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:54898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229808AbhCKAvC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Mar 2021 19:51:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A71564F7B;
        Thu, 11 Mar 2021 00:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615423862;
        bh=tmR1sOEmw0C/ThgCLAgH6DoHa4IopPXNoI6vFPGuA7g=;
        h=Date:From:To:Subject:From;
        b=JGMuYXxMaB8HcpQBVm0kT5piFCBL3cFhNjtBCU9leLP7m6D3GEk8MGznQHvCs1lDu
         KZcLSpmgs1Jcf9xqcyMHACZPuLBmxgNJh+9Gu1kAi6Ny5b4aOFUiM2fUfGholgug7U
         gUJKoUkTLf1fGVz9yZFATvdJUZso/5ysluhd/keY=
Date:   Wed, 10 Mar 2021 16:51:01 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, david@redhat.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, vbabka@suse.cz
Subject:  +
 mmmemory_hotplug-add-kernel-boot-option-to-enable-memmap_on_memory.patch
 added to -mm tree
Message-ID: <20210311005101.HzOWKK_RF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,memory_hotplug: add kernel boot option to enable memmap_on_memory
has been added to the -mm tree.  Its filename is
     mmmemory_hotplug-add-kernel-boot-option-to-enable-memmap_on_memory.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmmemory_hotplug-add-kernel-boot-option-to-enable-memmap_on_memory.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmmemory_hotplug-add-kernel-boot-option-to-enable-memmap_on_memory.patch

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
Subject: mm,memory_hotplug: add kernel boot option to enable memmap_on_memory

Self stored memmap leads to a sparse memory situation which is unsuitable
for workloads that requires large contiguous memory chunks, so make this
an opt-in which needs to be explicitly enabled.

To control this, let memory_hotplug have its own memory space, as
suggested by David, so we can add memory_hotplug.memmap_on_memory
parameter.

Link: https://lkml.kernel.org/r/20210309175546.5877-4-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |   16 ++++++++++++++
 mm/Makefile                                     |    5 +++-
 mm/memory_hotplug.c                             |   10 +++++++-
 3 files changed, 29 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~mmmemory_hotplug-add-kernel-boot-option-to-enable-memmap_on_memory
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -2808,6 +2808,22 @@
 			seconds.  Use this parameter to check at some
 			other rate.  0 disables periodic checking.
 
+	memory_hotplug.memmap_on_memory
+			[KNL,X86,ARM] Boolean flag to enable this feature.
+			Format: {on | off (default)}
+			When enabled, memory to build the pages tables for the
+			memmap array describing the hot-added range will be taken
+			from the range itself, so the memmap page tables will be
+			self-hosted.
+			Since only single memory device ranges are supported at
+			the moment, this option is disabled by default because
+			it might have an impact on workloads that needs large
+			contiguous memory chunks.
+			The state of the flag can be read in
+			/sys/module/memory_hotplug/parameters/memmap_on_memory.
+			Note that even when enabled, there are a few cases where
+			the feature is not effective.
+
 	memtest=	[KNL,X86,ARM,PPC] Enable memtest
 			Format: <integer>
 			default : 0 <disable>
--- a/mm/Makefile~mmmemory_hotplug-add-kernel-boot-option-to-enable-memmap_on_memory
+++ a/mm/Makefile
@@ -58,9 +58,13 @@ obj-y			:= filemap.o mempool.o oom_kill.
 page-alloc-y := page_alloc.o
 page-alloc-$(CONFIG_SHUFFLE_PAGE_ALLOCATOR) += shuffle.o
 
+# Give 'memory_hotplug' its own module-parameter namespace
+memory-hotplug-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o
+
 obj-y += page-alloc.o
 obj-y += init-mm.o
 obj-y += memblock.o
+obj-y += $(memory-hotplug-y)
 
 ifdef CONFIG_MMU
 	obj-$(CONFIG_ADVISE_SYSCALLS)	+= madvise.o
@@ -85,7 +89,6 @@ obj-$(CONFIG_KASAN)	+= kasan/
 obj-$(CONFIG_KFENCE) += kfence/
 obj-$(CONFIG_FAILSLAB) += failslab.o
 obj-$(CONFIG_HAVE_BOOTMEM_INFO_NODE) += bootmem_info.o
-obj-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o
 obj-$(CONFIG_MEMTEST)		+= memtest.o
 obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
--- a/mm/memory_hotplug.c~mmmemory_hotplug-add-kernel-boot-option-to-enable-memmap_on_memory
+++ a/mm/memory_hotplug.c
@@ -42,7 +42,15 @@
 #include "internal.h"
 #include "shuffle.h"
 
-static bool memmap_on_memory;
+
+/*
+ * memory_hotplug.memmap_on_memory parameter
+ */
+static bool memmap_on_memory __ro_after_init;
+#ifdef CONFIG_MHP_MEMMAP_ON_MEMORY
+module_param(memmap_on_memory, bool, 0444);
+MODULE_PARM_DESC(memmap_on_memory, "Enable memmap on memory for memory hotplug");
+#endif
 
 /*
  * online_page_callback contains pointer to current page onlining function.
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

