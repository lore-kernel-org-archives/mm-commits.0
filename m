Return-Path: <SRS0=f579=BK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E95EC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CA1422B42
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596227108;
	bh=Bk4xd110hLqd0kLUNch1orBzAGVcZILQcRBIKdDZfgQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=FVJakHiETBfSp8PEcVW90oE1WftdATJ+jd+7NichQue4BSIsjcwzxkzBd88bbjTav
	 MYQCGAVa5ivtSDkrBu59v6rMkwbQeJzht/JVLDwodvihKAbVTxOzaqybQKLZ1tKuuA
	 wfBAAA+WQIalhijEeYqMOotWRVOYRLiCPef2jQZg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725767AbgGaUZH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 31 Jul 2020 16:25:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727032AbgGaUZH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jul 2020 16:25:07 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF54C2087C;
        Fri, 31 Jul 2020 20:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596227106;
        bh=Bk4xd110hLqd0kLUNch1orBzAGVcZILQcRBIKdDZfgQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AkjH4s1l6XCSOBh2N02m68VX+ZqPBW2lYLzLaF/HLWZiB3AojKnBeT/jT5YsG8Z3D
         zTq98ynTbq3iYalaxyZElmTfIhBZourNyttRQmhjVnpqXaXmBMpc0QKTcG1vbX3GlE
         lbxpORIMrYa9kZb/AEphTwN4vkL8fhtX/4OmPOp4=
Date:   Fri, 31 Jul 2020 13:25:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org
Subject:  +
 mm-migrate-make-a-standard-migration-target-allocation-function-fix.patch
 added to -mm tree
Message-ID: <20200731202506.76Cgofl7k%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-migrate-make-a-standard-migration-target-allocation-function-fix
has been added to the -mm tree.  Its filename is
     mm-migrate-make-a-standard-migration-target-allocation-function-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-make-a-standard-migration-target-allocation-function-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-make-a-standard-migration-target-allocation-function-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-migrate-make-a-standard-migration-target-allocation-function-fix

fix typoe in comment

Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/hugetlb.h~mm-migrate-make-a-standard-migration-target-allocation-function-fix
+++ a/include/linux/hugetlb.h
@@ -705,7 +705,7 @@ static inline gfp_t htlb_modify_alloc_ma
 {
 	gfp_t modified_mask = htlb_alloc_mask(h);
 
-	/* Some callers might want to enfoce node */
+	/* Some callers might want to enforce node */
 	modified_mask |= (gfp_mask & __GFP_THISNODE);
 
 	return modified_mask;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-fix-kthread_use_mm-vs-tlb-invalidate-fix.patch
mm.patch
mm-handle-page-mapping-better-in-dump_page-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-thp-replace-http-links-with-https-ones-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-migrate-make-a-standard-migration-target-allocation-function-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

