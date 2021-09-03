Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95CFAC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EF7D610C8
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234472AbhICVCT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:02:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350030AbhICVCS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:02:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8455160EE3;
        Fri,  3 Sep 2021 21:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702878;
        bh=M7U6Dd/LCTB4xZXjf0jY15CqqM/ig+Lb2YrvMXEqdFQ=;
        h=Date:From:To:Subject:From;
        b=qhCjfJWNMWw8RztIG7bsVyESJm2HcztVpx45BK/89qkMTGtPCLopDci8Q3gfodwnf
         LxsbX9VhYlnZI1bSo984/iI8liorQsQdfrjcoeVS7baVV3M598CQUSEwn+sN6BX4sh
         zPGsfRnP8adHQOsR+GXFXvXGFrVtvBMGHgMcjYG4=
Date:   Fri, 03 Sep 2021 14:01:18 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vvs@virtuozzo.com
Subject:  [merged] mm-use-in_task-in-mempolicy_slab_node.patch
 removed from -mm tree
Message-ID: <20210903210118.3Qso3W-cp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy.c: use in_task() in mempolicy_slab_node()
has been removed from the -mm tree.  Its filename was
     mm-use-in_task-in-mempolicy_slab_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vasily Averin <vvs@virtuozzo.com>
Subject: mm/mempolicy.c: use in_task() in mempolicy_slab_node()

Obsoleted in_intrrupt() include task context with disabled BH, it's better
to use in_task() instead.

Link: https://lkml.kernel.org/r/984ee771-4834-21da-801f-c15c18ddf4d1@virtuozzo.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-use-in_task-in-mempolicy_slab_node
+++ a/mm/mempolicy.c
@@ -1934,7 +1934,7 @@ unsigned int mempolicy_slab_node(void)
 	struct mempolicy *policy;
 	int node = numa_mem_id();
 
-	if (in_interrupt())
+	if (!in_task())
 		return node;
 
 	policy = current->mempolicy;
_

Patches currently in -mm which might be from vvs@virtuozzo.com are


