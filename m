From: akpm@linux-foundation.org
Subject: [merged]
 mm-memblock-memblock_is_memory-reserved-can-be-boolean.patch removed from
 -mm tree
Date: Fri, 15 Jan 2016 14:32:52 -0800
Message-ID: <56997394.KNAE8uV81CqB9+2+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566AbcAOWcw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:32:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: memblock_is_memory()/reserved() can be boolean
has been removed from the -mm tree.  Its filename was
     mm-memblock-memblock_is_memory-reserved-can-be-boolean.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Subject: mm/memblock.c: memblock_is_memory()/reserved() can be boolean

Make memblock_is_memory() and memblock_is_reserved return bool to improve
readability due to these particular functions only using either one or
zero as their return value.

No functional change.

Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    4 ++--
 mm/memblock.c            |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/memblock.h~mm-memblock-memblock_is_memory-reserved-can-be-boolean include/linux/memblock.h
--- a/include/linux/memblock.h~mm-memblock-memblock_is_memory-reserved-can-be-boolean
+++ a/include/linux/memblock.h
@@ -325,10 +325,10 @@ phys_addr_t memblock_mem_size(unsigned l
 phys_addr_t memblock_start_of_DRAM(void);
 phys_addr_t memblock_end_of_DRAM(void);
 void memblock_enforce_memory_limit(phys_addr_t memory_limit);
-int memblock_is_memory(phys_addr_t addr);
+bool memblock_is_memory(phys_addr_t addr);
 int memblock_is_map_memory(phys_addr_t addr);
 int memblock_is_region_memory(phys_addr_t base, phys_addr_t size);
-int memblock_is_reserved(phys_addr_t addr);
+bool memblock_is_reserved(phys_addr_t addr);
 bool memblock_is_region_reserved(phys_addr_t base, phys_addr_t size);
 
 extern void __memblock_dump_all(void);
diff -puN mm/memblock.c~mm-memblock-memblock_is_memory-reserved-can-be-boolean mm/memblock.c
--- a/mm/memblock.c~mm-memblock-memblock_is_memory-reserved-can-be-boolean
+++ a/mm/memblock.c
@@ -1528,12 +1528,12 @@ static int __init_memblock memblock_sear
 	return -1;
 }
 
-int __init memblock_is_reserved(phys_addr_t addr)
+bool __init memblock_is_reserved(phys_addr_t addr)
 {
 	return memblock_search(&memblock.reserved, addr) != -1;
 }
 
-int __init_memblock memblock_is_memory(phys_addr_t addr)
+bool __init_memblock memblock_is_memory(phys_addr_t addr)
 {
 	return memblock_search(&memblock.memory, addr) != -1;
 }
_

Patches currently in -mm which might be from baiyaowei@cmss.chinamobile.com are

fs-statc-drop-the-last-new_valid_dev-check.patch
include-linux-kdev_th-remove-new_valid_dev.patch
init-mainc-obsolete_checksetup-can-be-boolean.patch
init-do_mounts-initrd_load-can-be-boolean.patch
ipc-shm-is_file_shm_hugepages-can-be-boolean.patch

