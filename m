Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8B06C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357381AbiCYBfJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355558AbiCYBeA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:34:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8440BF517
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 505CEB82725
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F1CC340ED;
        Fri, 25 Mar 2022 01:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171942;
        bh=tCkbySPCn0595nVuHdLhAVIwMbmzbA/49GtS7ud2n18=;
        h=Date:To:From:Subject:From;
        b=P26KeLEqXQusvYUgVrOF0tsJC+9uWMYMFSOS7ByKh7yIBNyCFoCDA/gRvVF3lyDW4
         8lPG7MmOzdXWpRDMovyCdzbxWfiqeGyG7ihvf5C9sAOHFIOvCpfvIz+wEff/oGBEaA
         kawuXlUFm5vI8WTnSVXZstpZ139FMpWGP0p/pY4M=
Date:   Thu, 24 Mar 2022 18:32:21 -0700
To:     mm-commits@vger.kernel.org, sourabhjain@linux.ibm.com,
        osalvador@suse.de, mpe@ellerman.id.au, mike.kravetz@oracle.com,
        mahesh@linux.ibm.com, david@redhat.com, hbathini@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] powerpc-fadump-opt-out-from-freeing-pages-on-cma-activation-failure.patch removed from -mm tree
Message-Id: <20220325013221.E6F1CC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/fadump: opt out from freeing pages on cma activation failure
has been removed from the -mm tree.  Its filename was
     powerpc-fadump-opt-out-from-freeing-pages-on-cma-activation-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hari Bathini <hbathini@linux.ibm.com>
Subject: powerpc/fadump: opt out from freeing pages on cma activation failure

With commit a4e92ce8e4c8 ("powerpc/fadump: Reservationless firmware
assisted dump"), Linux kernel's Contiguous Memory Allocator (CMA) based
reservation was introduced in fadump.  That change was aimed at using CMA
to let applications utilize the memory reserved for fadump while blocking
it from being used for kernel pages.  The assumption was, even if CMA
activation fails for whatever reason, the memory still remains reserved to
avoid it from being used for kernel pages.  But commit 072355c1cf2d
("mm/cma: expose all pages to the buddy if activation of an area fails")
breaks this assumption as it started exposing all pages to buddy allocator
on CMA activation failure.  It led to warning messages like below while
running crash-utility on vmcore of a kernel having above two commits:

  crash: seek error: kernel virtual address: <from reserved region>

To fix this problem, opt out from exposing pages to buddy allocator on CMA
activation failure for fadump reserved memory.

Link: https://lkml.kernel.org/r/20220117075246.36072-3-hbathini@linux.ibm.com
Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mahesh Salgaonkar <mahesh@linux.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/fadump.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/powerpc/kernel/fadump.c~powerpc-fadump-opt-out-from-freeing-pages-on-cma-activation-failure
+++ a/arch/powerpc/kernel/fadump.c
@@ -113,6 +113,12 @@ static int __init fadump_cma_init(void)
 	}
 
 	/*
+	 *  If CMA activation fails, keep the pages reserved, instead of
+	 *  exposing them to buddy allocator. Same as 'fadump=nocma' case.
+	 */
+	cma_reserve_pages_on_error(fadump_cma);
+
+	/*
 	 * So we now have successfully initialized cma area for fadump.
 	 */
 	pr_info("Initialized 0x%lx bytes cma area at %ldMB from 0x%lx "
_

Patches currently in -mm which might be from hbathini@linux.ibm.com are


