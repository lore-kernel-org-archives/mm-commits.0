Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8089EC4167B
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbiLLCNj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:13:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbiLLCNh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:13:37 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF26DAC
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:13:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1E18CCE0B8F
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290CCC433D2;
        Mon, 12 Dec 2022 02:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811212;
        bh=RwxiuOv1zhN3K4p+fcDItIPeZjHFFM15fobuwaVtqh8=;
        h=Date:To:From:Subject:From;
        b=03m2uvwW7iwi+45+Z4A48tr7yV9GapRSYgXki0CxB38b21YUQ+LLDGX2M2e5Kr+dD
         PBCFTWF+xGsWO9XsjsuYOnGJtQeYVWVSNGiYfUA4MnpGNJaK0QCjwPme0oKHzf4M++
         B+Cse3TnTgdpdXkt1Q+qPWFO0S+nab/9lXd4kUOA=
Date:   Sun, 11 Dec 2022 18:13:31 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shuah@kernel.org, peterx@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, hughd@google.com, aarcange@redhat.com,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch removed from -mm tree
Message-Id: <20221212021332.290CCC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/pagewalk: don't trigger test_walk() in walk_page_vma()
has been removed from the -mm tree.  Its filename was
     mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/pagewalk: don't trigger test_walk() in walk_page_vma()
Date: Fri, 21 Oct 2022 12:11:38 +0200

As Peter points out, the caller passes a single VMA and can just do that
check itself.

And in fact, no existing users rely on test_walk() getting called.  So
let's just remove it and make the implementation slightly more efficient.

Link: https://lkml.kernel.org/r/20221021101141.84170-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagewalk.h |    2 ++
 mm/pagewalk.c            |    7 -------
 2 files changed, 2 insertions(+), 7 deletions(-)

--- a/include/linux/pagewalk.h~mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma
+++ a/include/linux/pagewalk.h
@@ -27,6 +27,8 @@ struct mm_walk;
  *			"do page table walk over the current vma", returning
  *			a negative value means "abort current page table walk
  *			right now" and returning 1 means "skip the current vma"
+ *			Note that this callback is not called when the caller
+ *			passes in a single VMA as for walk_page_vma().
  * @pre_vma:            if set, called before starting walk on a non-null vma.
  * @post_vma:           if set, called after a walk on a non-null vma, provided
  *                      that @pre_vma and the vma walk succeeded.
--- a/mm/pagewalk.c~mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma
+++ a/mm/pagewalk.c
@@ -526,18 +526,11 @@ int walk_page_vma(struct vm_area_struct
 		.vma		= vma,
 		.private	= private,
 	};
-	int err;
 
 	if (!walk.mm)
 		return -EINVAL;
 
 	mmap_assert_locked(walk.mm);
-
-	err = walk_page_test(vma->vm_start, vma->vm_end, &walk);
-	if (err > 0)
-		return 0;
-	if (err < 0)
-		return err;
 	return __walk_page_range(vma->vm_start, vma->vm_end, &walk);
 }
 
_

Patches currently in -mm which might be from david@redhat.com are


