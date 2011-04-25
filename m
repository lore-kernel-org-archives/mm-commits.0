From: akpm@linux-foundation.org
Subject: + drivers-char-mspecc-use-kvzalloc-to-allocate-memory.patch added to -mm tree
Date: Mon, 25 Apr 2011 15:28:20 -0700
Message-ID: <201104252228.p3PMSKjl014662@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753255Ab1DYW2u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Apr 2011 18:28:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com


The patch titled
     drivers/char/mspec.c: use {k,v}zalloc to allocate memory
has been added to the -mm tree.  Its filename is
     drivers-char-mspecc-use-kvzalloc-to-allocate-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
drivers-char-mspecc-use-kvzalloc-to-allocate-memory.patch
kernel-profilec-use-vzalloc-instead-of-vmallocmemset.patch

