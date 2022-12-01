Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A350C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:03:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbiLAADw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbiLAACa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:02:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBBF189AED
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66CC56176C
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1FBC433B5;
        Thu,  1 Dec 2022 00:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852868;
        bh=3+zi/Znr22mZ8urtl/2c5QNRGTwyZjSnmoynuJCwvx4=;
        h=Date:To:From:Subject:From;
        b=QAq3pLiqyenNhu7hHmV5mzBdL2owUqw0IOglVsBxISyOLErTUWArnRo1kgajCKkxN
         +v0PpxwlSfcIQnDHOVvmUO6ATTy9XUL/ewIKzeaM2lyiVnerE6tRQKkqiUbYR6z3B0
         j44URerBG3ImslZis6FoH34xO2vFj6LRhZhJPClA=
Date:   Wed, 30 Nov 2022 16:01:07 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        torvalds@linux-foundation.org, rppt@kernel.org, peterx@redhat.com,
        npiggin@gmail.com, namit@vmware.com, mpe@ellerman.id.au,
        mgorman@techsingularity.net, hughd@google.com, david@fromorbit.com,
        anshuman.khandual@arm.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mprotect-minor-can_change_pte_writable-cleanups.patch removed from -mm tree
Message-Id: <20221201000108.AA1FBC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mprotect: minor can_change_pte_writable() cleanups
has been removed from the -mm tree.  Its filename was
     mm-mprotect-minor-can_change_pte_writable-cleanups.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/mprotect: minor can_change_pte_writable() cleanups
Date: Tue, 8 Nov 2022 18:46:47 +0100

We want to replicate this code for handling PMDs soon.

(1) No need to crash the kernel, warning and rejecting is good enough. As
    this will no longer get optimized out, drop the pte_write() check: no
    harm would be done.

(2) Add a comment why PROT_NONE mapped pages are excluded.

(3) Add a comment regarding MAP_SHARED handling and why we rely on the
    dirty bit in the PTE.

Link: https://lkml.kernel.org/r/20221108174652.198904-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nadav Amit <namit@vmware.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/mm/mprotect.c~mm-mprotect-minor-can_change_pte_writable-cleanups
+++ a/mm/mprotect.c
@@ -44,8 +44,10 @@ static inline bool can_change_pte_writab
 {
 	struct page *page;
 
-	VM_BUG_ON(!(vma->vm_flags & VM_WRITE) || pte_write(pte));
+	if (WARN_ON_ONCE(!(vma->vm_flags & VM_WRITE)))
+		return false;
 
+	/* Don't touch entries that are not even readable. */
 	if (pte_protnone(pte))
 		return false;
 
@@ -59,15 +61,22 @@ static inline bool can_change_pte_writab
 
 	if (!(vma->vm_flags & VM_SHARED)) {
 		/*
-		 * We can only special-case on exclusive anonymous pages,
-		 * because we know that our write-fault handler similarly would
-		 * map them writable without any additional checks while holding
-		 * the PT lock.
+		 * Writable MAP_PRIVATE mapping: We can only special-case on
+		 * exclusive anonymous pages, because we know that our
+		 * write-fault handler similarly would map them writable without
+		 * any additional checks while holding the PT lock.
 		 */
 		page = vm_normal_page(vma, addr, pte);
 		return page && PageAnon(page) && PageAnonExclusive(page);
 	}
 
+	/*
+	 * Writable MAP_SHARED mapping: "clean" might indicate that the FS still
+	 * needs a real write-fault for writenotify
+	 * (see vma_wants_writenotify()). If "dirty", the assumption is that the
+	 * FS was already notified and we can simply mark the PTE writable
+	 * just like the write-fault handler would do.
+	 */
 	return pte_dirty(pte);
 }
 
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch

