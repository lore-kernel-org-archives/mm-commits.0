Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05CCCC77B75
	for <mm-commits@archiver.kernel.org>; Wed, 17 May 2023 20:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjEQUde (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 May 2023 16:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjEQUdd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 May 2023 16:33:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3459C
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 13:33:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF2B564B17
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 20:32:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556D6C433D2;
        Wed, 17 May 2023 20:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684355526;
        bh=VG3Uy19UE4yozLp/LZJWONkp4uOV2Lke9NrjRJQqeUM=;
        h=Date:To:From:Subject:From;
        b=WfGOimZjelKe8KLBu59JA1GDX7s8tqAxaDLET34v4TUEEJSrueWKpEM5pCkrFMLa8
         EIfeXbfy9E+TDKu338iFqp48mr8okB80KPR2dyc3rbJNQfhmOoGI52LJyKl6cIiAvJ
         OPjcYnDDXhSop4sMJjZp9uDKg23wIURQMnind7+c=
Date:   Wed, 17 May 2023 13:32:05 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, david@redhat.com,
        axboe@kernel.dk, lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + io_uring-rsrc-delegate-vma-file-backed-check-to-gup.patch added to mm-unstable branch
Message-Id: <20230517203206.556D6C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: io_uring: rsrc: delegate VMA file-backed check to GUP
has been added to the -mm mm-unstable branch.  Its filename is
     io_uring-rsrc-delegate-vma-file-backed-check-to-gup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/io_uring-rsrc-delegate-vma-file-backed-check-to-gup.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-mmap-separate-writenotify-and-dirty-tracking-logic.patch
mm-gup-disallow-foll_longterm-gup-nonfast-writing-to-file-backed-mappings.patch
mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings.patch
mm-gup-add-missing-gup_must_unshare-check-to-gup_huge_pgd.patch
mm-gup-remove-unused-vmas-parameter-from-get_user_pages.patch
mm-gup-remove-unused-vmas-parameter-from-pin_user_pages_remote.patch
mm-gup-remove-vmas-parameter-from-get_user_pages_remote.patch
io_uring-rsrc-delegate-vma-file-backed-check-to-gup.patch
mm-gup-remove-vmas-parameter-from-pin_user_pages.patch
mm-gup-remove-vmas-array-from-internal-gup-functions.patch

