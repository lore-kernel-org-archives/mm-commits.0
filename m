Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97844C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382317AbiEMTZf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383889AbiEMTYN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:24:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF5DD2E6A8
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:22:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0AB560ADC
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F22C34100;
        Fri, 13 May 2022 19:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469750;
        bh=c7yltDUcW4izdw+p35UQZrKBUjzYIul2KMSTLHHY2oE=;
        h=Date:To:From:Subject:From;
        b=L4j0FLX9glMQzHLE3pw2HdstPKH8R4gbuc6uOFjY3yq6J6jw03knDfvElFlSEJuaI
         nwoiY906g3TR/ucF7ED4xQfwtYQWl+Hr0aAQWoUluHjbLsHYHYT+I+sswrfg6G0h2d
         r9A7onFWAVm6TqDs4g/ATfu4Nrx6eyb+KXV5ScBA=
Date:   Fri, 13 May 2022 12:22:29 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        pizhenwei@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failurec-simplify-num_poisoned_pages_dec.patch removed from -mm tree
Message-Id: <20220513192230.20F22C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory-failure.c: simplify num_poisoned_pages_dec
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-simplify-num_poisoned_pages_dec.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -9497,7 +9497,6 @@ bool put_page_back_buddy(struct page *pa
 		ClearPageHWPoisonTakenOff(page);
 		__free_one_page(page, pfn, zone, 0, migratetype, FPI_NONE);
 		if (TestClearPageHWPoison(page)) {
-			num_poisoned_pages_dec();
 			ret = true;
 		}
 	}
_

Patches currently in -mm which might be from pizhenwei@bytedance.com are


