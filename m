From: akpm@linux-foundation.org
Subject: [merged] drivers-char-mspecc-use-kvzalloc-to-allocate-memory.patch removed from -mm tree
Date: Fri, 27 May 2011 12:58:55 -0700
Message-ID: <201105271957.p4RJv1bE017628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754576Ab1E0UGE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 16:06:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rakib.mullick@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/char/mspec.c: use {k,v}zalloc to allocate memory
has been removed from the -mm tree.  Its filename was
     drivers-char-mspecc-use-kvzalloc-to-allocate-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/mspec.c: use {k,v}zalloc to allocate memory
From: Rakib Mullick <rakib.mullick@gmail.com>

Let memory allocator initialize the allocated memory as null, thus remove
the use of memset.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mspec.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/char/mspec.c~drivers-char-mspecc-use-kvzalloc-to-allocate-memory drivers/char/mspec.c
--- a/drivers/char/mspec.c~drivers-char-mspecc-use-kvzalloc-to-allocate-memory
+++ a/drivers/char/mspec.c
@@ -271,14 +271,13 @@ mspec_mmap(struct file *file, struct vm_
 	pages = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 	vdata_size = sizeof(struct vma_data) + pages * sizeof(long);
 	if (vdata_size <= PAGE_SIZE)
-		vdata = kmalloc(vdata_size, GFP_KERNEL);
+		vdata = kzalloc(vdata_size, GFP_KERNEL);
 	else {
-		vdata = vmalloc(vdata_size);
+		vdata = vzalloc(vdata_size);
 		flags = VMD_VMALLOCED;
 	}
 	if (!vdata)
 		return -ENOMEM;
-	memset(vdata, 0, vdata_size);
 
 	vdata->vm_start = vma->vm_start;
 	vdata->vm_end = vma->vm_end;
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

origin.patch

