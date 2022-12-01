Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92214C47089
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:03:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiLAADw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbiLAACa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:02:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066D58B19E
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8116B81D12
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB30C433D6;
        Thu,  1 Dec 2022 00:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852867;
        bh=ug9BO6H5tSgBW3Ju/1jy9gdBe01mfA+SrGVgLDqcbYg=;
        h=Date:To:From:Subject:From;
        b=Lw4Lx1NoIEnYYqcNKIM3x0/LkyrhUTcKhp/z9/x3St4m9+nlEU+lYeOvXBsYCaJ8H
         rhjrG9FCaoWlcFE4zJLIm7ApX79U1KL2F3PrX3O+J+WFoCQp1qty+CqYMUZ2srqKDW
         JHBrowq/ATNt9xbq3Y1HVq1Gll+4LiHCsxFwm8Ko=
Date:   Wed, 30 Nov 2022 16:01:06 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        torvalds@linux-foundation.org, rppt@kernel.org, peterx@redhat.com,
        npiggin@gmail.com, mpe@ellerman.id.au, mgorman@techsingularity.net,
        hughd@google.com, david@redhat.com, david@fromorbit.com,
        anshuman.khandual@arm.com, aarcange@redhat.com, namit@vmware.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mprotect-allow-clean-exclusive-anon-pages-to-be-writable.patch removed from -mm tree
Message-Id: <20221201000107.5AB30C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mprotect: allow clean exclusive anon pages to be writable
has been removed from the -mm tree.  Its filename was
     mm-mprotect-allow-clean-exclusive-anon-pages-to-be-writable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nadav Amit <namit@vmware.com>
Subject: mm/mprotect: allow clean exclusive anon pages to be writable
Date: Tue, 8 Nov 2022 18:46:46 +0100

Patch series "mm/autonuma: replace savedwrite infrastructure", v2.

As discussed in my talk at LPC, we can reuse the same mechanism for
deciding whether to map a pte writable when upgrading permissions via
mprotect() -- e.g., PROT_READ -> PROT_READ|PROT_WRITE -- to replace the
savedwrite infrastructure used for NUMA hinting faults (e.g., PROT_NONE ->
PROT_READ|PROT_WRITE).

Instead of maintaining previous write permissions for a pte/pmd, we
re-determine if the pte/pmd can be writable.  The big benefit is that we
have a common logic for deciding whether we can map a pte/pmd writable on
protection changes.

For private mappings, there should be no difference -- from what I
understand, that is what autonuma benchmarks care about.

I ran autonumabench for v1 on a system with 2 NUMA nodes, 96 GiB each via:
	perf stat --null --repeat 10
The numa01 benchmark is quite noisy in my environment and I failed to
reduce the noise so far.

numa01:
	mm-unstable:   146.88 +- 6.54 seconds time elapsed  ( +-  4.45% )
	mm-unstable++: 147.45 +- 13.39 seconds time elapsed  ( +-  9.08% )

numa02:
	mm-unstable:   16.0300 +- 0.0624 seconds time elapsed  ( +-  0.39% )
	mm-unstable++: 16.1281 +- 0.0945 seconds time elapsed  ( +-  0.59% )

It is worth noting that for shared writable mappings that require
writenotify, we will only avoid write faults if the pte/pmd is dirty
(inherited from the older mprotect logic).  If we ever care about
optimizing that further, we'd need a different mechanism to identify
whether the FS still needs to get notified on the next write access.

In any case, such an optimization will then not be autonuma-specific, but
mprotect() permission upgrades would similarly benefit from it.


This patch (of 7):

Anonymous pages might have the dirty bit clear, but this should not
prevent mprotect from making them writable if they are exclusive. 
Therefore, skip the test whether the page is dirty in this case.

Note that there are already other ways to get a writable PTE mapping an
anonymous page that is clean: for example, via MADV_FREE.  In an ideal
world, we'd have a different indication from the FS whether writenotify is
still required.

[david@redhat.com: return directly; update description]
Link: https://lkml.kernel.org/r/20221108174652.198904-1-david@redhat.com
Link: https://lkml.kernel.org/r/20221108174652.198904-2-david@redhat.com
Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/mprotect.c~mm-mprotect-allow-clean-exclusive-anon-pages-to-be-writable
+++ a/mm/mprotect.c
@@ -46,7 +46,7 @@ static inline bool can_change_pte_writab
 
 	VM_BUG_ON(!(vma->vm_flags & VM_WRITE) || pte_write(pte));
 
-	if (pte_protnone(pte) || !pte_dirty(pte))
+	if (pte_protnone(pte))
 		return false;
 
 	/* Do we need write faults for softdirty tracking? */
@@ -65,11 +65,10 @@ static inline bool can_change_pte_writab
 		 * the PT lock.
 		 */
 		page = vm_normal_page(vma, addr, pte);
-		if (!page || !PageAnon(page) || !PageAnonExclusive(page))
-			return false;
+		return page && PageAnon(page) && PageAnonExclusive(page);
 	}
 
-	return true;
+	return pte_dirty(pte);
 }
 
 static unsigned long change_pte_range(struct mmu_gather *tlb,
_

Patches currently in -mm which might be from namit@vmware.com are


