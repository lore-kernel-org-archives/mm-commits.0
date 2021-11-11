Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D714C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:47:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 681C96187A
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:47:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbhKKCue (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:50:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:55192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234421AbhKKCud (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:50:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D743C6135E;
        Thu, 11 Nov 2021 02:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598865;
        bh=6co9RX3K5B4k1lZtwf2OZFaGJZxfLYbr3LLn3oa9l4Q=;
        h=Date:From:To:Subject:From;
        b=Wy9kqe80mSyI8XDhxX7ZEqdirzH5Xy065BzbRJJSD7xmhQn6TojjulOUuYvwAdTDx
         BSXrKTm6JdsKwa7JPKIhxoMytwTtdO7bVMsgtN3NE+dxyDy1PuIw2MfaMueoED/BR3
         Z2SVfNqOHTEs4bsz0n8E9xymUSvmoGSez5zM/dn4=
Date:   Wed, 10 Nov 2021 18:47:44 -0800
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, arnd@arndb.de, borntraeger@de.ibm.com,
        chenhuacai@kernel.org, david@redhat.com, ebiederm@xmission.com,
        geert@linux-m68k.org, gor@linux.ibm.com, hca@linux.ibm.com,
        Jianyong.Wu@arm.com, jiaxun.yang@flygoat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, rppt@linux.ibm.com,
        shahab@synopsys.com, tsbogend@alpha.franken.de, vgupta@kernel.org
Subject:  [merged]
 =?US-ASCII?Q?memblock-add-memblock=5Fdriver=5Fmanaged-to-mimic-ioresource?=
 =?US-ASCII?Q?=5Fsysram=5Fdriver=5Fmanaged.patch?= removed from -mm tree
Message-ID: <20211111024744.6eQuZA2l7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: add MEMBLOCK_DRIVER_MANAGED to mimic IORESOURCE_SYSRAM_DRIVER_MANAGED
has been removed from the -mm tree.  Its filename was
     memblock-add-memblock_driver_managed-to-mimic-ioresource_sysram_driver_managed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: memblock: add MEMBLOCK_DRIVER_MANAGED to mimic IORESOURCE_SYSRAM_DRIVER_MANAGED

Let's add a flag that corresponds to IORESOURCE_SYSRAM_DRIVER_MANAGED,
indicating that we're dealing with a memory region that is never indicated
in the firmware-provided memory map, but always detected and added by a
driver.

Similar to MEMBLOCK_HOTPLUG, most infrastructure has to treat such memory
regions like ordinary MEMBLOCK_NONE memory regions -- for example, when
selecting memory regions to add to the vmcore for dumping in the
crashkernel via for_each_mem_range().

However, especially kexec_file is not supposed to select such memblocks
via for_each_free_mem_range() / for_each_free_mem_range_reverse() to place
kexec images, similar to how we handle IORESOURCE_SYSRAM_DRIVER_MANAGED
without CONFIG_ARCH_KEEP_MEMBLOCK.

We'll make sure that memory hotplug code sets the flag where applicable
(IORESOURCE_SYSRAM_DRIVER_MANAGED) next.  This prepares architectures that
need CONFIG_ARCH_KEEP_MEMBLOCK, such as arm64, for virtio-mem support.

Note that kexec *must not* indicate this memory to the second kernel and
*must not* place kexec-images on this memory.  Let's add a comment to
kexec_walk_memblock(), documenting how we handle MEMBLOCK_DRIVER_MANAGED
now just like using IORESOURCE_SYSRAM_DRIVER_MANAGED in
locate_mem_hole_callback() for kexec_walk_resources().

Also note that MEMBLOCK_HOTPLUG cannot be reused due to different
semantics:
	MEMBLOCK_HOTPLUG: memory is indicated as "System RAM" in the
	firmware-provided memory map and added to the system early during
	boot; kexec *has to* indicate this memory to the second kernel and
	can place kexec-images on this memory. After memory hotunplug,
	kexec has to be re-armed. We mostly ignore this flag when
	"movable_node" is not set on the kernel command line, because
	then we're told to not care about hotunpluggability of such
	memory regions.

	MEMBLOCK_DRIVER_MANAGED: memory is not indicated as "System RAM" in
	the firmware-provided memory map; this memory is always detected
	and added to the system by a driver; memory might not actually be
	physically hotunpluggable. kexec *must not* indicate this memory to
	the second kernel and *must not* place kexec-images on this memory.

Link: https://lkml.kernel.org/r/20211004093605.5830-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Jianyong Wu <Jianyong.Wu@arm.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shahab Vahedi <shahab@synopsys.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |   16 ++++++++++++++--
 kernel/kexec_file.c      |    5 +++++
 mm/memblock.c            |    4 ++++
 3 files changed, 23 insertions(+), 2 deletions(-)

--- a/include/linux/memblock.h~memblock-add-memblock_driver_managed-to-mimic-ioresource_sysram_driver_managed
+++ a/include/linux/memblock.h
@@ -37,12 +37,17 @@ extern unsigned long long max_possible_p
  * @MEMBLOCK_NOMAP: don't add to kernel direct mapping and treat as
  * reserved in the memory map; refer to memblock_mark_nomap() description
  * for further details
+ * @MEMBLOCK_DRIVER_MANAGED: memory region that is always detected and added
+ * via a driver, and never indicated in the firmware-provided memory map as
+ * system RAM. This corresponds to IORESOURCE_SYSRAM_DRIVER_MANAGED in the
+ * kernel resource tree.
  */
 enum memblock_flags {
 	MEMBLOCK_NONE		= 0x0,	/* No special request */
 	MEMBLOCK_HOTPLUG	= 0x1,	/* hotpluggable region */
 	MEMBLOCK_MIRROR		= 0x2,	/* mirrored region */
 	MEMBLOCK_NOMAP		= 0x4,	/* don't add to kernel direct mapping */
+	MEMBLOCK_DRIVER_MANAGED = 0x8,	/* always detected via a driver */
 };
 
 /**
@@ -213,7 +218,8 @@ static inline void __next_physmem_range(
  */
 #define for_each_mem_range(i, p_start, p_end) \
 	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,	\
-			     MEMBLOCK_HOTPLUG, p_start, p_end, NULL)
+			     MEMBLOCK_HOTPLUG | MEMBLOCK_DRIVER_MANAGED, \
+			     p_start, p_end, NULL)
 
 /**
  * for_each_mem_range_rev - reverse iterate through memblock areas from
@@ -224,7 +230,8 @@ static inline void __next_physmem_range(
  */
 #define for_each_mem_range_rev(i, p_start, p_end)			\
 	__for_each_mem_range_rev(i, &memblock.memory, NULL, NUMA_NO_NODE, \
-				 MEMBLOCK_HOTPLUG, p_start, p_end, NULL)
+				 MEMBLOCK_HOTPLUG | MEMBLOCK_DRIVER_MANAGED,\
+				 p_start, p_end, NULL)
 
 /**
  * for_each_reserved_mem_range - iterate over all reserved memblock areas
@@ -254,6 +261,11 @@ static inline bool memblock_is_nomap(str
 	return m->flags & MEMBLOCK_NOMAP;
 }
 
+static inline bool memblock_is_driver_managed(struct memblock_region *m)
+{
+	return m->flags & MEMBLOCK_DRIVER_MANAGED;
+}
+
 int memblock_search_pfn_nid(unsigned long pfn, unsigned long *start_pfn,
 			    unsigned long  *end_pfn);
 void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
--- a/kernel/kexec_file.c~memblock-add-memblock_driver_managed-to-mimic-ioresource_sysram_driver_managed
+++ a/kernel/kexec_file.c
@@ -556,6 +556,11 @@ static int kexec_walk_memblock(struct ke
 	if (kbuf->image->type == KEXEC_TYPE_CRASH)
 		return func(&crashk_res, kbuf);
 
+	/*
+	 * Using MEMBLOCK_NONE will properly skip MEMBLOCK_DRIVER_MANAGED. See
+	 * IORESOURCE_SYSRAM_DRIVER_MANAGED handling in
+	 * locate_mem_hole_callback().
+	 */
 	if (kbuf->top_down) {
 		for_each_free_mem_range_reverse(i, NUMA_NO_NODE, MEMBLOCK_NONE,
 						&mstart, &mend, NULL) {
--- a/mm/memblock.c~memblock-add-memblock_driver_managed-to-mimic-ioresource_sysram_driver_managed
+++ a/mm/memblock.c
@@ -982,6 +982,10 @@ static bool should_skip_region(struct me
 	if (!(flags & MEMBLOCK_NOMAP) && memblock_is_nomap(m))
 		return true;
 
+	/* skip driver-managed memory unless we were asked for it explicitly */
+	if (!(flags & MEMBLOCK_DRIVER_MANAGED) && memblock_is_driver_managed(m))
+		return true;
+
 	return false;
 }
 
_

Patches currently in -mm which might be from david@redhat.com are


