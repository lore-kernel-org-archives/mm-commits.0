Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF91FC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 10 Nov 2023 19:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236187AbjKJTik (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Nov 2023 14:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236207AbjKJTi0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Nov 2023 14:38:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0B837FEB
        for <mm-commits@vger.kernel.org>; Fri, 10 Nov 2023 10:20:14 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26041C433BF;
        Fri, 10 Nov 2023 18:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699640414;
        bh=ZiyYbmlJazyc3X0Ey8/Kdih9kVj1AVioQztOj5TyNaI=;
        h=Date:To:From:Subject:From;
        b=k/sZ5J/uXNlApiqttkjHayO3XL17S0lr2w5iJ5c25LkCFgRXw4BPkGzhFvwLMfj3i
         /pTocjb7iDSikfhiZzcNQGdUG/CTZjWg+ha0kjTY/sE3c+5CJxlv1V+w4/giSozPJi
         bKMNN4B3fztOlPRhBIzCyte88TV69+4yIyA94Bic=
Date:   Fri, 10 Nov 2023 10:20:13 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        gregory.price@memverge.com, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] page_idle-kill-page-idle-and-young-wrapper.patch removed from -mm tree
Message-Id: <20231110182014.26041C433BF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: page_idle: kill page idle and young wrapper
has been removed from the -mm tree.  Its filename was
     page_idle-kill-page-idle-and-young-wrapper.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: page_idle: kill page idle and young wrapper
Date: Fri, 10 Nov 2023 11:33:24 +0800

Since all the calls of page idle and young functions are gone, let's
remove all the wrappers.

Link: https://lkml.kernel.org/r/20231110033324.2455523-8-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gregory Price <gregory.price@memverge.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_idle.h |   25 -------------------------
 1 file changed, 25 deletions(-)

--- a/include/linux/page_idle.h~page_idle-kill-page-idle-and-young-wrapper
+++ a/include/linux/page_idle.h
@@ -119,29 +119,4 @@ static inline void folio_clear_idle(stru
 }
 
 #endif /* CONFIG_PAGE_IDLE_FLAG */
-
-static inline bool page_is_young(struct page *page)
-{
-	return folio_test_young(page_folio(page));
-}
-
-static inline void set_page_young(struct page *page)
-{
-	folio_set_young(page_folio(page));
-}
-
-static inline bool test_and_clear_page_young(struct page *page)
-{
-	return folio_test_clear_young(page_folio(page));
-}
-
-static inline bool page_is_idle(struct page *page)
-{
-	return folio_test_idle(page_folio(page));
-}
-
-static inline void set_page_idle(struct page *page)
-{
-	folio_set_idle(page_folio(page));
-}
 #endif /* _LINUX_MM_PAGE_IDLE_H */
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


