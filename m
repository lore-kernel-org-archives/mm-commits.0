From: akpm@linux-foundation.org
Subject: [merged] mm-mlock-use-offset_in_page-macro.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:07:50 -0800
Message-ID: <563d0896.tMR1XIC8s3/z5DPa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48694 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033223AbbKFUHu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:07:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mlock: use offset_in_page macro
has been removed from the -mm tree.  Its filename was
     mm-mlock-use-offset_in_page-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: mm/mlock: use offset_in_page macro

linux/mm.h provides offset_in_page() macro.  Let's use already predefined
macro instead of (addr & ~PAGE_MASK).

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/mlock.c~mm-mlock-use-offset_in_page-macro mm/mlock.c
--- a/mm/mlock.c~mm-mlock-use-offset_in_page-macro
+++ a/mm/mlock.c
@@ -560,7 +560,7 @@ static int do_mlock(unsigned long start,
 	struct vm_area_struct * vma, * prev;
 	int error;
 
-	VM_BUG_ON(start & ~PAGE_MASK);
+	VM_BUG_ON(offset_in_page(start));
 	VM_BUG_ON(len != PAGE_ALIGN(len));
 	end = start + len;
 	if (end < start)
@@ -616,7 +616,7 @@ SYSCALL_DEFINE2(mlock, unsigned long, st
 
 	lru_add_drain_all();	/* flush pagevec */
 
-	len = PAGE_ALIGN(len + (start & ~PAGE_MASK));
+	len = PAGE_ALIGN(len + (offset_in_page(start)));
 	start &= PAGE_MASK;
 
 	lock_limit = rlimit(RLIMIT_MEMLOCK);
@@ -645,7 +645,7 @@ SYSCALL_DEFINE2(munlock, unsigned long,
 {
 	int ret;
 
-	len = PAGE_ALIGN(len + (start & ~PAGE_MASK));
+	len = PAGE_ALIGN(len + (offset_in_page(start)));
 	start &= PAGE_MASK;
 
 	down_write(&current->mm->mmap_sem);
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are

mm-hugetlb-make-node_hstates-array-static.patch
lib-halfmd4-use-rol32-inline-function-in-the-round-macro.patch

