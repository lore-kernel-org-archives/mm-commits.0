Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D655C433E9
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF16D64EC4
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235274AbhBXUGl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:06:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:55472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231335AbhBXUF4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:05:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 940C364F35;
        Wed, 24 Feb 2021 20:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197098;
        bh=XQKP27moMFkKHciNc/q9f6Gqms+vt4sg+mpiFBlu66A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=unRm6qyPrQozw7PKb0Xj7gUnEnmSgS739GJqoGn6KcwB1oo9HsTJzBl7yAmGLyy6e
         cJoFW0UsKH/FwyNXkhsPtRgWwK/ZPByWKHiAXafBSu1wTFr7bP58dlp5UVz6ZpNnvD
         QudmVwmcsJZzloC0oagjXXsdSi0kX9cRGUPG6Zvo=
Date:   Wed, 24 Feb 2021 12:04:57 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexander.h.duyck@linux.intel.com,
        david@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        sh_def@163.com, torvalds@linux-foundation.org
Subject:  [patch 084/173] mm/page_reporting: use
 list_entry_is_head() in page_reporting_cycle()
Message-ID: <20210224200457.Ws5HbjiS0%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: sh <sh_def@163.com>
Subject: mm/page_reporting: use list_entry_is_head() in page_reporting_cycle()

Replace '&next->lru != list' with list_entry_is_head().  No functional
change.

Link: https://lkml.kernel.org/r/20201222182735.GA1257912@ubuntu-A520I-AC
Signed-off-by: sh <sh_def@163.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_reporting.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_reporting.c~mm-page_reporting-use-list_entry_is_head-in-page_reporting_cycle
+++ a/mm/page_reporting.c
@@ -211,7 +211,7 @@ page_reporting_cycle(struct page_reporti
 	}
 
 	/* Rotate any leftover pages to the head of the freelist */
-	if (&next->lru != list && !list_is_first(&next->lru, list))
+	if (!list_entry_is_head(next, list, lru) && !list_is_first(&next->lru, list))
 		list_rotate_to_front(&next->lru, list);
 
 	spin_unlock_irq(&zone->lock);
_
