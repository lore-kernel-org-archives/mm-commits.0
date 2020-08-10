Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB4AC433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81DDE2065D
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026972;
	bh=9FEiO6W0fkhoX1Y346iC19h4bc0cBBKeMXsoRvRUEso=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=q+1oYlPAWm+JrBwYKba975SB26OH8ZajN5BIJQ1iQ0tz0pfvHFeeoYRhfA8RxZsFT
	 2gEX/M6Evop8ZVvqTrhwmpeFEoywBAQ6t2OYCJlb4u7VpU9i5s0R2n4yNbRpG2Wbe4
	 /nOXLJQkay05erF8N8OYHrLiCh5MYUiWyboI4qK4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgHJCgM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:36:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:39292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCgM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:36:12 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78D50206C3;
        Mon, 10 Aug 2020 02:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026971;
        bh=9FEiO6W0fkhoX1Y346iC19h4bc0cBBKeMXsoRvRUEso=;
        h=Date:From:To:Subject:From;
        b=VUGwWfKDEVdgpceulzCYQ1/7Vw4sT1Ln602Hy6QIYCKUPqmMkkl3uJTXfgy8LKiHs
         K7Uj2T3GnGZnis1wFQQBrXHjKrSuahZsVfw1RQqsbSVTbkk/m8OLF5TfjjbgSvH0O0
         7LfbCZs/Htsakj5fWERRrC+ev7wWZ7086tecndII=
Date:   Sun, 09 Aug 2020 19:36:11 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, thunder.leizhen@huawei.com,
        tim.c.chen@linux.intel.com
Subject:  [merged]
 mm-swap-remove-redundant-check-for-swap_slot_cache_initialized.patch
 removed from -mm tree
Message-ID: <20200810023611.AE6Ygo66B%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap_slots.c: remove redundant check for swap_slot_cache_initialized
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-redundant-check-for-swap_slot_cache_initialized.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: mm/swap_slots.c: remove redundant check for swap_slot_cache_initialized

Because enable_swap_slots_cache can only become true in
enable_swap_slots_cache(), and depends on swap_slot_cache_initialized is
true before.  That means, when enable_swap_slots_cache is true,
swap_slot_cache_initialized is true also.

So the condition:
"swap_slot_cache_enabled && swap_slot_cache_initialized"
can be reduced to "swap_slot_cache_enabled"

And in mathematics:
"!swap_slot_cache_enabled || !swap_slot_cache_initialized"
is equal to "!(swap_slot_cache_enabled && swap_slot_cache_initialized)"

So no functional change.

Link: http://lkml.kernel.org/r/20200430061143.450-4-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_slots.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/swap_slots.c~mm-swap-remove-redundant-check-for-swap_slot_cache_initialized
+++ a/mm/swap_slots.c
@@ -46,8 +46,7 @@ static void __drain_swap_slots_cache(uns
 static void deactivate_swap_slots_cache(void);
 static void reactivate_swap_slots_cache(void);
 
-#define use_swap_slot_cache (swap_slot_cache_active && \
-		swap_slot_cache_enabled && swap_slot_cache_initialized)
+#define use_swap_slot_cache (swap_slot_cache_active && swap_slot_cache_enabled)
 #define SLOTS_CACHE 0x1
 #define SLOTS_CACHE_RET 0x2
 
@@ -94,7 +93,7 @@ static bool check_cache_active(void)
 {
 	long pages;
 
-	if (!swap_slot_cache_enabled || !swap_slot_cache_initialized)
+	if (!swap_slot_cache_enabled)
 		return false;
 
 	pages = get_nr_swap_pages();
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are


