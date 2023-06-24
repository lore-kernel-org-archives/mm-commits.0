Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 963C7C001B1
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:01:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbjFXABF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbjFXAAe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:00:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04510273D
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:00:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D244615E3
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F9BC433C0;
        Sat, 24 Jun 2023 00:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687564832;
        bh=szbOLxTSRopw2Tp70U+DPbZjfuzAMPkYK4ZG0eYsVKg=;
        h=Date:To:From:Subject:From;
        b=vwgKfqoiZrecWON2b/YkyAAUKUqrBTBepmXd4GSQPwM6rEqPa0cmK3l2hnAgKlFMW
         yGclp5Ddt96N6FsmYPKZY/aYwjnZDYV9VIohqzAGEPuL8V6mLVLB0UXIEQjrMrvqU4
         SiquEM68zX5zzqn2tBMHZk0Htjj8dqFA3/6rjaCE=
Date:   Fri, 23 Jun 2023 17:00:31 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        jgowans@amazon.com, baolin.wang@linux.alibaba.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kill-_page_to_lru_list.patch removed from -mm tree
Message-Id: <20230624000031.E1F9BC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: kill [add|del]_page_to_lru_list()
has been removed from the -mm tree.  Its filename was
     mm-kill-_page_to_lru_list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: kill [add|del]_page_to_lru_list()
Date: Mon, 19 Jun 2023 19:07:18 +0800

Now no one call [add|del]_page_to_lru_list(), let's drop unused page
interfaces.

Link:https://lkml.kernel.org/r/20230619110718.65679-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: James Gowans <jgowans@amazon.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   12 ------------
 1 file changed, 12 deletions(-)

--- a/include/linux/mm_inline.h~mm-kill-_page_to_lru_list
+++ a/include/linux/mm_inline.h
@@ -323,12 +323,6 @@ void lruvec_add_folio(struct lruvec *lru
 		list_add(&folio->lru, &lruvec->lists[lru]);
 }
 
-static __always_inline void add_page_to_lru_list(struct page *page,
-				struct lruvec *lruvec)
-{
-	lruvec_add_folio(lruvec, page_folio(page));
-}
-
 static __always_inline
 void lruvec_add_folio_tail(struct lruvec *lruvec, struct folio *folio)
 {
@@ -357,12 +351,6 @@ void lruvec_del_folio(struct lruvec *lru
 			-folio_nr_pages(folio));
 }
 
-static __always_inline void del_page_from_lru_list(struct page *page,
-				struct lruvec *lruvec)
-{
-	lruvec_del_folio(lruvec, page_folio(page));
-}
-
 #ifdef CONFIG_ANON_VMA_NAME
 /*
  * mmap_lock should be read-locked when calling anon_vma_name(). Caller should
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


