Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91908C43470
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A00E61402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhEHWwT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:52:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229664AbhEHWwS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:52:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91E48613EA;
        Sat,  8 May 2021 22:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514276;
        bh=WpvLnnW2pIXJYxb/c1zkSJMo7Rdto3BaQwWmV2cL25M=;
        h=Date:From:To:Subject:From;
        b=t7TWLf3fkw/8uRnQRf3oIDEZ450JRLnJpYD2T5WWG2LrZdwWMs9mO43b2is7vZyIc
         7xNAbwM/S1JX4F4c2if3DgijTFmrcaX2OEuou345+/9FD+jtvoYH72bujF1kyBdYsa
         Vmn5q5mJ/CehyhhzGNyO+F9ZSHclrY313dQ2t5+4=
Date:   Sat, 08 May 2021 15:51:16 -0700
From:   akpm@linux-foundation.org
To:     minchan@kernel.org, mm-commits@vger.kernel.org,
        sergey.senozhatsky.work@gmail.com, zhouchuangao@vivo.com
Subject:  [merged]
 mm-zsmalloc-use-bug_on-instead-of-if-condition-followed-by-bug.patch
 removed from -mm tree
Message-ID: <20210508225116.h3zWf-INl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: use BUG_ON instead of if condition followed by BUG.
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-use-bug_on-instead-of-if-condition-followed-by-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: zhouchuangao <zhouchuangao@vivo.com>
Subject: mm/zsmalloc: use BUG_ON instead of if condition followed by BUG.

It can be optimized at compile time.

Link: https://lkml.kernel.org/r/1616727798-9110-1-git-send-email-zhouchuangao@vivo.com
Signed-off-by: zhouchuangao <zhouchuangao@vivo.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-use-bug_on-instead-of-if-condition-followed-by-bug
+++ a/mm/zsmalloc.c
@@ -1987,8 +1987,7 @@ static int zs_page_migrate(struct addres
 		head = obj_to_head(page, addr);
 		if (head & OBJ_ALLOCATED_TAG) {
 			handle = head & ~OBJ_ALLOCATED_TAG;
-			if (!testpin_tag(handle))
-				BUG();
+			BUG_ON(!testpin_tag(handle));
 
 			old_obj = handle_to_obj(handle);
 			obj_to_location(old_obj, &dummy, &obj_idx);
@@ -2035,8 +2034,7 @@ unpin_objects:
 		head = obj_to_head(page, addr);
 		if (head & OBJ_ALLOCATED_TAG) {
 			handle = head & ~OBJ_ALLOCATED_TAG;
-			if (!testpin_tag(handle))
-				BUG();
+			BUG_ON(!testpin_tag(handle));
 			unpin_tag(handle);
 		}
 	}
_

Patches currently in -mm which might be from zhouchuangao@vivo.com are


