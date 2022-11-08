Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72BACC4332F
	for <mm-commits@archiver.kernel.org>; Tue,  8 Nov 2022 21:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiKHV7w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 16:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiKHV7v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 16:59:51 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C0521E19
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 13:59:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 70766CE1CF9
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 21:59:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D403C433D6;
        Tue,  8 Nov 2022 21:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667944786;
        bh=rzr8o7W8NN7LgALNnnSGbG4YrbEB9aQdmdS++whVf5A=;
        h=Date:To:From:Subject:From;
        b=GFBIW4hW/U85pCX4mpHPb9XrBw3ozn4KaWivGg0urbZmFr5DwUDglewo+XdBD0aWt
         na4mwWmQleEcmR0GdYhRW7LEkAyi9Tb09kR6RVeOM8krMIHCiGh88Sne54V4OAM6Ko
         sNiukLgSNkD6taP7af1fFTW5X9k3gnL08mB/SY5k=
Date:   Tue, 08 Nov 2022 13:59:46 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        torvalds@linux-foundation.org, rppt@kernel.org, peterx@redhat.com,
        npiggin@gmail.com, mpe@ellerman.id.au, mgorman@techsingularity.net,
        hughd@google.com, david@redhat.com, david@fromorbit.com,
        anshuman.khandual@arm.com, aarcange@redhat.com, namit@vmware.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-allow-clean-exclusive-anon-pages-to-be-writable.patch added to mm-unstable branch
Message-Id: <20221108215946.9D403C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mprotect: allow clean exclusive anon pages to be writable
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mprotect-allow-clean-exclusive-anon-pages-to-be-writable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mprotect-allow-clean-exclusive-anon-pages-to-be-writable.patch

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

In any case, such an optimiztion will then not be autonuma-specific, but
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

mm-mprotect-allow-clean-exclusive-anon-pages-to-be-writable.patch

