Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C71EC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 22:33:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB6C861A54
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 22:33:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348418AbhI3Wfk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Sep 2021 18:35:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345719AbhI3Wfj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Sep 2021 18:35:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F71D61A3F;
        Thu, 30 Sep 2021 22:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633041236;
        bh=PUBRxQkxD0Ehq3FUOYQQIinr4zWPMlT/nd3AzpMUf0k=;
        h=Date:From:To:Subject:From;
        b=IDbtLUVl0CEtM55UfvPTw2qFSQoznGYE1ziVyjyO5irQNPU8HloKZ+9k2Y2EMLnnY
         DD+oBWMMxyymQPZ0MReDEnExYUwQDLXepyMUfGDFm9v1esnnm+1G2eDMUPrcu9CdQE
         SBL3tUbedXbok4xSgW92tbaU0LFiys6DHIRilL/I=
Date:   Thu, 30 Sep 2021 15:33:55 -0700
From:   akpm@linux-foundation.org
To:     alexs@kernel.org, benh@kernel.crashing.org, bp@alien8.de,
        corbet@lwn.net, dave.hansen@linux.intel.com, david@redhat.com,
        gregkh@linuxfoundation.org, hpa@zytor.com, jasowang@redhat.com,
        luto@kernel.org, mhocko@suse.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, mst@redhat.com,
        osalvador@suse.de, paulus@samba.org, peterz@infradead.org,
        rafael@kernel.org, rppt@kernel.org, shuah@kernel.org,
        tglx@linutronix.de
Subject:  + x86-remove-memory-hotplug-support-on-x86_32.patch added
 to -mm tree
Message-ID: <20210930223355.cvybK3Mz3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86: remove memory hotplug support on X86_32
has been added to the -mm tree.  Its filename is
     x86-remove-memory-hotplug-support-on-x86_32.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/x86-remove-memory-hotplug-support-on-x86_32.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/x86-remove-memory-hotplug-support-on-x86_32.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: x86: remove memory hotplug support on X86_32

CONFIG_MEMORY_HOTPLUG was marked BROKEN over one year and we just
restricted it to 64 bit.  Let's remove the unused x86 32bit implementation
and simplify the Kconfig.

Link: https://lkml.kernel.org/r/20210929143600.49379-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig      |    6 +++---
 arch/x86/mm/init_32.c |   31 -------------------------------
 2 files changed, 3 insertions(+), 34 deletions(-)

--- a/arch/x86/Kconfig~x86-remove-memory-hotplug-support-on-x86_32
+++ a/arch/x86/Kconfig
@@ -62,7 +62,7 @@ config X86
 	select ARCH_32BIT_OFF_T			if X86_32
 	select ARCH_CLOCKSOURCE_INIT
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if X86_64 && HUGETLB_PAGE && MIGRATION
-	select ARCH_ENABLE_MEMORY_HOTPLUG if X86_64 || (X86_32 && HIGHMEM)
+	select ARCH_ENABLE_MEMORY_HOTPLUG if X86_64
 	select ARCH_ENABLE_MEMORY_HOTREMOVE if MEMORY_HOTPLUG
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if (PGTABLE_LEVELS > 2) && (X86_64 || X86_PAE)
 	select ARCH_ENABLE_THP_MIGRATION if X86_64 && TRANSPARENT_HUGEPAGE
@@ -1615,7 +1615,7 @@ config ARCH_SELECT_MEMORY_MODEL
 
 config ARCH_MEMORY_PROBE
 	bool "Enable sysfs memory/probe interface"
-	depends on X86_64 && MEMORY_HOTPLUG
+	depends on MEMORY_HOTPLUG
 	help
 	  This option enables a sysfs memory/probe interface for testing.
 	  See Documentation/admin-guide/mm/memory-hotplug.rst for more information.
@@ -2395,7 +2395,7 @@ endmenu
 
 config ARCH_HAS_ADD_PAGES
 	def_bool y
-	depends on X86_64 && ARCH_ENABLE_MEMORY_HOTPLUG
+	depends on ARCH_ENABLE_MEMORY_HOTPLUG
 
 config ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
 	def_bool y
--- a/arch/x86/mm/init_32.c~x86-remove-memory-hotplug-support-on-x86_32
+++ a/arch/x86/mm/init_32.c
@@ -779,37 +779,6 @@ void __init mem_init(void)
 	test_wp_bit();
 }
 
-#ifdef CONFIG_MEMORY_HOTPLUG
-int arch_add_memory(int nid, u64 start, u64 size,
-		    struct mhp_params *params)
-{
-	unsigned long start_pfn = start >> PAGE_SHIFT;
-	unsigned long nr_pages = size >> PAGE_SHIFT;
-	int ret;
-
-	/*
-	 * The page tables were already mapped at boot so if the caller
-	 * requests a different mapping type then we must change all the
-	 * pages with __set_memory_prot().
-	 */
-	if (params->pgprot.pgprot != PAGE_KERNEL.pgprot) {
-		ret = __set_memory_prot(start, nr_pages, params->pgprot);
-		if (ret)
-			return ret;
-	}
-
-	return __add_pages(nid, start_pfn, nr_pages, params);
-}
-
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
-{
-	unsigned long start_pfn = start >> PAGE_SHIFT;
-	unsigned long nr_pages = size >> PAGE_SHIFT;
-
-	__remove_pages(start_pfn, nr_pages, altmap);
-}
-#endif
-
 int kernel_set_to_readonly __read_mostly;
 
 static void mark_nxdata_nx(void)
_

Patches currently in -mm which might be from david@redhat.com are

memory-hotplugrst-fix-two-instances-of-movablecore-that-should-be-movable_node.patch
memory-hotplugrst-fix-wrong-sys-module-memory_hotplug-parameters-path.patch
memory-hotplugrst-document-the-auto-movable-online-policy.patch
mm-memory_hotplug-remove-config_x86_64_acpi_numa-dependency-from-config_memory_hotplug.patch
mm-memory_hotplug-remove-config_memory_hotplug_sparse.patch
mm-memory_hotplug-restrict-config_memory_hotplug-to-64-bit.patch
mm-memory_hotplug-remove-highmem-leftovers.patch
mm-memory_hotplug-remove-stale-function-declarations.patch
x86-remove-memory-hotplug-support-on-x86_32.patch
kernel-resource-clean-up-and-optimize-iomem_is_exclusive.patch
kernel-resource-disallow-access-to-exclusive-system-ram-regions.patch
virtio-mem-disallow-mapping-virtio-mem-memory-via-dev-mem.patch

