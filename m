From: akpm@linux-foundation.org
Subject: + x86-get-pg_data_ts-memory-from-other-node.patch added to -mm tree
Date: Mon, 14 Jan 2013 14:35:26 -0800
Message-ID: <20130114223532.654E1100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:57291 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757421Ab3ANWfe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jan 2013 17:35:34 -0500
Received: by mail-vb0-f73.google.com with SMTP id l1so561262vba.0
        for <mm-commits@vger.kernel.org>; Mon, 14 Jan 2013 14:35:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: isimatu.yasuaki@jp.fujitsu.com, hpa@zytor.com, jiang.liu@huawei.com, laijs@cn.fujitsu.com, mel@csn.ul.ie, mingo@elte.hu, tangchen@cn.fujitsu.com, tglx@linutronix.de, wency@cn.fujitsu.com, wujianguo@huawei.com


The patch titled
     Subject: x86: get pg_data_t's memory from other node
has been added to the -mm tree.  Its filename is
     x86-get-pg_data_ts-memory-from-other-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: x86: get pg_data_t's memory from other node

During the implementation of SRAT support, we met a problem.
In setup_arch(), we have the following call series:

1) memblock is ready;
2) some functions use memblock to allocate memory;
3) parse ACPI tables, such as SRAT.

Before 3), we don't know which memory is hotpluggable, and as a result, we
cannot prevent memblock from allocating hotpluggable memory.  So, in 2),
there could be some hotpluggable memory allocated by memblock.

Now, we are trying to parse SRAT earlier, before memblock is ready.  But I
think we need more investigation on this topic.  So in this v5, I dropped
all the SRAT support, and v5 is just the same as v3, and it is based on
3.8-rc3.

As we planned, we will support getting info from SRAT without users'
participation at last.  And we will post another patch-set to do so.


And also, I think for now, we can add this boot option as the first step of
supporting movable node. Since Linux cannot migrate the direct mapped pages,
the only way for now is to limit the whole node containing only movable memory.

Using SRAT is one way.  But even if we can use SRAT, users still need an
interface to enable/disable this functionality if they don't want to loose
their NUMA performance.  So I think, a user interface is always needed.

For now, users can disable this functionality by not specifying the boot
option.  Later, we will post SRAT support, and add another option value
"movablecore_map=acpi" to using SRAT.



This patch:

If system can create movable node which all memory of the node is
allocated as ZONE_MOVABLE, setup_node_data() cannot allocate memory for
the node's pg_data_t.  So, use memblock_alloc_try_nid() instead of
memblock_alloc_nid() to retry when the first allocation fails.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Wu Jianguo <wujianguo@huawei.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/x86/mm/numa.c~x86-get-pg_data_ts-memory-from-other-node arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~x86-get-pg_data_ts-memory-from-other-node
+++ a/arch/x86/mm/numa.c
@@ -221,10 +221,9 @@ static void __init setup_node_data(int n
 		nd_pa = __pa(nd);
 		remapped = true;
 	} else {
-		nd_pa = memblock_alloc_nid(nd_size, SMP_CACHE_BYTES, nid);
+		nd_pa = memblock_alloc_try_nid(nd_size, SMP_CACHE_BYTES, nid);
 		if (!nd_pa) {
-			pr_err("Cannot find %zu bytes in node %d\n",
-			       nd_size, nid);
+			pr_err("Cannot find %zu bytes in any node\n", nd_size);
 			return;
 		}
 		nd = __va(nd_pa);
_

Patches currently in -mm which might be from isimatu.yasuaki@jp.fujitsu.com are

x86-fix-the-argument-passed-to-sync_global_pgds.patch
x86-make-mem=-option-to-work-for-efi-platform.patch
memory-hotplug-try-to-offline-the-memory-twice-to-avoid-dependence.patch
memory-hotplug-check-whether-all-memory-blocks-are-offlined-or-not-when-removing-memory.patch
memory-hotplug-remove-redundant-codes.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs.patch
memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch
memory-hotplug-move-pgdat_resize_lock-into-sparse_remove_one_section.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch
memory-hotplug-remove-page-table-of-x86_64-architecture.patch
memory-hotplug-remove-memmap-of-sparse-vmemmap.patch
memory-hotplug-integrated-__remove_section-of-config_sparsemem_vmemmap.patch
memory_hotplug-clear-zone-when-removing-the-memory.patch
memory-hotplug-remove-sysfs-file-of-node.patch
memory-hotplug-free-node_data-when-a-node-is-offlined.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline.patch
x86-get-pg_data_ts-memory-from-other-node.patch

