Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE805C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  1 Feb 2022 20:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242672AbiBAU6U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Feb 2022 15:58:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55472 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242531AbiBAU6S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2022 15:58:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A892B82F8D
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 20:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF7CC340EB;
        Tue,  1 Feb 2022 20:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643749096;
        bh=fqo/Cs9VmeENzUszBePsTs/X5/ArzOQQR2v+mm2TnSc=;
        h=Date:To:From:Subject:From;
        b=F5Jsn1YWOiYkfqTmbFsr8zTQJN5wnY6BjNwP99Wditv/qmkiJbxSnoCEm6+7haOer
         rO+Yp1xNHrnkzXk5E5D6LWA/rFqR2Lmx9eJ5bJcEeZ676hgZ2eID4mEK5aKoyipyXy
         W7TiXROZEQANuMe5Ch086SZSO/t+Qhvv/n2W7qno=
Received: by hp1 (sSMTP sendmail emulation); Tue, 01 Feb 2022 12:58:14 -0800
Date:   Tue, 01 Feb 2022 12:58:14 -0800
To:     mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com,
        jhubbard@nvidia.com, jgg@ziepe.ca, jgg@nvidia.com, jack@suse.cz,
        david@redhat.com, alex.williamson@redhat.com, aarcange@redhat.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-invalid-page-pointer-returned-with-foll_pin-gups.patch added to -mm tree
Message-Id: <20220201205814.DCF7CC340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix invalid page pointer returned with FOLL_PIN gups
has been added to the -mm tree.  Its filename is
     mm-fix-invalid-page-pointer-returned-with-foll_pin-gups.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-invalid-page-pointer-returned-with-foll_pin-gups.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-invalid-page-pointer-returned-with-foll_pin-gups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: fix invalid page pointer returned with FOLL_PIN gups

Patch series "mm/gup: some cleanups", v2.


This patch (of 4):

Alex reported invalid page pointer returned with pin_user_pages_remote()
from vfio after upstream commit 4b6c33b32296 ("vfio/type1: Prepare for
batched pinning with struct vfio_batch").  This problem breaks NVIDIA vfio
mdev.

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

Link: https://lkml.kernel.org/r/20220201101108.306062-1-jhubbard@nvidia.com
Link: https://lkml.kernel.org/r/20220201101108.306062-2-jhubbard@nvidia.com
Fixes: 3faa52c03f44 ("mm/gup: track FOLL_PIN pages")
Signed-off-by: Peter Xu <peterx@redhat.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reported-by: Alex Williamson <alex.williamson@redhat.com>
Debugged-by: Alex Williamson <alex.williamson@redhat.com>
Tested-by: Alex Williamson <alex.williamson@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~mm-fix-invalid-page-pointer-returned-with-foll_pin-gups
+++ a/mm/gup.c
@@ -440,7 +440,7 @@ static int follow_pfn_pte(struct vm_area
 		pte_t *pte, unsigned int flags)
 {
 	/* No page to get reference */
-	if (flags & FOLL_GET)
+	if (flags & (FOLL_GET | FOLL_PIN))
 		return -EFAULT;
 
 	if (flags & FOLL_TOUCH) {
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-fix-invalid-page-pointer-returned-with-foll_pin-gups.patch

