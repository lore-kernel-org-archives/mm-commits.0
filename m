Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 918E2C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 21:30:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D795611CA
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 21:30:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbhJEVcs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Oct 2021 17:32:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235679AbhJEVcs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 Oct 2021 17:32:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE692613A9;
        Tue,  5 Oct 2021 21:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633469457;
        bh=FenLqaJ51O1u2XMcyuu1sxLt1DY5iSHhHQmvO3NhkOo=;
        h=Date:From:To:Subject:From;
        b=pg2wvHSbuDU930lLC1PLvVl6/Uc/2GcuFTIz5pwzKAEF9S8AxK5irq29XPfR+z8UR
         U3wt/wkGWMA+RU+SVXjNt4gEymg0QeYaGputMp/pq9KoOIG/K2QjIsFTQ9m0HpDZX4
         pE5ooUbl80WAud92g3XlUu1UU/s91OpuR50P1AuY=
Date:   Tue, 05 Oct 2021 14:30:56 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, boris.ostrovsky@oracle.com,
        boris.ostrvsky@oracle.com, bp@alien8.de, david@redhat.com,
        dyoung@redhat.com, hpa@zytor.com, jasowang@redhat.com,
        jgross@suse.com, mhocko@suse.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, mst@redhat.com, osalvador@suse.de,
        rafael.j.wysocki@intel.com, rppt@kernel.org,
        sstabellini@kernel.org, tglx@linutronix.de, vgoyal@redhat.com
Subject:  +
 x86-xen-print-a-warning-when-hvmop_get_mem_type-fails.patch added to -mm
 tree
Message-ID: <20211005213056.rN6BT9D-x%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/xen: print a warning when HVMOP_get_mem_type fails
has been added to the -mm tree.  Its filename is
     x86-xen-print-a-warning-when-hvmop_get_mem_type-fails.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/x86-xen-print-a-warning-when-hvmop_get_mem_type-fails.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/x86-xen-print-a-warning-when-hvmop_get_mem_type-fails.patch

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
Subject: x86/xen: print a warning when HVMOP_get_mem_type fails

HVMOP_get_mem_type is not expected to fail, "This call failing is
indication of something going quite wrong and it would be good to know
about this." [1]

Let's add a pr_warn_once().

[1] https://lkml.kernel.org/r/3b935aa0-6d85-0bcd-100e-15098add3c4c@oracle.com

Link: https://lkml.kernel.org/r/20211005121430.30136-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Suggested-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrvsky@oracle.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/mmu_hvm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/xen/mmu_hvm.c~x86-xen-print-a-warning-when-hvmop_get_mem_type-fails
+++ a/arch/x86/xen/mmu_hvm.c
@@ -22,8 +22,10 @@ static int xen_oldmem_pfn_is_ram(unsigne
 		.pfn = pfn,
 	};
 
-	if (HYPERVISOR_hvm_op(HVMOP_get_mem_type, &a))
+	if (HYPERVISOR_hvm_op(HVMOP_get_mem_type, &a)) {
+		pr_warn_once("Unexpected HVMOP_get_mem_type failure\n");
 		return -ENXIO;
+	}
 	return a.mem_type != HVMMEM_mmio_dm;
 }
 #endif
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

