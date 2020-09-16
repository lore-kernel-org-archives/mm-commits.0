Return-Path: <SRS0=oQto=CZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE92BC43461
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 01:12:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57038207DE
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 01:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600218769;
	bh=keMioiJ8bhQNSyvS5I3DZ5RXWajQNIAfz22zPD8JGpk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=tmvW90xnrHQ++Z7cc1bZyLHwh7GC8uUkPJlSOv4yg5fvcDyWg2pJTlu1ps5rdOIf+
	 3WygIOTzdVzCon5Ztn9BGi+inITgfvBRnFZmb8NbNkTHxJRok427uru7p+TB/NO+DA
	 yOwiB82uZQv9NiE8AMEeMylXRuGpV3gBLL/Eo3LE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgIPBMq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Sep 2020 21:12:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbgIPBMp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Sep 2020 21:12:45 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A95320715;
        Wed, 16 Sep 2020 01:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600218764;
        bh=keMioiJ8bhQNSyvS5I3DZ5RXWajQNIAfz22zPD8JGpk=;
        h=Date:From:To:Subject:From;
        b=n/tzyYV1pVnCGOrORI9tR74G4g+tas+Yn7T4+NyYirPnWDk5tXemxfOoEJ6C7V2uy
         L8YrE+tA3V1Ejys02UWA2ShHGu8aGB7atqsYBxJ0P1nD2R6rzIX3jTLISpv4ZKz6dy
         BFGlX7XvCuzZEoaFsgMLC79MCpm87WIVwSQe10wU=
Date:   Tue, 15 Sep 2020 18:12:43 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tony.luck@intel.com, rafael@kernel.org,
        osalvador@suse.de, nathanl@linux.ibm.com, mhocko@suse.com,
        gregkh@linuxfoundation.org, fenghua.yu@intel.com, david@redhat.com,
        cheloha@linux.ibm.com, ldufour@linux.ibm.com
Subject:  + mm-replace-memmap_context-by-meminit_context.patch added
 to -mm tree
Message-ID: <20200916011243.NX99a%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: replace memmap_context by meminit_context
has been added to the -mm tree.  Its filename is
     mm-replace-memmap_context-by-meminit_context.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-replace-memmap_context-by-meminit_context.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-replace-memmap_context-by-meminit_context.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laurent Dufour <ldufour@linux.ibm.com>
Subject: mm: replace memmap_context by meminit_context

Patch series "mm: fix memory to node bad links in sysfs", v3.

Sometimes, firmware may expose interleaved memory layout like this:
 Early memory node ranges
   node   1: [mem 0x0000000000000000-0x000000011fffffff]
   node   2: [mem 0x0000000120000000-0x000000014fffffff]
   node   1: [mem 0x0000000150000000-0x00000001ffffffff]
   node   0: [mem 0x0000000200000000-0x000000048fffffff]
   node   2: [mem 0x0000000490000000-0x00000007ffffffff]

In that case, we can see memory blocks assigned to multiple nodes in sysfs:

$ ls -l /sys/devices/system/memory/memory21
total 0
lrwxrwxrwx 1 root root     0 Aug 24 05:27 node1 -> ../../node/node1
lrwxrwxrwx 1 root root     0 Aug 24 05:27 node2 -> ../../node/node2
-rw-r--r-- 1 root root 65536 Aug 24 05:27 online
-r--r--r-- 1 root root 65536 Aug 24 05:27 phys_device
-r--r--r-- 1 root root 65536 Aug 24 05:27 phys_index
drwxr-xr-x 2 root root     0 Aug 24 05:27 power
-r--r--r-- 1 root root 65536 Aug 24 05:27 removable
-rw-r--r-- 1 root root 65536 Aug 24 05:27 state
lrwxrwxrwx 1 root root     0 Aug 24 05:25 subsystem -> ../../../../bus/memory
-rw-r--r-- 1 root root 65536 Aug 24 05:25 uevent
-r--r--r-- 1 root root 65536 Aug 24 05:27 valid_zones

The same applies in the node's directory with a memory21 link in both the
node1 and node2's directory.

This is wrong but doesn't prevent the system to run.  However when later,
one of these memory blocks is hot-unplugged and then hot-plugged, the
system is detecting an inconsistency in the sysfs layout and a BUG_ON() is
raised:

------------[ cut here ]------------
kernel BUG at /Users/laurent/src/linux-ppc/mm/memory_hotplug.c:1084!
Oops: Exception in kernel mode, sig: 5 [#1]
LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
Modules linked in: rpadlpar_io rpaphp pseries_rng rng_core vmx_crypto gf128mul binfmt_misc ip_tables x_tables xfs libcrc32c crc32c_vpmsum autofs4
CPU: 8 PID: 10256 Comm: drmgr Not tainted 5.9.0-rc1+ #25
NIP:  c000000000403f34 LR: c000000000403f2c CTR: 0000000000000000
REGS: c0000004876e3660 TRAP: 0700   Not tainted  (5.9.0-rc1+)
MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 24000448  XER: 20040000
CFAR: c000000000846d20 IRQMASK: 0
GPR00: c000000000403f2c c0000004876e38f0 c0000000012f6f00 ffffffffffffffef
GPR04: 0000000000000227 c0000004805ae680 0000000000000000 00000004886f0000
GPR08: 0000000000000226 0000000000000003 0000000000000002 fffffffffffffffd
GPR12: 0000000088000484 c00000001ec96280 0000000000000000 0000000000000000
GPR16: 0000000000000000 0000000000000000 0000000000000004 0000000000000003
GPR20: c00000047814ffe0 c0000007ffff7c08 0000000000000010 c0000000013332c8
GPR24: 0000000000000000 c0000000011f6cc0 0000000000000000 0000000000000000
GPR28: ffffffffffffffef 0000000000000001 0000000150000000 0000000010000000
NIP [c000000000403f34] add_memory_resource+0x244/0x340
LR [c000000000403f2c] add_memory_resource+0x23c/0x340
Call Trace:
[c0000004876e38f0] [c000000000403f2c] add_memory_resource+0x23c/0x340 (unreliable)
[c0000004876e39c0] [c00000000040408c] __add_memory+0x5c/0xf0
[c0000004876e39f0] [c0000000000e2b94] dlpar_add_lmb+0x1b4/0x500
[c0000004876e3ad0] [c0000000000e3888] dlpar_memory+0x1f8/0xb80
[c0000004876e3b60] [c0000000000dc0d0] handle_dlpar_errorlog+0xc0/0x190
[c0000004876e3bd0] [c0000000000dc398] dlpar_store+0x198/0x4a0
[c0000004876e3c90] [c00000000072e630] kobj_attr_store+0x30/0x50
[c0000004876e3cb0] [c00000000051f954] sysfs_kf_write+0x64/0x90
[c0000004876e3cd0] [c00000000051ee40] kernfs_fop_write+0x1b0/0x290
[c0000004876e3d20] [c000000000438dd8] vfs_write+0xe8/0x290
[c0000004876e3d70] [c0000000004391ac] ksys_write+0xdc/0x130
[c0000004876e3dc0] [c000000000034e40] system_call_exception+0x160/0x270
[c0000004876e3e20] [c00000000000d740] system_call_common+0xf0/0x27c
Instruction dump:
48442e35 60000000 0b030000 3cbe0001 7fa3eb78 7bc48402 38a5fffe 7ca5fa14
78a58402 48442db1 60000000 7c7c1b78 <0b030000> 7f23cb78 4bda371d 60000000
---[ end trace 562fd6c109cd0fb2 ]---

This has been seen on PowerPC LPAR.

The root cause of this issue is that when node's memory is registered, the
range used can overlap another node's range, thus the memory block is
registered to multiple nodes in sysfs.

There are 2 issues here:

a. The sysfs memory and node's layouts are broken due to these multiple
   links

b. The link errors in link_mem_sections() should not lead to a system
   panic.

To address a. register_mem_sect_under_node should not rely on the system
state to detect whether the link operation is triggered by a hot plug
operation or not. This is addressed by the patches 1 and 2 of this series.

The patch 3 is addressing the point b.


This patch (of 3):

The memmap_context enum is used to detect whether a memory operation is due
to a hot-add operation or happening at boot time.

Make it general to the hotplug operation and rename it as meminit_context.

There is no functional change introduced by this patch

Link: https://lkml.kernel.org/r/20200915094143.79181-1-ldufour@linux.ibm.com
Link: https://lkml.kernel.org/r/20200915132624.9723-1-ldufour@linux.ibm.com
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Cc: Scott Cheloha <cheloha@linux.ibm.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c    |    4 ++--
 include/linux/mm.h     |    2 +-
 include/linux/mmzone.h |   11 ++++++++---
 mm/memory_hotplug.c    |    2 +-
 mm/page_alloc.c        |   10 +++++-----
 5 files changed, 17 insertions(+), 12 deletions(-)

--- a/arch/ia64/mm/init.c~mm-replace-memmap_context-by-meminit_context
+++ a/arch/ia64/mm/init.c
@@ -538,7 +538,7 @@ virtual_memmap_init(u64 start, u64 end,
 	if (map_start < map_end)
 		memmap_init_zone((unsigned long)(map_end - map_start),
 				 args->nid, args->zone, page_to_pfn(map_start),
-				 MEMMAP_EARLY, NULL, MIGRATE_MOVABLE);
+				 MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
 	return 0;
 }
 
@@ -547,7 +547,7 @@ memmap_init (unsigned long size, int nid
 	     unsigned long start_pfn)
 {
 	if (!vmem_map) {
-		memmap_init_zone(size, nid, zone, start_pfn, MEMMAP_EARLY,
+		memmap_init_zone(size, nid, zone, start_pfn, MEMINIT_EARLY,
 				 NULL, MIGRATE_MOVABLE);
 	} else {
 		struct page *start;
--- a/include/linux/mm.h~mm-replace-memmap_context-by-meminit_context
+++ a/include/linux/mm.h
@@ -2430,7 +2430,7 @@ extern int __meminit __early_pfn_to_nid(
 
 extern void set_dma_reserve(unsigned long new_dma_reserve);
 extern void memmap_init_zone(unsigned long, int, unsigned long, unsigned long,
-			    enum memmap_context, struct vmem_altmap *,
+			    enum meminit_context, struct vmem_altmap *,
 			    int migratetype);
 extern void setup_per_zone_wmarks(void);
 extern int __meminit init_per_zone_wmark_min(void);
--- a/include/linux/mmzone.h~mm-replace-memmap_context-by-meminit_context
+++ a/include/linux/mmzone.h
@@ -859,10 +859,15 @@ bool zone_watermark_ok(struct zone *z, u
 		unsigned int alloc_flags);
 bool zone_watermark_ok_safe(struct zone *z, unsigned int order,
 		unsigned long mark, int highest_zoneidx);
-enum memmap_context {
-	MEMMAP_EARLY,
-	MEMMAP_HOTPLUG,
+/*
+ * Memory initialization context, use to differentiate memory added by
+ * the platform statically or via memory hotplug interface.
+ */
+enum meminit_context {
+	MEMINIT_EARLY,
+	MEMINIT_HOTPLUG,
 };
+
 extern void init_currently_empty_zone(struct zone *zone, unsigned long start_pfn,
 				     unsigned long size);
 
--- a/mm/memory_hotplug.c~mm-replace-memmap_context-by-meminit_context
+++ a/mm/memory_hotplug.c
@@ -734,7 +734,7 @@ void __ref move_pfn_range_to_zone(struct
 	 * are reserved so nobody should be touching them so we should be safe
 	 */
 	memmap_init_zone(nr_pages, nid, zone_idx(zone), start_pfn,
-			 MEMMAP_HOTPLUG, altmap, migratetype);
+			 MEMINIT_HOTPLUG, altmap, migratetype);
 
 	set_zone_contiguous(zone);
 }
--- a/mm/page_alloc.c~mm-replace-memmap_context-by-meminit_context
+++ a/mm/page_alloc.c
@@ -5976,7 +5976,7 @@ overlap_memmap_init(unsigned long zone,
  */
 void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 				unsigned long start_pfn,
-				enum memmap_context context,
+				enum meminit_context context,
 				struct vmem_altmap *altmap, int migratetype)
 {
 	unsigned long pfn, end_pfn = start_pfn + size;
@@ -6008,7 +6008,7 @@ void __meminit memmap_init_zone(unsigned
 		 * There can be holes in boot-time mem_map[]s handed to this
 		 * function.  They do not exist on hotplugged memory.
 		 */
-		if (context == MEMMAP_EARLY) {
+		if (context == MEMINIT_EARLY) {
 			if (overlap_memmap_init(zone, &pfn))
 				continue;
 			if (defer_init(nid, pfn, end_pfn))
@@ -6017,7 +6017,7 @@ void __meminit memmap_init_zone(unsigned
 
 		page = pfn_to_page(pfn);
 		__init_single_page(page, pfn, zone, nid);
-		if (context == MEMMAP_HOTPLUG)
+		if (context == MEMINIT_HOTPLUG)
 			__SetPageReserved(page);
 
 		/*
@@ -6088,7 +6088,7 @@ void __ref memmap_init_zone_device(struc
 		 * the address space during boot when many long-lived
 		 * kernel allocations are made.
 		 *
-		 * Please note that MEMMAP_HOTPLUG path doesn't clear memmap
+		 * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
 		 * because this is done early in section_activate()
 		 */
 		if (IS_ALIGNED(pfn, pageblock_nr_pages)) {
@@ -6126,7 +6126,7 @@ void __meminit __weak memmap_init(unsign
 		if (end_pfn > start_pfn) {
 			size = end_pfn - start_pfn;
 			memmap_init_zone(size, nid, zone, start_pfn,
-					 MEMMAP_EARLY, NULL, MIGRATE_MOVABLE);
+					 MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
 		}
 	}
 }
_

Patches currently in -mm which might be from ldufour@linux.ibm.com are

mm-replace-memmap_context-by-meminit_context.patch
mm-dont-rely-on-system-state-to-detect-hot-plug-operations.patch
mm-dont-panic-when-links-cant-be-created-in-sysfs.patch

