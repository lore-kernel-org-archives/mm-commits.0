Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46F64C3526F
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 219E422D07
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbgLPAAl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:34676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726166AbgLOX2U (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:28:20 -0500
Date:   Tue, 15 Dec 2020 15:24:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074662;
        bh=K/hAG5CB4IlqV/5I/L3AFaNlITSrs8fvrnoaFWvZwmo=;
        h=From:To:Subject:From;
        b=EZBfaYNKiO5psXEJJCTnxBCPWIKzCHHEktLQlktCZf6aBwE6mlFdRtlkeVVTZY0Bf
         ThlAzlGj3tCs5HPZ+PbGLKh7phT76MVbmuYY1yvKWpkBWCugjiy41JESzuvMNoWvZ/
         iWLIR5HFVExx45UWtTuoNI6maVJrO2X8Fjs/Jgvs=
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com
Subject:  [merged]
 zsmalloc-rework-the-list_add-code-in-insert_zspage.patch removed from -mm
 tree
Message-ID: <20201215232422.LEWxGXJCd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc.c: rework the list_add code in insert_zspage()
has been removed from the -mm tree.  Its filename was
     zsmalloc-rework-the-list_add-code-in-insert_zspage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are


