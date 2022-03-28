Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98902C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 23:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiC1XP3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 19:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbiC1XP2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 19:15:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5D71EEFE
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 16:13:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E510660F08
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 23:13:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42EEAC340ED;
        Mon, 28 Mar 2022 23:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648509226;
        bh=5A6TPrI7/UUyCZ6Mv/44HVTLnKpq5Ppeuo/LPNoQQIA=;
        h=Date:To:From:Subject:From;
        b=M652uViL1tki9F96ALMVx9JcMGMRYh6Qo4hF8N26n/NdpJbXRdmx6x0xjoSFyjr9F
         Qh9fe+DZt7LEE9ptuS5zFFGRy+9YhsHPttx3TZtSlk67bErlYlJIl1/nXoB17o7Ktb
         lcV7Pm8xIT3KKVTbfDRq3r3aEWdcLBzSD4IWYPTI=
Date:   Mon, 28 Mar 2022 16:13:45 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        mike.kravetz@oracle.com, david@redhat.com, maobibo@loongson.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-sched-to-numa-node-when-collapse-huge-page.patch added to -mm tree
Message-Id: <20220328231346.42EEAC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: sched to numa node when collapse huge page
has been added to the -mm tree.  Its filename is
     mm-khugepaged-sched-to-numa-node-when-collapse-huge-page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-khugepaged-sched-to-numa-node-when-collapse-huge-page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-khugepaged-sched-to-numa-node-when-collapse-huge-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-khugepaged-sched-to-numa-node-when-collapse-huge-page.patch

