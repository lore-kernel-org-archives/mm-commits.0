From: akpm@linux-foundation.org
Subject: [merged] mm-msync-use-offset_in_page-macro.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:07:38 -0800
Message-ID: <563d088a./4/VqZbi9htV/K+q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966286AbbKFUHi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:07:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/msync: use offset_in_page macro
has been removed from the -mm tree.  Its filename was
     mm-msync-use-offset_in_page-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: mm/msync: use offset_in_page macro

linux/mm.h provides offset_in_page() macro.  Let's use already predefined
macro instead of (addr & ~PAGE_MASK).

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/msync.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/msync.c~mm-msync-use-offset_in_page-macro mm/msync.c
--- a/mm/msync.c~mm-msync-use-offset_in_page-macro
+++ a/mm/msync.c
@@ -38,7 +38,7 @@ SYSCALL_DEFINE3(msync, unsigned long, st
 
 	if (flags & ~(MS_ASYNC | MS_INVALIDATE | MS_SYNC))
 		goto out;
-	if (start & ~PAGE_MASK)
+	if (offset_in_page(start))
 		goto out;
 	if ((flags & MS_ASYNC) && (flags & MS_SYNC))
 		goto out;
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are

mm-hugetlb-make-node_hstates-array-static.patch
lib-halfmd4-use-rol32-inline-function-in-the-round-macro.patch

