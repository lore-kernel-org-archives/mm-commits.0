From: akpm@linux-foundation.org
Subject: [merged] mm-mincore-use-offset_in_page-macro.patch removed from
 -mm tree
Date: Fri, 06 Nov 2015 12:07:42 -0800
Message-ID: <563d088e.+c02c96hfP+q3RCq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48690 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033195AbbKFUHm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:07:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mincore: use offset_in_page macro
has been removed from the -mm tree.  Its filename was
     mm-mincore-use-offset_in_page-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: mm/mincore: use offset_in_page macro

linux/mm.h provides offset_in_page() macro.  Let's use already predefined
macro instead of (addr & ~PAGE_MASK).

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mincore.c~mm-mincore-use-offset_in_page-macro mm/mincore.c
--- a/mm/mincore.c~mm-mincore-use-offset_in_page-macro
+++ a/mm/mincore.c
@@ -234,7 +234,7 @@ SYSCALL_DEFINE3(mincore, unsigned long,
 
 	/* This also avoids any overflows on PAGE_CACHE_ALIGN */
 	pages = len >> PAGE_SHIFT;
-	pages += (len & ~PAGE_MASK) != 0;
+	pages += (offset_in_page(len)) != 0;
 
 	if (!access_ok(VERIFY_WRITE, vec, pages))
 		return -EFAULT;
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are

mm-hugetlb-make-node_hstates-array-static.patch
lib-halfmd4-use-rol32-inline-function-in-the-round-macro.patch

