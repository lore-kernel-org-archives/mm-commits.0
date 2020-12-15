Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13958C35296
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB0C222DD6
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgLOX71 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:32844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728325AbgLOXXd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:23:33 -0500
Date:   Tue, 15 Dec 2020 15:21:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074518;
        bh=ZNlWIVW+UbviuzrZift8qtOmo6PlOozm20hDDSdHwJI=;
        h=From:To:Subject:From;
        b=m1278R47JLHDmzgDjY1r0j6DzSry/k0/UIWEltkqngNsN9qNvvhIMlvNxgMJvmL5H
         jU7A98Z8iiVj0obKpYg/WTNOLiChxD5g3FeuEHkaDgxdz69PcO225CMaXSAbnmBUxm
         /etj1IJ+ayrx3IZFGMtVj8p6vibE8IltuhQVP7kI=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, zou_wei@huawei.com
Subject:  [merged]
 mm-page_alloc-mark-some-symbols-with-static-keyword.patch removed from -mm
 tree
Message-ID: <20201215232158.11jT5dYo1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: mark some symbols with static keyword
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-mark-some-symbols-with-static-keyword.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zou Wei <zou_wei@huawei.com>
Subject: mm/page_alloc: mark some symbols with static keyword

Fix the following sparse warnings:

mm/page_alloc.c:3040:6: warning: symbol '__drain_all_pages' was not declared. Should it be static?
mm/page_alloc.c:6349:6: warning: symbol '__zone_set_pageset_high_and_batch' was not declared. Should it be static?

Link: https://lkml.kernel.org/r/1605517365-65858-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-mark-some-symbols-with-static-keyword
+++ a/mm/page_alloc.c
@@ -3035,7 +3035,7 @@ static void drain_local_pages_wq(struct
  * that need the guarantee that every CPU has drained can disable the
  * optimizing racy check.
  */
-void __drain_all_pages(struct zone *zone, bool force_all_cpus)
+static void __drain_all_pages(struct zone *zone, bool force_all_cpus)
 {
 	int cpu;
 
@@ -6357,7 +6357,7 @@ static void pageset_init(struct per_cpu_
 	pcp->batch = BOOT_PAGESET_BATCH;
 }
 
-void __zone_set_pageset_high_and_batch(struct zone *zone, unsigned long high,
+static void __zone_set_pageset_high_and_batch(struct zone *zone, unsigned long high,
 		unsigned long batch)
 {
 	struct per_cpu_pageset *p;
_

Patches currently in -mm which might be from zou_wei@huawei.com are

lib-ubsanc-mark-type_check_kinds-with-static-keyword.patch

