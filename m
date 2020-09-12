Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF6E4C433E2
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 16:24:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CF5F2083E
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 16:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599927891;
	bh=FiL9jwMN50h8NqXpwNO4P2u5WHlCjUtLkpUz19wm5VY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=yIGkKhIpeWa9HFl0B0YdQ+khr5e7NNPZFkSGbywEPHj1kgT8FN+nQR46Rn+CDoQuY
	 btlSU5e0WbOjT12ccRTjyfz+QpF+mk7IY/PyiNvQ2wAa2kNf+fw8bhyRGm55yvyo8Q
	 HzGsu0wiCWE2DbCbLMR68NVzqLAZ+2shHU+tVeQo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbgILQYr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 12:24:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725888AbgILQYE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 12:24:04 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6163E2087C;
        Sat, 12 Sep 2020 16:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599927844;
        bh=FiL9jwMN50h8NqXpwNO4P2u5WHlCjUtLkpUz19wm5VY=;
        h=Date:From:To:Subject:From;
        b=TLOllqN8558mOZQCaraHGGq0ZleRoBN2sJxpksiiouJ2U8YfFQ9hrPVlh6sgBnFgB
         nS/LdMUPOXgLwPNeNMYHaz8FAQGql41UrGDkXqaPOzjpEza//liaC88Shg4meQ9uQJ
         y2wCKN018MmZm3wR5+438n35aGECPpXbGuQlH0wY=
Date:   Sat, 12 Sep 2020 09:24:04 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, bharata@linux.ibm.com, hch@lst.de,
        jgg@nvidia.com, jglisse@redhat.com, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com
Subject:  [merged]
 mm-migrate-remove-unnecessary-is_zone_device_page-check.patch removed from
 -mm tree
Message-ID: <20200912162404.UwxvHamDf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: remove unnecessary is_zone_device_page() check
has been removed from the -mm tree.  Its filename was
     mm-migrate-remove-unnecessary-is_zone_device_page-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-thp-fix-__split_huge_pmd_locked-for-migration-pmd.patch
mm-test-use-the-new-skip-macro.patch
mm-migrate-remove-cpages-in-migrate_vma_finalize.patch
mm-migrate-remove-obsolete-comment-about-device-public.patch

