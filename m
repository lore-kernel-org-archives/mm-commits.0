Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0B9DC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 00:36:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiEMAgi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 20:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359742AbiEMAgh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 20:36:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADFC2ED74
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 17:36:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D64A8B82910
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 00:36:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973D4C385B8;
        Fri, 13 May 2022 00:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652402193;
        bh=zgE7thef0LOmsUbZa7WrxAMDMHvmxsagfpIPVNTs56A=;
        h=Date:To:From:Subject:From;
        b=EWT0pOykYgGdBwS01wkHsI6kgLCavf1Qz/9lA1EJsrN/xqXre2xoGJisOSatSxJjz
         8++fQ6MhGIM6Nxj5V8PcRGzW1sXi2DUHdpXmT2aOJ0cftPpeFUPbJeav2EBSyQLmnj
         vuOOqZ5PcCgFnaYi+zS2x9iIvqAH1dEmuqro2ayE=
Date:   Thu, 12 May 2022 17:36:32 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        mike.kravetz@oracle.com, david@redhat.com, maobibo@loongson.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-sched-to-numa-node-when-collapse-huge-page.patch removed from -mm tree
Message-Id: <20220513003633.973D4C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: sched to numa node when collapse huge page
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-sched-to-numa-node-when-collapse-huge-page.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Bibo Mao <maobibo@loongson.cn>
Subject: mm/khugepaged: sched to numa node when collapse huge page

Collapsing a huge page will copy huge page from general small pages, dest
node is calculated from most one of source pages, however THP daemon is
not scheduled on dest node.  The performance may be poor since huge page
copying across nodes, also cache is not used for target node.  With this
patch, khugepaged daemon switches to the same numa node with huge page. 
It saves copying time and makes use of local cache better.

With this patch, specint 2006 base performance is improved with 6% on
Loongson 3C5000L platform with 32 cores and 8 numa nodes.

Link: https://lkml.kernel.org/r/20220317065024.2635069-1-maobibo@loongson.cn
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Cc: David Hildenbrand <david@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/khugepaged.c~mm-khugepaged-sched-to-numa-node-when-collapse-huge-page
+++ a/mm/khugepaged.c
@@ -1055,6 +1055,7 @@ static void collapse_huge_page(struct mm
 	struct vm_area_struct *vma;
 	struct mmu_notifier_range range;
 	gfp_t gfp;
+	const struct cpumask *cpumask;
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
@@ -1068,6 +1069,13 @@ static void collapse_huge_page(struct mm
 	 * that. We will recheck the vma after taking it again in write mode.
 	 */
 	mmap_read_unlock(mm);
+
+	/* sched to specified node before huage page memory copy */
+	if (task_node(current) != node) {
+		cpumask = cpumask_of_node(node);
+		if (!cpumask_empty(cpumask))
+			set_cpus_allowed_ptr(current, cpumask);
+	}
 	new_page = khugepaged_alloc_page(hpage, gfp, node);
 	if (!new_page) {
 		result = SCAN_ALLOC_HUGE_PAGE_FAIL;
_

Patches currently in -mm which might be from maobibo@loongson.cn are


