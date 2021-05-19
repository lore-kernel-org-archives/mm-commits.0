Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83B16C433B4
	for <mm-commits@archiver.kernel.org>; Wed, 19 May 2021 00:07:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6830E60FF1
	for <mm-commits@archiver.kernel.org>; Wed, 19 May 2021 00:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240636AbhESAJF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 May 2021 20:09:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233598AbhESAJE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 May 2021 20:09:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B02996135B;
        Wed, 19 May 2021 00:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621382865;
        bh=2VHb11VGg3zUuQRyrne5i51JMMegDE2AJC+X6FCmrqs=;
        h=Date:From:To:Subject:From;
        b=oa8+3O6fqC9y0S4+L2S4RusgFgIDtMoT9TjHv0tDm7y7b1R75f8c9Z1LiWrsFbcyi
         emFkNfX2zCJ1TfqQb1Quq2jw5PXn1oq4TCn28/p4wMn+XqVkMBK/RFkWc4vaUFpnXW
         YGfANJ5ub0a+ygixJNQsHCpbawCR/ESMeCn5XhX0=
Date:   Tue, 18 May 2021 17:07:45 -0700
From:   akpm@linux-foundation.org
To:     mgorman@techsingularity.net, mm-commits@vger.kernel.org
Subject:  +
 mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix-fix.patch added
 to -mm tree
Message-ID: <20210519000745.Y8UJ4oKlz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: split per cpu page lists and zone stats -fix -fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: split per cpu page lists and zone stats -fix -fix

mm/ is not W=1 clean for make allnoconfig but this patch accidentally made
it worse for i386 with the warning

  mm/vmstat.c: In function `refresh_cpu_vm_stats':
  mm/vmstat.c:785:34: warning: unused variable `pcp' [-Wunused-variable]
     struct per_cpu_pages __percpu *pcp = zone->per_cpu_pageset;
                                    ^~~

This is a second fix to the mmotm patch
mm-page_alloc-split-per-cpu-page-lists-and-zone-stats.patch.

Link: https://lkml.kernel.org/r/20210516140705.GB3735@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/vmstat.c~mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix-fix
+++ a/mm/vmstat.c
@@ -782,7 +782,9 @@ static int refresh_cpu_vm_stats(bool do_
 
 	for_each_populated_zone(zone) {
 		struct per_cpu_zonestat __percpu *pzstats = zone->per_cpu_zonestats;
+#ifdef CONFIG_NUMA
 		struct per_cpu_pages __percpu *pcp = zone->per_cpu_pageset;
+#endif
 
 		for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++) {
 			int v;
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-split-per-cpu-page-lists-and-zone-stats.patch
mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix.patch
mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock.patch
mm-vmstat-convert-numa-statistics-to-basic-numa-counters.patch
mm-vmstat-inline-numa-event-counter-updates.patch
mm-page_alloc-batch-the-accounting-updates-in-the-bulk-allocator.patch
mm-page_alloc-reduce-duration-that-irqs-are-disabled-for-vm-counters.patch
mm-page_alloc-explicitly-acquire-the-zone-lock-in-__free_pages_ok.patch
mm-page_alloc-avoid-conflating-irqs-disabled-with-zone-lock.patch
mm-page_alloc-update-pgfree-outside-the-zone-lock-in-__free_pages_ok.patch

