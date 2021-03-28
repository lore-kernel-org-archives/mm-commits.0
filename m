Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53AD8C433F2
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F22061958
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbhC1TLr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 15:11:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231552AbhC1TLm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 15:11:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F52661981;
        Sun, 28 Mar 2021 19:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616958702;
        bh=PCe2QyVoZRKO/QJEvK9Osb2Z/Mdin2H5+yKwDwTgZx8=;
        h=Date:From:To:Subject:From;
        b=zpZIITjw7/CMzaO6maMoMl88T4zeuPHJGPKYrwVwCOB6FbvUmpYHh0uIqCuymPbLv
         mcSrgxiSnbNpAkfJ9SefqjLrSyDj1OUm1Xzmhk+UmO7aIYpt2rDeiHInRaiYBx9aj4
         mFaddcWTv4GPJIWSy5a8zxTF9PInsbUWGsKNs/lg=
Date:   Sun, 28 Mar 2021 12:11:41 -0700
From:   akpm@linux-foundation.org
To:     minchan@kernel.org, mm-commits@vger.kernel.org,
        sergey.senozhatsky.work@gmail.com, zhouchuangao@vivo.com
Subject:  +
 mm-zsmalloc-use-bug_on-instead-of-if-condition-followed-by-bug.patch added
 to -mm tree
Message-ID: <20210328191141.CshNnwk_R%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: use BUG_ON instead of if condition followed by BUG.
has been added to the -mm tree.  Its filename is
     mm-zsmalloc-use-bug_on-instead-of-if-condition-followed-by-bug.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-zsmalloc-use-bug_on-instead-of-if-condition-followed-by-bug.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-zsmalloc-use-bug_on-instead-of-if-condition-followed-by-bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page_alloc-duplicate-include-linux-vmalloch.patch
mm-zsmalloc-use-bug_on-instead-of-if-condition-followed-by-bug.patch
proc-sysctl-fix-function-name-error-in-comments.patch
umh-fix-some-spelling-mistakes.patch

