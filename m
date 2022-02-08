Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B639C4167D
	for <mm-commits@archiver.kernel.org>; Tue,  8 Feb 2022 22:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386336AbiBHWZo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:25:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387095AbiBHVyN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Feb 2022 16:54:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ABE5C0612BC
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 13:54:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C471614EB
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 21:54:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBAB9C004E1;
        Tue,  8 Feb 2022 21:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644357251;
        bh=8uTcGAW8eiKC1h+v9qilhpIMk8tfoid71KwsJ5v5cM8=;
        h=Date:To:From:Subject:From;
        b=Q4Fn0tAHrnBzQVnKv34cRs5CX3T9w8gS4TVN2eTUzSLik0N/xNIGKi9QrtiDdsQ5Y
         vHlE460J708RJVYkvY5MOMPB4jw5RdY0n7ZPQNOdtdW8te+adoZbpeD/ksn2Te7Pkx
         KEDyqSdb8GG5B3mViZAk56xiy7hwihqNuCYwYNJk=
Date:   Tue, 08 Feb 2022 13:54:10 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, surenb@google.com, shakeelb@google.com,
        riel@surriel.com, mhocko@suse.com, kirill@shutemov.name,
        hannes@cmpxchg.org, gthelen@google.com, david@redhat.com,
        apopple@nvidia.com, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-munlock-page-migration-needs-mlock-pagevec-drained.patch added to -mm tree
Message-Id: <20220208215410.DBAB9C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/munlock: page migration needs mlock pagevec drained
has been added to the -mm tree.  Its filename is
     mm-munlock-page-migration-needs-mlock-pagevec-drained.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-munlock-page-migration-needs-mlock-pagevec-drained.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-munlock-page-migration-needs-mlock-pagevec-drained.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/munlock: page migration needs mlock pagevec drained

Page migration of a VM_LOCKED page tends to fail, because when the old
page is unmapped, it is put on the mlock pagevec with raised refcount,
which then fails the freeze.

At first I thought this would be fixed by a local mlock_page_drain() at
the upper rmap_walk() level - which would have nicely batched all the
munlocks of that page; but tests show that the task can too easily move to
another cpu, leaving pagevec residue behind which fails the migration.

So try_to_migrate_one() drain the local pagevec after page_remove_rmap()
from a VM_LOCKED vma; and do the same in try_to_unmap_one(), whose
TTU_IGNORE_MLOCK users would want the same treatment; and do the same in
remove_migration_pte() - not important when successfully inserting a new
page, but necessary when hoping to retry after failure.

Any new pagevec runs the risk of adding a new way of stranding, and we
might discover other corners where mlock_page_drain() or lru_add_drain()
would now help.  If the mlock pagevec raises doubts, we can easily add a
sysctl to tune its length to 1, which reverts to synchronous operation.

Link: https://lkml.kernel.org/r/90c8962-d188-8687-dc70-628293316343@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 ++
 mm/rmap.c    |    4 ++++
 2 files changed, 6 insertions(+)

--- a/mm/migrate.c~mm-munlock-page-migration-needs-mlock-pagevec-drained
+++ a/mm/migrate.c
@@ -251,6 +251,8 @@ static bool remove_migration_pte(struct
 				page_add_file_rmap(new, vma, false);
 			set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
 		}
+		if (vma->vm_flags & VM_LOCKED)
+			mlock_page_drain(smp_processor_id());
 
 		trace_remove_migration_pte(pvmw.address, pte_val(pte),
 					   compound_order(new));
--- a/mm/rmap.c~mm-munlock-page-migration-needs-mlock-pagevec-drained
+++ a/mm/rmap.c
@@ -1681,6 +1681,8 @@ discard:
 		 * See Documentation/vm/mmu_notifier.rst
 		 */
 		page_remove_rmap(subpage, vma, PageHuge(page));
+		if (vma->vm_flags & VM_LOCKED)
+			mlock_page_drain(smp_processor_id());
 		put_page(page);
 	}
 
@@ -1959,6 +1961,8 @@ static bool try_to_migrate_one(struct pa
 		 * See Documentation/vm/mmu_notifier.rst
 		 */
 		page_remove_rmap(subpage, vma, PageHuge(page));
+		if (vma->vm_flags & VM_LOCKED)
+			mlock_page_drain(smp_processor_id());
 		put_page(page);
 	}
 
_

Patches currently in -mm which might be from hughd@google.com are

mm-munlock-delete-page_mlock-and-all-its-works.patch
mm-munlock-delete-foll_mlock-and-foll_populate.patch
mm-munlock-delete-munlock_vma_pages_all-allow-oomreap.patch
mm-munlock-rmap-call-mlock_vma_page-munlock_vma_page.patch
mm-munlock-replace-clear_page_mlock-by-final-clearance.patch
mm-munlock-maintain-page-mlock_count-while-unevictable.patch
mm-munlock-mlock_pte_range-when-mlocking-or-munlocking.patch
mm-migrate-__unmap_and_move-push-good-newpage-to-lru.patch
mm-munlock-delete-smp_mb-from-__pagevec_lru_add_fn.patch
mm-munlock-mlock_page-munlock_page-batch-by-pagevec.patch
mm-munlock-page-migration-needs-mlock-pagevec-drained.patch
mm-thp-collapse_file-do-try_to_unmapttu_batch_flush.patch
mm-thp-shrink_page_list-avoid-splitting-vm_locked-thp.patch

