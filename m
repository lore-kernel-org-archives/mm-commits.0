From: akpm@linux-foundation.org
Subject: + mm-memblock-memblock_is_memory-reserved-can-be-boolean.patch
 added to -mm tree
Date: Tue, 17 Nov 2015 15:56:41 -0800
Message-ID: <564bbeb9.3x9SVvU2uB7c+vyY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48494 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbbKQX4l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 18:56:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: memblock_is_memory()/reserved() can be boolean
has been added to the -mm tree.  Its filename is
     mm-memblock-memblock_is_memory-reserved-can-be-boolean.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblock-memblock_is_memory-reserved-can-be-boolean.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblock-memblock_is_memory-reserved-can-be-boolean.patch

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
@@ -318,9 +318,9 @@ phys_addr_t memblock_mem_size(unsigned l
 phys_addr_t memblock_start_of_DRAM(void);
 phys_addr_t memblock_end_of_DRAM(void);
 void memblock_enforce_memory_limit(phys_addr_t memory_limit);
-int memblock_is_memory(phys_addr_t addr);
+bool memblock_is_memory(phys_addr_t addr);
 int memblock_is_region_memory(phys_addr_t base, phys_addr_t size);
-int memblock_is_reserved(phys_addr_t addr);
+bool memblock_is_reserved(phys_addr_t addr);
 bool memblock_is_region_reserved(phys_addr_t base, phys_addr_t size);
 
 extern void __memblock_dump_all(void);
diff -puN mm/memblock.c~mm-memblock-memblock_is_memory-reserved-can-be-boolean mm/memblock.c
--- a/mm/memblock.c~mm-memblock-memblock_is_memory-reserved-can-be-boolean
+++ a/mm/memblock.c
@@ -1509,12 +1509,12 @@ static int __init_memblock memblock_sear
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

mm-hugetlb-is_file_hugepages-can-be-boolean.patch
mm-memblock-memblock_is_memory-reserved-can-be-boolean.patch
fs-statc-drop-the-last-new_valid_dev-check.patch
include-linux-kdev_th-remove-new_valid_dev.patch
ipc-shm-is_file_shm_hugepages-can-be-boolean.patch

