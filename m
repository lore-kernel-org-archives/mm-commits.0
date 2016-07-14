From: akpm@linux-foundation.org
Subject: +
 mm-memblock-add-new-infrastructure-to-address-the-mem-limit-issue.patch
 added to -mm tree
Date: Thu, 14 Jul 2016 15:14:50 -0700
Message-ID: <57880eda.8FJJN3k/BjEdFIYo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbcGNWOw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jul 2016 18:14:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dennis.chen@arm.com, ard.biesheuvel@linaro.org, catalin.marinas@arm.com, kaly.xin@arm.com, mark.rutland@arm.com, matt@codeblueprint.co.uk, mgorman@techsingularity.net, mingo@kernel.org, penberg@kernel.org, rafael@kernel.org, steve.capper@arm.com, tangchen@cn.fujitsu.com, tony.luck@intel.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: add new infrastructure to address the mem limit issue
has been added to the -mm tree.  Its filename is
     mm-memblock-add-new-infrastructure-to-address-the-mem-limit-issue.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblock-add-new-infrastructure-to-address-the-mem-limit-issue.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblock-add-new-infrastructure-to-address-the-mem-limit-issue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dennis Chen <dennis.chen@arm.com>
Subject: mm/memblock.c: add new infrastructure to address the mem limit issue

In some cases, memblock is queried by kernel to determine whether a
specified address is RAM or not.  For example, the ACPI core needs this
information to determine which attributes to use when mapping ACPI
regions(acpi_os_ioremap).  Use of incorrect memory types can result in
faults, data corruption, or other issues.

Removing memory with memblock_enforce_memory_limit() throws away this
information, and so a kernel booted with 'mem=' may suffer from the issues
described above.  To avoid this, we need to keep those NOMAP regions
instead of removing all above the limit, which preserves the information
we need while preventing other use of those regions.

This patch adds new infrastructure to retain all NOMAP memblock regions
while removing others, to cater for this.

Link: http://lkml.kernel.org/r/1468475036-5852-2-git-send-email-dennis.chen@arm.com
Signed-off-by: Dennis Chen <dennis.chen@arm.com>
Acked-by: Steve Capper <steve.capper@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Kaly Xin <kaly.xin@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    1 
 mm/memblock.c            |   57 +++++++++++++++++++++++++++++++++----
 2 files changed, 53 insertions(+), 5 deletions(-)

diff -puN include/linux/memblock.h~mm-memblock-add-new-infrastructure-to-address-the-mem-limit-issue include/linux/memblock.h
--- a/include/linux/memblock.h~mm-memblock-add-new-infrastructure-to-address-the-mem-limit-issue
+++ a/include/linux/memblock.h
@@ -332,6 +332,7 @@ phys_addr_t memblock_mem_size(unsigned l
 phys_addr_t memblock_start_of_DRAM(void);
 phys_addr_t memblock_end_of_DRAM(void);
 void memblock_enforce_memory_limit(phys_addr_t memory_limit);
+void memblock_mem_limit_remove_map(phys_addr_t limit);
 bool memblock_is_memory(phys_addr_t addr);
 int memblock_is_map_memory(phys_addr_t addr);
 int memblock_is_region_memory(phys_addr_t base, phys_addr_t size);
diff -puN mm/memblock.c~mm-memblock-add-new-infrastructure-to-address-the-mem-limit-issue mm/memblock.c
--- a/mm/memblock.c~mm-memblock-add-new-infrastructure-to-address-the-mem-limit-issue
+++ a/mm/memblock.c
@@ -1465,15 +1465,16 @@ phys_addr_t __init_memblock memblock_end
 	return (memblock.memory.regions[idx].base + memblock.memory.regions[idx].size);
 }
 
-void __init memblock_enforce_memory_limit(phys_addr_t limit)
+static phys_addr_t __init_memblock __find_max_addr(phys_addr_t limit)
 {
 	phys_addr_t max_addr = (phys_addr_t)ULLONG_MAX;
 	struct memblock_region *r;
 
-	if (!limit)
-		return;
-
-	/* find out max address */
+	/*
+	 * translate the memory @limit size into the max address within one of
+	 * the memory memblock regions, if the @limit exceeds the total size
+	 * of those regions, max_addr will keep original value ULLONG_MAX
+	 */
 	for_each_memblock(memory, r) {
 		if (limit <= r->size) {
 			max_addr = r->base + limit;
@@ -1482,12 +1483,58 @@ void __init memblock_enforce_memory_limi
 		limit -= r->size;
 	}
 
+	return max_addr;
+}
+
+void __init memblock_enforce_memory_limit(phys_addr_t limit)
+{
+	phys_addr_t max_addr = (phys_addr_t)ULLONG_MAX;
+
+	if (!limit)
+		return;
+
+	max_addr = __find_max_addr(limit);
+
+	/* @limit exceeds the total size of the memory, do nothing */
+	if (max_addr == (phys_addr_t)ULLONG_MAX)
+		return;
+
 	/* truncate both memory and reserved regions */
 	memblock_remove_range(&memblock.memory, max_addr,
 			      (phys_addr_t)ULLONG_MAX);
 	memblock_remove_range(&memblock.reserved, max_addr,
 			      (phys_addr_t)ULLONG_MAX);
 }
+
+void __init memblock_mem_limit_remove_map(phys_addr_t limit)
+{
+	struct memblock_type *type = &memblock.memory;
+	phys_addr_t max_addr;
+	int i, ret, start_rgn, end_rgn;
+
+	if (!limit)
+		return;
+
+	max_addr = __find_max_addr(limit);
+
+	/* @limit exceeds the total size of the memory, do nothing */
+	if (max_addr == (phys_addr_t)ULLONG_MAX)
+		return;
+
+	ret = memblock_isolate_range(type, max_addr, (phys_addr_t)ULLONG_MAX,
+				&start_rgn, &end_rgn);
+	if (ret)
+		return;
+
+	/* remove all the MAP regions above the limit */
+	for (i = end_rgn - 1; i >= start_rgn; i--) {
+		if (!memblock_is_nomap(&type->regions[i]))
+			memblock_remove_region(type, i);
+	}
+	/* truncate the reserved regions */
+	memblock_remove_range(&memblock.reserved, max_addr,
+			      (phys_addr_t)ULLONG_MAX);
+}
 
 static int __init_memblock memblock_search(struct memblock_type *type, phys_addr_t addr)
 {
_

Patches currently in -mm which might be from dennis.chen@arm.com are

mm-memblock-add-new-infrastructure-to-address-the-mem-limit-issue.patch
arm64-acpi-fix-the-acpi-alignment-exception-when-mem=-specified.patch

