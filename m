Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77177EB64DC
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jun 2023 21:56:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjFUV4x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jun 2023 17:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjFUV4w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Jun 2023 17:56:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A515E57
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 14:56:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7F8A616EC
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 21:56:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17912C433C0;
        Wed, 21 Jun 2023 21:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687384610;
        bh=Gr0h9wKJQj9rPeH0SZHYmOknoWgpgEUagO8LGogw6Ks=;
        h=Date:To:From:Subject:From;
        b=bg2VKcSen/lLea3m5dXnuLMmJVNwcVV6E9fLyd++a5/Zmny/pC0mYDQ4rGl2a1kS0
         45yn/XPjxiiTEWId8cKZlEMbkID7/UbDO+DnQZjmpfUD1tlM7t2knl0OB8eHcAhs4v
         cYz/lkxTWQfY/r3ztQr7ajF13k3J4C3hnWYsePNY=
Date:   Wed, 21 Jun 2023 14:56:49 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        jgowans@amazon.com, baolin.wang@linux.alibaba.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kill-_page_to_lru_list.patch added to mm-unstable branch
Message-Id: <20230621215650.17912C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kill [add|del]_page_to_lru_list()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kill-_page_to_lru_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kill-_page_to_lru_list.patch

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

mm-compaction-convert-to-use-a-folio-in-isolate_migratepages_block.patch
mm-kill-_page_to_lru_list.patch

