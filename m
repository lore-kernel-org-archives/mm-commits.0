Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F6D3C35270
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F09E22D08
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725840AbgLPAAL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:34560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbgLOX1O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:27:14 -0500
Date:   Tue, 15 Dec 2020 15:17:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074229;
        bh=J3bQVAg5+vdGINxEtlxgXqJ4lc1EzrHUBj51VE+e4IM=;
        h=From:To:Subject:From;
        b=N1oLQbn0zY/5P9XexlDZN5fLTDaetoNBlb20SHBplxxAnY+hWDJGM0Qwo9ryWBJiR
         gNk0SGcQ9fq4/L2Jl1M+POypqG/CebPt2/n9tJTC4NFdbFEHDKierO2tiDDMQm3jri
         UPGyHxPxR9DK/h1MHQtBUFrGXeZij6bJ05SUXi2c=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, carver4lio@163.com,
        liu.hailong6@zte.com.cn, mm-commits@vger.kernel.org
Subject:  [merged] mm-remove-the-unuseful-else-after-a-return.patch
 removed from -mm tree
Message-ID: <20201215231709.ciUy2g6yu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap.c: remove else after a return
has been removed from the -mm tree.  Its filename was
     mm-remove-the-unuseful-else-after-a-return.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from carver4lio@163.com are


