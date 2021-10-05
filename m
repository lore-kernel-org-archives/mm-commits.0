Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F232DC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 23:40:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C30036124D
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 23:40:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236799AbhJEXmO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Oct 2021 19:42:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233540AbhJEXmN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 Oct 2021 19:42:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1296861248;
        Tue,  5 Oct 2021 23:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633477222;
        bh=l6J11RejnRbgmzl0e2olVP0FcDPEjlBqqglGTHCO4hY=;
        h=Date:From:To:Subject:From;
        b=McfgKH4YwP5AmErk/oR1kCONyg+DpX1iIBJXfibVd5k8bun9t2s2AIIgeVY0r0WTk
         IsKhHEAG7AjmZDEg5P6N3xcUkvJHHrE53lfUmqo5omHUv9GC6t46pHKFv7FSlbOKFg
         wqfzD7UEThGZr0bzv+tfIF1OWWLG1iTf5OI+FVGo=
Date:   Tue, 05 Oct 2021 16:40:21 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, arnd@arndb.de, borntraeger@de.ibm.com,
        chenhuacai@kernel.org, david@redhat.com, ebiederm@xmission.com,
        geert@linux-m68k.org, gor@linux.ibm.com, hca@linux.ibm.com,
        Jianyong.Wu@arm.com, jiaxun.yang@flygoat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, rppt@kernel.org,
        shahab@synopsys.com, tsbogend@alpha.franken.de, vgupta@kernel.org
Subject:  +
 =?US-ASCII?Q?mm-memory=5Fhotplug-handle-memblock=5Fadd=5Fnode-failures-?=
 =?US-ASCII?Q?in-add=5Fmemory=5Fresource.patch?= added to -mm tree
Message-ID: <20211005234021.q-4ubxrJA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: handle memblock_add_node() failures in add_memory_resource()
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-handle-memblock_add_node-failures-in-add_memory_resource.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-handle-memblock_add_node-failures-in-add_memory_resource.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-handle-memblock_add_node-failures-in-add_memory_resource.patch

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
Subject: mm/memory_hotplug: handle memblock_add_node() failures in add_memory_resource()

Patch series "mm/memory_hotplug: full support for add_memory_driver_managed() with CONFIG_ARCH_KEEP_MEMBLOCK", v2.

Architectures that require CONFIG_ARCH_KEEP_MEMBLOCK=y, such as arm64,
don't cleanly support add_memory_driver_managed() yet.  Most prominently,
kexec_file can still end up placing kexec images on such driver-managed
memory, resulting in undesired behavior, for example, having kexec images
located on memory not part of the firmware-provided memory map.

Teaching kexec to not place images on driver-managed memory is especially
relevant for virtio-mem.  Details can be found in commit 7b7b27214bba
("mm/memory_hotplug: introduce add_memory_driver_managed()").

Extend memblock with a new flag and set it from memory hotplug code when
applicable.  This is required to fully support virtio-mem on arm64, making
also kexec_file behave like on x86-64.


This patch (of 2):

If memblock_add_node() fails, we're most probably running out of memory. 
While this is unlikely to happen, it can happen and having memory added
without a memblock can be problematic for architectures that use memblock
to detect valid memory.  Let's fail in a nice way instead of silently
ignoring the error.

Link: https://lkml.kernel.org/r/20211004093605.5830-1-david@redhat.com
Link: https://lkml.kernel.org/r/20211004093605.5830-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Jianyong Wu <Jianyong.Wu@arm.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Shahab Vahedi <shahab@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-handle-memblock_add_node-failures-in-add_memory_resource
+++ a/mm/memory_hotplug.c
@@ -1369,8 +1369,11 @@ int __ref add_memory_resource(int nid, s
 
 	mem_hotplug_begin();
 
-	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK))
-		memblock_add_node(start, size, nid);
+	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK)) {
+		ret = memblock_add_node(start, size, nid);
+		if (ret)
+			goto error_mem_hotplug_end;
+	}
 
 	ret = __try_online_node(nid, false);
 	if (ret < 0)
@@ -1443,6 +1446,7 @@ error:
 		rollback_node_hotadd(nid);
 	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK))
 		memblock_remove(start, size);
+error_mem_hotplug_end:
 	mem_hotplug_done();
 	return ret;
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

