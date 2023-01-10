Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD31BC54EBD
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 00:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjAJA7g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Jan 2023 19:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjAJA7f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2023 19:59:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE1640852
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 16:59:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4C96BCE1147
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 00:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB8FC433D2;
        Tue, 10 Jan 2023 00:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673312371;
        bh=X0gzYLrtB1g7DK8F2fEI07kPFtT2Osj08C5SDzbh008=;
        h=Date:To:From:Subject:From;
        b=ZE0k9+IeoUuLGhheC3C+1tVBvFTAC5rJ4K3mLU3ZkGAy6EKqsFAQjM48ejkpLv9q9
         +MotcgXod7L/glrXhzrv3n7WHnq3qYuW+m/BF+my79QWJrwsGNfp5ie1ZXGcQg+E2m
         GxRHPGe6+Q5Zi+dydoGZS62hVMQIWUrLgZMdTfi0=
Date:   Mon, 09 Jan 2023 16:59:30 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org, rcampbell@nvidia.com,
        mike.kravetz@oracle.com, jhubbard@nvidia.com, jglisse@redhat.com,
        jgg@nvidia.com, ira.weiny@intel.com, hch@lst.de,
        apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmu_notifier-remove-unused-mmu_notifier_range_update_to_read_only-export.patch added to mm-unstable branch
Message-Id: <20230110005931.2EB8FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmu_notifier: remove unused mmu_notifier_range_update_to_read_only export
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmu_notifier-remove-unused-mmu_notifier_range_update_to_read_only-export.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmu_notifier-remove-unused-mmu_notifier_range_update_to_read_only-export.patch

This patch will later appear in the mm-unstable branch at
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
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/mmu_notifier: remove unused mmu_notifier_range_update_to_read_only export
Date: Mon, 9 Jan 2023 12:22:07 +1100

mmu_notifier_range_update_to_read_only() was originally introduced in
commit c6d23413f81b ("mm/mmu_notifier:
mmu_notifier_range_update_to_read_only() helper") as an optimisation for
device drivers that know a range has only been mapped read-only.  However
there are no users of this feature so remove it.  As it is the only user
of the struct mmu_notifier_range.vma field remove that also.

Link: https://lkml.kernel.org/r/20230109012207.79457-1-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |    2 --
 mm/mmu_notifier.c            |   10 ----------
 2 files changed, 12 deletions(-)

--- a/include/linux/mmu_notifier.h~mm-mmu_notifier-remove-unused-mmu_notifier_range_update_to_read_only-export
+++ a/include/linux/mmu_notifier.h
@@ -269,7 +269,6 @@ extern struct lockdep_map __mmu_notifier
 #endif
 
 struct mmu_notifier_range {
-	struct vm_area_struct *vma;
 	struct mm_struct *mm;
 	unsigned long start;
 	unsigned long end;
@@ -519,7 +518,6 @@ static inline void mmu_notifier_range_in
 					   unsigned long start,
 					   unsigned long end)
 {
-	range->vma = vma;
 	range->event = event;
 	range->mm = mm;
 	range->start = start;
--- a/mm/mmu_notifier.c~mm-mmu_notifier-remove-unused-mmu_notifier_range_update_to_read_only-export
+++ a/mm/mmu_notifier.c
@@ -1120,13 +1120,3 @@ void mmu_notifier_synchronize(void)
 	synchronize_srcu(&srcu);
 }
 EXPORT_SYMBOL_GPL(mmu_notifier_synchronize);
-
-bool
-mmu_notifier_range_update_to_read_only(const struct mmu_notifier_range *range)
-{
-	if (!range->vma || range->event != MMU_NOTIFY_PROTECTION_VMA)
-		return false;
-	/* Return true if the vma still have the read flag set. */
-	return range->vma->vm_flags & VM_READ;
-}
-EXPORT_SYMBOL_GPL(mmu_notifier_range_update_to_read_only);
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-mmu_notifier-remove-unused-mmu_notifier_range_update_to_read_only-export.patch

