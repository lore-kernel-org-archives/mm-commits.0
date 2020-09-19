Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E8A1C43464
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2298E21D7F
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600475050;
	bh=tdhsp2I1J/lH5s/jtH+I134kACuAEZKRzZFK112BTEs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=BZSTqMXSrj0kx7AfSQIXes2pahdxcVJjdE5MLpwVlQD52YkC/v6xqI5QmvTqQTx0z
	 p72WMfWRhQDZRi9HhAQzfkLh7sWbssQ58uGqFZh/v05i96OJ0lpca1Cucsb0RrE1J/
	 BXoOJrE118N7F2n6RdsCavzxP8F/M8aOQ60oLqWM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgISAYJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Sep 2020 20:24:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISAYJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Sep 2020 20:24:09 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 340F721D43;
        Sat, 19 Sep 2020 00:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600475048;
        bh=tdhsp2I1J/lH5s/jtH+I134kACuAEZKRzZFK112BTEs=;
        h=Date:From:To:Subject:From;
        b=zwCDWY5ZmXlSvjvXgwNvX4u/Ef43UfQ8MXRip/RmuXnBAwvDP9o7+O1eC7BRy9Qn+
         MO0QmO9AQraQ5izL1E1iD/aAje4+h8+40/tVP4lq+6fEJshTfY6A2lStZa9JhKJunX
         OQ6UnjLFFu2/C8d9urF+daeHXYkuzLgnua1rFnwM=
Date:   Fri, 18 Sep 2020 17:24:07 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zeil@yandex-team.ru,
        tony.luck@intel.com, osalvador@suse.de, mike.kravetz@oracle.com,
        mhocko@kernel.org, david@redhat.com, dave.hansen@intel.com,
        cai@lca.pw, aneesh.kumar@linux.vnet.ibm.com,
        aneesh.kumar@linux.ibm.com, naoya.horiguchi@nec.com
Subject:  [to-be-updated]
 mmhwpoison-cleanup-unused-pagehuge-check.patch removed from -mm tree
Message-ID: <20200919002407.0TsAR%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: cleanup unused PageHuge() check
has been removed from the -mm tree.  Its filename was
     mmhwpoison-cleanup-unused-pagehuge-check.patch

This patch was dropped because an updated version will be merged

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

mm-hwpoison-remove-recalculating-hpage.patch
mmhwpoison-inject-dont-pin-for-hwpoison_filter.patch
mmhwpoison-introduce-mf_msg_unsplit_thp.patch
mmhwpoison-double-check-page-count-in-__get_any_page.patch

