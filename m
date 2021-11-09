Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0989FC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E350D60E97
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235342AbhKICep (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:34:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:49886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229999AbhKICeo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:34:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34E42611CC;
        Tue,  9 Nov 2021 02:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425119;
        bh=GRssYLRAX2Yfo2vvVJ1KMqnPhCEIASTQrKk2Fccwhos=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=G/8423lHgactQIjeufpiaSjD8muybmoMeDL71nxOvMowdO1bfvXF9/JkRqYJQ+PCg
         D5brmP4yKl9r4MSUEc0JR/Pt44yD2Gn+Jjn+2a0S21UstWYRYzEffMELjXxXJwTGuk
         4nu4D5NEVd5U19v+qwDK/QGt4EmkS3qTZc8+OIwU=
Date:   Mon, 08 Nov 2021 18:31:58 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com,
        boris.ostrovsky@oracle.com, bp@alien8.de, david@redhat.com,
        dyoung@redhat.com, hpa@zytor.com, jasowang@redhat.com,
        jgross@suse.com, linux-mm@kvack.org, mhocko@suse.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, mst@redhat.com,
        osalvador@suse.de, rafael.j.wysocki@intel.com, rppt@kernel.org,
        sstabellini@kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vgoyal@redhat.com
Subject:  [patch 11/87] virtio-mem: factor out hotplug specifics
 from virtio_mem_remove() into virtio_mem_deinit_hotplug()
Message-ID: <20211109023158.kXdsza3SM%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
