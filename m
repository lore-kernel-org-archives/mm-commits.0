Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5C1CC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E23E61426
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhEHWwP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:52:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhEHWwN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:52:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A37AA6101D;
        Sat,  8 May 2021 22:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514270;
        bh=jllKuxyRYJi47Qa7SvmTKYl8x5fAry01JX8xJKUpX9Q=;
        h=Date:From:To:Subject:From;
        b=eCxc0SEhOf0RDd2v0AuU+uB/tRRN4yIBLTzT88ge3+VK8DiSUwNB98wG3jDzowLVA
         i4wSf/i9Fp6OXw8S2HIA7+KPtByv2wslYdDUSXkxZY0PmrZ76/oc3FfVYm109zv+5a
         GCaXVPAWwNeogOwlztei9ibJlVB09JGkSws7+ql8=
Date:   Sat, 08 May 2021 15:51:10 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, david@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, vbabka@suse.cz
Subject:  [merged]
 mmmemory_hotplug-add-kernel-boot-option-to-enable-memmap_on_memory.patch
 removed from -mm tree
Message-ID: <20210508225110.BPN7H1QOC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,memory_hotplug: add kernel boot option to enable memmap_on_memory
has been removed from the -mm tree.  Its filename was
     mmmemory_hotplug-add-kernel-boot-option-to-enable-memmap_on_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,memory_hotplug: add kernel boot option to enable memmap_on_memory

Self stored memmap leads to a sparse memory situation which is unsuitable
for workloads that requires large contiguous memory chunks, so make this
an opt-in which needs to be explicitly enabled.

To control this, let memory_hotplug have its own memory space, as
suggested by David, so we can add memory_hotplug.memmap_on_memory
parameter.

Link: https://lkml.kernel.org/r/20210421102701.25051-7-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |   17 ++++++++++++++
 mm/Makefile                                     |    5 +++-
 mm/memory_hotplug.c                             |   10 +++++++-
 3 files changed, 30 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~mmmemory_hotplug-add-kernel-boot-option-to-enable-memmap_on_memory
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -2801,6 +2801,23 @@
 			seconds.  Use this parameter to check at some
 			other rate.  0 disables periodic checking.
 
+	memory_hotplug.memmap_on_memory
+			[KNL,X86,ARM] Boolean flag to enable this feature.
+			Format: {on | off (default)}
+			When enabled, runtime hotplugged memory will
+			allocate its internal metadata (struct pages)
+			from the hotadded memory which will allow to
+			hotadd a lot of memory without requiring
+			additional memory to do so.
+			This feature is disabled by default because it
+			has some implication on large (e.g. GB)
+			allocations in some configurations (e.g. small
+			memory blocks).
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
@@ -83,7 +87,6 @@ obj-$(CONFIG_SLUB) += slub.o
 obj-$(CONFIG_KASAN)	+= kasan/
 obj-$(CONFIG_KFENCE) += kfence/
 obj-$(CONFIG_FAILSLAB) += failslab.o
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


