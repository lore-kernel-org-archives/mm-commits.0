From: akpm@linux-foundation.org
Subject: + memblock-make-memblock_overlaps_region-return-bool.patch added
 to -mm tree
Date: Thu, 23 Jul 2015 12:36:13 -0700
Message-ID: <55b1422d.mmC2gfherzUnkz/s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38094 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbbGWTgO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jul 2015 15:36:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, bhe@redhat.com, fabf@skynet.be, isimatu.yasuaki@jp.fujitsu.com, kuleshovmail@gmail.com, lcapitulino@redhat.com, qiuxishi@huawei.com, tglx@linutronix.de, tj@kernel.org, vladimir.murzin@arm.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: make memblock_overlaps_region() return bool.
has been added to the -mm tree.  Its filename is
     memblock-make-memblock_overlaps_region-return-bool.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memblock-make-memblock_overlaps_region-return-bool.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memblock-make-memblock_overlaps_region-return-bool.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: mm/memblock.c: make memblock_overlaps_region() return bool.

memblock_overlaps_region() checks if the given memblock region intersects
a region in memblock.  If so, it returns the index of the intersected
region.

But its only caller is memblock_is_region_reserved(), and it returns 0 if
false, non-zero if true.

Both of these should return bool.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Alexander Kuleshov <kuleshovmail@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    2 +-
 mm/memblock.c            |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/memblock.h~memblock-make-memblock_overlaps_region-return-bool include/linux/memblock.h
--- a/include/linux/memblock.h~memblock-make-memblock_overlaps_region-return-bool
+++ a/include/linux/memblock.h
@@ -323,7 +323,7 @@ void memblock_enforce_memory_limit(phys_
 int memblock_is_memory(phys_addr_t addr);
 int memblock_is_region_memory(phys_addr_t base, phys_addr_t size);
 int memblock_is_reserved(phys_addr_t addr);
-int memblock_is_region_reserved(phys_addr_t base, phys_addr_t size);
+bool memblock_is_region_reserved(phys_addr_t base, phys_addr_t size);
 
 extern void __memblock_dump_all(void);
 
diff -puN mm/memblock.c~memblock-make-memblock_overlaps_region-return-bool mm/memblock.c
--- a/mm/memblock.c~memblock-make-memblock_overlaps_region-return-bool
+++ a/mm/memblock.c
@@ -91,7 +91,7 @@ static unsigned long __init_memblock mem
 	return ((base1 < (base2 + size2)) && (base2 < (base1 + size1)));
 }
 
-static long __init_memblock memblock_overlaps_region(struct memblock_type *type,
+static bool __init_memblock memblock_overlaps_region(struct memblock_type *type,
 					phys_addr_t base, phys_addr_t size)
 {
 	unsigned long i;
@@ -103,7 +103,7 @@ static long __init_memblock memblock_ove
 			break;
 	}
 
-	return (i < type->cnt) ? i : -1;
+	return i < type->cnt;
 }
 
 /*
@@ -1566,12 +1566,12 @@ int __init_memblock memblock_is_region_m
  * Check if the region [@base, @base+@size) intersects a reserved memory block.
  *
  * RETURNS:
- * 0 if false, non-zero if true
+ * True if they intersect, false if not.
  */
-int __init_memblock memblock_is_region_reserved(phys_addr_t base, phys_addr_t size)
+bool __init_memblock memblock_is_region_reserved(phys_addr_t base, phys_addr_t size)
 {
 	memblock_cap_size(base, &size);
-	return memblock_overlaps_region(&memblock.reserved, base, size) >= 0;
+	return memblock_overlaps_region(&memblock.reserved, base, size);
 }
 
 void __init_memblock memblock_trim_memory(phys_addr_t align)
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

memblock-make-memblock_overlaps_region-return-bool.patch
mem-hotplug-handle-node-hole-when-initializing-numa_meminfo.patch

