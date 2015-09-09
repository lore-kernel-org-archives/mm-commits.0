From: akpm@linux-foundation.org
Subject: [merged] dax-use-linear_page_index.patch removed from -mm tree
Date: Wed, 09 Sep 2015 12:43:35 -0700
Message-ID: <55f08be7.U9++7l1XK/S7EIiU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbbIITnf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:43:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: use linear_page_index()
has been removed from the -mm tree.  Its filename was
     dax-use-linear_page_index.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: dax: use linear_page_index()

I was basically open-coding it (thanks to copying code from do_fault()
which probably also needs to be fixed).

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/dax.c~dax-use-linear_page_index fs/dax.c
--- a/fs/dax.c~dax-use-linear_page_index
+++ a/fs/dax.c
@@ -529,7 +529,7 @@ int __dax_pmd_fault(struct vm_area_struc
 	if ((pmd_addr + PMD_SIZE) > vma->vm_end)
 		return VM_FAULT_FALLBACK;
 
-	pgoff = ((pmd_addr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
+	pgoff = linear_page_index(vma, pmd_addr);
 	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	if (pgoff >= size)
 		return VM_FAULT_SIGBUS;
_

Patches currently in -mm which might be from willy@linux.intel.com are


