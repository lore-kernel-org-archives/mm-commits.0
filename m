Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C22AC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:43:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D80C3208E4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816204;
	bh=YGNafOn8zidjdGtkdrrWBzRspeXsofiMpYa2wxxSoss=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=WXPjKdr6r5V1esFOUVnxL1emviYRObGc1YkvVdb2wsIoYNo0PTzaX1Xi4RWSnHVcl
	 mFFhsl/BIgnL3qk4GyRIl78HRtAZPbGq9dIjlIco8fTvS/gDo/4CSPRz4FzVoyO3mh
	 OhbU5UdWuFEPtr++37E+cQQLIeGf+mrb6Nr3ruxw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393821AbgJPCnY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:43:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730617AbgJPCnY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:43:24 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D02D62087D;
        Fri, 16 Oct 2020 02:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816203;
        bh=YGNafOn8zidjdGtkdrrWBzRspeXsofiMpYa2wxxSoss=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=el73+9vSDmtxICxV2taZtRIb+mkAqb64TQXs6100FxBInjb8pTqJ2YKfehotnjY/f
         ihBONbqjnbjWzy0di8Pjf7yBFlmQhGNDPrfU9lQjYS4Fm87mRMy7SAKpwzmLBzIW/L
         AKorwN7uzvzfhw+jIFZKKoS8qqnF+2c8oT5v2vZo=
Date:   Thu, 15 Oct 2020 19:43:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, aris@ruivo.org, cai@lca.pw,
        dave.hansen@intel.com, david@redhat.com, linux-mm@kvack.org,
        mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.com, osalvador@suse.de, tony.luck@intel.com,
        torvalds@linux-foundation.org, zeil@yandex-team.ru
Subject:  [patch 041/156] mm,hwpoison: cleanup unused PageHuge()
 check
Message-ID: <20201016024322.6-udsd9SS%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
