Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAD24C43461
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 04:49:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE0F620748
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 04:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599194964;
	bh=s+Q/+rKLEIdVxUhSAO9NjpNa0wEzYrWFbRPULWdCBXg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=mMXAWgRK2oh8+Q0Nzex5NpjIsqBYhx5m+9Nf3sKSh53ExPGwFuNFm5B5piJ5aVEMK
	 EqqVjF01N3b3zY02T7pq9Jqyys4ZJ4Tzrile8rF9NbjB0sI30L4nahh4WIzRztRyg6
	 Mx4j+Tl9tMn7o7BFECFeesUOxZ/BjLfhSFnClLXE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgIDEtY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 00:49:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbgIDEtX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 00:49:23 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8F26206E7;
        Fri,  4 Sep 2020 04:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599194963;
        bh=s+Q/+rKLEIdVxUhSAO9NjpNa0wEzYrWFbRPULWdCBXg=;
        h=Date:From:To:Subject:From;
        b=kLi06W6vemy5iv1hOnSBc/7XN6/lzy4IEOvlltpGEludMkMUNyJzzKpG9J8ZunO2P
         EG6XR+5zmbNJsmlXfvuU7wZXoHR8Rxj6sUY/zjjiTHMIcY6rnrDU7zKAowOMEB5A0r
         SXJqW3nYBtOS6Yib+bHvIc/5OUaYGkurrhAFyNwU=
Date:   Thu, 03 Sep 2020 21:49:22 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, jglisse@redhat.com, jgg@nvidia.com,
        hch@lst.de, bharata@linux.ibm.com, apopple@nvidia.com,
        rcampbell@nvidia.com
Subject:  +
 mm-migrate-remove-unnecessary-is_zone_device_page-check.patch added to -mm
 tree
Message-ID: <20200904044922.UHrRk%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: remove unnecessary is_zone_device_page() check
has been added to the -mm tree.  Its filename is
     mm-migrate-remove-unnecessary-is_zone_device_page-check.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-remove-unnecessary-is_zone_device_page-check.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-remove-unnecessary-is_zone_device_page-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/migrate: remove unnecessary is_zone_device_page() check

Patch series "mm/migrate: preserve soft dirty in remove_migration_pte()".

I happened to notice this from code inspection after seeing Alistair
Popple's patch ("mm/rmap: Fixup copying of soft dirty and uffd ptes").


This patch (of 2):

The check for is_zone_device_page() and is_device_private_page() is
unnecessary since the latter is sufficient to determine if the page is a
device private page.  Simplify the code for easier reading.

Link: https://lkml.kernel.org/r/20200831212222.22409-1-rcampbell@nvidia.com
Link: https://lkml.kernel.org/r/20200831212222.22409-2-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bharata B Rao <bharata@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/mm/migrate.c~mm-migrate-remove-unnecessary-is_zone_device_page-check
+++ a/mm/migrate.c
@@ -246,13 +246,11 @@ static bool remove_migration_pte(struct
 		else if (pte_swp_uffd_wp(*pvmw.pte))
 			pte = pte_mkuffd_wp(pte);
 
-		if (unlikely(is_zone_device_page(new))) {
-			if (is_device_private_page(new)) {
-				entry = make_device_private_entry(new, pte_write(pte));
-				pte = swp_entry_to_pte(entry);
-				if (pte_swp_uffd_wp(*pvmw.pte))
-					pte = pte_swp_mkuffd_wp(pte);
-			}
+		if (unlikely(is_device_private_page(new))) {
+			entry = make_device_private_entry(new, pte_write(pte));
+			pte = swp_entry_to_pte(entry);
+			if (pte_swp_uffd_wp(*pvmw.pte))
+				pte = pte_swp_mkuffd_wp(pte);
 		}
 
 #ifdef CONFIG_HUGETLB_PAGE
_

Patches currently in -mm which might be from rcampbell@nvidia.com are

mm-migrate-remove-unnecessary-is_zone_device_page-check.patch
mm-migrate-preserve-soft-dirty-in-remove_migration_pte.patch
mm-thp-fix-__split_huge_pmd_locked-for-migration-pmd.patch
mm-test-use-the-new-skip-macro.patch
mm-migrate-remove-cpages-in-migrate_vma_finalize.patch
mm-migrate-remove-obsolete-comment-about-device-public.patch

