Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C93AC2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:15:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A189224B2
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgLODPK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:15:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:42044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbgLODOo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:14:44 -0500
Date:   Mon, 14 Dec 2020 19:14:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608002063;
        bh=UXjlp9NJlhwE5ikCzG+uXHjYWwkGAgJ7NH8vp6BO+0M=;
        h=From:To:Subject:In-Reply-To:From;
        b=GTS+TWXsS/z4pqdZe2fjajFt775FRAx9t9x24C5XIDJqRIP2CoX0w8wWss08GS0b4
         3w3mlYRYpP6MU+cqTLOCyOeqDsbxMOQCDUGCz34MdGCag92ZjfLUpb6rAqHO3AgqTe
         JDrozSaqDHlsWqlL3RjSpRBLbagHiuvlxKEWv0ZM=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, minchan@kernel.org, mm-commits@vger.kernel.org,
        sergey.senozhatsky@gmail.com, torvalds@linux-foundation.org
Subject:  [patch 188/200] mm/zsmalloc.c: rework the list_add code
 in insert_zspage()
Message-ID: <20201215031422.zqoLTL8_6%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/zsmalloc.c: rework the list_add code in insert_zspage()

Rework the list_add code to make it more readable and simple.

Link: https://lkml.kernel.org/r/20201015130107.65195-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-rework-the-list_add-code-in-insert_zspage
+++ a/mm/zsmalloc.c
@@ -726,13 +726,10 @@ static void insert_zspage(struct size_cl
 	 * We want to see more ZS_FULL pages and less almost empty/full.
 	 * Put pages with higher ->inuse first.
 	 */
-	if (head) {
-		if (get_zspage_inuse(zspage) < get_zspage_inuse(head)) {
-			list_add(&zspage->list, &head->list);
-			return;
-		}
-	}
-	list_add(&zspage->list, &class->fullness_list[fullness]);
+	if (head && get_zspage_inuse(zspage) < get_zspage_inuse(head))
+		list_add(&zspage->list, &head->list);
+	else
+		list_add(&zspage->list, &class->fullness_list[fullness]);
 }
 
 /*
_
