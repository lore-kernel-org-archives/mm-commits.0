Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAC5EC43217
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:46:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236617AbiCVVsZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236700AbiCVVsO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:48:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504DE5F8E8
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:46:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC63AB81DB7
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E875C340EC;
        Tue, 22 Mar 2022 21:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985599;
        bh=jedrvYwFspMSMsyT77JGhwiWtvwDzGhVLUBNE0+fuGg=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=z+c8GO9uLdRpXBnRpB75QxO0Az8B6Qf7dFo31CUWKSGchQ60fA1CYCFVFpUlyNI+D
         wT43ZMBv+6kdyo6jRVkspCt94d6jGjXapjlvD9UYGepsoHdAYtN7n3LvKQE3rTpvP3
         tb3QCCYdOUkRPatb3IZpLFR+JEKZH+y4v070+faA=
Date:   Tue, 22 Mar 2022 14:46:38 -0700
To:     shy828301@gmail.com, rientjes@google.com, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, willy@infradead.org,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 160/227] mm/hwpoison: check the subpage, not the head page
Message-Id: <20220322214639.8E875C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
