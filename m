Return-Path: <SRS0=iiPm=C7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DA9BC4363D
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 17:00:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 286172376F
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 17:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600794014;
	bh=NPmc+HBqJX2PYxhQhMeKrRza0yVxiQBIKSFiDE+X7Zc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=MXrk9NgXyKLU7rhBJStXDLyQ4hY/KrslUEkSJKuQnbjoBv+h0tEmkQ5bfvtro3RN0
	 kEbIrSBBG0ZlawzAEJLV8u3gqwxHehqY3gxmFF6B5w0vhTHnWAYBERSYU9S0Uben5c
	 OwH0CTpN9kbaglTvlVS+9ToZwx+3YjbMI+0WdPsA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgIVRAN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Sep 2020 13:00:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbgIVRAN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Sep 2020 13:00:13 -0400
Received: from X1 (unknown [216.241.194.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74EF423119;
        Tue, 22 Sep 2020 17:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600794013;
        bh=NPmc+HBqJX2PYxhQhMeKrRza0yVxiQBIKSFiDE+X7Zc=;
        h=Date:From:To:Subject:From;
        b=DcdGpgGk/jOA4fjbS1hD8FnrmwY4KQz7jozaS4iIyDz5a1yxB+BuD70/KUZI6MxuL
         TT2oZBDUKSfuSM3Tfv4EIbdZkePXg3/ajAeLziXJUntxIOCG/CosonPn8vLp/KAKMI
         WaA0ovvaQnsDfm5Ly9CT0HX2pa9EhkNfdL52DZc4=
Date:   Tue, 22 Sep 2020 10:00:11 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zeil@yandex-team.ru,
        tony.luck@intel.com, osalvador@suse.de, osalvador@suse.com,
        mike.kravetz@oracle.com, mhocko@kernel.org, david@redhat.com,
        dave.hansen@intel.com, cai@lca.pw, aris@ruivo.org,
        aneesh.kumar@linux.vnet.ibm.com, aneesh.kumar@linux.ibm.com,
        naoya.horiguchi@nec.com
Subject:  + mmhwpoison-cleanup-unused-pagehuge-check.patch added to
 -mm tree
Message-ID: <20200922170011.x8qOR%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: cleanup unused PageHuge() check
has been added to the -mm tree.  Its filename is
     mmhwpoison-cleanup-unused-pagehuge-check.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-cleanup-unused-pagehuge-check.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-cleanup-unused-pagehuge-check.patch

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

mmhwpoison-cleanup-unused-pagehuge-check.patch
mm-hwpoison-remove-recalculating-hpage.patch
mmhwpoison-inject-dont-pin-for-hwpoison_filter.patch
mmhwpoison-introduce-mf_msg_unsplit_thp.patch
mmhwpoison-double-check-page-count-in-__get_any_page.patch

