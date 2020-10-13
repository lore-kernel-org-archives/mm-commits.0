Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD68C35257
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5BE522227
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633207;
	bh=40jUhlXjsCIlF9PM4OdimJ2+GAuN/dN5ImzIXVC7xy8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=mQ3kFxV8PMGGSMqYEp5HwtzVNMSSCYt3v9CLFfgYA8e16g4xRS1E0VJZ17pY6YS4q
	 hFe4aUopscJI/BThm4Yt2ZGhgA/INGv3Wbj6lK+dKDX82oQoNT998aQlvaDCgP7UGj
	 +Y0zpbPz8tZdaO709pKB00BdQho0COUjw0Nea95k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgJMXxY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:53:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729955AbgJMXwY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:52:24 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70363221FF;
        Tue, 13 Oct 2020 23:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633144;
        bh=40jUhlXjsCIlF9PM4OdimJ2+GAuN/dN5ImzIXVC7xy8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZeqOImPMTOC2unKXDS5zCBrGkAm1WT9I3ORgFGL+WbXH9lvFPs3T89fCBETTB6AP8
         POaPlcNsB4kIJWX19By6mD6sZSlHboOwHB+Jmt3jRfwx+wf0MRQOFnTS8MDzoFugmT
         zI+mVn6M6r+P+GLYSnWM8rfHbQscVCbXzeQ7ZP64=
Date:   Tue, 13 Oct 2020 16:52:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        shakeelb@google.com, torvalds@linux-foundation.org
Subject:  [patch 074/181] mm/swap.c: fix incomplete comment in
 lru_cache_add_inactive_or_unevictable()
Message-ID: <20201013235224.i1-UT5nwl%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swap.c: fix incomplete comment in lru_cache_add_inactive_or_unevictable()

Since commit 9c4e6b1a7027 ("mm, mlock, vmscan: no more skipping
pagevecs"), unevictable pages do not goes directly back onto zone's
unevictable list.

Link: https://lkml.kernel.org/r/20200927122209.59328-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/swap.c~mm-fix-incomplete-comment-in-lru_cache_add_inactive_or_unevictable
+++ a/mm/swap.c
@@ -481,9 +481,7 @@ EXPORT_SYMBOL(lru_cache_add);
  * @vma:   vma in which page is mapped for determining reclaimability
  *
  * Place @page on the inactive or unevictable LRU list, depending on its
- * evictability.  Note that if the page is not evictable, it goes
- * directly back onto it's zone's unevictable list, it does NOT use a
- * per cpu pagevec.
+ * evictability.
  */
 void lru_cache_add_inactive_or_unevictable(struct page *page,
 					 struct vm_area_struct *vma)
_
