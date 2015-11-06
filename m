From: akpm@linux-foundation.org
Subject: [merged] mm-util-use-offset_in_page-macro.patch removed from -mm
 tree
Date: Fri, 06 Nov 2015 12:07:48 -0800
Message-ID: <563d0894.V1XltDs59kIujqqm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48697 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033560AbbKFUHs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:07:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/util: use offset_in_page macro
has been removed from the -mm tree.  Its filename was
     mm-util-use-offset_in_page-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: mm/util: use offset_in_page macro

linux/mm.h provides offset_in_page() macro.  Let's use already predefined
macro instead of (addr & ~PAGE_MASK).

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/util.c~mm-util-use-offset_in_page-macro mm/util.c
--- a/mm/util.c~mm-util-use-offset_in_page-macro
+++ a/mm/util.c
@@ -309,7 +309,7 @@ unsigned long vm_mmap(struct file *file,
 {
 	if (unlikely(offset + PAGE_ALIGN(len) < offset))
 		return -EINVAL;
-	if (unlikely(offset & ~PAGE_MASK))
+	if (unlikely(offset_in_page(offset)))
 		return -EINVAL;
 
 	return vm_mmap_pgoff(file, addr, len, prot, flag, offset >> PAGE_SHIFT);
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are

mm-hugetlb-make-node_hstates-array-static.patch
lib-halfmd4-use-rol32-inline-function-in-the-round-macro.patch

