Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BEC1C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 18:09:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36DF561077
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 18:09:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbhJRSLT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Oct 2021 14:11:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229696AbhJRSLT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 Oct 2021 14:11:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC81A60F44;
        Mon, 18 Oct 2021 18:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634580548;
        bh=gHc4knVVhBdGa9cT+0+chJjFCU1Pw9rCoq/ghOYUPoM=;
        h=Date:From:To:Subject:From;
        b=VO9QbxbffhIkzSup9kfBoId6krpIx17Ujt6OGMrW6AsQVwWahpETMOPyQxxHnwNNa
         k0YqagtpEe1z/JS16EkH4DFAkeu0Zkk9Y4bBFTjDOF2ebXTiwZ6fPtKqOeOHXuJPir
         GJBLvRFjpLOMfaSj/L3gteccnx1Aqpxn8TeXamxo=
Date:   Mon, 18 Oct 2021 11:09:07 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, jglisse@redhat.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com
Subject:  +
 mm-rmapc-avoid-double-faults-migrating-device-private-pages.patch added to
 -mm tree
Message-ID: <20211018180907.9sYSO2r4w%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap.c: avoid double faults migrating device private pages
has been added to the -mm tree.  Its filename is
     mm-rmapc-avoid-double-faults-migrating-device-private-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rmapc-avoid-double-faults-migrating-device-private-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rmapc-avoid-double-faults-migrating-device-private-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/rmap.c: avoid double faults migrating device private pages

During migration special page table entries are installed for each page
being migrated.  These entries store the pfn and associated permissions of
ptes mapping the page being migarted.

Device-private pages use special swap pte entries to distinguish read-only
vs.  writeable pages which the migration code checks when creating
migration entries.  Normally this follows a fast path in
migrate_vma_collect_pmd() which correctly copies the permissions of
device-private pages over to migration entries when migrating pages back
to the CPU.

However the slow-path falls back to using try_to_migrate() which
unconditionally creates read-only migration entries for device-private
pages.  This leads to unnecessary double faults on the CPU as the new
pages are always mapped read-only even when they could be mapped
writeable.  Fix this by correctly copying device-private permissions in
try_to_migrate_one().

Link: https://lkml.kernel.org/r/20211018045247.3128058-1-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reported-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/rmap.c~mm-rmapc-avoid-double-faults-migrating-device-private-pages
+++ a/mm/rmap.c
@@ -1807,6 +1807,7 @@ static bool try_to_migrate_one(struct pa
 		update_hiwater_rss(mm);
 
 		if (is_zone_device_page(page)) {
+			unsigned long pfn = page_to_pfn(page);
 			swp_entry_t entry;
 			pte_t swp_pte;
 
@@ -1815,8 +1816,11 @@ static bool try_to_migrate_one(struct pa
 			 * pte. do_swap_page() will wait until the migration
 			 * pte is removed and then restart fault handling.
 			 */
-			entry = make_readable_migration_entry(
-							page_to_pfn(page));
+			entry = pte_to_swp_entry(pteval);
+			if (is_writable_device_private_entry(entry))
+				entry = make_writable_migration_entry(pfn);
+			else
+				entry = make_readable_migration_entry(pfn);
 			swp_pte = swp_entry_to_pte(entry);
 
 			/*
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-rmapc-avoid-double-faults-migrating-device-private-pages.patch

