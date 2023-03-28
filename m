Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D30EBC77B6F
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjC1XWG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbjC1XVi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD0E30D2
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79B28619AC
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DDBC433EF;
        Tue, 28 Mar 2023 23:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045689;
        bh=KN2sriK3Dl/zWhYeWegss9pq+eozArvKhZ7xpS3As/Y=;
        h=Date:To:From:Subject:From;
        b=mfcpeLSqYQ5nSuAEzihkGfZLiV2usx1A4xkoIw2+7j5qyc9ijFvCBfwenHhwfx6E/
         xiTbx2qE4IaGBdPQVCCnAFq873HyJfjHB6prKbyLm2BZCnlgOCalV5vVxpw5cnbtpP
         8EotXGmnvfu/xP+2bHGev3HW0gPPfApX3Mt/T3h4=
Date:   Tue, 28 Mar 2023 16:21:29 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        stevensd@chromium.org, shy828301@gmail.com, hannes@cmpxchg.org,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-cleanup-memcg-uncharge-for-failure-path.patch removed from -mm tree
Message-Id: <20230328232129.D0DDBC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: cleanup memcg uncharge for failure path
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-cleanup-memcg-uncharge-for-failure-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/khugepaged: cleanup memcg uncharge for failure path
Date: Fri, 3 Mar 2023 10:12:18 -0500

Explicit memcg uncharging is not needed when the memcg accounting has the
same lifespan of the page/folio.  That becomes the case for khugepaged
after Yang & Zach's recent rework so the hpage will be allocated for each
collapse rather than being cached.

Cleanup the explicit memcg uncharge in khugepaged failure path and leave
that for put_page().

Link: https://lkml.kernel.org/r/20230303151218.311015-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Suggested-by: Zach O'Keefe <zokeefe@google.com>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: David Stevens <stevensd@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-cleanup-memcg-uncharge-for-failure-path
+++ a/mm/khugepaged.c
@@ -1136,10 +1136,8 @@ static int collapse_huge_page(struct mm_
 out_up_write:
 	mmap_write_unlock(mm);
 out_nolock:
-	if (hpage) {
-		mem_cgroup_uncharge(page_folio(hpage));
+	if (hpage)
 		put_page(hpage);
-	}
 	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result);
 	return result;
 }
@@ -2145,10 +2143,8 @@ xa_unlocked:
 		unlock_page(hpage);
 out:
 	VM_BUG_ON(!list_empty(&pagelist));
-	if (hpage) {
-		mem_cgroup_uncharge(page_folio(hpage));
+	if (hpage)
 		put_page(hpage);
-	}
 
 	trace_mm_khugepaged_collapse_file(mm, hpage, index, is_shmem, addr, file, nr, result);
 	return result;
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path.patch
mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v2.patch
mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v3.patch
mm-uffd-uffd_feature_wp_unpopulated.patch
mm-uffd-uffd_feature_wp_unpopulated-fix.patch
selftests-mm-smoke-test-uffd_feature_wp_unpopulated.patch

