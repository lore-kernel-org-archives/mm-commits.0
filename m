Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 621EAC07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C62761C9E
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbhGFTXP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:23:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231696AbhGFTXP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:23:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FAE561C9A;
        Tue,  6 Jul 2021 19:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599236;
        bh=R2A08XVS8jaH63t2QedLq31VbjYTwornoP8rSltZsh8=;
        h=Date:From:To:Subject:From;
        b=Iw7KUdyB4HDh8o/j+EmWBEzXcgOqgwIgNJIorKmEKN+ctQplhsK/1AKftbez6H0fF
         Cb1WeHIddXz6COsTKjoqSvvCMUxbpgpjP02S7FLriv0WbyTuRLlG1YyyTwdwC/tJTV
         PHXR1Q5DC2347byD8vGQIoIld3/PMJF770roYhiM=
Date:   Tue, 06 Jul 2021 12:20:36 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, ngupta@vflare.org,
        senozhatsky@chromium.org
Subject:  [merged]
 mm-zsmallocc-remove-confusing-code-in-obj_free.patch removed from -mm tree
Message-ID: <20210706192036.r69PCzZQu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc.c: remove confusing code in obj_free()
has been removed from the -mm tree.  Its filename was
     mm-zsmallocc-remove-confusing-code-in-obj_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

