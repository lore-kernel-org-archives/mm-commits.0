Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B1B0C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:45:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FBF66136F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbhKEUrl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:47:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233504AbhKEUrl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:47:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD0916136A;
        Fri,  5 Nov 2021 20:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145101;
        bh=idL0yaFmY8TUVLDiAyvWIBsNSZtEO/ZbWdvGTnAYvG0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=purpFdKL9jSqV02q7QhJHpwT0YC5oCFkTXmung7fTYtGKZHYzQ1pVIictLj0G/lkQ
         ZU5ZGPVQfGfAcMEFffMIJWv/lWkzfjtctuUFlWyNg2KqStBY/EBJwGQY+BHI/VCRfy
         ndP7edNlym1wYtEfn6zniON96q11mVjIKTOe5jpA=
Date:   Fri, 05 Nov 2021 13:45:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apopple@nvidia.com, jglisse@redhat.com,
        jhubbard@nvidia.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com,
        torvalds@linux-foundation.org
Subject:  [patch 197/262] mm/rmap.c: avoid double faults migrating
 device private pages
Message-ID: <20211105204500.E7gZ9uZtc%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
