Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2870FC001DB
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235802AbjHKXFo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236864AbjHKXD5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:03:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A2EF3A99
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DC76631F5
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BB0C433C8;
        Fri, 11 Aug 2023 23:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794926;
        bh=dqYE4179bCSvUzK1wCpcYlP1EdyuuqsBmIWDAMplEqs=;
        h=Date:To:From:Subject:From;
        b=v4T8IARj7Ftsraqh1Cc0rCOJ5e+MflTTtXALrzEtRXbdcTskwBHITwaAj1NL9bP23
         30EoH1YVQ5tdILr23NuIsbfgF1OSiV5+ME5AcoZopF58X60PJAPyJcg8xGw8eNeS3A
         2OGZXcvjQZkfNr8GY0wFb3NYWIsmJh0Lkc4r4i/c=
Date:   Fri, 11 Aug 2023 16:02:05 -0700
To:     mm-commits@vger.kernel.org, zhi.wang.linux@gmail.com,
        will@kernel.org, tvrtko.ursulin@linux.intel.com, sj@kernel.org,
        seanjc@google.com, robin.murphy@arm.com, npiggin@gmail.com,
        nicolinc@nvidia.com, mpe@ellerman.id.au, kevin.tian@intel.com,
        jhubbard@nvidia.com, jgg@ziepe.ca, jgg@nvidia.com,
        fbarrat@linux.ibm.com, chaitanya.kumar.borah@intel.com,
        catalin.marinas@arm.com, ajd@linux.ibm.com, apopple@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmu_notifiers-fixup-comment-in-mmu_interval_read_begin.patch removed from -mm tree
Message-Id: <20230811230206.02BB0C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mmu_notifiers: fixup comment in mmu_interval_read_begin()
has been removed from the -mm tree.  Its filename was
     mmu_notifiers-fixup-comment-in-mmu_interval_read_begin.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


