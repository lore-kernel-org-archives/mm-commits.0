Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60DD1C7EE45
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:29:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbjFIX3N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbjFIX2O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:28:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D073C22
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:27:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4918C61AE1
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:27:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2458C433EF;
        Fri,  9 Jun 2023 23:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353278;
        bh=25MTzSYA7cNil/0kXqNydmrlchn1dfayRQ7shMFkvk4=;
        h=Date:To:From:Subject:From;
        b=CrjeRmTIC1TV9ZqI0pNe8ADO3DHf8Xhwns4VMd4nwzKylPjj9OvIK14Jpwke7Nknv
         CmF+7Mvdh0IQcErouhcLG5GIUkopkz2BVH1mzRxcr17D1hQqasvEhnFQGlXc26AI8V
         56ERfhgNjBTTVGwuKHSzpy9zanfLRBKAQL9c2gEk=
Date:   Fri, 09 Jun 2023 16:27:58 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, seanjc@google.com,
        sakari.ailus@linux.intel.com, jgg@nvidia.com, jarkko@kernel.org,
        hch@lst.de, gregkh@linuxfoundation.org, frankja@linux.ibm.com,
        dennis.dalessandro@cornelisnetworks.com, david@redhat.com,
        christian.koenig@amd.com, catalin.marinas@arm.com, axboe@kernel.dk,
        lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] io_uring-rsrc-delegate-vma-file-backed-check-to-gup.patch removed from -mm tree
Message-Id: <20230609232758.A2458C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: io_uring: rsrc: delegate VMA file-backed check to GUP
has been removed from the -mm tree.  Its filename was
     io_uring-rsrc-delegate-vma-file-backed-check-to-gup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: io_uring: rsrc: delegate VMA file-backed check to GUP
Date: Wed, 17 May 2023 20:25:42 +0100

Now that the GUP explicitly checks FOLL_LONGTERM pin_user_pages() for
broken file-backed mappings in "mm/gup: disallow FOLL_LONGTERM GUP-nonfast
writing to file-backed mappings", there is no need to explicitly check VMAs
for this condition, so simply remove this logic from io_uring altogether.

Link: https://lkml.kernel.org/r/e4a4efbda9cd12df71e0ed81796dc630231a1ef2.1684350871.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 io_uring/rsrc.c |   34 ++++++----------------------------
 1 file changed, 6 insertions(+), 28 deletions(-)

--- a/io_uring/rsrc.c~io_uring-rsrc-delegate-vma-file-backed-check-to-gup
+++ a/io_uring/rsrc.c
@@ -1030,9 +1030,8 @@ static int io_buffer_account_pin(struct
 struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages)
 {
 	unsigned long start, end, nr_pages;
-	struct vm_area_struct **vmas = NULL;
 	struct page **pages = NULL;
-	int i, pret, ret = -ENOMEM;
+	int pret, ret = -ENOMEM;
 
 	end = (ubuf + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	start = ubuf >> PAGE_SHIFT;
@@ -1042,45 +1041,24 @@ struct page **io_pin_pages(unsigned long
 	if (!pages)
 		goto done;
 
-	vmas = kvmalloc_array(nr_pages, sizeof(struct vm_area_struct *),
-			      GFP_KERNEL);
-	if (!vmas)
-		goto done;
-
 	ret = 0;
 	mmap_read_lock(current->mm);
 	pret = pin_user_pages(ubuf, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
-			      pages, vmas);
-	if (pret == nr_pages) {
-		/* don't support file backed memory */
-		for (i = 0; i < nr_pages; i++) {
-			struct vm_area_struct *vma = vmas[i];
-
-			if (vma_is_shmem(vma))
-				continue;
-			if (vma->vm_file &&
-			    !is_file_hugepages(vma->vm_file)) {
-				ret = -EOPNOTSUPP;
-				break;
-			}
-		}
+			      pages, NULL);
+	if (pret == nr_pages)
 		*npages = nr_pages;
-	} else {
+	else
 		ret = pret < 0 ? pret : -EFAULT;
-	}
+
 	mmap_read_unlock(current->mm);
 	if (ret) {
-		/*
-		 * if we did partial map, or found file backed vmas,
-		 * release any pages we did get
-		 */
+		/* if we did partial map, release any pages we did get */
 		if (pret > 0)
 			unpin_user_pages(pages, pret);
 		goto done;
 	}
 	ret = 0;
 done:
-	kvfree(vmas);
 	if (ret < 0) {
 		kvfree(pages);
 		pages = ERR_PTR(ret);
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-vmalloc-do-not-output-a-spurious-warning-when-huge-vmalloc-fails.patch

