Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 852BBC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:06:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21BDC2087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817603;
	bh=YGNafOn8zidjdGtkdrrWBzRspeXsofiMpYa2wxxSoss=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=l+/BUGlSI1NSfMB07C04URJ6mo/4uaFG73kcke4s6bm5fSaBySqFqQqbVH88uR4GO
	 fauCPGPLkbf6SKDpUZ+yyvxMqu7Io1EZZapUyiywqfO2OwcUPfE4J416HmaynbLEEt
	 c10Z5sDWcE7VHVcwDMvJ+tOzVfVdCpw208M5IgnI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404481AbgJPDGm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:06:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404479AbgJPDGl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:06:41 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 248C220789;
        Fri, 16 Oct 2020 03:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817600;
        bh=YGNafOn8zidjdGtkdrrWBzRspeXsofiMpYa2wxxSoss=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0BYTQdjgRXB7uxu66qSk4wlFlrhrHOxDra7XOwD08Yc8z8PF9MdjvM62WBkDckRid
         W+bHk8DRU1D6DLwPYW75YHAhtYyyUqOTagxzTmAq9L05YP9QYMP9UZ7CwM4bheVUZn
         fkO/uz9JL5Gecf1bC6zU7E/Ah9Fxz2Px7jJVf18M=
Date:   Thu, 15 Oct 2020 20:06:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, aris@ruivo.org, cai@lca.pw,
        dave.hansen@intel.com, david@redhat.com, mhocko@kernel.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.com, osalvador@suse.de,
        tony.luck@intel.com, torvalds@linux-foundation.org,
        zeil@yandex-team.ru
Subject:  [patch 041/156] mm,hwpoison: cleanup unused PageHuge()
 check
Message-ID: <20201016030638.P1sawQnqx%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
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
