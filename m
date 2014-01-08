From: akpm@linux-foundation.org
Subject: + mm-free-memblockmemory-in-free_all_bootmem-fix.patch added to
 -mm tree
Date: Wed, 08 Jan 2014 14:07:00 -0800
Message-ID: <52cdcc04.6RhbLXXSeCcAssaC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbaAHWHB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jan 2014 17:07:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wujianguo@huawei.com, toshi.kani@hp.com, tj@kernel.org, tangchen@cn.fujitsu.com, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, phacht@linux.vnet.ibm.com

Subject: + mm-free-memblockmemory-in-free_all_bootmem-fix.patch added to -mm tree
To: phacht@linux.vnet.ibm.com,hannes@cmpxchg.org,iamjoonsoo.kim@lge.com,tangchen@cn.fujitsu.com,tj@kernel.org,toshi.kani@hp.com,wujianguo@huawei.com
From: akpm@linux-foundation.org
Date: Wed, 08 Jan 2014 14:07:00 -0800


The patch titled
     Subject: mm-free-memblockmemory-in-free_all_bootmem-fix
has been added to the -mm tree.  Its filename is
     mm-free-memblockmemory-in-free_all_bootmem-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-free-memblockmemory-in-free_all_bootmem-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-free-memblockmemory-in-free_all_bootmem-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Subject: mm-free-memblockmemory-in-free_all_bootmem-fix

Am Wed, 8 Jan 2014 12:08:04 +0800
schrieb Jianguo Wu <wujianguo@huawei.com>:

> For some archs, like arm64, would use memblock.memory after system
> booting, so we can not simply released to the buddy allocator, maybe
> need !defined(CONFIG_ARCH_DISCARD_MEMBLOCK).

Signed-off-by: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c  |    4 ++++
 mm/nobootmem.c |    3 +++
 2 files changed, 7 insertions(+)

diff -puN mm/memblock.c~mm-free-memblockmemory-in-free_all_bootmem-fix mm/memblock.c
--- a/mm/memblock.c~mm-free-memblockmemory-in-free_all_bootmem-fix
+++ a/mm/memblock.c
@@ -291,6 +291,8 @@ phys_addr_t __init_memblock get_allocate
 			  memblock.reserved.max);
 }
 
+#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
+
 phys_addr_t __init_memblock get_allocated_memblock_memory_regions_info(
 					phys_addr_t *addr)
 {
@@ -303,6 +305,8 @@ phys_addr_t __init_memblock get_allocate
 			  memblock.memory.max);
 }
 
+#endif
+
 /**
  * memblock_double_array - double the size of the memblock regions array
  * @type: memblock type of the regions array being doubled
diff -puN mm/nobootmem.c~mm-free-memblockmemory-in-free_all_bootmem-fix mm/nobootmem.c
--- a/mm/nobootmem.c~mm-free-memblockmemory-in-free_all_bootmem-fix
+++ a/mm/nobootmem.c
@@ -127,10 +127,13 @@ static unsigned long __init free_low_mem
 	if (size)
 		count += __free_memory_core(start, start + size);
 
+#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
+
 	/* Free memblock.memory array if it was allocated */
 	size = get_allocated_memblock_memory_regions_info(&start);
 	if (size)
 		count += __free_memory_core(start, start + size);
+#endif
 
 	return count;
 }
_

Patches currently in -mm which might be from phacht@linux.vnet.ibm.com are

mm-nobootmemc-add-return-value-check-in-__alloc_memory_core_early.patch
mm-free-memblockmemory-in-free_all_bootmem.patch
mm-free-memblockmemory-in-free_all_bootmem-fix.patch

