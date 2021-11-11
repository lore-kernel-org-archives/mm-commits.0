Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23D89C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:47:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0951661884
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234421AbhKKCuj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:50:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234428AbhKKCuj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:50:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A59F61361;
        Thu, 11 Nov 2021 02:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598870;
        bh=qZ5lLFXkluIGRzYRS6xn+hCN7kxSE0qu52vUbCOx0UQ=;
        h=Date:From:To:Subject:From;
        b=I4007y9TbRje+n2p5HLhg3eMPsZCNH17JV/bs6DH0vMNW0nceg2UW68/yTyPbfDTz
         IlPYFdvq0Y74gV/tVdynvmw9hh2v0s0ibHjL3pJfdtgdGqZYmaEUWFgxJec+ZRWe7D
         CaaDV8WXOfZfJjX9/6DT4kOh5DWy+Kk0w0dP4a6w=
Date:   Wed, 10 Nov 2021 18:47:50 -0800
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, jglisse@redhat.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com
Subject:  [merged]
 mm-rmapc-avoid-double-faults-migrating-device-private-pages.patch removed
 from -mm tree
Message-ID: <20211111024750.V9GfRmfXD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap.c: avoid double faults migrating device private pages
has been removed from the -mm tree.  Its filename was
     mm-rmapc-avoid-double-faults-migrating-device-private-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-migratec-remove-migrate_pfn_locked.patch

