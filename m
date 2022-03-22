Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C8DC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:40:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbiCVVlt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235978AbiCVVlN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:41:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD401E7
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:39:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2793E61748
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D93C340EC;
        Tue, 22 Mar 2022 21:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985184;
        bh=TgP8gVZ3VEv74o04VvHLA+1bQwsdNlpj/ml52mWc2tI=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=meMmPqS8ZxVcQqfWHGJI9RrAR/Fl1zFkRy054SyBoQSBsYyO9FTk5AwoXMt26wmY3
         Fhj0Ah+PQth+Eg22nE/hmkVzTJUX6iIGhz+/ws4hopSQCjdai7CRTPJ4USvbG3NP9F
         EudObRaMUqlV2A4Sa5dRkAxthfovGM7eu983RT1M=
Date:   Tue, 22 Mar 2022 14:39:43 -0700
To:     willy@infradead.org, peterx@redhat.com, lukas.bulwahn@gmail.com,
        kirill.shutemov@linux.intel.com, jgg@ziepe.ca, jgg@nvidia.com,
        jack@suse.cz, imbrenda@linux.ibm.com, hch@lst.de, david@redhat.com,
        alex.williamson@redhat.com, aarcange@redhat.com,
        jhubbard@nvidia.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 024/227] mm/gup: remove unused pin_user_pages_locked()
Message-Id: <20220322213944.80D93C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: remove unused pin_user_pages_locked()

This routine was used for a short while, but then the calling code was
refactored and the only caller was removed.

Link: https://lkml.kernel.org/r/20220204020010.68930-4-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 --
 mm/gup.c           |   29 -----------------------------
 2 files changed, 31 deletions(-)

--- a/include/linux/mm.h~mm-gup-remove-unused-pin_user_pages_locked
+++ a/include/linux/mm.h
@@ -1918,8 +1918,6 @@ long pin_user_pages(unsigned long start,
 		    struct vm_area_struct **vmas);
 long get_user_pages_locked(unsigned long start, unsigned long nr_pages,
 		    unsigned int gup_flags, struct page **pages, int *locked);
-long pin_user_pages_locked(unsigned long start, unsigned long nr_pages,
-		    unsigned int gup_flags, struct page **pages, int *locked);
 long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
 		    struct page **pages, unsigned int gup_flags);
 long pin_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
--- a/mm/gup.c~mm-gup-remove-unused-pin_user_pages_locked
+++ a/mm/gup.c
@@ -3127,32 +3127,3 @@ long pin_user_pages_unlocked(unsigned lo
 	return get_user_pages_unlocked(start, nr_pages, pages, gup_flags);
 }
 EXPORT_SYMBOL(pin_user_pages_unlocked);
-
-/*
- * pin_user_pages_locked() is the FOLL_PIN variant of get_user_pages_locked().
- * Behavior is the same, except that this one sets FOLL_PIN and rejects
- * FOLL_GET.
- */
-long pin_user_pages_locked(unsigned long start, unsigned long nr_pages,
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
-
-	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
-	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
-		return -EINVAL;
-
-	gup_flags |= FOLL_PIN;
-	return __get_user_pages_locked(current->mm, start, nr_pages,
-				       pages, NULL, locked,
-				       gup_flags | FOLL_TOUCH);
-}
-EXPORT_SYMBOL(pin_user_pages_locked);
_
