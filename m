Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 392A1C761A6
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:20:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjC1XU4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjC1XUz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:20:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B56E0
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:20:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E8E9619EE
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:20:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95610C433EF;
        Tue, 28 Mar 2023 23:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045653;
        bh=SZAh9I2ZpLuld961lpMc7ihLtVygktIS9q6AYXwG728=;
        h=Date:To:From:Subject:From;
        b=ygqISwzv1V0/1hX9udIkc3e4B1HqXGl8ZLX9Oi9TGF/GjEQEj7qz0QhEZLbF7FX0v
         yqvbmAc9Q991GoY/hpROrHUXArgcXJPhCweT6DGQkAYSjhER31zmopvIeL9qyoJzvr
         Wi6MW9QF+QNg8GfXJo2diG5Wuo+kVpOKH/d7KrnI=
Date:   Tue, 28 Mar 2023 16:20:53 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        stevensd@chromium.org, shy828301@gmail.com, hannes@cmpxchg.org,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-alloc_charge_hpage-take-care-of-mem-charge-errors.patch removed from -mm tree
Message-Id: <20230328232053.95610C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: alloc_charge_hpage() take care of mem charge errors
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-alloc_charge_hpage-take-care-of-mem-charge-errors.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/khugepaged: alloc_charge_hpage() take care of mem charge errors
Date: Wed, 22 Feb 2023 14:52:47 -0500

If memory charge failed, instead of returning the hpage but with an error,
allow the function to cleanup the folio properly, which is normally what a
function should do in this case - either return successfully, or return
with no side effect of partial runs with an indicated error.

This will also avoid the caller calling mem_cgroup_uncharge()
unnecessarily with either anon or shmem path (even if it's safe to do so).

Link: https://lkml.kernel.org/r/20230222195247.791227-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Stevens <stevensd@chromium.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-alloc_charge_hpage-take-care-of-mem-charge-errors
+++ a/mm/khugepaged.c
@@ -972,12 +972,19 @@ static int alloc_charge_hpage(struct pag
 	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
 		     GFP_TRANSHUGE);
 	int node = hpage_collapse_find_target_node(cc);
+	struct folio *folio;
 
 	if (!hpage_collapse_alloc_page(hpage, gfp, node, &cc->alloc_nmask))
 		return SCAN_ALLOC_HUGE_PAGE_FAIL;
-	if (unlikely(mem_cgroup_charge(page_folio(*hpage), mm, gfp)))
+
+	folio = page_folio(*hpage);
+	if (unlikely(mem_cgroup_charge(folio, mm, gfp))) {
+		folio_put(folio);
+		*hpage = NULL;
 		return SCAN_CGROUP_CHARGE_FAIL;
+	}
 	count_memcg_page_event(*hpage, THP_COLLAPSE_ALLOC);
+
 	return SCAN_SUCCEED;
 }
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path.patch
mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v2.patch
mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v3.patch
mm-uffd-uffd_feature_wp_unpopulated.patch
mm-uffd-uffd_feature_wp_unpopulated-fix.patch
selftests-mm-smoke-test-uffd_feature_wp_unpopulated.patch

