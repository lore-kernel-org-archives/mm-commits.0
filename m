From: akpm@linux-foundation.org
Subject: [folded-merged]
 userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch removed from -mm tree
Date: Fri, 04 Sep 2015 15:30:26 -0700
Message-ID: <55ea1b82.EGIf8k89dSbhIqos%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54087 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760730AbbIDWa1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2015 18:30:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix
has been removed from the -mm tree.  Its filename was
     userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch

This patch was dropped because it was folded into userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix

delete weird BUILD_BUG_ON()

Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/userfaultfd.c~userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix mm/userfaultfd.c
--- a/mm/userfaultfd.c~userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix
+++ a/mm/userfaultfd.c
@@ -256,7 +256,6 @@ retry:
 		if (unlikely(err == -EFAULT)) {
 			void *page_kaddr;
 
-			BUILD_BUG_ON(zeropage);
 			up_read(&dst_mm->mmap_sem);
 			BUG_ON(!page);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
genalloc-add-support-of-multiple-gen_pools-per-device-fix.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch

