Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C49DC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BF6121775
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881358;
	bh=g4nYD1L1+5kNFHkOlwQnOXX8l7EclaWZa34WPVPHO4g=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=CDYJ+SDF426L5ddIL5+38iRC1GzctE0FnRk49s5SP0XYLiQSZcxs9sn6NWXPvsjM/
	 WaIv38nhUv6MF+rgoQD7vQ3vbnD0DVs+1N+mv/S4ek+LBNwBq/TpXi+BSMxhz3wMCv
	 6dU1LOp3UHcepwB6ShFlrl7rq8Z7wr60EjW9EczA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391541AbgJPUtR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:49:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:38340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391060AbgJPUtR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:49:17 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5406216C4;
        Fri, 16 Oct 2020 20:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881356;
        bh=g4nYD1L1+5kNFHkOlwQnOXX8l7EclaWZa34WPVPHO4g=;
        h=Date:From:To:Subject:From;
        b=2kUauR9wpxBQRTcNGNGtPwb0R4HHo8b94xaHvb5MiNnGnMFcZFV590gPj+EjJFkgb
         bhFNGTXudVtUjW0S6wFpcruPBFWj25iLHYHvLyfFhin46IdsJZQxLzuyc7xkpGsMBf
         ToRNJU/OHpZutCvnATduD2wb/lO0LD/PUQqorfjc=
Date:   Fri, 16 Oct 2020 13:49:15 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
        aris@ruivo.org, cai@lca.pw, dave.hansen@intel.com,
        david@redhat.com, mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.com, osalvador@suse.de, tony.luck@intel.com,
        zeil@yandex-team.ru
Subject:  [merged] mmhwpoison-cleanup-unused-pagehuge-check.patch
 removed from -mm tree
Message-ID: <20201016204915.hXMrfGvCN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: cleanup unused PageHuge() check
has been removed from the -mm tree.  Its filename was
     mmhwpoison-cleanup-unused-pagehuge-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm,hwpoison: cleanup unused PageHuge() check

Patch series "HWPOISON: soft offline rework", v7.

This patchset fixes a couple of issues that the patchset Naoya sent [1]
contained due to rebasing problems and a misunterdansting.

Main focus of this series is to stabilize soft offline.  Historically soft
offlined pages have suffered from racy conditions because PageHWPoison is
used to a little too aggressively, which (directly or indirectly) invades
other mm code which cares little about hwpoison.  This results in
unexpected behavior or kernel panic, which is very far from soft offline's
"do not disturb userspace or other kernel component" policy.  An example
of this can be found here [2].

Along with several cleanups, this code refactors and changes the way soft
offline work.  Main point of this change set is to contain target page
"via buddy allocator" or in migrating path.  For ther former we first free
the target page as we do for normal pages, and once it has reached buddy
and it has been taken off the freelists, we flag it as HWpoison.  For the
latter we never get to release the page in unmap_and_move, so the page is
under our control and we can handle it in hwpoison code.

[1] https://patchwork.kernel.org/cover/11704083/
[2] https://lore.kernel.org/linux-mm/20190826104144.GA7849@linux/T/#u


This patch (of 14):

Drop the PageHuge check, which is dead code since memory_failure() forks
into memory_failure_hugetlb() for hugetlb pages.

memory_failure() and memory_failure_hugetlb() shares some functions like
hwpoison_user_mappings() and identify_page_state(), so they should
properly handle 4kB page, thp, and hugetlb.

Link: https://lkml.kernel.org/r/20200922135650.1634-1-osalvador@suse.de
Link: https://lkml.kernel.org/r/20200922135650.1634-2-osalvador@suse.de
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Qian Cai <cai@lca.pw>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Aristeu Rozanski <aris@ruivo.org>
Cc: Oscar Salvador <osalvador@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-cleanup-unused-pagehuge-check
+++ a/mm/memory-failure.c
@@ -1381,10 +1381,7 @@ int memory_failure(unsigned long pfn, in
 	 * page_remove_rmap() in try_to_unmap_one(). So to determine page status
 	 * correctly, we save a copy of the page flags at this time.
 	 */
-	if (PageHuge(p))
-		page_flags = hpage->flags;
-	else
-		page_flags = p->flags;
+	page_flags = p->flags;
 
 	/*
 	 * unpoison always clear PG_hwpoison inside page lock
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are


