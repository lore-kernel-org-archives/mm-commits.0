From: akpm@linux-foundation.org
Subject: + mm-vmalloc-use-offset_in_page-macro.patch added to -mm tree
Date: Tue, 15 Sep 2015 15:22:49 -0700
Message-ID: <55f89a39.gJG6Lqc7X4GueQ0K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55965 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbbIOWWu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Sep 2015 18:22:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: use offset_in_page macro
has been added to the -mm tree.  Its filename is
     mm-vmalloc-use-offset_in_page-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-use-offset_in_page-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-use-offset_in_page-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: mm/vmalloc: use offset_in_page macro

linux/mm.h provides offset_in_page() macro.  Let's use already predefined
macro instead of (addr & ~PAGE_MASK).

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-use-offset_in_page-macro mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-use-offset_in_page-macro
+++ a/mm/vmalloc.c
@@ -358,7 +358,7 @@ static struct vmap_area *alloc_vmap_area
 	struct vmap_area *first;
 
 	BUG_ON(!size);
-	BUG_ON(size & ~PAGE_MASK);
+	BUG_ON(offset_in_page(size));
 	BUG_ON(!is_power_of_2(align));
 
 	va = kmalloc_node(sizeof(struct vmap_area),
@@ -936,7 +936,7 @@ static void *vb_alloc(unsigned long size
 	void *vaddr = NULL;
 	unsigned int order;
 
-	BUG_ON(size & ~PAGE_MASK);
+	BUG_ON(offset_in_page(size));
 	BUG_ON(size > PAGE_SIZE*VMAP_MAX_ALLOC);
 	if (WARN_ON(size == 0)) {
 		/*
@@ -989,7 +989,7 @@ static void vb_free(const void *addr, un
 	unsigned int order;
 	struct vmap_block *vb;
 
-	BUG_ON(size & ~PAGE_MASK);
+	BUG_ON(offset_in_page(size));
 	BUG_ON(size > PAGE_SIZE*VMAP_MAX_ALLOC);
 
 	flush_cache_vunmap((unsigned long)addr, (unsigned long)addr + size);
@@ -1902,7 +1902,7 @@ static int aligned_vread(char *buf, char
 	while (count) {
 		unsigned long offset, length;
 
-		offset = (unsigned long)addr & ~PAGE_MASK;
+		offset = offset_in_page(addr);
 		length = PAGE_SIZE - offset;
 		if (length > count)
 			length = count;
@@ -1941,7 +1941,7 @@ static int aligned_vwrite(char *buf, cha
 	while (count) {
 		unsigned long offset, length;
 
-		offset = (unsigned long)addr & ~PAGE_MASK;
+		offset = offset_in_page(addr);
 		length = PAGE_SIZE - offset;
 		if (length > count)
 			length = count;
@@ -2392,7 +2392,7 @@ struct vm_struct **pcpu_get_vm_areas(con
 	bool purged = false;
 
 	/* verify parameters and allocate data structures */
-	BUG_ON(align & ~PAGE_MASK || !is_power_of_2(align));
+	BUG_ON(offset_in_page(align) || !is_power_of_2(align));
 	for (last_area = 0, area = 0; area < nr_vms; area++) {
 		start = offsets[area];
 		end = start + sizes[area];
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are

mm-msync-use-offset_in_page-macro.patch
mm-nommu-use-offset_in_page-macro.patch
mm-mincore-use-offset_in_page-macro.patch
mm-early_ioremap-use-offset_in_page-macro.patch
mm-percpu-use-offset_in_page-macro.patch
mm-util-use-offset_in_page-macro.patch
mm-mlock-use-offset_in_page-macro.patch
mm-vmalloc-use-offset_in_page-macro.patch
mm-mmap-use-offset_in_page-macro.patch
mm-mremap-use-offset_in_page-macro.patch
lib-halfmd4-use-rol32-inline-function-in-the-round-macro.patch

