From: akpm@linux-foundation.org
Subject: - alsa-usx2y-nopage.patch removed from -mm tree
Date: Thu, 13 Dec 2007 15:32:14 -0800
Message-ID: <200712132332.lBDNWEhD023944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36850 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755879AbXLMXcV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Dec 2007 18:32:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     alsa: usx2y nopage
has been removed from the -mm tree.  Its filename was
     alsa-usx2y-nopage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: alsa: usx2y nopage
From: Nick Piggin <npiggin@suse.de>

Convert alsa usx2y driver from nopage to fault.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/usb/usx2y/usX2Yhwdep.c    |   21 ++++++++-------------
 sound/usb/usx2y/usx2yhwdeppcm.c |   19 ++++++-------------
 2 files changed, 14 insertions(+), 26 deletions(-)

diff -puN sound/usb/usx2y/usX2Yhwdep.c~alsa-usx2y-nopage sound/usb/usx2y/usX2Yhwdep.c
--- a/sound/usb/usx2y/usX2Yhwdep.c~alsa-usx2y-nopage
+++ a/sound/usb/usx2y/usX2Yhwdep.c
@@ -34,34 +34,29 @@
 int usX2Y_hwdep_pcm_new(struct snd_card *card);
 
 
-static struct page * snd_us428ctls_vm_nopage(struct vm_area_struct *area, unsigned long address, int *type)
+static int snd_us428ctls_vm_fault(struct vm_area_struct *area, struct vm_fault *vmf)
 {
 	unsigned long offset;
 	struct page * page;
 	void *vaddr;
 
-	snd_printdd("ENTER, start %lXh, ofs %lXh, pgoff %ld, addr %lXh\n",
+	snd_printdd("ENTER, start %lXh, pgoff %ld\n",
 		   area->vm_start,
-		   address - area->vm_start,
-		   (address - area->vm_start) >> PAGE_SHIFT,
-		   address);
+		   vmf->pgoff);
 	
-	offset = area->vm_pgoff << PAGE_SHIFT;
-	offset += address - area->vm_start;
-	snd_assert((offset % PAGE_SIZE) == 0, return NOPAGE_SIGBUS);
+	offset = vmf->pgoff << PAGE_SHIFT;
 	vaddr = (char*)((struct usX2Ydev *)area->vm_private_data)->us428ctls_sharedmem + offset;
 	page = virt_to_page(vaddr);
 	get_page(page);
-	snd_printdd( "vaddr=%p made us428ctls_vm_nopage() return %p; offset=%lX\n", vaddr, page, offset);
+	vmf->page = page;
 
-	if (type)
-		*type = VM_FAULT_MINOR;
+	snd_printdd( "vaddr=%p made us428ctls_vm_fault() page %p\n", vaddr, page);
 
-	return page;
+	return 0;
 }
 
 static struct vm_operations_struct us428ctls_vm_ops = {
-	.nopage = snd_us428ctls_vm_nopage,
+	.fault = snd_us428ctls_vm_fault,
 };
 
 static int snd_us428ctls_mmap(struct snd_hwdep * hw, struct file *filp, struct vm_area_struct *area)
diff -puN sound/usb/usx2y/usx2yhwdeppcm.c~alsa-usx2y-nopage sound/usb/usx2y/usx2yhwdeppcm.c
--- a/sound/usb/usx2y/usx2yhwdeppcm.c~alsa-usx2y-nopage
+++ a/sound/usb/usx2y/usx2yhwdeppcm.c
@@ -683,30 +683,23 @@ static void snd_usX2Y_hwdep_pcm_vm_close
 }
 
 
-static struct page * snd_usX2Y_hwdep_pcm_vm_nopage(struct vm_area_struct *area, unsigned long address, int *type)
+static int snd_usX2Y_hwdep_pcm_vm_fault(struct vm_area_struct *area, struct vm_fault *vmf)
 {
 	unsigned long offset;
-	struct page *page;
 	void *vaddr;
 
-	offset = area->vm_pgoff << PAGE_SHIFT;
-	offset += address - area->vm_start;
-	snd_assert((offset % PAGE_SIZE) == 0, return NOPAGE_OOM);
+	offset = vmf->pgoff << PAGE_SHIFT;
 	vaddr = (char*)((struct usX2Ydev *)area->vm_private_data)->hwdep_pcm_shm + offset;
-	page = virt_to_page(vaddr);
-	get_page(page);
-
-	if (type)
-		*type = VM_FAULT_MINOR;
-
-	return page;
+	vmf->page = virt_to_page(vaddr);
+	get_page(vmf->page);
+	return 0;
 }
 
 
 static struct vm_operations_struct snd_usX2Y_hwdep_pcm_vm_ops = {
 	.open = snd_usX2Y_hwdep_pcm_vm_open,
 	.close = snd_usX2Y_hwdep_pcm_vm_close,
-	.nopage = snd_usX2Y_hwdep_pcm_vm_nopage,
+	.fault = snd_usX2Y_hwdep_pcm_vm_fault,
 };
 
 
_

Patches currently in -mm which might be from npiggin@suse.de are

git-alsa.patch
git-dvb.patch
ia64-ia32-nopage.patch
ieee1394-nopage.patch
ib-nopage.patch
git-jfs.patch
git-kvm.patch
nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
git-sched.patch
sg-nopage.patch
git-block.patch
usb-mon-nopage.patch
slub-use-non-atomic-bit-unlock.patch
radix-tree-avoid-atomic-allocations-for-preloaded-insertions.patch
mm-dont-allow-ioremapping-of-ranges-larger-than-vmalloc-space.patch
mm-special-mapping-nopage.patch
agp-alpha-nopage.patch
vt-bitlock-fix.patch
radix_treeh-trivial-comment-correction.patch
inotify-fix-race.patch
inotify-remove-debug-code.patch
relay-nopage.patch
uio-nopage.patch
ext2-xip-check-fix.patch
fb-defio-nopage.patch
rewrite-rd.patch
rewrite-rd-fix.patch
rd-support-xip.patch
reiser4.patch
