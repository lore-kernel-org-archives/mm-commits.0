Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55FA4C2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 00:56:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DED7E2222F
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 00:56:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="VZv/Pn+S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgKMA4I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 19:56:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:58854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725929AbgKMA4I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 19:56:08 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50CF121D79;
        Fri, 13 Nov 2020 00:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605228967;
        bh=Xlm6wSeEV7ACgDOw+/omGojH8zdMwqcmJMJlEntYwvY=;
        h=Date:From:To:Subject:From;
        b=VZv/Pn+SKEXtAPGLmT0/Bk+sxPJaQg79DV1RPjNLcKkQYuI7k2Kqp1FO/ZS73qoEn
         znoktt9wZMjrmDTU6eEVWbYFTNtvK6nsddrUt6SqhstiQSkvBdLhFbCOcLqqg5uBAU
         AeJuinMrvDKbwlOMP+WP30jIn/JNOZw+0NHnqDic=
Date:   Thu, 12 Nov 2020 16:56:05 -0800
From:   akpm@linux-foundation.org
To:     a.darwish@linutronix.de, aarcange@redhat.com,
        aneesh.kumar@linux.ibm.com, hch@lst.de, hughd@google.com,
        jack@suse.cz, jannh@google.com, jgg@nvidia.com,
        jhubbard@nvidia.com, kirill@shutemov.name, ktkhai@virtuozzo.com,
        leonro@nvidia.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        oleg@redhat.com, peterx@redhat.com, torvalds@linux-foundation.org
Subject:  + mm-reorganize-internal_get_user_pages_fast.patch added
 to -mm tree
Message-ID: <20201113005605.K5Q5B3SlA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: reorganize internal_get_user_pages_fast()
has been added to the -mm tree.  Its filename is
     mm-reorganize-internal_get_user_pages_fast.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-reorganize-internal_get_user_pages_fast.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-reorganize-internal_get_user_pages_fast.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jason Gunthorpe <jgg@nvidia.com>
Subject: mm/gup: reorganize internal_get_user_pages_fast()

The next patch in this series makes the lockless flow a little more
complex, so move the entire block into a new function and remove a level
of indention.  Tidy a bit of cruft:

 - addr is always the same as start, so use start

 - Use the modern check_add_overflow() for computing end = start + len

 - nr_pinned/pages << PAGE_SHIFT needs the LHS to be unsigned long to
   avoid shift overflow, make the variables unsigned long to avoid coding
   casts in both places. nr_pinned was missing its cast

 - The handling of ret and nr_pinned can be streamlined a bit

No functional change.

Link: https://lkml.kernel.org/r/1-v4-908497cf359a+4782-gup_fork_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: "Ahmed S. Darwish" <a.darwish@linutronix.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kirill Shutemov <kirill@shutemov.name>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |  101 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 55 insertions(+), 46 deletions(-)

--- a/mm/gup.c~mm-reorganize-internal_get_user_pages_fast
+++ a/mm/gup.c
@@ -2677,13 +2677,43 @@ static int __gup_longterm_unlocked(unsig
 	return ret;
 }
 
-static int internal_get_user_pages_fast(unsigned long start, int nr_pages,
+static unsigned long lockless_pages_from_mm(unsigned long start,
+					    unsigned long end,
+					    unsigned int gup_flags,
+					    struct page **pages)
+{
+	unsigned long flags;
+	int nr_pinned = 0;
+
+	if (!IS_ENABLED(CONFIG_HAVE_FAST_GUP) ||
+	    !gup_fast_permitted(start, end))
+		return 0;
+
+	/*
+	 * Disable interrupts. The nested form is used, in order to allow full,
+	 * general purpose use of this routine.
+	 *
+	 * With interrupts disabled, we block page table pages from being freed
+	 * from under us. See struct mmu_table_batch comments in
+	 * include/asm-generic/tlb.h for more details.
+	 *
+	 * We do not adopt an rcu_read_lock() here as we also want to block IPIs
+	 * that come from THPs splitting.
+	 */
+	local_irq_save(flags);
+	gup_pgd_range(start, end, gup_flags, pages, &nr_pinned);
+	local_irq_restore(flags);
+	return nr_pinned;
+}
+
+static int internal_get_user_pages_fast(unsigned long start,
+					unsigned long nr_pages,
 					unsigned int gup_flags,
 					struct page **pages)
 {
-	unsigned long addr, len, end;
-	unsigned long flags;
-	int nr_pinned = 0, ret = 0;
+	unsigned long len, end;
+	unsigned long nr_pinned;
+	int ret;
 
 	if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM |
 				       FOLL_FORCE | FOLL_PIN | FOLL_GET |
@@ -2697,54 +2727,33 @@ static int internal_get_user_pages_fast(
 		might_lock_read(&current->mm->mmap_lock);
 
 	start = untagged_addr(start) & PAGE_MASK;
-	addr = start;
-	len = (unsigned long) nr_pages << PAGE_SHIFT;
-	end = start + len;
-
-	if (end <= start)
+	len = nr_pages << PAGE_SHIFT;
+	if (check_add_overflow(start, len, &end))
 		return 0;
 	if (unlikely(!access_ok((void __user *)start, len)))
 		return -EFAULT;
 
-	/*
-	 * Disable interrupts. The nested form is used, in order to allow
-	 * full, general purpose use of this routine.
-	 *
-	 * With interrupts disabled, we block page table pages from being
-	 * freed from under us. See struct mmu_table_batch comments in
-	 * include/asm-generic/tlb.h for more details.
-	 *
-	 * We do not adopt an rcu_read_lock(.) here as we also want to
-	 * block IPIs that come from THPs splitting.
-	 */
-	if (IS_ENABLED(CONFIG_HAVE_FAST_GUP) && gup_fast_permitted(start, end)) {
-		unsigned long fast_flags = gup_flags;
-
-		local_irq_save(flags);
-		gup_pgd_range(addr, end, fast_flags, pages, &nr_pinned);
-		local_irq_restore(flags);
-		ret = nr_pinned;
-	}
-
-	if (nr_pinned < nr_pages && !(gup_flags & FOLL_FAST_ONLY)) {
-		/* Try to get the remaining pages with get_user_pages */
-		start += nr_pinned << PAGE_SHIFT;
-		pages += nr_pinned;
-
-		ret = __gup_longterm_unlocked(start, nr_pages - nr_pinned,
-					      gup_flags, pages);
-
-		/* Have to be a bit careful with return values */
-		if (nr_pinned > 0) {
-			if (ret < 0)
-				ret = nr_pinned;
-			else
-				ret += nr_pinned;
-		}
+	nr_pinned = lockless_pages_from_mm(start, end, gup_flags, pages);
+	if (nr_pinned == nr_pages || gup_flags & FOLL_FAST_ONLY)
+		return nr_pinned;
+
+	/* Slow path: try to get the remaining pages with get_user_pages */
+	start += nr_pinned << PAGE_SHIFT;
+	pages += nr_pinned;
+	ret = __gup_longterm_unlocked(start, nr_pages - nr_pinned, gup_flags,
+				      pages);
+	if (ret < 0) {
+		/*
+		 * The caller has to unpin the pages we already pinned so
+		 * returning -errno is not an option
+		 */
+		if (nr_pinned)
+			return nr_pinned;
+		return ret;
 	}
-
-	return ret;
+	return ret + nr_pinned;
 }
+
 /**
  * get_user_pages_fast_only() - pin user pages in memory
  * @start:      starting user address
_

Patches currently in -mm which might be from jgg@nvidia.com are

mm-gup-use-unpin_user_pages-in-__gup_longterm_locked.patch
mm-reorganize-internal_get_user_pages_fast.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork.patch

