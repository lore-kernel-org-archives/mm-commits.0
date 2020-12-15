Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27EA1C2BB40
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5553224B2
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgLODFk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:05:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:60680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727223AbgLODFS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:05:18 -0500
Date:   Mon, 14 Dec 2020 19:05:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001502;
        bh=ac+AE+rdhzuUx5TMyW1deoj6szh7xa0A3YGUu6Ckwok=;
        h=From:To:Subject:In-Reply-To:From;
        b=phlAtmXzKcyQliHXhvZP76nsKKhGu+MrvQSUkOlE/SeXGuRfVHhzqt6QmJbQcTB6J
         2w+7mUXnKP7XUY3Dnaki9m4QhUCbJsA4o3llLzGGXVZMT89WCsU1Cqo9MvfnqA50RP
         ZZALYms+kUsK/SSCvDcqijk5J1EfsTM88uu+5MWc=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, carver4lio@163.com, linux-mm@kvack.org,
        liu.hailong6@zte.com.cn, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 031/200] mm/filemap.c: remove else after a return
Message-ID: <20201215030502.gbCPAEf6A%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hailong Liu <carver4lio@163.com>
Subject: mm/filemap.c: remove else after a return

The `else' is not useful after a `return' in __lock_page_or_retry().

[akpm@linux-foundation.org: coding style fixes]
Link: https://lkml.kernel.org/r/20201202154720.115162-1-carver4lio@163.com
Signed-off-by: Hailong Liu<liu.hailong6@zte.com.cn>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/mm/filemap.c~mm-remove-the-unuseful-else-after-a-return
+++ a/mm/filemap.c
@@ -1583,19 +1583,20 @@ int __lock_page_or_retry(struct page *pa
 		else
 			wait_on_page_locked(page);
 		return 0;
-	} else {
-		if (flags & FAULT_FLAG_KILLABLE) {
-			int ret;
+	}
+	if (flags & FAULT_FLAG_KILLABLE) {
+		int ret;
 
-			ret = __lock_page_killable(page);
-			if (ret) {
-				mmap_read_unlock(mm);
-				return 0;
-			}
-		} else
-			__lock_page(page);
-		return 1;
+		ret = __lock_page_killable(page);
+		if (ret) {
+			mmap_read_unlock(mm);
+			return 0;
+		}
+	} else {
+		__lock_page(page);
 	}
+	return 1;
+
 }
 
 /**
_
