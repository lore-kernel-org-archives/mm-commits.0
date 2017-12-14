From: akpm@linux-foundation.org
Subject: + mm-memblock-memblock_is_map-region_memory-can-be-boolean.patch
 added to -mm tree
Date: Thu, 14 Dec 2017 12:23:50 -0800
Message-ID: <5a32ddd6.TdQ1+WvTbSuydgnW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46210 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752612AbdLNUXv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Dec 2017 15:23:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock: memblock_is_map/region_memory can be boolean
has been added to the -mm tree.  Its filename is
     mm-memblock-memblock_is_map-region_memory-can-be-boolean.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblock-memblock_is_map-region_memory-can-be-boolean.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblock-memblock_is_map-region_memory-can-be-boolean.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Subject: mm/memblock: memblock_is_map/region_memory can be boolean

Make memblock_is_map/region_memory return bool due to these two functions
only using either true or false as its return value.

No functional change.

Link: http://lkml.kernel.org/r/1513266622-15860-2-git-send-email-baiyaowei@cmss.chinamobile.com
Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    4 ++--
 mm/memblock.c            |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/memblock.h~mm-memblock-memblock_is_map-region_memory-can-be-boolean include/linux/memblock.h
--- a/include/linux/memblock.h~mm-memblock-memblock_is_map-region_memory-can-be-boolean
+++ a/include/linux/memblock.h
@@ -332,8 +332,8 @@ void memblock_enforce_memory_limit(phys_
 void memblock_cap_memory_range(phys_addr_t base, phys_addr_t size);
 void memblock_mem_limit_remove_map(phys_addr_t limit);
 bool memblock_is_memory(phys_addr_t addr);
-int memblock_is_map_memory(phys_addr_t addr);
-int memblock_is_region_memory(phys_addr_t base, phys_addr_t size);
+bool memblock_is_map_memory(phys_addr_t addr);
+bool memblock_is_region_memory(phys_addr_t base, phys_addr_t size);
 bool memblock_is_reserved(phys_addr_t addr);
 bool memblock_is_region_reserved(phys_addr_t base, phys_addr_t size);
 
diff -puN mm/memblock.c~mm-memblock-memblock_is_map-region_memory-can-be-boolean mm/memblock.c
--- a/mm/memblock.c~mm-memblock-memblock_is_map-region_memory-can-be-boolean
+++ a/mm/memblock.c
@@ -1654,7 +1654,7 @@ bool __init_memblock memblock_is_memory(
 	return memblock_search(&memblock.memory, addr) != -1;
 }
 
-int __init_memblock memblock_is_map_memory(phys_addr_t addr)
+bool __init_memblock memblock_is_map_memory(phys_addr_t addr)
 {
 	int i = memblock_search(&memblock.memory, addr);
 
@@ -1690,13 +1690,13 @@ int __init_memblock memblock_search_pfn_
  * RETURNS:
  * 0 if false, non-zero if true
  */
-int __init_memblock memblock_is_region_memory(phys_addr_t base, phys_addr_t size)
+bool __init_memblock memblock_is_region_memory(phys_addr_t base, phys_addr_t size)
 {
 	int idx = memblock_search(&memblock.memory, base);
 	phys_addr_t end = base + memblock_cap_size(base, &size);
 
 	if (idx == -1)
-		return 0;
+		return false;
 	return (memblock.memory.regions[idx].base +
 		 memblock.memory.regions[idx].size) >= end;
 }
_

Patches currently in -mm which might be from baiyaowei@cmss.chinamobile.com are

mm-memblock-memblock_is_map-region_memory-can-be-boolean.patch
lib-lockref-__lockref_is_dead-can-be-boolean.patch
kernel-cpuset-current_cpuset_is_being_rebound-can-be-boolean.patch
kernel-resource-iomem_is_exclusive-can-be-boolean.patch
kernel-module-module_is_live-can-be-boolean.patch
kernel-mutex-mutex_is_locked-can-be-boolean.patch
crash_dump-is_kdump_kernel-can-be-boolean.patch

