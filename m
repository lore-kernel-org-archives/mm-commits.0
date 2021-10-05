Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E70C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 23:40:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D70746124C
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 23:40:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236889AbhJEXm2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Oct 2021 19:42:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:54718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233540AbhJEXm1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 Oct 2021 19:42:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EABD61269;
        Tue,  5 Oct 2021 23:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633477236;
        bh=VpXkwVUrRlKYQDgjA4iaosWM4KTc93+aLYEf8P3LBKg=;
        h=Date:From:To:Subject:From;
        b=bUxGluH8n4XxLl8227H1FF8JgasXORTS4vP9pmjk1Bmhv0OniB2Nd7almHEugBLmA
         iTV2u6U/in/24b8X4BEV688gVhiILQrl9uOrxxm9jES1O7f3mFGN2sEHzce3HWea0q
         LEvG6RapKmZssZ6jWaoHRW11FEvUlIYfTVQEEuD8=
Date:   Tue, 05 Oct 2021 16:40:35 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, arnd@arndb.de, borntraeger@de.ibm.com,
        chenhuacai@kernel.org, david@redhat.com, ebiederm@xmission.com,
        geert@linux-m68k.org, gor@linux.ibm.com, hca@linux.ibm.com,
        Jianyong.Wu@arm.com, jiaxun.yang@flygoat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, rppt@kernel.org,
        shahab@synopsys.com, tsbogend@alpha.franken.de, vgupta@kernel.org
Subject:  +
 =?US-ASCII?Q?mm-memory=5Fhotplug-indicate-memblock=5Fdriver=5Fmanaged-wit?=
 =?US-ASCII?Q?h-ioresource=5Fsysram=5Fdriver=5Fmanaged.patch?= added to -mm
 tree
Message-ID: <20211005234035.tKQVXcvjD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: indicate MEMBLOCK_DRIVER_MANAGED with IORESOURCE_SYSRAM_DRIVER_MANAGED
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-indicate-memblock_driver_managed-with-ioresource_sysram_driver_managed.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-indicate-memblock_driver_managed-with-ioresource_sysram_driver_managed.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-indicate-memblock_driver_managed-with-ioresource_sysram_driver_managed.patch

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
Subject: mm/memory_hotplug: indicate MEMBLOCK_DRIVER_MANAGED with IORESOURCE_SYSRAM_DRIVER_MANAGED

Let's communicate driver-managed regions to memblock, to properly teach
kexec_file with CONFIG_ARCH_KEEP_MEMBLOCK to not place images on these
memory regions.

Link: https://lkml.kernel.org/r/20211004093605.5830-6-david@redhat.com
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

 mm/memory_hotplug.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-indicate-memblock_driver_managed-with-ioresource_sysram_driver_managed
+++ a/mm/memory_hotplug.c
@@ -1342,6 +1342,7 @@ bool mhp_supports_memmap_on_memory(unsig
 int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 {
 	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
+	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
 	struct vmem_altmap mhp_altmap = {};
 	struct memory_group *group = NULL;
 	u64 start, size;
@@ -1370,7 +1371,9 @@ int __ref add_memory_resource(int nid, s
 	mem_hotplug_begin();
 
 	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK)) {
-		ret = memblock_add_node(start, size, nid, MEMBLOCK_NONE);
+		if (res->flags & IORESOURCE_SYSRAM_DRIVER_MANAGED)
+			memblock_flags = MEMBLOCK_DRIVER_MANAGED;
+		ret = memblock_add_node(start, size, nid, memblock_flags);
 		if (ret)
 			goto error_mem_hotplug_end;
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

