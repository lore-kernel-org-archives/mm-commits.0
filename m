Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41AEAC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jun 2022 19:38:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbiFXTis (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jun 2022 15:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbiFXTiq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2022 15:38:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432315DC1C
        for <mm-commits@vger.kernel.org>; Fri, 24 Jun 2022 12:38:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC9C46221C
        for <mm-commits@vger.kernel.org>; Fri, 24 Jun 2022 19:38:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30AECC34114;
        Fri, 24 Jun 2022 19:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656099523;
        bh=8kRPfh0idhtM9m+75M5mtNJzd9LkPfRVpRGvGtrxfu4=;
        h=Date:To:From:Subject:From;
        b=XS3jIBlw1z4x97mkSg91caienWLBkTR3+IrtE8qKF6EHyiwohK1UGjhDI37QD3vo6
         jg94UiIX8bXpe3Y7DIAB/Zbysmuo7B94/hGSCoqMLAIkOcFFZng2zZe5isApR/z2AT
         HahyWes69tCMY1SQ0A/n49ENjSE78LSf9Jt+z2D8=
Date:   Fri, 24 Jun 2022 12:38:42 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        hch@lst.de, apopple@nvidia.com, alex.sierra@amd.com,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-fix-dereferencing-invalid-subpage-pointer-in-try_to_migrate_one.patch added to mm-hotfixes-unstable branch
Message-Id: <20220624193843.30AECC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: fix dereferencing invalid subpage pointer in try_to_migrate_one()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-rmap-fix-dereferencing-invalid-subpage-pointer-in-try_to_migrate_one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-fix-dereferencing-invalid-subpage-pointer-in-try_to_migrate_one.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: fix dereferencing invalid subpage pointer in try_to_migrate_one()
Date: Thu, 23 Jun 2022 22:53:32 +0200

The subpage we calculate is an invalid pointer for device private pages,
because device private pages are mapped via non-present device private
entries, not ordinary present PTEs.

Let's just not compute broken pointers and fixup later.  Move the proper
assignment of the correct subpage to the beginning of the function and
assert that we really only have a single page in our folio.

This currently results in a BUG when tying to compute anon_exclusive,
because:

[  528.727237] BUG: unable to handle page fault for address: ffffea1fffffffc0
[  528.739585] #PF: supervisor read access in kernel mode
[  528.745324] #PF: error_code(0x0000) - not-present page
[  528.751062] PGD 44eaf2067 P4D 44eaf2067 PUD 0
[  528.756026] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  528.760890] CPU: 120 PID: 18275 Comm: hmm-tests Not tainted 5.19.0-rc3-kfd-alex #257
[  528.769542] Hardware name: AMD Corporation BardPeak/BardPeak, BIOS RTY1002BDS 09/17/2021
[  528.778579] RIP: 0010:try_to_migrate_one+0x21a/0x1000
[  528.784225] Code: f6 48 89 c8 48 2b 05 45 d1 6a 01 48 c1 f8 06 48 29
c3 48 8b 45 a8 48 c1 e3 06 48 01 cb f6 41 18 01 48 89 85 50 ff ff ff 74
0b <4c> 8b 33 49 c1 ee 11 41 83 e6 01 48 8b bd 48 ff ff ff e8 3f 99 02
[  528.805194] RSP: 0000:ffffc90003cdfaa0 EFLAGS: 00010202
[  528.811027] RAX: 00007ffff7ff4000 RBX: ffffea1fffffffc0 RCX: ffffeaffffffffc0
[  528.818995] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90003cdfaf8
[  528.826962] RBP: ffffc90003cdfb70 R08: 0000000000000000 R09: 0000000000000000
[  528.834930] R10: ffffc90003cdf910 R11: 0000000000000002 R12: ffff888194450540
[  528.842899] R13: ffff888160d057c0 R14: 0000000000000000 R15: 03ffffffffffffff
[  528.850865] FS:  00007ffff7fdb740(0000) GS:ffff8883b0600000(0000) knlGS:0000000000000000
[  528.859891] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  528.866308] CR2: ffffea1fffffffc0 CR3: 00000001562b4003 CR4: 0000000000770ee0
[  528.874275] PKRU: 55555554
[  528.877286] Call Trace:
[  528.880016]  <TASK>
[  528.882356]  ? lock_is_held_type+0xdf/0x130
[  528.887033]  rmap_walk_anon+0x167/0x410
[  528.891316]  try_to_migrate+0x90/0xd0
[  528.895405]  ? try_to_unmap_one+0xe10/0xe10
[  528.900074]  ? anon_vma_ctor+0x50/0x50
[  528.904260]  ? put_anon_vma+0x10/0x10
[  528.908347]  ? invalid_mkclean_vma+0x20/0x20
[  528.913114]  migrate_vma_setup+0x5f4/0x750
[  528.917691]  dmirror_devmem_fault+0x8c/0x250 [test_hmm]
[  528.923532]  do_swap_page+0xac0/0xe50
[  528.927623]  ? __lock_acquire+0x4b2/0x1ac0
[  528.932199]  __handle_mm_fault+0x949/0x1440
[  528.936876]  handle_mm_fault+0x13f/0x3e0
[  528.941256]  do_user_addr_fault+0x215/0x740
[  528.945928]  exc_page_fault+0x75/0x280
[  528.950115]  asm_exc_page_fault+0x27/0x30
[  528.954593] RIP: 0033:0x40366b
...

Link: https://lkml.kernel.org/r/20220623205332.319257-1-david@redhat.com
Fixes: 6c287605fd56 ("mm: remember exclusively mapped anonymous pages with PG_anon_exclusive")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Tested-by: Alistair Popple <apopple@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- a/mm/rmap.c~mm-rmap-fix-dereferencing-invalid-subpage-pointer-in-try_to_migrate_one
+++ a/mm/rmap.c
@@ -1899,8 +1899,23 @@ static bool try_to_migrate_one(struct fo
 		/* Unexpected PMD-mapped THP? */
 		VM_BUG_ON_FOLIO(!pvmw.pte, folio);
 
-		subpage = folio_page(folio,
-				pte_pfn(*pvmw.pte) - folio_pfn(folio));
+		if (folio_is_zone_device(folio)) {
+			/*
+			 * Our PTE is a non-present device exclusive entry and
+			 * calculating the subpage as for the common case would
+			 * result in an invalid pointer.
+			 *
+			 * Since only PAGE_SIZE pages can currently be
+			 * migrated, just set it to page. This will need to be
+			 * changed when hugepage migrations to device private
+			 * memory are supported.
+			 */
+			VM_BUG_ON_FOLIO(folio_nr_pages(folio) > 1, folio);
+			subpage = &folio->page;
+		} else {
+			subpage = folio_page(folio,
+					pte_pfn(*pvmw.pte) - folio_pfn(folio));
+		}
 		address = pvmw.address;
 		anon_exclusive = folio_test_anon(folio) &&
 				 PageAnonExclusive(subpage);
@@ -1993,15 +2008,7 @@ static bool try_to_migrate_one(struct fo
 			/*
 			 * No need to invalidate here it will synchronize on
 			 * against the special swap migration pte.
-			 *
-			 * The assignment to subpage above was computed from a
-			 * swap PTE which results in an invalid pointer.
-			 * Since only PAGE_SIZE pages can currently be
-			 * migrated, just set it to page. This will need to be
-			 * changed when hugepage migrations to device private
-			 * memory are supported.
 			 */
-			subpage = &folio->page;
 		} else if (PageHWPoison(subpage)) {
 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
 			if (folio_test_hugetlb(folio)) {
_

Patches currently in -mm which might be from david@redhat.com are

mm-rmap-fix-dereferencing-invalid-subpage-pointer-in-try_to_migrate_one.patch
mm-mprotect-try-avoiding-write-faults-for-exclusive-anonymous-pages-when-changing-protection.patch

