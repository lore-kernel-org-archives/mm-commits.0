Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41A28C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:51:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25F366187A
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:51:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234525AbhKKCyB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:54:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:57824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234519AbhKKCx7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:53:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E3F06135E;
        Thu, 11 Nov 2021 02:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599071;
        bh=6XYKO+gfnFWN9N+ObgLnO7psLMCviw91gSIoUWDUdGc=;
        h=Date:From:To:Subject:From;
        b=1HbtlozSqdoz9Idd+YZSuv7inFH8NxXdlU0ggc4ScCmO38v3F5wVlEnmx+J8ocEiK
         z/e6bAZmyN0+5h43RgFx90Hp0ZDvJbHH9ZXJ8anerSRQXJ21Ok2XZvj5rOpBfc3a2M
         pTpvnmOiZAGeM5LEg/+13EoduciKINhGM0ZbLhsg=
Date:   Wed, 10 Nov 2021 18:51:10 -0800
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, boris.ostrovsky@oracle.com, bp@alien8.de,
        david@redhat.com, dyoung@redhat.com, hpa@zytor.com,
        jasowang@redhat.com, jgross@suse.com, mhocko@suse.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, mst@redhat.com,
        osalvador@suse.de, rafael.j.wysocki@intel.com, rppt@kernel.org,
        sstabellini@kernel.org, tglx@linutronix.de, vgoyal@redhat.com
Subject:  [merged]
 =?US-ASCII?Q?virtio-mem-factor-out-hotplug-specifics-from-virtio=5Fmem?=
 =?US-ASCII?Q?=5Fremove-into-virtio=5Fmem=5Fdeinit=5Fhotplug.patch?=
 removed from -mm tree
Message-ID: <20211111025110.BF4JEO1A7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: virtio-mem: factor out hotplug specifics from virtio_mem_remove() into virtio_mem_deinit_hotplug()
has been removed from the -mm tree.  Its filename was
     virtio-mem-factor-out-hotplug-specifics-from-virtio_mem_remove-into-virtio_mem_deinit_hotplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


