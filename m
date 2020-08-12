Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3971FC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 117FA206B2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195955;
	bh=9ASv3NpcW4/1rNEOjEE3L/vC6ggeuFWi7A7S2ML+5TM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=vhzXW+CTamcNl3qIAP8H+lj3ukWWrfbGWVJaXAA+VohL4YSyovKaJAia1FvTb3esD
	 O9HUQq1ebGadVIB4L8JvA5EofnfYhEWWLk2hYG1tBwyjFJZJQSCdv9pNN4llrgCCzk
	 5DdEVy1cYM179zop71BIoc7XNR9nnHseyS26/6fc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbgHLBce (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:32:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:32830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgHLBce (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:32:34 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 042252076C;
        Wed, 12 Aug 2020 01:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195954;
        bh=9ASv3NpcW4/1rNEOjEE3L/vC6ggeuFWi7A7S2ML+5TM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=f2WdJFQFbc17Cc1k+SsL4apSwmXd6U97N7dh6eM8+MJ70ZQ146itstKGlImjNPDrl
         +7UndvWes4sIpCRFKipv599t2bUTzyizVtBuHPlJzYtOOQBRvVUfpmuV1qxK9Lj93r
         t1APTQ3U+XDusJTfUAeck6iv/JA6bfdZ8WUo8FMw=
Date:   Tue, 11 Aug 2020 18:32:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org
Subject:  [patch 043/165] include/linux/highmem.h: fix duplicated
 words in a comment
Message-ID: <20200812013233.EprZdFk2h%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: include/linux/highmem.h: fix duplicated words in a comment

Change the doubled word "is" in a comment to "it is".

Link: http://lkml.kernel.org/r/ad605959-0083-4794-8d31-6b073300dd6f@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/highmem.h~highmem-linux-highmemh-fix-duplicated-words-in-a-comment
+++ a/include/linux/highmem.h
@@ -73,7 +73,7 @@ static inline void kunmap(struct page *p
  * no global lock is needed and because the kmap code must perform a global TLB
  * invalidation when the kmap pool wraps.
  *
- * However when holding an atomic kmap is is not legal to sleep, so atomic
+ * However when holding an atomic kmap it is not legal to sleep, so atomic
  * kmaps are appropriate for short, tight code paths only.
  *
  * The use of kmap_atomic/kunmap_atomic is discouraged - kmap/kunmap
_
