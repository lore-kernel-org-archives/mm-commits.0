Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04C66C7618E
	for <mm-commits@archiver.kernel.org>; Fri, 21 Apr 2023 21:53:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbjDUVxU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Apr 2023 17:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233742AbjDUVwv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Apr 2023 17:52:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B015B1BD6
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 14:52:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8446465316
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 21:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A59C4339B;
        Fri, 21 Apr 2023 21:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682113967;
        bh=/bA+7wL6d3U2IQLWLqRYCJK3tAklGw9PUAwZ8agN3Z4=;
        h=Date:To:From:Subject:From;
        b=ZlBAXtzG7fRh8NtWsmWFsO4xO31+sHvfO23wSXJCVSGtDQ3apyx/tZC25+8Njhyxf
         eGaVkqg4HKBmTjoC/eEsd7fKizWxFqgItjnmOLoger0Jb/nhkCoYyPjFE+b/x68d2y
         VtD0GIDq3sUJ8ghCgAK0Q51Bq7DZwPgDYGekUPXk=
Date:   Fri, 21 Apr 2023 14:52:47 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        mgorman@techsingularity.net, kirill.shutemov@linux.intel.com,
        apopple@nvidia.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-dont-check-vma-write-permissions-if-the-pte-pmd-indicates-write-permissions.patch removed from -mm tree
Message-Id: <20230421215247.D8A59C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: don't check VMA write permissions if the PTE/PMD indicates write permissions
has been removed from the -mm tree.  Its filename was
     mm-dont-check-vma-write-permissions-if-the-pte-pmd-indicates-write-permissions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: don't check VMA write permissions if the PTE/PMD indicates write permissions
Date: Tue, 18 Apr 2023 16:21:13 +0200

Staring at the comment "Recheck VMA as permissions can change since
migration started" in remove_migration_pte() can result in confusion,
because if the source PTE/PMD indicates write permissions, then there
should be no need to check VMA write permissions when restoring migration
entries or PTE-mapping a PMD.

Commit d3cb8bf6081b ("mm: migrate: Close race between migration completion
and mprotect") introduced the maybe_mkwrite() handling in
remove_migration_pte() in 2014, stating that a race between mprotect() and
migration finishing would be possible, and that we could end up with a
writable PTE that should be readable.

However, mprotect() code first updates vma->vm_flags / vma->vm_page_prot
and then walks the page tables to (a) set all present writable PTEs to
read-only and (b) convert all writable migration entries to readable
migration entries.  While walking the page tables and modifying the
entries, migration code has to grab the PT locks to synchronize against
concurrent page table modifications.

Assuming migration would find a writable migration entry (while holding
the PT lock) and replace it with a writable present PTE, surely mprotect()
code didn't stumble over the writable migration entry yet (converting it
into a readable migration entry) and would instead wait for the PT lock to
convert the now present writable PTE into a read-only PTE.  As mprotect()
didn't finish yet, the behavior is just like migration didn't happen: a
writable PTE will be converted to a read-only PTE.

So it's fine to rely on the writability information in the source PTE/PMD
and not recheck against the VMA as long as we're holding the PT lock to
synchronize with anyone who concurrently wants to downgrade write
permissions (like mprotect()) by first adjusting vma->vm_flags /
vma->vm_page_prot to then walk over the page tables to adjust the page
table entries.

Running test cases that should reveal such races -- mprotect(PROT_READ)
racing with page migration or THP splitting -- for multiple hours did not
reveal an issue with this cleanup.

Link: https://lkml.kernel.org/r/20230418142113.439494-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 mm/migrate.c     |    5 +----
 2 files changed, 3 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-dont-check-vma-write-permissions-if-the-pte-pmd-indicates-write-permissions
+++ a/mm/huge_memory.c
@@ -2234,7 +2234,7 @@ static void __split_huge_pmd_locked(stru
 		} else {
 			entry = mk_pte(page + i, READ_ONCE(vma->vm_page_prot));
 			if (write)
-				entry = maybe_mkwrite(entry, vma);
+				entry = pte_mkwrite(entry);
 			if (anon_exclusive)
 				SetPageAnonExclusive(page + i);
 			if (!young)
@@ -3271,7 +3271,7 @@ void remove_migration_pmd(struct page_vm
 	if (pmd_swp_soft_dirty(*pvmw->pmd))
 		pmde = pmd_mksoft_dirty(pmde);
 	if (is_writable_migration_entry(entry))
-		pmde = maybe_pmd_mkwrite(pmde, vma);
+		pmde = pmd_mkwrite(pmde);
 	if (pmd_swp_uffd_wp(*pvmw->pmd))
 		pmde = pmd_mkuffd_wp(pmde);
 	if (!is_migration_entry_young(entry))
--- a/mm/migrate.c~mm-dont-check-vma-write-permissions-if-the-pte-pmd-indicates-write-permissions
+++ a/mm/migrate.c
@@ -213,16 +213,13 @@ static bool remove_migration_pte(struct
 		if (pte_swp_soft_dirty(*pvmw.pte))
 			pte = pte_mksoft_dirty(pte);
 
-		/*
-		 * Recheck VMA as permissions can change since migration started
-		 */
 		entry = pte_to_swp_entry(*pvmw.pte);
 		if (!is_migration_entry_young(entry))
 			pte = pte_mkold(pte);
 		if (folio_test_dirty(folio) && is_migration_entry_dirty(entry))
 			pte = pte_mkdirty(pte);
 		if (is_writable_migration_entry(entry))
-			pte = maybe_mkwrite(pte, vma);
+			pte = pte_mkwrite(pte);
 		else if (pte_swp_uffd_wp(*pvmw.pte))
 			pte = pte_mkuffd_wp(pte);
 
_

Patches currently in -mm which might be from david@redhat.com are


