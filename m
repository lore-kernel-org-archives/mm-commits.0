Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF7FC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 23:40:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9ADB61354
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 23:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236873AbhJEXmZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Oct 2021 19:42:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233540AbhJEXmY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 Oct 2021 19:42:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1543B61251;
        Tue,  5 Oct 2021 23:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633477233;
        bh=wK32bREa7QZ5wTLo8CsbvSn6OEj0lX8cgsKjFdHiOvk=;
        h=Date:From:To:Subject:From;
        b=s0R4WUfcXd2oh2TgPxUIlnE+A7Gwf0LIk6ekZyA5osl2JZxymNAZj/x9CXLVKwFqV
         9MbZk2r1qyrSsms0B9iqP4C8t4BVhC25oZvq+PPG0rGjzpft2PUgLgz9besFwbew0Y
         Us6kfp9Yk8EiB8gTKITuEuG+RWxZfqafHkGVrphU=
Date:   Tue, 05 Oct 2021 16:40:32 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, arnd@arndb.de, borntraeger@de.ibm.com,
        chenhuacai@kernel.org, david@redhat.com, ebiederm@xmission.com,
        geert@linux-m68k.org, gor@linux.ibm.com, hca@linux.ibm.com,
        Jianyong.Wu@arm.com, jiaxun.yang@flygoat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, rppt@kernel.org,
        shahab@synopsys.com, tsbogend@alpha.franken.de, vgupta@kernel.org
Subject:  +
 =?US-ASCII?Q?memblock-add-memblock=5Fdriver=5Fmanaged-to-mimic-ioresource?=
 =?US-ASCII?Q?=5Fsysram=5Fdriver=5Fmanaged.patch?= added to -mm tree
Message-ID: <20211005234032.jJW3J1sQF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: add MEMBLOCK_DRIVER_MANAGED to mimic IORESOURCE_SYSRAM_DRIVER_MANAGED
has been added to the -mm tree.  Its filename is
     memblock-add-memblock_driver_managed-to-mimic-ioresource_sysram_driver_managed.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memblock-add-memblock_driver_managed-to-mimic-ioresource_sysram_driver_managed.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memblock-add-memblock_driver_managed-to-mimic-ioresource_sysram_driver_managed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Mike Rapoport <rppt@kernel.org>
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
@@ -979,6 +979,10 @@ static bool should_skip_region(struct me
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

memory-hotplugrst-fix-two-instances-of-movablecore-that-should-be-movable_node.patch
memory-hotplugrst-fix-wrong-sys-module-memory_hotplug-parameters-path.patch
memory-hotplugrst-document-the-auto-movable-online-policy.patch
mm-memory_hotplug-remove-config_x86_64_acpi_numa-dependency-from-config_memory_hotplug.patch
mm-memory_hotplug-remove-config_memory_hotplug_sparse.patch
mm-memory_hotplug-restrict-config_memory_hotplug-to-64-bit.patch
mm-memory_hotplug-remove-highmem-leftovers.patch
mm-memory_hotplug-remove-stale-function-declarations.patch
x86-remove-memory-hotplug-support-on-x86_32.patch
mm-memory_hotplug-handle-memblock_add_node-failures-in-add_memory_resource.patch
memblock-improve-memblock_hotplug-documentation.patch
memblock-allow-to-specify-flags-with-memblock_add_node.patch
memblock-add-memblock_driver_managed-to-mimic-ioresource_sysram_driver_managed.patch
mm-memory_hotplug-indicate-memblock_driver_managed-with-ioresource_sysram_driver_managed.patch
x86-xen-update-xen_oldmem_pfn_is_ram-documentation.patch
x86-xen-simplify-xen_oldmem_pfn_is_ram.patch
x86-xen-print-a-warning-when-hvmop_get_mem_type-fails.patch
proc-vmcore-let-pfn_is_ram-return-a-bool.patch
proc-vmcore-convert-oldmem_pfn_is_ram-callback-to-more-generic-vmcore-callbacks.patch
virtio-mem-factor-out-hotplug-specifics-from-virtio_mem_init-into-virtio_mem_init_hotplug.patch
virtio-mem-factor-out-hotplug-specifics-from-virtio_mem_probe-into-virtio_mem_init_hotplug.patch
virtio-mem-factor-out-hotplug-specifics-from-virtio_mem_remove-into-virtio_mem_deinit_hotplug.patch
virtio-mem-kdump-mode-to-sanitize-proc-vmcore-access.patch
kernel-resource-clean-up-and-optimize-iomem_is_exclusive.patch
kernel-resource-disallow-access-to-exclusive-system-ram-regions.patch
virtio-mem-disallow-mapping-virtio-mem-memory-via-dev-mem.patch

