Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EC41C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241237AbiCYBfR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357428AbiCYBeu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:34:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1D8BF94D
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24AB9B826FE
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5676C340EC;
        Fri, 25 Mar 2022 01:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171949;
        bh=paUvWyk6eyTikbUh2a5nJuJ08yixBqpZVPMT2GRg8fA=;
        h=Date:To:From:Subject:From;
        b=J7WEgt9SlJJ1t6YU85cs98o40uniyr/aLia7oplDtit9Q7F9j9za/8wbtmhvuA8yk
         QMgfk1z7NQsnxrFV1Kx3Ky2MFVPVTN1i4DyI6nIFtSqaRBoAJiMqs8UMMTnq9puuey
         rcoA1yF+TXzb5oGjV7HY4USPgLF8fmCn6XvOhIr8=
Date:   Thu, 24 Mar 2022 18:32:29 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        rientjes@google.com, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-hwpoison-check-the-subpage-not-the-head-page.patch removed from -mm tree
Message-Id: <20220325013229.B5676C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: check the subpage, not the head page
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-check-the-subpage-not-the-head-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/hwpoison: check the subpage, not the head page

Hardware poison is tracked on a per-page basis, not on the head page.

Link: https://lkml.kernel.org/r/20220130013042.1906881-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/rmap.c~mm-hwpoison-check-the-subpage-not-the-head-page
+++ a/mm/rmap.c
@@ -1553,7 +1553,7 @@ static bool try_to_unmap_one(struct page
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
 
-		if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
+		if (PageHWPoison(subpage) && !(flags & TTU_IGNORE_HWPOISON)) {
 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
 			if (PageHuge(page)) {
 				hugetlb_count_sub(compound_nr(page), mm);
@@ -1873,7 +1873,7 @@ static bool try_to_migrate_one(struct pa
 			 * memory are supported.
 			 */
 			subpage = page;
-		} else if (PageHWPoison(page)) {
+		} else if (PageHWPoison(subpage)) {
 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
 			if (PageHuge(page)) {
 				hugetlb_count_sub(compound_nr(page), mm);
_

Patches currently in -mm which might be from willy@infradead.org are


