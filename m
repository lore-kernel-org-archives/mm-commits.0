Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46515C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:33:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12E6F20731
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:33:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727271AbgLODGY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:06:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:34316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbgLODGX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:06:23 -0500
Date:   Mon, 14 Dec 2020 19:05:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001542;
        bh=o4wCxhKw4UDYzXo+2WFu+ixaBfuUhSb+S6TYZhgzCHA=;
        h=From:To:Subject:In-Reply-To:From;
        b=nZJKCDijGXM29l+ypaXAMIYq2USuBnSUCfXOtF5Loe2Awbkaj+55zn8CJ/5uzG0yJ
         QUbwvS68gxIDUIAoXE7wXq+qfmxOED9KTVDYqxpX/1nm52gFR392IVaMn5wkXysQ3d
         7T/zMz5n03HwMbMjL+qf4AJVZul0xabGYKyR+1Jw=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jack@suse.cz, jgg@nvidia.com,
        jhubbard@nvidia.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        torvalds@linux-foundation.org
Subject:  [patch 043/200] mm/gup: reorganize
 internal_get_user_pages_fast()
Message-ID: <20201215030541.cG0zYz8N3%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>
Subject: mm/gup: reorganize internal_get_user_pages_fast()

Patch series "Add a seqcount between gup_fast and copy_page_range()", v4.

As discussed and suggested by Linus use a seqcount to close the small race
between gup_fast and copy_page_range().

Ahmed confirms that raw_write_seqcount_begin() is the correct API to use
in this case and it doesn't trigger any lockdeps.

I was able to test it using two threads, one forking and the other using
ibv_reg_mr() to trigger GUP fast.  Modifying copy_page_range() to sleep
made the window large enough to reliably hit to test the logic.


This patch (of 2):

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

Link: https://lkml.kernel.org/r/0-v4-908497cf359a+4782-gup_fork_jgg@nvidia.com
Link: https://lkml.kernel.org/r/1-v4-908497cf359a+4782-gup_fork_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
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
