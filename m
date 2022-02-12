Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E78C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 12 Feb 2022 00:29:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354436AbiBLA3L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 19:29:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354435AbiBLA3K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 19:29:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F3AD7C
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 16:29:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50F0961C55
        for <mm-commits@vger.kernel.org>; Sat, 12 Feb 2022 00:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A62CC340EB;
        Sat, 12 Feb 2022 00:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644625747;
        bh=Ojv42GrKeP755lPkyAwJ3THkeG2XygI9EqSsdmh0bhU=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=h9qHGXaLMBT/y02kXqibpei1v0wdTQlP2fEy5uEOhuryE/gkbA3GlzAbnXeBTFZ/L
         OO0nYXlCX+WKHs5LqfKiiWUCi8DhiZUGCCkhJV0/v7DGeg31w6tBRJlOiMl55rr2/k
         dUqgMoEZB3v92RZsjBRmWK6/0HEnjiE1IdGw3njE=
Date:   Fri, 11 Feb 2022 16:29:07 -0800
To:     willy@infradead.org, peterx@redhat.com, lukas.bulwahn@gmail.com,
        kirill.shutemov@linux.intel.com, jgg@ziepe.ca, jgg@nvidia.com,
        jack@suse.cz, imbrenda@linux.ibm.com, hch@lst.de, david@redhat.com,
        alex.williamson@redhat.com, aarcange@redhat.com,
        jhubbard@nvidia.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220211162756.9f8e8baef81183041ccfc16f@linux-foundation.org>
Subject: [patch 5/5] mm/gup: remove unused get_user_pages_locked()
Message-Id: <20220212002907.9A62CC340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: remove unused get_user_pages_locked()

Now that the last caller of get_user_pages_locked() is gone, remove it.

Link: https://lkml.kernel.org/r/20220204020010.68930-6-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-gup-remove-unused-get_user_pages_locked
+++ a/include/linux/mm.h
@@ -1916,8 +1916,6 @@ long get_user_pages(unsigned long start,
 long pin_user_pages(unsigned long start, unsigned long nr_pages,
 		    unsigned int gup_flags, struct page **pages,
 		    struct vm_area_struct **vmas);
-long get_user_pages_locked(unsigned long start, unsigned long nr_pages,
-		    unsigned int gup_flags, struct page **pages, int *locked);
 long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
 		    struct page **pages, unsigned int gup_flags);
 long pin_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
--- a/mm/gup.c~mm-gup-remove-unused-get_user_pages_locked
+++ a/mm/gup.c
@@ -2145,65 +2145,6 @@ long get_user_pages(unsigned long start,
 }
 EXPORT_SYMBOL(get_user_pages);
 
-/**
- * get_user_pages_locked() - variant of get_user_pages()
- *
- * @start:      starting user address
- * @nr_pages:   number of pages from start to pin
- * @gup_flags:  flags modifying lookup behaviour
- * @pages:      array that receives pointers to the pages pinned.
- *              Should be at least nr_pages long. Or NULL, if caller
- *              only intends to ensure the pages are faulted in.
- * @locked:     pointer to lock flag indicating whether lock is held and
- *              subsequently whether VM_FAULT_RETRY functionality can be
- *              utilised. Lock must initially be held.
- *
- * It is suitable to replace the form:
- *
- *      mmap_read_lock(mm);
- *      do_something()
- *      get_user_pages(mm, ..., pages, NULL);
- *      mmap_read_unlock(mm);
- *
- *  to:
- *
- *      int locked = 1;
- *      mmap_read_lock(mm);
- *      do_something()
- *      get_user_pages_locked(mm, ..., pages, &locked);
- *      if (locked)
- *          mmap_read_unlock(mm);
- *
- * We can leverage the VM_FAULT_RETRY functionality in the page fault
- * paths better by using either get_user_pages_locked() or
- * get_user_pages_unlocked().
- *
- */
-long get_user_pages_locked(unsigned long start, unsigned long nr_pages,
-			   unsigned int gup_flags, struct page **pages,
-			   int *locked)
-{
-	/*
-	 * FIXME: Current FOLL_LONGTERM behavior is incompatible with
-	 * FAULT_FLAG_ALLOW_RETRY because of the FS DAX check requirement on
-	 * vmas.  As there are no users of this flag in this call we simply
-	 * disallow this option for now.
-	 */
-	if (WARN_ON_ONCE(gup_flags & FOLL_LONGTERM))
-		return -EINVAL;
-	/*
-	 * FOLL_PIN must only be set internally by the pin_user_pages*() APIs,
-	 * never directly by the caller, so enforce that:
-	 */
-	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
-		return -EINVAL;
-
-	return __get_user_pages_locked(current->mm, start, nr_pages,
-				       pages, NULL, locked,
-				       gup_flags | FOLL_TOUCH);
-}
-EXPORT_SYMBOL(get_user_pages_locked);
-
 /*
  * get_user_pages_unlocked() is suitable to replace the form:
  *
_
