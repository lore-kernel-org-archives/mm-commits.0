Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E74F7C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 21:31:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4837615E0
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 21:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236655AbhJEVdB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Oct 2021 17:33:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236610AbhJEVdB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 Oct 2021 17:33:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0ED5A613D5;
        Tue,  5 Oct 2021 21:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633469470;
        bh=bvPNozhdsC3HYKoOC05RXll6DT0r3oSRp7ytn32MK2I=;
        h=Date:From:To:Subject:From;
        b=luWG1zFhrcxu9WLZonWcQ40W2484Lu8LB/cJ86GI7/IxoaefCpBncaNm/3EXaK/eU
         PDIlYOUmUwSt2fGUcecFf8BFvmnFdW25AmMOyUvxjmkONgLjRZvpH06I6R3BXVPrZ4
         0JgGP/gtmDL7pf/4bo2yV4Vg0rEBO4pYtW0D2E7Q=
Date:   Tue, 05 Oct 2021 14:31:09 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, boris.ostrovsky@oracle.com,
        boris.ostrvsky@oracle.com, bp@alien8.de, david@redhat.com,
        dyoung@redhat.com, hpa@zytor.com, jasowang@redhat.com,
        jgross@suse.com, mhocko@suse.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, mst@redhat.com, osalvador@suse.de,
        rafael.j.wysocki@intel.com, rppt@kernel.org,
        sstabellini@kernel.org, tglx@linutronix.de, vgoyal@redhat.com
Subject:  +
 =?US-ASCII?Q?virtio-mem-factor-out-hotplug-specifics-from-virtio=5Fmem=5F?=
 =?US-ASCII?Q?probe-into-virtio=5Fmem=5Finit=5Fhotplug.patch?= added to -mm
 tree
Message-ID: <20211005213109.cgYAIlTGd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: virtio-mem: factor out hotplug specifics from virtio_mem_probe() into virtio_mem_init_hotplug()
has been added to the -mm tree.  Its filename is
     virtio-mem-factor-out-hotplug-specifics-from-virtio_mem_probe-into-virtio_mem_init_hotplug.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/virtio-mem-factor-out-hotplug-specifics-from-virtio_mem_probe-into-virtio_mem_init_hotplug.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/virtio-mem-factor-out-hotplug-specifics-from-virtio_mem_probe-into-virtio_mem_init_hotplug.patch

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
Subject: virtio-mem: factor out hotplug specifics from virtio_mem_probe() into virtio_mem_init_hotplug()

Let's prepare for a new virtio-mem kdump mode in which we don't actually
hot(un)plug any memory but only observe the state of device blocks.

Link: https://lkml.kernel.org/r/20211005121430.30136-8-david@redhat.com
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

 drivers/virtio/virtio_mem.c |   87 +++++++++++++++++-----------------
 1 file changed, 45 insertions(+), 42 deletions(-)

--- a/drivers/virtio/virtio_mem.c~virtio-mem-factor-out-hotplug-specifics-from-virtio_mem_probe-into-virtio_mem_init_hotplug
+++ a/drivers/virtio/virtio_mem.c
@@ -260,6 +260,8 @@ static void virtio_mem_fake_offline_goin
 static void virtio_mem_fake_offline_cancel_offline(unsigned long pfn,
 						   unsigned long nr_pages);
 static void virtio_mem_retry(struct virtio_mem *vm);
+static int virtio_mem_create_resource(struct virtio_mem *vm);
+static void virtio_mem_delete_resource(struct virtio_mem *vm);
 
 /*
  * Register a virtio-mem device so it will be considered for the online_page
@@ -2395,7 +2397,8 @@ static int virtio_mem_init_vq(struct vir
 static int virtio_mem_init_hotplug(struct virtio_mem *vm)
 {
 	const struct range pluggable_range = mhp_get_pluggable_range(true);
-	uint64_t sb_size, addr;
+	uint64_t unit_pages, sb_size, addr;
+	int rc;
 
 	/* bad device setup - warn only */
 	if (!IS_ALIGNED(vm->addr, memory_block_size_bytes()))
@@ -2474,7 +2477,48 @@ static int virtio_mem_init_hotplug(struc
 		dev_info(&vm->vdev->dev, "big block size: 0x%llx",
 			 (unsigned long long)vm->bbm.bb_size);
 
+	/* create the parent resource for all memory */
+	rc = virtio_mem_create_resource(vm);
+	if (rc)
+		return rc;
+
+	/* use a single dynamic memory group to cover the whole memory device */
+	if (vm->in_sbm)
+		unit_pages = PHYS_PFN(memory_block_size_bytes());
+	else
+		unit_pages = PHYS_PFN(vm->bbm.bb_size);
+	rc = memory_group_register_dynamic(vm->nid, unit_pages);
+	if (rc < 0)
+		goto out_del_resource;
+	vm->mgid = rc;
+
+	/*
+	 * If we still have memory plugged, we have to unplug all memory first.
+	 * Registering our parent resource makes sure that this memory isn't
+	 * actually in use (e.g., trying to reload the driver).
+	 */
+	if (vm->plugged_size) {
+		vm->unplug_all_required = true;
+		dev_info(&vm->vdev->dev, "unplugging all memory is required\n");
+	}
+
+	/* register callbacks */
+	vm->memory_notifier.notifier_call = virtio_mem_memory_notifier_cb;
+	rc = register_memory_notifier(&vm->memory_notifier);
+	if (rc)
+		goto out_unreg_group;
+	rc = register_virtio_mem_device(vm);
+	if (rc)
+		goto out_unreg_mem;
+
 	return 0;
+out_unreg_mem:
+	unregister_memory_notifier(&vm->memory_notifier);
+out_unreg_group:
+	memory_group_unregister(vm->mgid);
+out_del_resource:
+	virtio_mem_delete_resource(vm);
+	return rc;
 }
 
 static int virtio_mem_init(struct virtio_mem *vm)
@@ -2578,7 +2622,6 @@ static bool virtio_mem_has_memory_added(
 static int virtio_mem_probe(struct virtio_device *vdev)
 {
 	struct virtio_mem *vm;
-	uint64_t unit_pages;
 	int rc;
 
 	BUILD_BUG_ON(sizeof(struct virtio_mem_req) != 24);
@@ -2608,40 +2651,6 @@ static int virtio_mem_probe(struct virti
 	if (rc)
 		goto out_del_vq;
 
-	/* create the parent resource for all memory */
-	rc = virtio_mem_create_resource(vm);
-	if (rc)
-		goto out_del_vq;
-
-	/* use a single dynamic memory group to cover the whole memory device */
-	if (vm->in_sbm)
-		unit_pages = PHYS_PFN(memory_block_size_bytes());
-	else
-		unit_pages = PHYS_PFN(vm->bbm.bb_size);
-	rc = memory_group_register_dynamic(vm->nid, unit_pages);
-	if (rc < 0)
-		goto out_del_resource;
-	vm->mgid = rc;
-
-	/*
-	 * If we still have memory plugged, we have to unplug all memory first.
-	 * Registering our parent resource makes sure that this memory isn't
-	 * actually in use (e.g., trying to reload the driver).
-	 */
-	if (vm->plugged_size) {
-		vm->unplug_all_required = true;
-		dev_info(&vm->vdev->dev, "unplugging all memory is required\n");
-	}
-
-	/* register callbacks */
-	vm->memory_notifier.notifier_call = virtio_mem_memory_notifier_cb;
-	rc = register_memory_notifier(&vm->memory_notifier);
-	if (rc)
-		goto out_unreg_group;
-	rc = register_virtio_mem_device(vm);
-	if (rc)
-		goto out_unreg_mem;
-
 	virtio_device_ready(vdev);
 
 	/* trigger a config update to start processing the requested_size */
@@ -2649,12 +2658,6 @@ static int virtio_mem_probe(struct virti
 	queue_work(system_freezable_wq, &vm->wq);
 
 	return 0;
-out_unreg_mem:
-	unregister_memory_notifier(&vm->memory_notifier);
-out_unreg_group:
-	memory_group_unregister(vm->mgid);
-out_del_resource:
-	virtio_mem_delete_resource(vm);
 out_del_vq:
 	vdev->config->del_vqs(vdev);
 out_free_vm:
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

