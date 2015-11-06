From: akpm@linux-foundation.org
Subject: [merged]
 mm-mmapc-remove-useless-statement-vma-=-null-in-find_vma.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:07:18 -0800
Message-ID: <563d0876.IFhohXvSg4nZLtKP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48639 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161169AbbKFUHS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:07:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gang.chen.5i5j@gmail.com, oleg@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: remove useless statement "vma = NULL" in find_vma()
has been removed from the -mm tree.  Its filename was
     mm-mmapc-remove-useless-statement-vma-=-null-in-find_vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: mm/mmap.c: remove useless statement "vma = NULL" in find_vma()

Before the main loop, vma is already is NULL.  There is no need to set it
to NULL again.

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/mmap.c~mm-mmapc-remove-useless-statement-vma-=-null-in-find_vma mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-remove-useless-statement-vma-=-null-in-find_vma
+++ a/mm/mmap.c
@@ -2047,7 +2047,6 @@ struct vm_area_struct *find_vma(struct m
 		return vma;
 
 	rb_node = mm->mm_rb.rb_node;
-	vma = NULL;
 
 	while (rb_node) {
 		struct vm_area_struct *tmp;
_

Patches currently in -mm which might be from gang.chen.5i5j@gmail.com are

mm-mmapc-change-static-function-__install_special_mapping-args-order.patch

