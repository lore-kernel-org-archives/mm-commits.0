Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF377C00140
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 00:01:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiHKABI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Aug 2022 20:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232361AbiHKABH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2022 20:01:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06000419AE
        for <mm-commits@vger.kernel.org>; Wed, 10 Aug 2022 17:01:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9646C60F3A
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 00:01:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEEDAC433D6;
        Thu, 11 Aug 2022 00:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660176065;
        bh=ET3105NfHh4OXgusUVibiuxeTfgTupPOnp0BrO/p8lY=;
        h=Date:To:From:Subject:From;
        b=VF6g8BN0pGDUzxhQ4LIyPeM3aC3zzvnPCgtnMxoXqkQqVNMIZhfy3yS57tq0yu0xX
         9JyiCFf8m9oz65LwEakQM8z+91IRmQrJjuc/sS5icADMo36c3IqnTdnsETfAqK9tX4
         8tZO0jR+e83j9VOMG8MqYWi809Xm7ADOORczMz34=
Date:   Wed, 10 Aug 2022 17:01:04 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-cleanup-try_to_split_thp_page.patch added to mm-unstable branch
Message-Id: <20220811000104.EEEDAC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory-failure: cleanup try_to_split_thp_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-cleanup-try_to_split_thp_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-cleanup-try_to_split_thp_page.patch

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
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
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

mm-memory-failure-cleanup-try_to_split_thp_page.patch

