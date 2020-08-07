Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B6A5C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 01:06:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E460221E2
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 01:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596762415;
	bh=lqFwfZlFj8M+JBaLsg1u0QjRsrOw3isMv/BG4pDKZNA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=v0vNmJcF+EHk1vU0gaMfFvitmrCzx8K7bbN0H/+EAiZRUXv9ra/Lz8VHPCoWvmkw4
	 LfL8s8uQu21c2g1HmBio80RD+uxZXeOdBaVGzPbcOB+f5sUanVbquKudBKkS/OO89k
	 ijIRG8CLLxBhcDZ+OyWemlV248RxPkptmbIa0xjM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgHGBGy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Aug 2020 21:06:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726011AbgHGBGy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 Aug 2020 21:06:54 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 323BD21744;
        Fri,  7 Aug 2020 01:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596762413;
        bh=lqFwfZlFj8M+JBaLsg1u0QjRsrOw3isMv/BG4pDKZNA=;
        h=Date:From:To:Subject:From;
        b=YhXrWuXsSc8MlHOzje3mkFz/UTMLkicXO2qFVag3V3ql3TclY2c5/5mVw2oy3fHOX
         eemDzHnSDX/INnPHThALrP+DfJ45q5dpYoQZIeB0p7lvlep5XH49yg25+UZ8x6L7OC
         yjF/kUCOtISr+jKe4wzkQq+coS9abiRsDyhsB1n0=
Date:   Thu, 06 Aug 2020 18:06:52 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
        cai@lca.pw, dave.hansen@intel.com, david@redhat.com,
        mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, tony.luck@intel.com, zeil@yandex-team.ru
Subject:  + mmhwpoison-cleanup-unused-pagehuge-check.patch added to
 -mm tree
Message-ID: <20200807010652.l3GOeWEgK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: cleanup unused PageHuge() check
has been added to the -mm tree.  Its filename is
     mmhwpoison-cleanup-unused-pagehuge-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-cleanup-unused-pagehuge-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-cleanup-unused-pagehuge-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm,hwpoison: cleanup unused PageHuge() check

Patch series "HWPOISON: soft offline rework", v6.

Main focus of this series is to stabilize soft offline.  Historically soft
offlined pages have suffered from racy conditions because PageHWPoison is
used to a little too aggressively, which (directly or indirectly) invades
other mm code which cares little about hwpoison.  This results in
unexpected behavior or kernel panic, which is very far from soft offline's
"do not disturb userspace or other kernel component" policy.

Main point of this change set is to contain target page "via buddy
allocator", where we first free the target page as we do for normal pages,
and remove from buddy only when we confirm that it reaches free list. 
There is surely race window of page allocation, but that's fine because
someone really want that page and the page is still working, so soft
offline can happily give up.


This patch (of 12):

Drop the PageHuge check, which is dead code since memory_failure() forks
into memory_failure_hugetlb() for hugetlb pages.

memory_failure() and memory_failure_hugetlb() shares some functions like
hwpoison_user_mappings() and identify_page_state(), so they should
properly handle 4kB page, thp, and hugetlb.

Link: http://lkml.kernel.org/r/20200806184923.7007-1-nao.horiguchi@gmail.com
Link: http://lkml.kernel.org/r/20200806184923.7007-2-nao.horiguchi@gmail.com
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-cleanup-unused-pagehuge-check
+++ a/mm/memory-failure.c
@@ -1382,10 +1382,7 @@ int memory_failure(unsigned long pfn, in
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

mmhwpoison-cleanup-unused-pagehuge-check.patch
mm-hwpoison-remove-recalculating-hpage.patch
mmhwpoison-inject-dont-pin-for-hwpoison_filter.patch
mmhwpoison-introduce-mf_msg_unsplit_thp.patch
mmhwpoison-double-check-page-count-in-__get_any_page.patch

