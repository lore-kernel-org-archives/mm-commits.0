Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74BFBC433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:40:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56E1D61426
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:40:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbhEEBk5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:40:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231869AbhEEBk4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:40:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31F3D61029;
        Wed,  5 May 2021 01:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178801;
        bh=rSlC+aYFNNl+LzjQyVpX0B56vseEQT8n2IgVzPTWsnw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Zlhym412ViFatlElIAVwd0+tEFukY5OzaomBRiXhroW71AtjuZmZKD4AoXzleudWb
         AItwaMBSNI3hb35KPC5YVnkUPDslfQb95034ra5VSuGxSrCoS6VlFMepvgu3HI6jFr
         dCrzTkNTLk7NJlmxNGUciMCcGxoBUSQEmXCsZcB4=
Date:   Tue, 04 May 2021 18:40:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, sergey.senozhatsky.work@gmail.com,
        torvalds@linux-foundation.org, zhouchuangao@vivo.com
Subject:  [patch 134/143] mm/zsmalloc: use BUG_ON instead of if
 condition followed by BUG.
Message-ID: <20210505014000.Edaxu2Zh0%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
