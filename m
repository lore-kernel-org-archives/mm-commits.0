From: akpm@osdl.org
Subject: - mm-incorrect-vm_fault_oom-returns-from-drivers.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:56:21 -0800
Message-ID: <200612072256.kB7MuLXg029193@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50417 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163595AbWLGW4f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:56:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, airlied@linux.ie, greg@kroah.com, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: incorrect VM_FAULT_OOM returns from drivers
has been removed from the -mm tree.  Its filename was
     mm-incorrect-vm_fault_oom-returns-from-drivers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: incorrect VM_FAULT_OOM returns from drivers
From: Nick Piggin <npiggin@suse.de>

Some drivers are returning OOM when it is not in response to a memory
shortage.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/drm/drm_vm.c    |    8 ++++----
 sound/core/pcm_native.c      |   10 +++++-----
 sound/oss/via82cxxx_audio.c  |    4 ++--
 sound/usb/usx2y/usX2Yhwdep.c |    2 +-
 4 files changed, 12 insertions(+), 12 deletions(-)

diff -puN drivers/char/drm/drm_vm.c~mm-incorrect-vm_fault_oom-returns-from-drivers drivers/char/drm/drm_vm.c
--- a/drivers/char/drm/drm_vm.c~mm-incorrect-vm_fault_oom-returns-from-drivers
+++ a/drivers/char/drm/drm_vm.c
@@ -147,14 +147,14 @@ static __inline__ struct page *drm_do_vm
 	if (address > vma->vm_end)
 		return NOPAGE_SIGBUS;	/* Disallow mremap */
 	if (!map)
-		return NOPAGE_OOM;	/* Nothing allocated */
+		return NOPAGE_SIGBUS;	/* Nothing allocated */
 
 	offset = address - vma->vm_start;
 	i = (unsigned long)map->handle + offset;
 	page = (map->type == _DRM_CONSISTENT) ?
 		virt_to_page((void *)i) : vmalloc_to_page((void *)i);
 	if (!page)
-		return NOPAGE_OOM;
+		return NOPAGE_SIGBUS;
 	get_page(page);
 
 	DRM_DEBUG("shm_nopage 0x%lx\n", address);
@@ -272,7 +272,7 @@ static __inline__ struct page *drm_do_vm
 	if (address > vma->vm_end)
 		return NOPAGE_SIGBUS;	/* Disallow mremap */
 	if (!dma->pagelist)
-		return NOPAGE_OOM;	/* Nothing allocated */
+		return NOPAGE_SIGBUS;	/* Nothing allocated */
 
 	offset = address - vma->vm_start;	/* vm_[pg]off[set] should be 0 */
 	page_nr = offset >> PAGE_SHIFT;
@@ -310,7 +310,7 @@ static __inline__ struct page *drm_do_vm
 	if (address > vma->vm_end)
 		return NOPAGE_SIGBUS;	/* Disallow mremap */
 	if (!entry->pagelist)
-		return NOPAGE_OOM;	/* Nothing allocated */
+		return NOPAGE_SIGBUS;	/* Nothing allocated */
 
 	offset = address - vma->vm_start;
 	map_offset = map->offset - (unsigned long)dev->sg->virtual;
diff -puN sound/core/pcm_native.c~mm-incorrect-vm_fault_oom-returns-from-drivers sound/core/pcm_native.c
--- a/sound/core/pcm_native.c~mm-incorrect-vm_fault_oom-returns-from-drivers
+++ a/sound/core/pcm_native.c
@@ -3027,7 +3027,7 @@ static struct page * snd_pcm_mmap_status
 	struct page * page;
 	
 	if (substream == NULL)
-		return NOPAGE_OOM;
+		return NOPAGE_SIGBUS;
 	runtime = substream->runtime;
 	page = virt_to_page(runtime->status);
 	get_page(page);
@@ -3070,7 +3070,7 @@ static struct page * snd_pcm_mmap_contro
 	struct page * page;
 	
 	if (substream == NULL)
-		return NOPAGE_OOM;
+		return NOPAGE_SIGBUS;
 	runtime = substream->runtime;
 	page = virt_to_page(runtime->control);
 	get_page(page);
@@ -3131,18 +3131,18 @@ static struct page *snd_pcm_mmap_data_no
 	size_t dma_bytes;
 	
 	if (substream == NULL)
-		return NOPAGE_OOM;
+		return NOPAGE_SIGBUS;
 	runtime = substream->runtime;
 	offset = area->vm_pgoff << PAGE_SHIFT;
 	offset += address - area->vm_start;
-	snd_assert((offset % PAGE_SIZE) == 0, return NOPAGE_OOM);
+	snd_assert((offset % PAGE_SIZE) == 0, return NOPAGE_SIGBUS);
 	dma_bytes = PAGE_ALIGN(runtime->dma_bytes);
 	if (offset > dma_bytes - PAGE_SIZE)
 		return NOPAGE_SIGBUS;
 	if (substream->ops->page) {
 		page = substream->ops->page(substream, offset);
 		if (! page)
-			return NOPAGE_OOM;
+			return NOPAGE_OOM; /* XXX: is this really due to OOM? */
 	} else {
 		vaddr = runtime->dma_area + offset;
 		page = virt_to_page(vaddr);
diff -puN sound/oss/via82cxxx_audio.c~mm-incorrect-vm_fault_oom-returns-from-drivers sound/oss/via82cxxx_audio.c
--- a/sound/oss/via82cxxx_audio.c~mm-incorrect-vm_fault_oom-returns-from-drivers
+++ a/sound/oss/via82cxxx_audio.c
@@ -2120,8 +2120,8 @@ static struct page * via_mm_nopage (stru
 		return NOPAGE_SIGBUS; /* Disallow mremap */
 	}
         if (!card) {
-		DPRINTK ("EXIT, returning NOPAGE_OOM\n");
-		return NOPAGE_OOM;	/* Nothing allocated */
+		DPRINTK ("EXIT, returning NOPAGE_SIGBUS\n");
+		return NOPAGE_SIGBUS;	/* Nothing allocated */
 	}
 
 	pgoff = vma->vm_pgoff + ((address - vma->vm_start) >> PAGE_SHIFT);
diff -puN sound/usb/usx2y/usX2Yhwdep.c~mm-incorrect-vm_fault_oom-returns-from-drivers sound/usb/usx2y/usX2Yhwdep.c
--- a/sound/usb/usx2y/usX2Yhwdep.c~mm-incorrect-vm_fault_oom-returns-from-drivers
+++ a/sound/usb/usx2y/usX2Yhwdep.c
@@ -48,7 +48,7 @@ static struct page * snd_us428ctls_vm_no
 	
 	offset = area->vm_pgoff << PAGE_SHIFT;
 	offset += address - area->vm_start;
-	snd_assert((offset % PAGE_SIZE) == 0, return NOPAGE_OOM);
+	snd_assert((offset % PAGE_SIZE) == 0, return NOPAGE_SIGBUS);
 	vaddr = (char*)((struct usX2Ydev *)area->vm_private_data)->us428ctls_sharedmem + offset;
 	page = virt_to_page(vaddr);
 	get_page(page);
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-only-mm-debug-write-deadlocks.patch
mm-fix-pagecache-write-deadlocks.patch
mm-fix-pagecache-write-deadlocks-comment.patch
mm-fix-pagecache-write-deadlocks-mm-pagecache-write-deadlocks-efault-fix.patch
mm-fix-pagecache-write-deadlocks-zerolength-fix.patch
mm-fix-pagecache-write-deadlocks-stale-holes-fix.patch
fs-prepare_write-fixes.patch
fs-prepare_write-fixes-fuse-fix.patch
fs-prepare_write-fixes-jffs-fix.patch
fs-prepare_write-fixes-fat-fix.patch
fs-fix-cont-vs-deadlock-patches.patch

