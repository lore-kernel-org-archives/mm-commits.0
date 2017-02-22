From: akpm@linux-foundation.org
Subject: [patch 083/142] userfaultfd: shmem: avoid leaking blocks and used blocks in UFFDIO_COPY
Date: Wed, 22 Feb 2017 15:43:55 -0800
Message-ID: <58ae223b.s94zcpo1WpZfL2Ig%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48878 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934046AbdBVXn4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:43:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com

From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: shmem: avoid leaking blocks and used blocks in UFFDIO_COPY

If the atomic copy_user fails because of a real dangling userland
pointer, we won't go back into the shmem method, so when the method
returns it must not leave anything charged up, except the page itself.

Link: http://lkml.kernel.org/r/20161216144821.5183-37-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff -puN mm/shmem.c~userfaultfd-shmem-avoid-leaking-blocks-and-used-blocks-in-uffdio_copy mm/shmem.c
--- a/mm/shmem.c~userfaultfd-shmem-avoid-leaking-blocks-and-used-blocks-in-uffdio_copy
+++ a/mm/shmem.c
@@ -2214,17 +2214,17 @@ int shmem_mcopy_atomic_pte(struct mm_str
 	pte_t _dst_pte, *dst_pte;
 	int ret;
 
-	if (!*pagep) {
-		ret = -ENOMEM;
-		if (shmem_acct_block(info->flags, 1))
-			goto out;
-		if (sbinfo->max_blocks) {
-			if (percpu_counter_compare(&sbinfo->used_blocks,
-						   sbinfo->max_blocks) >= 0)
-				goto out_unacct_blocks;
-			percpu_counter_inc(&sbinfo->used_blocks);
-		}
+	ret = -ENOMEM;
+	if (shmem_acct_block(info->flags, 1))
+		goto out;
+	if (sbinfo->max_blocks) {
+		if (percpu_counter_compare(&sbinfo->used_blocks,
+					   sbinfo->max_blocks) >= 0)
+			goto out_unacct_blocks;
+		percpu_counter_inc(&sbinfo->used_blocks);
+	}
 
+	if (!*pagep) {
 		page = shmem_alloc_page(gfp, info, pgoff);
 		if (!page)
 			goto out_dec_used_blocks;
@@ -2237,6 +2237,9 @@ int shmem_mcopy_atomic_pte(struct mm_str
 		/* fallback to copy_from_user outside mmap_sem */
 		if (unlikely(ret)) {
 			*pagep = page;
+			if (sbinfo->max_blocks)
+				percpu_counter_add(&sbinfo->used_blocks, -1);
+			shmem_unacct_blocks(info->flags, 1);
 			/* don't free the page */
 			return -EFAULT;
 		}
_
