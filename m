From: akpm@linux-foundation.org
Subject: + memblock-refactor-functions-to-set-clear-memblock_hotplug.patch added to -mm tree
Date: Mon, 10 Nov 2014 14:41:58 -0800
Message-ID: <54613f36.DwFAYwjWQOI9DuaQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44701 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaKJWl5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Nov 2014 17:41:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tony.luck@intel.com, Emilian.Medve@freescale.com, grygorii.strashko@ti.com, phacht@linux.vnet.ibm.com, santosh.shilimkar@ti.com, tangchen@cn.fujitsu.com, yinghai@kernel.org, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: refactor functions to set/clear MEMBLOCK_HOTPLUG
has been added to the -mm tree.  Its filename is
     memblock-refactor-functions-to-set-clear-memblock_hotplug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memblock-refactor-functions-to-set-clear-memblock_hotplug.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/memblock-refactor-functions-to-set-clear-memblock_hotplug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tony Luck <tony.luck@intel.com>
Subject: mm/memblock.c: refactor functions to set/clear MEMBLOCK_HOTPLUG

There is a lot of duplication in the rubric around actually setting or
clearing a mem region flag.  Create a new helper function to do this and
reduce each of memblock_mark_hotplug() and memblock_clear_hotplug() to a
single line.

This will be useful if someone were to add a new mem region flag - which
I hope to be doing some day soon. But it looks like a plausible cleanup
even without that - so I'd like to get it out of the way now.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Emil Medve <Emilian.Medve@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |   43 ++++++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff -puN mm/memblock.c~memblock-refactor-functions-to-set-clear-memblock_hotplug mm/memblock.c
--- a/mm/memblock.c~memblock-refactor-functions-to-set-clear-memblock_hotplug
+++ a/mm/memblock.c
@@ -715,16 +715,13 @@ int __init_memblock memblock_reserve(phy
 }
 
 /**
- * memblock_mark_hotplug - Mark hotpluggable memory with flag MEMBLOCK_HOTPLUG.
- * @base: the base phys addr of the region
- * @size: the size of the region
  *
- * This function isolates region [@base, @base + @size), and mark it with flag
- * MEMBLOCK_HOTPLUG.
+ * This function isolates region [@base, @base + @size), and sets/clears flag
  *
  * Return 0 on succees, -errno on failure.
  */
-int __init_memblock memblock_mark_hotplug(phys_addr_t base, phys_addr_t size)
+static int __init_memblock memblock_setclr_flag(phys_addr_t base,
+				phys_addr_t size, int set, int flag)
 {
 	struct memblock_type *type = &memblock.memory;
 	int i, ret, start_rgn, end_rgn;
@@ -734,37 +731,37 @@ int __init_memblock memblock_mark_hotplu
 		return ret;
 
 	for (i = start_rgn; i < end_rgn; i++)
-		memblock_set_region_flags(&type->regions[i], MEMBLOCK_HOTPLUG);
+		if (set)
+			memblock_set_region_flags(&type->regions[i], flag);
+		else
+			memblock_clear_region_flags(&type->regions[i], flag);
 
 	memblock_merge_regions(type);
 	return 0;
 }
 
 /**
- * memblock_clear_hotplug - Clear flag MEMBLOCK_HOTPLUG for a specified region.
+ * memblock_mark_hotplug - Mark hotpluggable memory with flag MEMBLOCK_HOTPLUG.
  * @base: the base phys addr of the region
  * @size: the size of the region
  *
- * This function isolates region [@base, @base + @size), and clear flag
- * MEMBLOCK_HOTPLUG for the isolated regions.
+ * Return 0 on succees, -errno on failure.
+ */
+int __init_memblock memblock_mark_hotplug(phys_addr_t base, phys_addr_t size)
+{
+	return memblock_setclr_flag(base, size, 1, MEMBLOCK_HOTPLUG);
+}
+
+/**
+ * memblock_clear_hotplug - Clear flag MEMBLOCK_HOTPLUG for a specified region.
+ * @base: the base phys addr of the region
+ * @size: the size of the region
  *
  * Return 0 on succees, -errno on failure.
  */
 int __init_memblock memblock_clear_hotplug(phys_addr_t base, phys_addr_t size)
 {
-	struct memblock_type *type = &memblock.memory;
-	int i, ret, start_rgn, end_rgn;
-
-	ret = memblock_isolate_range(type, base, size, &start_rgn, &end_rgn);
-	if (ret)
-		return ret;
-
-	for (i = start_rgn; i < end_rgn; i++)
-		memblock_clear_region_flags(&type->regions[i],
-					    MEMBLOCK_HOTPLUG);
