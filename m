Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 064B4C11F6A
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E202B61468
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238500AbhGABzb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:55:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238499AbhGABzb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:55:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D79926105A;
        Thu,  1 Jul 2021 01:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104382;
        bh=M43RQCLRu9wA7tddapQP5/1Byd2HZw83UfDEII0Ul6A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Sxeb7AJjQLm5yRyJX2qlJnorgGzclyuvHaDFYhsSfbV0Avgiq0De9MR20W33VjXpq
         1/W9NU++xxqjPIkWicTUmqlIcPO5ix9CMo8e9MdmCc61F8TjnsmaHY3un5qPD6AXx+
         pDD3rqDDo2s5bAT5FDvw2AcOOIEvLOZPGuOIyWRM=
Date:   Wed, 30 Jun 2021 18:53:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, minchan@kernel.org, mm-commits@vger.kernel.org,
        ngupta@vflare.org, senozhatsky@chromium.org,
        torvalds@linux-foundation.org
Subject:  [patch 109/192] mm/zsmalloc.c: remove confusing code in
 obj_free()
Message-ID: <20210701015301.tcFA0cOau%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/zsmalloc.c: remove confusing code in obj_free()

Patch series "Cleanup for zsmalloc".

This series contains cleanups to remove confusing code in obj_free(),
combine two atomic ops and improve readability for async_free_zspage(). 
More details can be found in the respective changelogs.


This patch (of 2):

OBJ_ALLOCATED_TAG is only set for handle to indicate allocated object. 
It's irrelevant with obj.  So remove this misleading code to improve
readability.

Link: https://lkml.kernel.org/r/20210624123930.1769093-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210624123930.1769093-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/zsmalloc.c~mm-zsmallocc-remove-confusing-code-in-obj_free
+++ a/mm/zsmalloc.c
@@ -1471,7 +1471,6 @@ static void obj_free(struct size_class *
 	unsigned int f_objidx;
 	void *vaddr;
 
-	obj &= ~OBJ_ALLOCATED_TAG;
 	obj_to_location(obj, &f_page, &f_objidx);
 	f_offset = (class->size * f_objidx) & ~PAGE_MASK;
 	zspage = get_zspage(f_page);
_
