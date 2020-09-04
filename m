Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 743F8C433E2
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 04:49:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47E2A20748
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 04:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599194966;
	bh=24owoGzJwJIQr7JwFGXX0RwfND4VMHGoGB2DwnJd3VE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=HlOKM3O2vy+WSDz7rth+dzrmWlDYRpfCiD00bHI26u0QzsuaatzumBrzo8FlXXjHJ
	 1a/v8P1eIi8wRzRkAo+OVkm737si4Jszdoh+bwH6MseF6UGFqvrYZo1u4JKs0f3Y1l
	 wBwC+CL1TqihhKT4tvFttPpHAX57LUWLmxy8w2ec=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgIDEtZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 00:49:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:45506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbgIDEtZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 00:49:25 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E747206F2;
        Fri,  4 Sep 2020 04:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599194964;
        bh=24owoGzJwJIQr7JwFGXX0RwfND4VMHGoGB2DwnJd3VE=;
        h=Date:From:To:Subject:From;
        b=EfKpSigVbE3kcxE/UPfsn7DSUXh63rTVi70a3OoMZs55fpb4f8nJ4QQryh07JNIZT
         AJ2uixmfx207vdEfJfVQBbpwKwQscJmvOjztfh+bI15THziQPE6NuTx7MH6XlFj8iy
         WSoZdpL/BGDE7ORXiDflmuX9uUcgp5+Ra/8gHrfQ=
Date:   Thu, 03 Sep 2020 21:49:24 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, jglisse@redhat.com, jgg@nvidia.com,
        hch@lst.de, bharata@linux.ibm.com, apopple@nvidia.com,
        rcampbell@nvidia.com
Subject:  +
 mm-migrate-preserve-soft-dirty-in-remove_migration_pte.patch added to -mm
 tree
Message-ID: <20200904044924.RCEUu%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: preserve soft dirty in remove_migration_pte()
has been added to the -mm tree.  Its filename is
     mm-migrate-preserve-soft-dirty-in-remove_migration_pte.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-preserve-soft-dirty-in-remove_migration_pte.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-preserve-soft-dirty-in-remove_migration_pte.patch

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

mm-migrate-remove-unnecessary-is_zone_device_page-check.patch
mm-migrate-preserve-soft-dirty-in-remove_migration_pte.patch
mm-thp-fix-__split_huge_pmd_locked-for-migration-pmd.patch
mm-test-use-the-new-skip-macro.patch
mm-migrate-remove-cpages-in-migrate_vma_finalize.patch
mm-migrate-remove-obsolete-comment-about-device-public.patch

