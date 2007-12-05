From: akpm@linux-foundation.org
Subject: + relay-nopage.patch added to -mm tree
Date: Wed, 05 Dec 2007 14:44:46 -0800
Message-ID: <200712052244.lB5Miktv028871@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57960 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752577AbXLEWpA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Dec 2007 17:45:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, zanussi@us.ibm.com


The patch titled
     relay: nopage
has been added to the -mm tree.  Its filename is
     relay-nopage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: relay: nopage
From: Nick Piggin <npiggin@suse.de>

Convert relay from nopage to fault.
Remove redundant vma range checks.
Switch from OOM to SIGBUS if the resource is not available.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Tom Zanussi <zanussi@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff -puN kernel/relay.c~relay-nopage kernel/relay.c
--- a/kernel/relay.c~relay-nopage
+++ a/kernel/relay.c
@@ -37,37 +37,31 @@ static void relay_file_mmap_close(struct
 }
 
 /*
- * nopage() vm_op implementation for relay file mapping.
+ * fault() vm_op implementation for relay file mapping.
  */
-static struct page *relay_buf_nopage(struct vm_area_struct *vma,
-				     unsigned long address,
-				     int *type)
+static int relay_buf_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct page *page;
 	struct rchan_buf *buf = vma->vm_private_data;
-	unsigned long offset = address - vma->vm_start;
+	pgoff_t pgoff = vmf->pgoff;
 
-	if (address > vma->vm_end)
-		return NOPAGE_SIGBUS; /* Disallow mremap */
 	if (!buf)
-		return NOPAGE_OOM;
+		return VM_FAULT_OOM;
 
-	page = vmalloc_to_page(buf->start + offset);
+	page = vmalloc_to_page(buf->start + (pgoff << PAGE_SHIFT));
 	if (!page)
-		return NOPAGE_OOM;
+		return VM_FAULT_SIGBUS;
 	get_page(page);
+	vmf->page = page;
 
-	if (type)
-		*type = VM_FAULT_MINOR;
-
-	return page;
+	return 0;
 }
 
 /*
  * vm_ops for relay file mappings.
  */
 static struct vm_operations_struct relay_file_mmap_ops = {
-	.nopage = relay_buf_nopage,
+	.fault = relay_buf_fault,
 	.close = relay_file_mmap_close,
 };
 
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-fix-xip-file-writes.patch
git-jfs.patch
nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
slub-use-non-atomic-bit-unlock.patch
radix-tree-avoid-atomic-allocations-for-preloaded-insertions.patch
mm-dont-allow-ioremapping-of-ranges-larger-than-vmalloc-space.patch
vt-bitlock-fix.patch
radix_treeh-trivial-comment-correction.patch
inotify-fix-race.patch
inotify-remove-debug-code.patch
rewrite-rd.patch
rewrite-rd-fix.patch
rd-support-xip.patch
reiser4.patch
ia64-ia32-nopage.patch
relay-nopage.patch
uio-nopage.patch
ieee1394-nopage.patch
v4l-nopage.patch
fb-defio-nopage.patch
agp-alpha-nopage.patch
sg-nopage.patch
ib-nopage.patch
usb-mon-nopage.patch
alsa-nopage.patch
alsa-usx2y-nopage.patch
mm-special-mapping-nopage.patch
