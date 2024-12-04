Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA21014F9F7
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 22:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733350397; cv=none; b=HCSrCbVToHKQAbBEUQD/uvXAQWrEGGwkrqNXZVkZiD+alptZAEU94nw9ur5Y5tINMsa3PNNFOJ+QZsvQOfwBEw4UoJGZknS9bjgN/JjmSsmR57KPverDhsSidUmjXY/MuvRf8pIxHiXxeE05F8hbOvqn/6fspk/BN/0wvTpzg3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733350397; c=relaxed/simple;
	bh=H0cbWEH+zyqndyH/+uZLzBXqbkmDUyCcB+MXowtVbNE=;
	h=Date:To:From:Subject:Message-Id; b=G5cYuWAOWX0q0El0MTvKQi1ILTA4Val70XRZej4CfxI+L6yXKPXDIEXEUB3/do31VvnykeOnHcI1tq81vq26oeNPEYsq772DACGgPJct8ag+kRwinBfav96IzBCs5Nsr8XScXLiaowZrKi2PyvbL69VGTUAzyygbSa1pfiaY/54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KXCWr0ks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KXCWr0ks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E133C4CECD;
	Wed,  4 Dec 2024 22:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733350397;
	bh=H0cbWEH+zyqndyH/+uZLzBXqbkmDUyCcB+MXowtVbNE=;
	h=Date:To:From:Subject:From;
	b=KXCWr0ksUm8vo/jFPiZx6zrC/yQEmXJV+L7ZsMPRhEiOoJ3fEP/gdOvTG24iVsAB0
	 deq29+fVNLivxzPwMo0plyaTw1IwKoUI+32NwvYrknFwZNFpIY89FhCe82PY6UCCXs
	 on/SSx9u8UEik/L0JHjd+lVBWwMMvwfBzPvXbf4I=
Date: Wed, 04 Dec 2024 14:13:16 -0800
To: mm-commits@vger.kernel.org,xuanzhuo@linux.alibaba.com,vgoyal@redhat.com,thuth@redhat.com,svens@linux.ibm.com,mst@redhat.com,jasowang@redhat.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,frankja@linux.ibm.com,farman@linux.ibm.com,eperezma@redhat.com,dyoung@redhat.com,cohuck@redhat.com,borntraeger@linux.ibm.com,bhe@redhat.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + virtio-mem-mark-device-ready-before-registering-callbacks-in-kdump-mode.patch added to mm-unstable branch
Message-Id: <20241204221317.4E133C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: virtio-mem: mark device ready before registering callbacks in kdump mode
has been added to the -mm mm-unstable branch.  Its filename is
     virtio-mem-mark-device-ready-before-registering-callbacks-in-kdump-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/virtio-mem-mark-device-ready-before-registering-callbacks-in-kdump-mode.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: virtio-mem: mark device ready before registering callbacks in kdump mode
Date: Wed, 4 Dec 2024 13:54:40 +0100

After the callbacks are registered we may immediately get a callback.  So
mark the device ready before registering the callbacks.

Link: https://lkml.kernel.org/r/20241204125444.1734652-10-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Eric Farman <farman@linux.ibm.com>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_mem.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/virtio/virtio_mem.c~virtio-mem-mark-device-ready-before-registering-callbacks-in-kdump-mode
+++ a/drivers/virtio/virtio_mem.c
@@ -2648,6 +2648,7 @@ static int virtio_mem_init_hotplug(struc
 	if (rc)
 		goto out_unreg_pm;
 
+	virtio_device_ready(vm->vdev);
 	return 0;
 out_unreg_pm:
 	unregister_pm_notifier(&vm->pm_notifier);
@@ -2729,6 +2730,8 @@ static bool virtio_mem_vmcore_pfn_is_ram
 
 static int virtio_mem_init_kdump(struct virtio_mem *vm)
 {
+	/* We must be prepared to receive a callback immediately. */
+	virtio_device_ready(vm->vdev);
 #ifdef CONFIG_PROC_VMCORE
 	dev_info(&vm->vdev->dev, "memory hot(un)plug disabled in kdump kernel\n");
 	vm->vmcore_cb.pfn_is_ram = virtio_mem_vmcore_pfn_is_ram;
@@ -2870,8 +2873,6 @@ static int virtio_mem_probe(struct virti
 	if (rc)
 		goto out_del_vq;
 
-	virtio_device_ready(vdev);
-
 	/* trigger a config update to start processing the requested_size */
 	if (!vm->in_kdump) {
 		atomic_set(&vm->config_changed, 1);
_

Patches currently in -mm which might be from david@redhat.com are

mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm.patch
mm-filemap-dont-call-folio_test_locked-without-a-reference-in-next_uptodate_folio.patch
docs-tmpfs-update-the-large-folios-policy-for-tmpfs-and-shmem.patch
mm-memory_hotplug-move-debug_pagealloc_map_pages-into-online_pages_range.patch
mm-page_isolation-dont-pass-gfp-flags-to-isolate_single_pageblock.patch
mm-page_isolation-dont-pass-gfp-flags-to-start_isolate_page_range.patch
mm-page_alloc-make-__alloc_contig_migrate_range-static.patch
mm-page_alloc-sort-out-the-alloc_contig_range-gfp-flags-mess.patch
mm-page_alloc-forward-the-gfp-flags-from-alloc_contig_range-to-post_alloc_hook.patch
powernv-memtrace-use-__gfp_zero-with-alloc_contig_pages.patch
mm-hugetlb-dont-map-folios-writable-without-vm_write-when-copying-during-fork.patch
fs-proc-vmcore-convert-vmcore_cb_lock-into-vmcore_mutex.patch
fs-proc-vmcore-replace-vmcoredd_mutex-by-vmcore_mutex.patch
fs-proc-vmcore-disallow-vmcore-modifications-while-the-vmcore-is-open.patch
fs-proc-vmcore-prefix-all-pr_-with-vmcore.patch
fs-proc-vmcore-move-vmcore-definitions-out-of-kcoreh.patch
fs-proc-vmcore-factor-out-allocating-a-vmcore-range-and-adding-it-to-a-list.patch
fs-proc-vmcore-factor-out-freeing-a-list-of-vmcore-ranges.patch
fs-proc-vmcore-introduce-proc_vmcore_device_ram-to-detect-device-ram-ranges-in-2nd-kernel.patch
virtio-mem-mark-device-ready-before-registering-callbacks-in-kdump-mode.patch
virtio-mem-remember-usable-region-size.patch
virtio-mem-support-config_proc_vmcore_device_ram.patch
s390-kdump-virtio-mem-kdump-support-config_proc_vmcore_device_ram.patch

