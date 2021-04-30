Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC1C7C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:55:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B48561468
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:55:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhD3Fzu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:55:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230132AbhD3Fzt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:55:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 774DF61459;
        Fri, 30 Apr 2021 05:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762100;
        bh=/OPPDAWUkpd6ZV/THbEEyUEw0QJFPDFog9OSW1OlypQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=VfSV1ShGYjET+ch7M6X472HhV/CVcmRrsRl+Bz6Ge1gv2RRzxh1Xp2TBxMGKBYg/m
         0trRGR8oxS6La7QTJBCJGG5wZRkmT5n/3QkVezA4LYOykWGP3ujE0YaGQLbYnjcma4
         JktRJ9YkPyIrzDjiyYpR7kugMMf4Ps0qBs5ni0cM=
Date:   Thu, 29 Apr 2021 22:55:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        zhongjiang-ali@linux.alibaba.com
Subject:  [patch 035/178] mm, page_owner: remove unused parameter
 in __set_page_owner_handle
Message-ID: <20210430055500.HxeucjGI5%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: zhongjiang-ali <zhongjiang-ali@linux.alibaba.com>
Subject: mm, page_owner: remove unused parameter in __set_page_owner_handle

Since commit 5556cfe8d994 ("mm, page_owner: fix off-by-one error in
__set_page_owner_handle()") introduced, the parameter 'page' will not
used, hence it need to be removed.

Link: https://lkml.kernel.org/r/1616602022-43545-1-git-send-email-zhongjiang-ali@linux.alibaba.com
Signed-off-by: zhongjiang-ali <zhongjiang-ali@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-remove-unused-parameter-in-__set_page_owner_handle
+++ a/mm/page_owner.c
@@ -165,9 +165,9 @@ void __reset_page_owner(struct page *pag
 	}
 }
 
-static inline void __set_page_owner_handle(struct page *page,
-	struct page_ext *page_ext, depot_stack_handle_t handle,
-	unsigned int order, gfp_t gfp_mask)
+static inline void __set_page_owner_handle(struct page_ext *page_ext,
+					depot_stack_handle_t handle,
+					unsigned int order, gfp_t gfp_mask)
 {
 	struct page_owner *page_owner;
 	int i;
@@ -197,7 +197,7 @@ noinline void __set_page_owner(struct pa
 		return;
 
 	handle = save_stack(gfp_mask);
-	__set_page_owner_handle(page, page_ext, handle, order, gfp_mask);
+	__set_page_owner_handle(page_ext, handle, order, gfp_mask);
 }
 
 void __set_page_owner_migrate_reason(struct page *page, int reason)
@@ -616,7 +616,7 @@ static void init_pages_in_zone(pg_data_t
 				continue;
 
 			/* Found early allocated page */
-			__set_page_owner_handle(page, page_ext, early_handle,
+			__set_page_owner_handle(page_ext, early_handle,
 						0, 0);
 			count++;
 		}
_
