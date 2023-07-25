Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EF3CC41513
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jul 2023 17:39:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbjGYRjy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jul 2023 13:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjGYRjx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jul 2023 13:39:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24483193
        for <mm-commits@vger.kernel.org>; Tue, 25 Jul 2023 10:39:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8ABCE61839
        for <mm-commits@vger.kernel.org>; Tue, 25 Jul 2023 17:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE04DC433C7;
        Tue, 25 Jul 2023 17:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690306791;
        bh=Zwyu797fQBUL8c9pLlm8pBmLyxdyp0QXn7rv6nihSeI=;
        h=Date:To:From:Subject:From;
        b=BDxEMSVgiiKLwI++Rwv7JTIxlC/Iw6TnzjvVkdfY12h0Rn17AToF1SgtQmnNZ9jDn
         QvB3pF/enT2UGImUV498sAAQpSUXyNkY8EIi3VSqKSkTyz0R7ZE54cThN0FVwbZ8+6
         lpIS8D6AJz8zYBjcQkdm23KN33uXRZ4e5UdGcDvE=
Date:   Tue, 25 Jul 2023 10:39:50 -0700
To:     mm-commits@vger.kernel.org, zhi.wang.linux@gmail.com,
        will@kernel.org, tvrtko.ursulin@linux.intel.com, sj@kernel.org,
        seanjc@google.com, robin.murphy@arm.com, npiggin@gmail.com,
        nicolinc@nvidia.com, mpe@ellerman.id.au, kevin.tian@intel.com,
        jhubbard@nvidia.com, jgg@ziepe.ca, jgg@nvidia.com,
        fbarrat@linux.ibm.com, chaitanya.kumar.borah@intel.com,
        catalin.marinas@arm.com, ajd@linux.ibm.com, apopple@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmu_notifiers-fixup-comment-in-mmu_interval_read_begin.patch added to mm-unstable branch
Message-Id: <20230725173950.DE04DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmu_notifiers: fixup comment in mmu_interval_read_begin()
has been added to the -mm mm-unstable branch.  Its filename is
     mmu_notifiers-fixup-comment-in-mmu_interval_read_begin.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmu_notifiers-fixup-comment-in-mmu_interval_read_begin.patch

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
Subject: mmu_notifiers: fixup comment in mmu_interval_read_begin()
Date: Tue, 25 Jul 2023 23:42:04 +1000

The comment in mmu_interval_read_begin() refers to a function that doesn't
exist and uses the wrong call-back name.  The op for mmu interval
notifiers is mmu_interval_notifier_ops->invalidate() so fix the comment up
to reflect that.

Link: https://lkml.kernel.org/r/e7a09081b3ac82a03c189409f1262fc2df91071e.1690292440.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Cc: Frederic Barrat <fbarrat@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zhi Wang <zhi.wang.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_notifier.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mmu_notifier.c~mmu_notifiers-fixup-comment-in-mmu_interval_read_begin
+++ a/mm/mmu_notifier.c
@@ -199,7 +199,7 @@ mmu_interval_read_begin(struct mmu_inter
 	 * invalidate_start/end and is colliding.
 	 *
 	 * The locking looks broadly like this:
-	 *   mn_tree_invalidate_start():          mmu_interval_read_begin():
+	 *   mn_itree_inv_start():                 mmu_interval_read_begin():
 	 *                                         spin_lock
 	 *                                          seq = READ_ONCE(interval_sub->invalidate_seq);
 	 *                                          seq == subs->invalidate_seq
@@ -207,7 +207,7 @@ mmu_interval_read_begin(struct mmu_inter
 	 *    spin_lock
 	 *     seq = ++subscriptions->invalidate_seq
 	 *    spin_unlock
-	 *     op->invalidate_range():
+	 *     op->invalidate():
 	 *       user_lock
 	 *        mmu_interval_set_seq()
 	 *         interval_sub->invalidate_seq = seq
_

Patches currently in -mm which might be from apopple@nvidia.com are

arm64-smmu-use-tlbi-asid-when-invalidating-entire-range.patch
mmu_notifiers-fixup-comment-in-mmu_interval_read_begin.patch
mmu_notifiers-call-invalidate_range-when-invalidating-tlbs.patch
mmu_notifiers-dont-invalidate-secondary-tlbs-as-part-of-mmu_notifier_invalidate_range_end.patch
mmu_notifiers-rename-invalidate_range-notifier.patch

