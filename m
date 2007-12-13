From: akpm@linux-foundation.org
Subject: - alsa-nopage.patch removed from -mm tree
Date: Thu, 13 Dec 2007 15:32:12 -0800
Message-ID: <200712132332.lBDNWCgZ023941@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50871 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754629AbXLMXcT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Dec 2007 18:32:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     alsa: nopage
has been removed from the -mm tree.  Its filename was
     alsa-nopage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: alsa: nopage
From: Nick Piggin <npiggin@suse.de>

Convert ALSA from nopage to fault.
Switch from OOM to SIGBUS if the resource is not available.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/core/pcm_native.c |   59 ++++++++++++++++----------------------
 1 file changed, 25 insertions(+), 34 deletions(-)

diff -puN sound/core/pcm_native.c~alsa-nopage sound/core/pcm_native.c
--- a/sound/core/pcm_native.c~alsa-nopage
+++ a/sound/core/pcm_native.c
@@ -3021,26 +3021,23 @@ static unsigned int snd_pcm_capture_poll
 /*
  * mmap status record
  */
-static struct page * snd_pcm_mmap_status_nopage(struct vm_area_struct *area,
-						unsigned long address, int *type)
+static int snd_pcm_mmap_status_fault(struct vm_area_struct *area,
+						struct vm_fault *vmf)
 {
 	struct snd_pcm_substream *substream = area->vm_private_data;
 	struct snd_pcm_runtime *runtime;
-	struct page * page;
 	
 	if (substream == NULL)
-		return NOPAGE_SIGBUS;
+		return VM_FAULT_SIGBUS;
 	runtime = substream->runtime;
-	page = virt_to_page(runtime->status);
-	get_page(page);
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return page;
+	vmf->page = virt_to_page(runtime->status);
+	get_page(vmf->page);
+	return 0;
 }
 
 static struct vm_operations_struct snd_pcm_vm_ops_status =
 {
-	.nopage =	snd_pcm_mmap_status_nopage,
+	.fault =	snd_pcm_mmap_status_fault,
 };
 
 static int snd_pcm_mmap_status(struct snd_pcm_substream *substream, struct file *file,
@@ -3064,26 +3061,23 @@ static int snd_pcm_mmap_status(struct sn
 /*
  * mmap control record
  */
-static struct page * snd_pcm_mmap_control_nopage(struct vm_area_struct *area,
-						 unsigned long address, int *type)
+static int snd_pcm_mmap_control_fault(struct vm_area_struct *area,
+						struct vm_fault *vmf)
 {
 	struct snd_pcm_substream *substream = area->vm_private_data;
 	struct snd_pcm_runtime *runtime;
-	struct page * page;
 	
 	if (substream == NULL)
-		return NOPAGE_SIGBUS;
+		return VM_FAULT_SIGBUS;
 	runtime = substream->runtime;
-	page = virt_to_page(runtime->control);
-	get_page(page);
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return page;
+	vmf->page = virt_to_page(runtime->control);
+	get_page(vmf->page);
+	return 0;
 }
 
 static struct vm_operations_struct snd_pcm_vm_ops_control =
 {
-	.nopage =	snd_pcm_mmap_control_nopage,
+	.fault =	snd_pcm_mmap_control_fault,
 };
 
 static int snd_pcm_mmap_control(struct snd_pcm_substream *substream, struct file *file,
@@ -3120,10 +3114,10 @@ static int snd_pcm_mmap_control(struct s
 #endif /* coherent mmap */
 
 /*
- * nopage callback for mmapping a RAM page
+ * fault callback for mmapping a RAM page
  */
-static struct page *snd_pcm_mmap_data_nopage(struct vm_area_struct *area,
-					     unsigned long address, int *type)
+static int snd_pcm_mmap_data_fault(struct vm_area_struct *area,
+						struct vm_fault *vmf)
 {
 	struct snd_pcm_substream *substream = area->vm_private_data;
 	struct snd_pcm_runtime *runtime;
@@ -3133,33 +3127,30 @@ static struct page *snd_pcm_mmap_data_no
 	size_t dma_bytes;
 	
 	if (substream == NULL)
-		return NOPAGE_SIGBUS;
+		return VM_FAULT_SIGBUS;
 	runtime = substream->runtime;
-	offset = area->vm_pgoff << PAGE_SHIFT;
-	offset += address - area->vm_start;
-	snd_assert((offset % PAGE_SIZE) == 0, return NOPAGE_SIGBUS);
+	offset = vmf->pgoff << PAGE_SHIFT;
 	dma_bytes = PAGE_ALIGN(runtime->dma_bytes);
 	if (offset > dma_bytes - PAGE_SIZE)
-		return NOPAGE_SIGBUS;
+		return VM_FAULT_SIGBUS;
 	if (substream->ops->page) {
 		page = substream->ops->page(substream, offset);
-		if (! page)
-			return NOPAGE_OOM; /* XXX: is this really due to OOM? */
+		if (!page)
+			return VM_FAULT_SIGBUS;
 	} else {
 		vaddr = runtime->dma_area + offset;
 		page = virt_to_page(vaddr);
 	}
 	get_page(page);
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return page;
+	vmf->page = page;
+	return 0;
 }
 
 static struct vm_operations_struct snd_pcm_vm_ops_data =
 {
 	.open =		snd_pcm_mmap_data_open,
 	.close =	snd_pcm_mmap_data_close,
-	.nopage =	snd_pcm_mmap_data_nopage,
+	.fault =	snd_pcm_mmap_data_fault,
 };
 
 /*
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
