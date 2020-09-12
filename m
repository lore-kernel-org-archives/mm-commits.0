Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A420C433E2
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 16:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0734C2083E
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 16:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599927895;
	bh=G+cRBEMRkdkptnurY2P6TvN2a2nDZDPL4wn3fycs7PA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=CZuSoc3N5QLTdjMpx92E90zWun7zMRnHmf7bwcub3fOpX2z/ORwgm2i8aMqT+/prH
	 22U+/Fhr51xC9oum3eeZTwdRtK5IqzHbuBaeGiIRBX26wDDQ19rakNE6C0HYnZfjJQ
	 JlsF9Pint4T71nplj/U1x7+431m6E9599JxGU20U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgILQYt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 12:24:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbgILQYH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 12:24:07 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B4B82083E;
        Sat, 12 Sep 2020 16:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599927846;
        bh=G+cRBEMRkdkptnurY2P6TvN2a2nDZDPL4wn3fycs7PA=;
        h=Date:From:To:Subject:From;
        b=nbv3IPDYzkzFGbMAr+hLCxON7cwrig0dDJ17VDSPVBUuKZ98ygsC+IY93cjbI0juW
         qttCzpUuOMSADVoC3JDFhilvBaOQ7Bnfs5DIVkudpTbsnLukJ8sdkaeFfxqs28VeJg
         lCTD4TXq2YfNhks4GIjjcr0SvQI9BQFXeRl6Rips=
Date:   Sat, 12 Sep 2020 09:24:06 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, bharata@linux.ibm.com, hch@lst.de,
        jgg@nvidia.com, jglisse@redhat.com, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com
Subject:  [merged]
 mm-migrate-preserve-soft-dirty-in-remove_migration_pte.patch removed from
 -mm tree
Message-ID: <20200912162406.YmgBWMWkb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: preserve soft dirty in remove_migration_pte()
has been removed from the -mm tree.  Its filename was
     mm-migrate-preserve-soft-dirty-in-remove_migration_pte.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/migrate: preserve soft dirty in remove_migration_pte()

The code to remove a migration PTE and replace it with a device private
PTE was not copying the soft dirty bit from the migration entry.  This
could lead to page contents not being marked dirty when faulting the page
back from device private memory.

Link: https://lkml.kernel.org/r/20200831212222.22409-3-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bharata B Rao <bharata@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/migrate.c~mm-migrate-preserve-soft-dirty-in-remove_migration_pte
+++ a/mm/migrate.c
@@ -249,6 +249,8 @@ static bool remove_migration_pte(struct
 		if (unlikely(is_device_private_page(new))) {
 			entry = make_device_private_entry(new, pte_write(pte));
 			pte = swp_entry_to_pte(entry);
+			if (pte_swp_soft_dirty(*pvmw.pte))
+				pte = pte_swp_mksoft_dirty(pte);
 			if (pte_swp_uffd_wp(*pvmw.pte))
 				pte = pte_swp_mkuffd_wp(pte);
 		}
_

Patches currently in -mm which might be from rcampbell@nvidia.com are

mm-thp-fix-__split_huge_pmd_locked-for-migration-pmd.patch
mm-test-use-the-new-skip-macro.patch
mm-migrate-remove-cpages-in-migrate_vma_finalize.patch
mm-migrate-remove-obsolete-comment-about-device-public.patch

