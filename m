From: akpm@linux-foundation.org
Subject: + mm-remove-unused-get_vm_area_node.patch added to -mm tree
Date: Mon, 22 Nov 2010 15:36:52 -0800
Message-ID: <201011222336.oAMNaqGV015681@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44859 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757791Ab0KVXhC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Nov 2010 18:37:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, cl@linux.com


The patch titled
     mm: remove unused get_vm_area_node
has been added to the -mm tree.  Its filename is
     mm-remove-unused-get_vm_area_node.patch

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
Subject: mm: remove unused get_vm_area_node
From: David Rientjes <rientjes@google.com>

get_vm_area_node() is unused in the kernel and can thus be removed.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    3 ---
 mm/vmalloc.c            |    7 -------
 2 files changed, 10 deletions(-)

diff -puN include/linux/vmalloc.h~mm-remove-unused-get_vm_area_node include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~mm-remove-unused-get_vm_area_node
+++ a/include/linux/vmalloc.h
@@ -92,9 +92,6 @@ extern struct vm_struct *__get_vm_area_c
 					unsigned long flags,
 					unsigned long start, unsigned long end,
 					void *caller);
-extern struct vm_struct *get_vm_area_node(unsigned long size,
-					  unsigned long flags, int node,
-					  gfp_t gfp_mask);
 extern struct vm_struct *remove_vm_area(const void *addr);
 
 extern int map_vm_area(struct vm_struct *area, pgprot_t prot,
diff -puN mm/vmalloc.c~mm-remove-unused-get_vm_area_node mm/vmalloc.c
--- a/mm/vmalloc.c~mm-remove-unused-get_vm_area_node
+++ a/mm/vmalloc.c
@@ -1366,13 +1366,6 @@ struct vm_struct *get_vm_area_caller(uns
 						-1, GFP_KERNEL, caller);
 }
 
-struct vm_struct *get_vm_area_node(unsigned long size, unsigned long flags,
-				   int node, gfp_t gfp_mask)
-{
-	return __get_vm_area_node(size, 1, flags, VMALLOC_START, VMALLOC_END,
-				  node, gfp_mask, __builtin_return_address(0));
-}
