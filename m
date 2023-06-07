Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A8BFC7EE2F
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 02:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240770AbjFGCiP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jun 2023 22:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240773AbjFGCiB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jun 2023 22:38:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60401731
        for <mm-commits@vger.kernel.org>; Tue,  6 Jun 2023 19:37:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A91462F11
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 02:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE413C433EF;
        Wed,  7 Jun 2023 02:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686105477;
        bh=8B/0UzbSwFUFHeXgl2jqGxnm07DvI0zTlrtJP7qO51M=;
        h=Date:To:From:Subject:From;
        b=2AQWgcmIj0e06W9a7XWdkrC9Gr33leePA7y7cuBB9O/cJ5GU04E1znRjafcvKLoX7
         cCJxrXxLdj57+thWrg1ENT+fQQh6ytViFXF8eRWzpLzuPWfO4tCRUBvr+230s1CWcE
         crjaw698rsxZMB4kzpMkfcQ6Wtv9SYCGsVHoNOrg=
Date:   Tue, 06 Jun 2023 19:37:57 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, urezki@gmail.com,
        mhocko@suse.com, hch@infradead.org, david@redhat.com,
        bhe@redhat.com, lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-do-not-output-a-spurious-warning-when-huge-vmalloc-fails.patch added to mm-unstable branch
Message-Id: <20230607023757.CE413C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: do not output a spurious warning when huge vmalloc() fails
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-do-not-output-a-spurious-warning-when-huge-vmalloc-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-do-not-output-a-spurious-warning-when-huge-vmalloc-fails.patch

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
Subject: mm/vmalloc: do not output a spurious warning when huge vmalloc() fails
Date: Mon, 5 Jun 2023 21:11:07 +0100

In __vmalloc_area_node() we always warn_alloc() when an allocation
performed by vm_area_alloc_pages() fails unless it was due to a pending
fatal signal.

However, huge page allocations instigated either by vmalloc_huge() or
__vmalloc_node_range() (or a caller that invokes this like kvmalloc() or
kvmalloc_node()) always falls back to order-0 allocations if the huge page
allocation fails.

This renders the warning useless and noisy, especially as all callers
appear to be aware that this may fallback.  This has already resulted in
at least one bug report from a user who was confused by this (see link).

Therefore, simply update the code to only output this warning for order-0
pages when no fatal signal is pending.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1211410
Link: https://lkml.kernel.org/r/20230605201107.83298-1-lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-do-not-output-a-spurious-warning-when-huge-vmalloc-fails
+++ a/mm/vmalloc.c
@@ -3149,11 +3149,20 @@ static void *__vmalloc_area_node(struct
 	 * allocation request, free them via vfree() if any.
 	 */
 	if (area->nr_pages != nr_small_pages) {
-		/* vm_area_alloc_pages() can also fail due to a fatal signal */
-		if (!fatal_signal_pending(current))
+		/*
+		 * vm_area_alloc_pages() can fail due to insufficient memory but
+		 * also:-
+		 *
+		 * - a pending fatal signal
+		 * - insufficient huge page-order pages
+		 *
+		 * Since we always retry allocations at order-0 in the huge page
+		 * case a warning for either is spurious.
+		 */
+		if (!fatal_signal_pending(current) && page_order == 0)
 			warn_alloc(gfp_mask, NULL,
-				"vmalloc error: size %lu, page order %u, failed to allocate pages",
-				area->nr_pages * PAGE_SIZE, page_order);
+				"vmalloc error: size %lu, failed to allocate pages",
+				area->nr_pages * PAGE_SIZE);
 		goto fail;
 	}
 
_

Patches currently in -mm which might be from lstoakes@gmail.com are

lib-test_vmallocc-avoid-garbage-in-page-array.patch
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
mm-mmap-refactor-mlock_future_check.patch
mm-vmalloc-dont-purge-usable-blocks-unnecessarily-fix.patch
mm-vmalloc-do-not-output-a-spurious-warning-when-huge-vmalloc-fails.patch

