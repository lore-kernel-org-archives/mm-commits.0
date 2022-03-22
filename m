Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48546C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236491AbiCVVsQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236402AbiCVVsH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:48:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB015FF1A
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:46:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B078B6100A
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC70C340EC;
        Tue, 22 Mar 2022 21:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985578;
        bh=rVcXrpMApCnqbgK4FnFZ6aZ0OghhdBHDhXCnJqs3fYI=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=mM9yP7B55z3rV7AECvjzPz28YcUlLU/2X/Vz+4F+KqAeAE41tEsyvKR1YVlDPAFTw
         Cj1j1hNqOqbHCrMkCKI5CjhUO8FluGDwe2dQDyFAw7a8IYP1gKfa6ilD/zS2BMMnlh
         LWjIwyNxlQdmA3puTLc6Dknwnvj9YeR4k/TSqw8E=
Date:   Tue, 22 Mar 2022 14:46:17 -0700
To:     sourabhjain@linux.ibm.com, osalvador@suse.de, mpe@ellerman.id.au,
        mike.kravetz@oracle.com, mahesh@linux.ibm.com, david@redhat.com,
        hbathini@linux.ibm.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 153/227] powerpc/fadump: opt out from freeing pages on cma activation failure
Message-Id: <20220322214618.0DC70C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
