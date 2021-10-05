Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EDECC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 21:31:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86383615E2
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 21:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236610AbhJEVdE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Oct 2021 17:33:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:51344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236662AbhJEVdE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 Oct 2021 17:33:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02C3F6124D;
        Tue,  5 Oct 2021 21:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633469473;
        bh=EXEGfyMvWrKchEnScfF/WHzxqfkLFUjpTiUxn2rqOoM=;
        h=Date:From:To:Subject:From;
        b=wpEhnFLs+tyRjDgAv6qMTg6v6jDC+Uw3Z1cXYhPLcJgNxVXoS5zkk/iUz139UEaoW
         0po6UVEmdvsL/QfGPhPxoAG4SILRJgy4gpK8t7WqwWwLNXInZR44E/n98/Dpj7CQRj
         a2bfF0o7mMmy/vcJ1XpYqEYWGtGQQ6t+L3vNQXFo=
Date:   Tue, 05 Oct 2021 14:31:12 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, boris.ostrovsky@oracle.com,
        boris.ostrvsky@oracle.com, bp@alien8.de, david@redhat.com,
        dyoung@redhat.com, hpa@zytor.com, jasowang@redhat.com,
        jgross@suse.com, mhocko@suse.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, mst@redhat.com, osalvador@suse.de,
        rafael.j.wysocki@intel.com, rppt@kernel.org,
        sstabellini@kernel.org, tglx@linutronix.de, vgoyal@redhat.com
Subject:  +
 =?US-ASCII?Q?virtio-mem-factor-out-hotplug-specifics-from-virtio=5Fmem?=
 =?US-ASCII?Q?=5Fremove-into-virtio=5Fmem=5Fdeinit=5Fhotplug.patch?= added
 to -mm tree
Message-ID: <20211005213112.QbOak7jzA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: virtio-mem: factor out hotplug specifics from virtio_mem_remove() into virtio_mem_deinit_hotplug()
has been added to the -mm tree.  Its filename is
     virtio-mem-factor-out-hotplug-specifics-from-virtio_mem_remove-into-virtio_mem_deinit_hotplug.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/virtio-mem-factor-out-hotplug-specifics-from-virtio_mem_remove-into-virtio_mem_deinit_hotplug.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/virtio-mem-factor-out-hotplug-specifics-from-virtio_mem_remove-into-virtio_mem_deinit_hotplug.patch

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
Subject: virtio-mem: factor out hotplug specifics from virtio_mem_remove() into virtio_mem_deinit_hotplug()

Let's prepare for a new virtio-mem kdump mode in which we don't actually
hot(un)plug any memory but only observe the state of device blocks.

Link: https://lkml.kernel.org/r/20211005121430.30136-9-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
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

 drivers/virtio/virtio_mem.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/virtio/virtio_mem.c~virtio-mem-factor-out-hotplug-specifics-from-virtio_mem_remove-into-virtio_mem_deinit_hotplug
+++ a/drivers/virtio/virtio_mem.c
@@ -2667,9 +2667,8 @@ out_free_vm:
 	return rc;
 }
 
-static void virtio_mem_remove(struct virtio_device *vdev)
+static void virtio_mem_deinit_hotplug(struct virtio_mem *vm)
 {
-	struct virtio_mem *vm = vdev->priv;
 	unsigned long mb_id;
 	int rc;
 
@@ -2716,7 +2715,8 @@ static void virtio_mem_remove(struct vir
 	 * away. Warn at least.
 	 */
 	if (virtio_mem_has_memory_added(vm)) {
-		dev_warn(&vdev->dev, "device still has system memory added\n");
+		dev_warn(&vm->vdev->dev,
+			 "device still has system memory added\n");
 	} else {
 		virtio_mem_delete_resource(vm);
 		kfree_const(vm->resource_name);
@@ -2730,6 +2730,13 @@ static void virtio_mem_remove(struct vir
 	} else {
 		vfree(vm->bbm.bb_states);
 	}
+}
+
+static void virtio_mem_remove(struct virtio_device *vdev)
+{
+	struct virtio_mem *vm = vdev->priv;
+
+	virtio_mem_deinit_hotplug(vm);
 
 	/* reset the device and cleanup the queues */
 	vdev->config->reset(vdev);
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

