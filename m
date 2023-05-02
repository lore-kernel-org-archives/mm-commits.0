Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 980AFC19F20
	for <mm-commits@archiver.kernel.org>; Tue,  2 May 2023 21:07:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjEBVHy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 17:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjEBVHa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 17:07:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8273B9E
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 14:07:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A4CA628D1
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 21:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6634FC433D2;
        Tue,  2 May 2023 21:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683061648;
        bh=y0tTndZoOJj48MIsI2mSwiE4cp+7e9OXNBilUdClpdM=;
        h=Date:To:From:Subject:From;
        b=tKC2Plh/qohOwvrNblbpRjLo1qKInN8KQvFCvICcYl7dQAs6TE/HGt2wk8i6JBrMN
         fYMgCo/I4Zwxaa/CPEKr11MXoX/opBosktZU/9WBylH1hApwsApC173hKUMIerXkYs
         Y3coZv802rV4TZAOZJgvbLcOPXNSzm0ayhfL+Aho=
Date:   Tue, 02 May 2023 14:07:27 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, vbabka@suse.cz,
        rppt@kernel.org, mhocko@suse.com, mgorman@techsingularity.net,
        david@redhat.com, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-drop-the-unnecessary-pfn_valid-for-start-pfn.patch added to mm-unstable branch
Message-Id: <20230502210728.6634FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: drop the unnecessary pfn_valid() for start pfn
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-drop-the-unnecessary-pfn_valid-for-start-pfn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-drop-the-unnecessary-pfn_valid-for-start-pfn.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm/page_alloc: drop the unnecessary pfn_valid() for start pfn
Date: Mon, 24 Apr 2023 21:45:39 +0800

__pageblock_pfn_to_page() currently performs both pfn_valid check and
pfn_to_online_page().  The former one is redundant because the latter is a
stronger check.  Drop pfn_valid().

Link: https://lkml.kernel.org/r/c3868b58c6714c09a43440d7d02c7b4eed6e03f6.1682342634.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-drop-the-unnecessary-pfn_valid-for-start-pfn
+++ a/mm/page_alloc.c
@@ -1521,7 +1521,7 @@ struct page *__pageblock_pfn_to_page(uns
 	/* end_pfn is one past the range we are checking */
 	end_pfn--;
 
-	if (!pfn_valid(start_pfn) || !pfn_valid(end_pfn))
+	if (!pfn_valid(end_pfn))
 		return NULL;
 
 	start_page = pfn_to_online_page(start_pfn);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-page_alloc-add-some-comments-to-explain-the-possible-hole-in-__pageblock_pfn_to_page.patch
mm-page_alloc-drop-the-unnecessary-pfn_valid-for-start-pfn.patch

