Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AA04C433FE
	for <mm-commits@archiver.kernel.org>; Sat, 12 Feb 2022 00:28:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344832AbiBLA27 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 19:28:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344273AbiBLA26 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 19:28:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE622D7D
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 16:28:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B70361CE4
        for <mm-commits@vger.kernel.org>; Sat, 12 Feb 2022 00:28:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE0EC340E9;
        Sat, 12 Feb 2022 00:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644625735;
        bh=r0eAsPz7tsymPUCZg2jJkLK9OkeZFEYLLk2Yj4LFvdY=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=0rFlMmREds6iYjqV+GnxX1k7sUGimsbvO0m6peeraPDlwSLwTWr7N30wUrVqr1+D/
         YgSivEI9ssW5dJnd9NHhAqL7vu0lVYUGtWcsKpCY1iwxHT4zEKkKOM4bVB7pbfbwCF
         Ccu5BZahDn6deLc7QjIA/TRi2TRdtoDP1d1+OJj8=
Date:   Fri, 11 Feb 2022 16:28:55 -0800
To:     willy@infradead.org, lukas.bulwahn@gmail.com,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com, jgg@ziepe.ca,
        jgg@nvidia.com, jack@suse.cz, imbrenda@linux.ibm.com, hch@lst.de,
        david@redhat.com, alex.williamson@redhat.com, aarcange@redhat.com,
        peterx@redhat.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220211162756.9f8e8baef81183041ccfc16f@linux-foundation.org>
Subject: [patch 1/5] mm: fix invalid page pointer returned with FOLL_PIN gups
Message-Id: <20220212002855.BAE0EC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: mm: fix invalid page pointer returned with FOLL_PIN gups

Patch series "mm/gup: some cleanups", v4.


This patch (of 5):

Alex reported invalid page pointer returned with pin_user_pages_remote()
from vfio after upstream commit 4b6c33b32296 ("vfio/type1: Prepare for
batched pinning with struct vfio_batch").

It turns out that it's not the fault of the vfio commit; however after
vfio switches to a full page buffer to store the page pointers it starts
to expose the problem easier.

The problem is for VM_PFNMAP vmas we should normally fail with an -EFAULT
then vfio will carry on to handle the MMIO regions.  However when the bug
triggered, follow_page_mask() returned -EEXIST for such a page, which will
jump over the current page, leaving that entry in **pages untouched. 
However the caller is not aware of it, hence the caller will reference the
page as usual even if the pointer data can be anything.

We had that -EEXIST logic since commit 1027e4436b6a ("mm: make GUP handle
pfn mapping unless FOLL_GET is requested") which seems very reasonable. 
It could be that when we reworked GUP with FOLL_PIN we could have
overlooked that special path in commit 3faa52c03f44 ("mm/gup: track
FOLL_PIN pages"), even if that commit rightfully touched up
follow_devmap_pud() on checking FOLL_PIN when it needs to return an
-EEXIST.

Attaching the Fixes to the FOLL_PIN rework commit, as it happened later than
1027e4436b6a.

[jhubbard@nvidia.com: added some tags, removed a reference to an out of tree module.]
Link: https://lkml.kernel.org/r/20220207062213.235127-1-jhubbard@nvidia.com
Link: https://lkml.kernel.org/r/20220204020010.68930-1-jhubbard@nvidia.com
Link: https://lkml.kernel.org/r/20220204020010.68930-2-jhubbard@nvidia.com
Fixes: 3faa52c03f44 ("mm/gup: track FOLL_PIN pages")
Signed-off-by: Peter Xu <peterx@redhat.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reported-by: Alex Williamson <alex.williamson@redhat.com>
Debugged-by: Alex Williamson <alex.williamson@redhat.com>
Tested-by: Alex Williamson <alex.williamson@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/gup.c~mm-fix-invalid-page-pointer-returned-with-foll_pin-gups
+++ a/mm/gup.c
@@ -465,7 +465,7 @@ static int follow_pfn_pte(struct vm_area
 		pte_t *pte, unsigned int flags)
 {
 	/* No page to get reference */
-	if (flags & FOLL_GET)
+	if (flags & (FOLL_GET | FOLL_PIN))
 		return -EFAULT;
 
 	if (flags & FOLL_TOUCH) {
_
