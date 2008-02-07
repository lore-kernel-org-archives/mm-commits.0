From: akpm@linux-foundation.org
Subject: - relay-nopage.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:24:10 -0800
Message-ID: <200802070023.m170Npx4006562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56087 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762522AbYBGAop (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, zanussi@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     relay: nopage
has been removed from the -mm tree.  Its filename was
     relay-nopage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
drm-convert-from-nopage-to-fault.patch
git-kvm.patch
nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
sg-nopage.patch
mm-special-mapping-nopage.patch
rewrite-rd.patch
rewrite-rd-fix.patch
rewrite-rd-fix-2.patch
rd-support-xip.patch
mm-remove-nopage.patch
buffer_head-fix-private_list-handling.patch
reiser4.patch
reiser4-correct-references-to-filemap_nopage.patch
