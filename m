From: akpm@linux-foundation.org
Subject: + mm-vmalloc-improve-vmallocinfo.patch added to -mm tree
Date: Wed, 12 Nov 2008 16:18:33 -0800
Message-ID: <200811130018.mAD0IXcu015621@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752054AbYKMATU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 19:19:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@redhat.com, npiggin@suse.de


The patch titled
     mm: vmalloc improve vmallocinfo
has been added to the -mm tree.  Its filename is
     mm-vmalloc-improve-vmallocinfo.patch

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
Subject: mm: vmalloc improve vmallocinfo
From: Glauber Costa <glommer@redhat.com>

If we do that, output of files like /proc/vmallocinfo will show things
like "vmalloc_32", "vmalloc_user", or whomever the caller was as the
caller.  This info is not as useful as the real caller of the allocation.

So, proposal is to call __vmalloc_node node directly, with matching
parameters to save the caller information

Signed-off-by: Glauber Costa <glommer@redhat.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-improve-vmallocinfo mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-improve-vmallocinfo
+++ a/mm/vmalloc.c
@@ -1363,7 +1363,8 @@ void *vmalloc_user(unsigned long size)
 	struct vm_struct *area;
 	void *ret;
 
-	ret = __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO, PAGE_KERNEL);
+	ret = __vmalloc_node(size, GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO,
+			     PAGE_KERNEL, -1, __builtin_return_address(0));
 	if (ret) {
 		area = find_vm_area(ret);
 		area->flags |= VM_USERMAP;
@@ -1408,7 +1409,8 @@ EXPORT_SYMBOL(vmalloc_node);
 
 void *vmalloc_exec(unsigned long size)
 {
-	return __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL_EXEC);
+	return __vmalloc_node(size, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL_EXEC,
+			      -1, __builtin_return_address(0));
 }
 
 #if defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA32)
@@ -1428,7 +1430,8 @@ void *vmalloc_exec(unsigned long size)
  */
 void *vmalloc_32(unsigned long size)
 {
-	return __vmalloc(size, GFP_VMALLOC32, PAGE_KERNEL);
+	return __vmalloc_node(size, GFP_VMALLOC32, PAGE_KERNEL,
+			      -1, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(vmalloc_32);
 
@@ -1444,7 +1447,8 @@ void *vmalloc_32_user(unsigned long size
 	struct vm_struct *area;
 	void *ret;
 
-	ret = __vmalloc(size, GFP_VMALLOC32 | __GFP_ZERO, PAGE_KERNEL);
+	ret = __vmalloc_node(size, GFP_VMALLOC32 | __GFP_ZERO, PAGE_KERNEL,
+			     -1, __builtin_return_address(0));
 	if (ret) {
 		area = find_vm_area(ret);
 		area->flags |= VM_USERMAP;
_

Patches currently in -mm which might be from glommer@redhat.com are

linux-next.patch
mm-vmalloc-search-restart-fix.patch
mm-vmalloc-tweak-failure-printk.patch
mm-vmalloc-improve-vmallocinfo.patch

