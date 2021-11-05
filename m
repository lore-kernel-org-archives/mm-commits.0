Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AAC1C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:43:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E589161357
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233714AbhKEUps (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:45:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233648AbhKEUps (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:45:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FACF61351;
        Fri,  5 Nov 2021 20:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144988;
        bh=WOVh97OTdGCAQNLoT+0RB6o5sJyaUskNsPPKcjdv91Y=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZBdyRlzE+tDCzJUVU+Y1MAz6wl7B6dsaoROHbE2zUiINFnkTqf52lmM1Fd8U9XKSR
         0P9iL4wvz5RDQnnurEFChIIsteGb4cx4JS6oJMgpKseISesyaV+BDf68TGKJj5EPfl
         9lwWIBDs+K4epUz2qiwvOkb7ROOLxkv0M/v1JLfk=
Date:   Fri, 05 Nov 2021 13:43:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, christophe.leroy@csgroup.eu,
        jgross@suse.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, Shahab.Vahedi@synopsys.com,
        torvalds@linux-foundation.org
Subject:  [patch 162/262] arch_numa: simplify numa_distance
 allocation
Message-ID: <20211105204307.tnUYssaTr%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: arch_numa: simplify numa_distance allocation

Patch series "memblock: cleanup memblock_free interface", v2.

This is the fix for memblock freeing APIs mismatch [1].

The first patch is a cleanup of numa_distance allocation in arch_numa I've
spotted during the conversion.  The second patch is a fix for Xen memory
freeing on some of the error paths.

[1] https://lore.kernel.org/all/CAHk-=wj9k4LZTz+svCxLYs5Y1=+yKrbAUArH1+ghyG3OLd8VVg@mail.gmail.com


This patch (of 6):

Memory allocation of numa_distance uses memblock_phys_alloc_range()
without actual range limits, converts the returned physical address to
virtual and then only uses the virtual address for further initialization.

Simplify this by replacing memblock_phys_alloc_range() with
memblock_alloc().

Link: https://lkml.kernel.org/r/20210930185031.18648-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20210930185031.18648-2-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Juergen Gross <jgross@suse.com>
Cc: Shahab Vahedi <Shahab.Vahedi@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/arch_numa.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/base/arch_numa.c~arch_numa-simplify-numa_distance-allocation
+++ a/drivers/base/arch_numa.c
@@ -337,15 +337,13 @@ void __init numa_free_distance(void)
 static int __init numa_alloc_distance(void)
 {
 	size_t size;
-	u64 phys;
 	int i, j;
 
 	size = nr_node_ids * nr_node_ids * sizeof(numa_distance[0]);
-	phys = memblock_phys_alloc_range(size, PAGE_SIZE, 0, PFN_PHYS(max_pfn));
-	if (WARN_ON(!phys))
+	numa_distance = memblock_alloc(size, PAGE_SIZE);
+	if (WARN_ON(!numa_distance))
 		return -ENOMEM;
 
-	numa_distance = __va(phys);
 	numa_distance_cnt = nr_node_ids;
 
 	/* fill with the default distances */
_
