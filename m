Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2EFEC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 888546141E
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbhEHWlN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:41:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229616AbhEHWlN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:41:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 721DD613EA;
        Sat,  8 May 2021 22:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513610;
        bh=LhU/qeYpMYGj3lCUxxvVXt0h7cT375iAVYhbFZKoehc=;
        h=Date:From:To:Subject:From;
        b=hcHtCTYERn1Eq6PUa5dDLUAjdd5t+MPXRWiPJnPuUeDKxsaeJmqfgEhP6LaL1raag
         dhW0pMvlD6VLsuyIGQJ68Jxf/DPTwzPwuIs9llD5begwK9oZGknw9yhwlFVMcFOj4I
         7l9l1W45MTSMUVlCvlGPP581qUJ8BDNKh3i3qC5s=
Date:   Sat, 08 May 2021 15:40:10 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zhongjiang-ali@linux.alibaba.com
Subject:  [merged]
 mm-page_owner-remove-unused-parameter-in-__set_page_owner_handle.patch
 removed from -mm tree
Message-ID: <20210508224010.w_ST9Eqra%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_owner: remove unused parameter in __set_page_owner_handle
has been removed from the -mm tree.  Its filename was
     mm-page_owner-remove-unused-parameter-in-__set_page_owner_handle.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from zhongjiang-ali@linux.alibaba.com are


