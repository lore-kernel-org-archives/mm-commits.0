Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B97D6C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:51:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A09516135E
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:51:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234526AbhKKCyD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:54:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:57862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234519AbhKKCyC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:54:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E9B060F26;
        Thu, 11 Nov 2021 02:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599074;
        bh=gj3KKxPfG9Qx4Gup4oBbLNKfk2YmJOG3WTGzUPa5Yg8=;
        h=Date:From:To:Subject:From;
        b=WiyRJaelIKaM7LtWpQut45K13BcxHCRrfgrqZYH99mFUYCHwKWE/0z41p5N5PzR9r
         FoS+at49Rk5Iv+FAXc1+6OQiNKN3oYM/mSN6BMlDlYV/1gi88h6Ngy5ZlYK5n5hjc/
         yUCJNc5FO45aLBP94KqtprxBhqyjh/57s/knFEVs=
Date:   Wed, 10 Nov 2021 18:51:13 -0800
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, boris.ostrovsky@oracle.com, bp@alien8.de,
        david@redhat.com, dyoung@redhat.com, hpa@zytor.com,
        jasowang@redhat.com, jgross@suse.com, mhocko@suse.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, mst@redhat.com,
        osalvador@suse.de, rafael.j.wysocki@intel.com, rppt@kernel.org,
        sstabellini@kernel.org, tglx@linutronix.de, vgoyal@redhat.com
Subject:  [merged]
 virtio-mem-kdump-mode-to-sanitize-proc-vmcore-access.patch removed from -mm
 tree
Message-ID: <20211111025113.WCaTwivtK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: virtio-mem: kdump mode to sanitize /proc/vmcore access
has been removed from the -mm tree.  Its filename was
     virtio-mem-kdump-mode-to-sanitize-proc-vmcore-access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: virtio-mem: kdump mode to sanitize /proc/vmcore access

Although virtio-mem currently supports reading unplugged memory in the
hypervisor, this will change in the future, indicated to the device via a
new feature flag.  We similarly sanitized /proc/kcore access recently. 
[1]

Let's register a vmcore callback, to allow vmcore code to check if a PFN
belonging to a virtio-mem device is either currently plugged and should be
dumped or is currently unplugged and should not be accessed, instead
mapping the shared zeropage or returning zeroes when reading.

This is important when not capturing /proc/vmcore via tools like
"makedumpfile" that can identify logically unplugged virtio-mem memory via
PG_offline in the memmap, but simply by e.g., copying the file.

Distributions that support virtio-mem+kdump have to make sure that the
virtio_mem module will be part of the kdump kernel or the kdump initrd;
dracut was recently [2] extended to include virtio-mem in the generated
initrd.  As long as no special kdump kernels are used, this will
automatically make sure that virtio-mem will be around in the kdump initrd
and sanitize /proc/vmcore access -- with dracut.

With this series, we'll send one virtio-mem state request for every ~2 MiB
chunk of virtio-mem memory indicated in the vmcore that we intend to
read/map.

In the future, we might want to allow building virtio-mem for kdump mode
only, even without CONFIG_MEMORY_HOTPLUG and friends: this way, we could
support special stripped-down kdump kernels that have many other config
options disabled; we'll tackle that once required.  Further, we might want
to try sensing bigger blocks (e.g., memory sections) first before falling
back to device blocks on demand.

Tested with Fedora rawhide, which contains a recent kexec-tools version
(considering "System RAM (virtio_mem)" when creating the vmcore header)
and a recent dracut version (including the virtio_mem module in the kdump
initrd).

[1] https://lkml.kernel.org/r/20210526093041.8800-1-david@redhat.com
[2] https://github.com/dracutdevs/dracut/pull/1157

Link: https://lkml.kernel.org/r/20211005121430.30136-10-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
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

 drivers/virtio/virtio_mem.c |  136 +++++++++++++++++++++++++++++++---
 1 file changed, 124 insertions(+), 12 deletions(-)

--- a/drivers/virtio/virtio_mem.c~virtio-mem-kdump-mode-to-sanitize-proc-vmcore-access
+++ a/drivers/virtio/virtio_mem.c
@@ -223,6 +223,9 @@ struct virtio_mem {
 	 * When this lock is held the pointers can't change, ONLINE and
 	 * OFFLINE blocks can't change the state and no subblocks will get
 	 * plugged/unplugged.
+	 *
+	 * In kdump mode, used to serialize requests, last_block_addr and
+	 * last_block_plugged.
 	 */
 	struct mutex hotplug_mutex;
 	bool hotplug_active;
@@ -230,6 +233,9 @@ struct virtio_mem {
 	/* An error occurred we cannot handle - stop processing requests. */
 	bool broken;
 
+	/* Cached valued of is_kdump_kernel() when the device was probed. */
+	bool in_kdump;
+
 	/* The driver is being removed. */
 	spinlock_t removal_lock;
 	bool removing;
@@ -243,6 +249,13 @@ struct virtio_mem {
 	/* Memory notifier (online/offline events). */
 	struct notifier_block memory_notifier;
 
+#ifdef CONFIG_PROC_VMCORE
+	/* vmcore callback for /proc/vmcore handling in kdump mode */
+	struct vmcore_cb vmcore_cb;
+	uint64_t last_block_addr;
+	bool last_block_plugged;
+#endif /* CONFIG_PROC_VMCORE */
+
 	/* Next device in the list of virtio-mem devices. */
 	struct list_head next;
 };
@@ -2293,6 +2306,12 @@ static void virtio_mem_run_wq(struct wor
 	uint64_t diff;
 	int rc;
 
+	if (unlikely(vm->in_kdump)) {
+		dev_warn_once(&vm->vdev->dev,
+			     "unexpected workqueue run in kdump kernel\n");
+		return;
+	}
+
 	hrtimer_cancel(&vm->retry_timer);
 
 	if (vm->broken)
@@ -2521,6 +2540,86 @@ out_del_resource:
 	return rc;
 }
 
+#ifdef CONFIG_PROC_VMCORE
+static int virtio_mem_send_state_request(struct virtio_mem *vm, uint64_t addr,
+					 uint64_t size)
+{
+	const uint64_t nb_vm_blocks = size / vm->device_block_size;
+	const struct virtio_mem_req req = {
+		.type = cpu_to_virtio16(vm->vdev, VIRTIO_MEM_REQ_STATE),
+		.u.state.addr = cpu_to_virtio64(vm->vdev, addr),
+		.u.state.nb_blocks = cpu_to_virtio16(vm->vdev, nb_vm_blocks),
+	};
+	int rc = -ENOMEM;
+
+	dev_dbg(&vm->vdev->dev, "requesting state: 0x%llx - 0x%llx\n", addr,
+		addr + size - 1);
+
+	switch (virtio_mem_send_request(vm, &req)) {
+	case VIRTIO_MEM_RESP_ACK:
+		return virtio16_to_cpu(vm->vdev, vm->resp.u.state.state);
+	case VIRTIO_MEM_RESP_ERROR:
+		rc = -EINVAL;
+		break;
+	default:
+		break;
+	}
+
+	dev_dbg(&vm->vdev->dev, "requesting state failed: %d\n", rc);
+	return rc;
+}
+
+static bool virtio_mem_vmcore_pfn_is_ram(struct vmcore_cb *cb,
+					 unsigned long pfn)
+{
+	struct virtio_mem *vm = container_of(cb, struct virtio_mem,
+					     vmcore_cb);
+	uint64_t addr = PFN_PHYS(pfn);
+	bool is_ram;
+	int rc;
+
+	if (!virtio_mem_contains_range(vm, addr, PAGE_SIZE))
+		return true;
+	if (!vm->plugged_size)
+		return false;
+
+	/*
+	 * We have to serialize device requests and access to the information
+	 * about the block queried last.
+	 */
+	mutex_lock(&vm->hotplug_mutex);
+
+	addr = ALIGN_DOWN(addr, vm->device_block_size);
+	if (addr != vm->last_block_addr) {
+		rc = virtio_mem_send_state_request(vm, addr,
+						   vm->device_block_size);
+		/* On any kind of error, we're going to signal !ram. */
+		if (rc == VIRTIO_MEM_STATE_PLUGGED)
+			vm->last_block_plugged = true;
+		else
+			vm->last_block_plugged = false;
+		vm->last_block_addr = addr;
+	}
+
+	is_ram = vm->last_block_plugged;
+	mutex_unlock(&vm->hotplug_mutex);
+	return is_ram;
+}
+#endif /* CONFIG_PROC_VMCORE */
+
+static int virtio_mem_init_kdump(struct virtio_mem *vm)
+{
+#ifdef CONFIG_PROC_VMCORE
+	dev_info(&vm->vdev->dev, "memory hot(un)plug disabled in kdump kernel\n");
+	vm->vmcore_cb.pfn_is_ram = virtio_mem_vmcore_pfn_is_ram;
+	register_vmcore_cb(&vm->vmcore_cb);
+	return 0;
+#else /* CONFIG_PROC_VMCORE */
+	dev_warn(&vm->vdev->dev, "disabled in kdump kernel without vmcore\n");
+	return -EBUSY;
+#endif /* CONFIG_PROC_VMCORE */
+}
+
 static int virtio_mem_init(struct virtio_mem *vm)
 {
 	uint16_t node_id;
@@ -2530,15 +2629,6 @@ static int virtio_mem_init(struct virtio
 		return -EINVAL;
 	}
 
-	/*
-	 * We don't want to (un)plug or reuse any memory when in kdump. The
-	 * memory is still accessible (but not mapped).
-	 */
-	if (is_kdump_kernel()) {
-		dev_warn(&vm->vdev->dev, "disabled in kdump kernel\n");
-		return -EBUSY;
-	}
-
 	/* Fetch all properties that can't change. */
 	virtio_cread_le(vm->vdev, struct virtio_mem_config, plugged_size,
 			&vm->plugged_size);
@@ -2562,6 +2652,12 @@ static int virtio_mem_init(struct virtio
 	if (vm->nid != NUMA_NO_NODE && IS_ENABLED(CONFIG_NUMA))
 		dev_info(&vm->vdev->dev, "nid: %d", vm->nid);
 
+	/*
+	 * We don't want to (un)plug or reuse any memory when in kdump. The
+	 * memory is still accessible (but not exposed to Linux).
+	 */
+	if (vm->in_kdump)
+		return virtio_mem_init_kdump(vm);
 	return virtio_mem_init_hotplug(vm);
 }
 
@@ -2640,6 +2736,7 @@ static int virtio_mem_probe(struct virti
 	hrtimer_init(&vm->retry_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	vm->retry_timer.function = virtio_mem_timer_expired;
 	vm->retry_timer_ms = VIRTIO_MEM_RETRY_TIMER_MIN_MS;
+	vm->in_kdump = is_kdump_kernel();
 
 	/* register the virtqueue */
 	rc = virtio_mem_init_vq(vm);
@@ -2654,8 +2751,10 @@ static int virtio_mem_probe(struct virti
 	virtio_device_ready(vdev);
 
 	/* trigger a config update to start processing the requested_size */
-	atomic_set(&vm->config_changed, 1);
-	queue_work(system_freezable_wq, &vm->wq);
+	if (!vm->in_kdump) {
+		atomic_set(&vm->config_changed, 1);
+		queue_work(system_freezable_wq, &vm->wq);
+	}
 
 	return 0;
 out_del_vq:
@@ -2732,11 +2831,21 @@ static void virtio_mem_deinit_hotplug(st
 	}
 }
 
+static void virtio_mem_deinit_kdump(struct virtio_mem *vm)
+{
+#ifdef CONFIG_PROC_VMCORE
+	unregister_vmcore_cb(&vm->vmcore_cb);
+#endif /* CONFIG_PROC_VMCORE */
+}
+
 static void virtio_mem_remove(struct virtio_device *vdev)
 {
 	struct virtio_mem *vm = vdev->priv;
 
-	virtio_mem_deinit_hotplug(vm);
+	if (vm->in_kdump)
+		virtio_mem_deinit_kdump(vm);
+	else
+		virtio_mem_deinit_hotplug(vm);
 
 	/* reset the device and cleanup the queues */
 	vdev->config->reset(vdev);
@@ -2750,6 +2859,9 @@ static void virtio_mem_config_changed(st
 {
 	struct virtio_mem *vm = vdev->priv;
 
+	if (unlikely(vm->in_kdump))
+		return;
+
 	atomic_set(&vm->config_changed, 1);
 	virtio_mem_retry(vm);
 }
_

Patches currently in -mm which might be from david@redhat.com are


