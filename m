Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9537BECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiILD24 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiILD21 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:28:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7789726540
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22CEBB8085E
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8514C433D7;
        Mon, 12 Sep 2022 03:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953302;
        bh=knGzUySg2/bf1Lk8k4J8FTlTRC1aQMKSnjchxjWPn3s=;
        h=Date:To:From:Subject:From;
        b=s4QAsZQBdVTDXQirm7jnVu+lTXyJBvhwDrjfGdpkVrji7XoFpb9m+i36UNblJcUil
         Sm1sR6Sf//Jlkx67LaTYd0CH0F0PdQsGfeLjO6QwJaTfk+dV2a0kd4r1F9MkK+RRiM
         4TmV3WmT2kVE2O2lzX6Ri+PQfe38ztrG9kxXsgVI=
Date:   Sun, 11 Sep 2022 20:28:22 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-cleanup-try_to_split_thp_page.patch removed from -mm tree
Message-Id: <20220912032822.B8514C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory-failure: cleanup try_to_split_thp_page()
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-cleanup-try_to_split_thp_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory-failure: cleanup try_to_split_thp_page()
Date: Tue, 9 Aug 2022 19:18:13 +0800

Since commit 5d1fd5dc877b ("mm,hwpoison: introduce MF_MSG_UNSPLIT_THP"),
the action_result(,MF_MSG_UNSPLIT_THP,) called to show memory error event
in memory_failure(), so the pr_info() in try_to_split_thp_page() is only
needed in soft_offline_in_use_page().

Meanwhile this could also fix the unexpected prefix for "thp split failed"
due to commit 96f96763de26 ("mm: memory-failure: convert to pr_fmt()").

Link: https://lkml.kernel.org/r/20220809111813.139690-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-cleanup-try_to_split_thp_page
+++ a/mm/memory-failure.c
@@ -1524,20 +1524,18 @@ static int identify_page_state(unsigned
 	return page_action(ps, p, pfn);
 }
 
-static int try_to_split_thp_page(struct page *page, const char *msg)
+static int try_to_split_thp_page(struct page *page)
 {
+	int ret;
+
 	lock_page(page);
-	if (unlikely(split_huge_page(page))) {
-		unsigned long pfn = page_to_pfn(page);
+	ret = split_huge_page(page);
+	unlock_page(page);
 
-		unlock_page(page);
-		pr_info("%s: %#lx: thp split failed\n", msg, pfn);
+	if (unlikely(ret))
 		put_page(page);
-		return -EBUSY;
-	}
-	unlock_page(page);
 
-	return 0;
+	return ret;
 }
 
 static void unmap_and_kill(struct list_head *to_kill, unsigned long pfn,
@@ -2079,7 +2077,7 @@ try_again:
 		 * page is a valid handlable page.
 		 */
 		SetPageHasHWPoisoned(hpage);
-		if (try_to_split_thp_page(p, "Memory Failure") < 0) {
+		if (try_to_split_thp_page(p) < 0) {
 			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_IGNORED);
 			res = -EBUSY;
 			goto unlock_mutex;
@@ -2505,8 +2503,11 @@ static int soft_offline_in_use_page(stru
 	struct page *hpage = compound_head(page);
 
 	if (!PageHuge(page) && PageTransHuge(hpage))
-		if (try_to_split_thp_page(page, "soft offline") < 0)
+		if (try_to_split_thp_page(page) < 0) {
+			pr_info("soft offline: %#lx: thp split failed\n",
+				page_to_pfn(page));
 			return -EBUSY;
+		}
 	return __soft_offline_page(page);
 }
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-reuse-pageblock_start-end_pfn-macro.patch
mm-add-pageblock_align-macro.patch
mm-add-pageblock_aligned-macro.patch
memblock-tests-add-new-pageblock-related-macro.patch
kernel-exit-cleanup-release_thread.patch

