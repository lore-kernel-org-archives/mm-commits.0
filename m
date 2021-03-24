Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B37CC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 18:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9E1161A17
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 18:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237629AbhCXS5u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:57:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237604AbhCXS5b (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Mar 2021 14:57:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FDEF619EC;
        Wed, 24 Mar 2021 18:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616612251;
        bh=jQzGKL9I9rW2zbiy/mz354szE7BM50kn6MpPj4bMw3c=;
        h=Date:From:To:Subject:From;
        b=oeIQ21s0zFNuz6ryGq5doNo2c7euD67WvBe/Djr1jTEI2aB21XKrxRFljbdG5Mz96
         s2HyKhT+xwD4i3SkjrXp/DzPSsTOT0iqK0Sxbdd9E2UvU6EAs8AHEa0hNrX1X6B3Cf
         5zSqySKXH5S32IpAXL9mKbBPvYhZh7bz2SM0ZQS0=
Date:   Wed, 24 Mar 2021 11:57:31 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zhongjiang-ali@linux.alibaba.com
Subject:  +
 mm-page_owner-remove-unused-parameter-in-__set_page_owner_handle.patch added
 to -mm tree
Message-ID: <20210324185731.bWeGV%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_owner: remove unused parameter in __set_page_owner_handle
has been added to the -mm tree.  Its filename is
     mm-page_owner-remove-unused-parameter-in-__set_page_owner_handle.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-remove-unused-parameter-in-__set_page_owner_handle.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-remove-unused-parameter-in-__set_page_owner_handle.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page_owner-remove-unused-parameter-in-__set_page_owner_handle.patch

