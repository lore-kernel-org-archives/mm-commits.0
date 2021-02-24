Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8393C433E9
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:03:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E59264F1D
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:03:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235120AbhBXUDE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:03:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:55458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235216AbhBXUC0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:02:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE9B864E20;
        Wed, 24 Feb 2021 20:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196890;
        bh=toh4JbE/mFziqaT8vghw6ctptenKDfbrWau1XAqpAkk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1I5XAof1vqyjwy2NSLCMOnqiYWzLbsdTts2qjLc95SSguL9cuLiAEIaM8tj63RKF7
         bfpy5lOy77laJpmTfVH+VfeCc1BH+e5xztBmpOp8ppoywy+yJ141Jst439lPFAa96A
         Jh87IYRAlUDJhbEiLkfz1cD6Bd++kkelGOUnAcho=
Date:   Wed, 24 Feb 2021 12:01:29 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org, ziy@nvidia.com
Subject:  [patch 024/173] mm/debug: improve memcg debugging
Message-ID: <20210224200129.GAA7qjsYK%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/debug: improve memcg debugging

The memcg_data is only valid on the head page, not the tail pages.  Change
the format and location of the printout within the dump to match the other
parts of struct page better.

Link: https://lkml.kernel.org/r/20210114190200.1894484-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/debug.c~mm-debug-improve-memcg-debugging
+++ a/mm/debug.c
@@ -110,6 +110,11 @@ void __dump_page(struct page *page, cons
 					head_compound_mapcount(head));
 		}
 	}
+
+#ifdef CONFIG_MEMCG
+	if (head->memcg_data)
+		pr_warn("memcg:%lx\n", head->memcg_data);
+#endif
 	if (PageKsm(page))
 		type = "ksm ";
 	else if (PageAnon(page))
@@ -180,11 +185,6 @@ hex_only:
 
 	if (reason)
 		pr_warn("page dumped because: %s\n", reason);
-
-#ifdef CONFIG_MEMCG
-	if (!page_poisoned && page->memcg_data)
-		pr_warn("pages's memcg:%lx\n", page->memcg_data);
-#endif
 }
 
 void dump_page(struct page *page, const char *reason)
_
