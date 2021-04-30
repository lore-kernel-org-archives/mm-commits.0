Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02374C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:57:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D631E6147F
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhD3F57 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:57:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229834AbhD3F54 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:57:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A78461476;
        Fri, 30 Apr 2021 05:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762227;
        bh=h2QPY9cwQrpFW3ouErkTvsq0JefgpJbHIeLt+u7qKLU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0MWZUCQdCB+uoXt0SBFp/+omSlKD9nd+cF8lJBAEf+YoTo2qf+AB5YCJPbBb6adYP
         KBwYM7oIAHq+PUOrImWcwlsuDQw51P9O3rgZx5Yyblp++MY+ntCDkrlL2R8gB7yTfx
         GSwAzon8RP10MTQtHmEjj28QDuBzB2J4VopUB0Ws=
Date:   Thu, 29 Apr 2021 22:57:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        wangqing@vivo.com
Subject:  [patch 077/178] mm/memory.c: do_numa_page(): delete bool
 "migrated"
Message-ID: <20210430055707.7F8XCZEuW%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>
Subject: mm/memory.c: do_numa_page(): delete bool "migrated"

Smatch gives the warning:
	do_numa_page() warn: assigning (-11) to unsigned variable 'migrated'

Link: https://lkml.kernel.org/r/1614603421-2681-1-git-send-email-wangqing@vivo.com
Signed-off-by: Wang Qing <wangqing@vivo.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/memory.c~mm-delete-bool-migrated
+++ a/mm/memory.c
@@ -4098,7 +4098,6 @@ static vm_fault_t do_numa_page(struct vm
 	int page_nid = NUMA_NO_NODE;
 	int last_cpupid;
 	int target_nid;
-	bool migrated = false;
 	pte_t pte, old_pte;
 	bool was_writable = pte_savedwrite(vmf->orig_pte);
 	int flags = 0;
@@ -4168,8 +4167,7 @@ static vm_fault_t do_numa_page(struct vm
 	}
 
 	/* Migrate to the requested node */
-	migrated = migrate_misplaced_page(page, vma, target_nid);
-	if (migrated) {
+	if (migrate_misplaced_page(page, vma, target_nid)) {
 		page_nid = target_nid;
 		flags |= TNF_MIGRATED;
 	} else
_
