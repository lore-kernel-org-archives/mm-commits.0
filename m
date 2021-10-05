Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEF96C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 21:30:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C099661222
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 21:30:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235845AbhJEVcn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Oct 2021 17:32:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235679AbhJEVcm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 Oct 2021 17:32:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2065C61159;
        Tue,  5 Oct 2021 21:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633469451;
        bh=bL3fBLdu18xzq/gJXYKn0cpTBCsym6igFaM+VnD4v/w=;
        h=Date:From:To:Subject:From;
        b=JPu0gYAKXj/sxEP1KYxEWHgP5NAb7/eiq3cVuiIgYLCzjXnZJ2w/xOblgRoHUPT56
         +K0KAiUaCPdG9oLp4eHjiEvWXJIR29QRBBHYxcXVOZSR+dW24q7s4txR7pjhb3Ejqo
         sp5LCNiXBlZkXVRIHhgBo1ZYoa4eeoFcXsuHJVdI=
Date:   Tue, 05 Oct 2021 14:30:50 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, boris.ostrovsky@oracle.com,
        boris.ostrvsky@oracle.com, bp@alien8.de, david@redhat.com,
        dyoung@redhat.com, hpa@zytor.com, jasowang@redhat.com,
        jgross@suse.com, mhocko@suse.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, mst@redhat.com, osalvador@suse.de,
        rafael.j.wysocki@intel.com, rppt@kernel.org,
        sstabellini@kernel.org, tglx@linutronix.de, vgoyal@redhat.com
Subject:  +
 x86-xen-update-xen_oldmem_pfn_is_ram-documentation.patch added to -mm tree
Message-ID: <20211005213050.ugF1yT5Ay%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/xen: update xen_oldmem_pfn_is_ram() documentation
has been added to the -mm tree.  Its filename is
     x86-xen-update-xen_oldmem_pfn_is_ram-documentation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/x86-xen-update-xen_oldmem_pfn_is_ram-documentation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/x86-xen-update-xen_oldmem_pfn_is_ram-documentation.patch

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
Subject: x86/xen: update xen_oldmem_pfn_is_ram() documentation

After removing /dev/kmem, sanitizing /proc/kcore and handling /dev/mem,
this series tackles the last sane way how a VM could accidentially access
logically unplugged memory managed by a virtio-mem device: /proc/vmcore

When dumping memory via "makedumpfile", PG_offline pages, used by
virtio-mem to flag logically unplugged memory, are already properly
excluded; however, especially when accessing/copying /proc/vmcore "the
usual way", we can still end up reading logically unplugged memory part of
a virtio-mem device.

Patch #1-#3 are cleanups.  Patch #4 extends the existing oldmem_pfn_is_ram
mechanism.  Patch #5-#7 are virtio-mem refactorings for patch #8, which
implements the virtio-mem logic to query the state of device blocks.

Patch #8:

"
Although virtio-mem currently supports reading unplugged memory in the
hypervisor, this will change in the future, indicated to the device via
a new feature flag. We similarly sanitized /proc/kcore access recently.
[...]
Distributions that support virtio-mem+kdump have to make sure that the
virtio_mem module will be part of the kdump kernel or the kdump initrd;
dracut was recently [2] extended to include virtio-mem in the generated
initrd. As long as no special kdump kernels are used, this will
automatically make sure that virtio-mem will be around in the kdump initrd
and sanitize /proc/vmcore access -- with dracut.
"

This is the last remaining bit to support
VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE [3] in the Linux implementation of
virtio-mem.

Note: this is best-effort.  We'll never be able to control what runs
inside the second kernel, really, but we also don't have to care: we only
care about sane setups where we don't want our VM getting zapped once we
touch the wrong memory location while dumping.  While we usually expect
sane setups to use "makedumfile", nothing really speaks against just
copying /proc/vmcore, especially in environments where HWpoisioning isn't
typically expected.  Also, we really don't want to put all our trust
completely on the memmap, so sanitizing also makes sense when just using
"makedumpfile".

[1] https://lkml.kernel.org/r/20210526093041.8800-1-david@redhat.com
[2] https://github.com/dracutdevs/dracut/pull/1157
[3] https://lists.oasis-open.org/archives/virtio-comment/202109/msg00021.html


This patch (of 9):

The callback is only used for the vmcore nowadays.

Link: https://lkml.kernel.org/r/20211005121430.30136-1-david@redhat.com
Link: https://lkml.kernel.org/r/20211005121430.30136-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Boris Ostrovsky <boris.ostrvsky@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/mmu_hvm.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/arch/x86/xen/mmu_hvm.c~x86-xen-update-xen_oldmem_pfn_is_ram-documentation
+++ a/arch/x86/xen/mmu_hvm.c
@@ -9,12 +9,9 @@
 
 #ifdef CONFIG_PROC_VMCORE
 /*
- * This function is used in two contexts:
- * - the kdump kernel has to check whether a pfn of the crashed kernel
- *   was a ballooned page. vmcore is using this function to decide
- *   whether to access a pfn of the crashed kernel.
- * - the kexec kernel has to check whether a pfn was ballooned by the
- *   previous kernel. If the pfn is ballooned, handle it properly.
+ * The kdump kernel has to check whether a pfn of the crashed kernel
+ * was a ballooned page. vmcore is using this function to decide
+ * whether to access a pfn of the crashed kernel.
  * Returns 0 if the pfn is not backed by a RAM page, the caller may
  * handle the pfn special in this case.
  */
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

