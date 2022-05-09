Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF60C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  9 May 2022 23:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbiEIXXE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 May 2022 19:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbiEIXXA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2022 19:23:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B451FE1D5
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 16:19:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D1626121D
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 23:19:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717D8C385C2;
        Mon,  9 May 2022 23:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652138344;
        bh=O71pkjDEHDLamijh9t8jfUtiye1TlRcqFXpM3pR927c=;
        h=Date:To:From:Subject:From;
        b=Zr1y/BUDoJ9l6bV1ZBI+gLneaQpbjN0Yw0c2k23CLXmCKSZ6k03WdOdlm+9H+RtKW
         3VaSLSrZUKUevvaIeg5PkFXKBDbbCg3cEMiCv9VCHSmu2dIqqHWKOrcSC4g18PFzFZ
         K7ejWw7y28NdvQEldLfm5u1WQmbFO5vSWDk7JR6E=
Date:   Mon, 09 May 2022 16:19:03 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        pizhenwei@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failurec-simplify-num_poisoned_pages_dec.patch added to mm-unstable branch
Message-Id: <20220509231904.717D8C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: simplify num_poisoned_pages_dec
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failurec-simplify-num_poisoned_pages_dec.patch

This patch should soon appear in the mm-unstable branch at
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
From: zhenwei pi <pizhenwei@bytedance.com>
Subject: mm/memory-failure.c: simplify num_poisoned_pages_dec

Don't decrease the number of poisoned pages in page_alloc.c, let the
memory-failure.c do inc/dec poisoned pages only.

Also simplify unpoison_memory(), only decrease the number of
poisoned pages when:
 - TestClearPageHWPoison() succeed
 - put_page_back_buddy succeed

After decreasing, print necessary log.

Finally, remove clear_page_hwpoison() and unpoison_taken_off_page().

Link: https://lkml.kernel.org/r/20220509105641.491313-3-pizhenwei@bytedance.com
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   37 +++++++++----------------------------
 mm/page_alloc.c     |    1 -
 2 files changed, 9 insertions(+), 29 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failurec-simplify-num_poisoned_pages_dec
+++ a/mm/memory-failure.c
@@ -2079,28 +2079,6 @@ core_initcall(memory_failure_init);
 		pr_info(fmt, pfn);			\
 })
 
-static inline int clear_page_hwpoison(struct ratelimit_state *rs, struct page *p)
-{
-	if (TestClearPageHWPoison(p)) {
-		unpoison_pr_info("Unpoison: Software-unpoisoned page %#lx\n",
-				 page_to_pfn(p), rs);
-		num_poisoned_pages_dec();
-		return 1;
-	}
-	return 0;
-}
-
-static inline int unpoison_taken_off_page(struct ratelimit_state *rs,
-					  struct page *p)
-{
-	if (put_page_back_buddy(p)) {
-		unpoison_pr_info("Unpoison: Software-unpoisoned page %#lx\n",
-				 page_to_pfn(p), rs);
-		return 0;
-	}
-	return -EBUSY;
-}
-
 /**
  * unpoison_memory - Unpoison a previously poisoned page
  * @pfn: Page number of the to be unpoisoned page
@@ -2118,6 +2096,7 @@ int unpoison_memory(unsigned long pfn)
 	struct page *page;
 	struct page *p;
 	int ret = -EBUSY;
+	int freeit = 0;
 	static DEFINE_RATELIMIT_STATE(unpoison_rs, DEFAULT_RATELIMIT_INTERVAL,
 					DEFAULT_RATELIMIT_BURST);
 
@@ -2158,18 +2137,15 @@ int unpoison_memory(unsigned long pfn)
 
 	ret = get_hwpoison_page(p, MF_UNPOISON);
 	if (!ret) {
-		if (clear_page_hwpoison(&unpoison_rs, page))
-			ret = 0;
-		else
-			ret = -EBUSY;
+		ret = TestClearPageHWPoison(page) ? 0 : -EBUSY;
 	} else if (ret < 0) {
 		if (ret == -EHWPOISON) {
-			ret = unpoison_taken_off_page(&unpoison_rs, p);
+			ret = put_page_back_buddy(p) ? 0 : -EBUSY;
 		} else
 			unpoison_pr_info("Unpoison: failed to grab page %#lx\n",
 					 pfn, &unpoison_rs);
 	} else {
-		int freeit = clear_page_hwpoison(&unpoison_rs, p);
+		freeit = !!TestClearPageHWPoison(p);
 
 		put_page(page);
 		if (freeit && !(pfn == my_zero_pfn(0) && page_count(p) == 1)) {
@@ -2180,6 +2156,11 @@ int unpoison_memory(unsigned long pfn)
 
 unlock_mutex:
 	mutex_unlock(&mf_mutex);
+	if (!ret || freeit) {
+		num_poisoned_pages_dec();
+		unpoison_pr_info("Unpoison: Software-unpoisoned page %#lx\n",
+				 page_to_pfn(p), &unpoison_rs);
+	}
 	return ret;
 }
 EXPORT_SYMBOL(unpoison_memory);
--- a/mm/page_alloc.c~mm-memory-failurec-simplify-num_poisoned_pages_dec
+++ a/mm/page_alloc.c
@@ -9489,7 +9489,6 @@ bool put_page_back_buddy(struct page *pa
 		ClearPageHWPoisonTakenOff(page);
 		__free_one_page(page, pfn, zone, 0, migratetype, FPI_NONE);
 		if (TestClearPageHWPoison(page)) {
-			num_poisoned_pages_dec();
 			ret = true;
 		}
 	}
_

Patches currently in -mm which might be from pizhenwei@bytedance.com are

mm-memory-failurec-move-clear_hwpoisoned_pages.patch
mm-memory-failurec-simplify-num_poisoned_pages_dec.patch
mm-memory-failurec-add-hwpoison_filter-for-soft-offline.patch
mm-hwpoison-disable-hwpoison-filter-during-removing.patch
mm-memory-failurec-simplify-num_poisoned_pages_inc-dec.patch

