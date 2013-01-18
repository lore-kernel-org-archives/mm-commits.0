From: akpm@linux-foundation.org
Subject: + memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix-fix.patch added to -mm tree
Date: Fri, 18 Jan 2013 13:41:25 -0800
Message-ID: <20130118214125.D66345A41FB@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:47600 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab3ARVl1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Jan 2013 16:41:27 -0500
Received: by mail-oa0-f73.google.com with SMTP id n12so1026792oag.0
        for <mm-commits@vger.kernel.org>; Fri, 18 Jan 2013 13:41:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linfeng@cn.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: memory-hotplug: mm/Kconfig: move auto selects from MEMORY_HOTPLUG to MEMORY_HOTREMOVE as needed
has been added to the -mm tree.  Its filename is
     memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lin Feng <linfeng@cn.fujitsu.com>
Subject: memory-hotplug: mm/Kconfig: move auto selects from MEMORY_HOTPLUG to MEMORY_HOTREMOVE as needed

Since we have 2 config options called MEMORY_HOTPLUG and MEMORY_HOTREMOVE
used for memory hot-add and hot-remove separately, and codes in function
register_page_bootmem_info_node() are only used for collecting infomation
for hot-remove(commit 04753278), so move it to MEMORY_HOTREMOVE.

Besides page_isolation.c selected by MEMORY_ISOLATION under MEMORY_HOTPLUG
is also such case, move it too.

Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/Kconfig~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix-fix mm/Kconfig
--- a/mm/Kconfig~memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix-fix
+++ a/mm/Kconfig
@@ -172,8 +172,6 @@ config HAVE_BOOTMEM_INFO_NODE
 # eventually, we can have this option just 'select SPARSEMEM'
 config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
-	select MEMORY_ISOLATION
-	select HAVE_BOOTMEM_INFO_NODE if X86_64
 	depends on SPARSEMEM || X86_64_ACPI_NUMA
 	depends on HOTPLUG && ARCH_ENABLE_MEMORY_HOTPLUG
 	depends on (IA64 || X86 || PPC_BOOK3S_64 || SUPERH || S390)
@@ -184,6 +182,8 @@ config MEMORY_HOTPLUG_SPARSE
 
 config MEMORY_HOTREMOVE
 	bool "Allow for memory hot remove"
+	select MEMORY_ISOLATION
+	select HAVE_BOOTMEM_INFO_NODE if X86_64
 	depends on MEMORY_HOTPLUG && ARCH_ENABLE_MEMORY_HOTREMOVE
 	depends on MIGRATION
 
_

Patches currently in -mm which might be from linfeng@cn.fujitsu.com are

memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix-fix.patch
memory-hotplug-remove-memmap-of-sparse-vmemmap-fix.patch
page_alloc-add-movable_memmap-kernel-parameter.patch
page_alloc-introduce-zone_movable_limit-to-keep-movable-limit-for-nodes.patch
page_alloc-make-movablecore_map-has-higher-priority.patch
page_alloc-bootmem-limit-with-movablecore_map.patch

