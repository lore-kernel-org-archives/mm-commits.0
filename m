Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9B67C433B4
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE8CF61041
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbhEGBF2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:05:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234090AbhEGBF1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:05:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23BFF61041;
        Fri,  7 May 2021 01:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349466;
        bh=oYJQ30afkHJReuv6M9UXXmMZGu6Bfqkux4O3kIgCugo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CbqmBZwxnXGqHeYN9ig3JXKPepq71FvO+hQMgTVj+ftgZJXc9Ui2GqCdPx/Z0hbln
         9TuFUPZeJLlnc7YIdDl47V++lkjXi9I3RZcENfk1VtyeNP8WNkhM97kTPOu+yCEBwI
         Yx7KZqYMVuSGtr7s+QBY+xQMZc2VRAsjYLvlCvQ0=
Date:   Thu, 06 May 2021 18:04:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, eb@emlix.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 46/91] kernel/fork.c: simplify copy_mm()
Message-ID: <20210507010425.GotugDEPA%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Rolf Eike Beer <eb@emlix.com>
Subject: kernel/fork.c: simplify copy_mm()

All this can happen without a single goto.

Link: https://lkml.kernel.org/r/2072685.XptgVkyDqn@devpool47
Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/kernel/fork.c~simplify-copy_mm
+++ a/kernel/fork.c
@@ -1396,7 +1396,6 @@ fail_nomem:
 static int copy_mm(unsigned long clone_flags, struct task_struct *tsk)
 {
 	struct mm_struct *mm, *oldmm;
-	int retval;
 
 	tsk->min_flt = tsk->maj_flt = 0;
 	tsk->nvcsw = tsk->nivcsw = 0;
@@ -1423,21 +1422,15 @@ static int copy_mm(unsigned long clone_f
 	if (clone_flags & CLONE_VM) {
 		mmget(oldmm);
 		mm = oldmm;
-		goto good_mm;
+	} else {
+		mm = dup_mm(tsk, current->mm);
+		if (!mm)
+			return -ENOMEM;
 	}
 
-	retval = -ENOMEM;
-	mm = dup_mm(tsk, current->mm);
-	if (!mm)
-		goto fail_nomem;
-
-good_mm:
 	tsk->mm = mm;
 	tsk->active_mm = mm;
 	return 0;
-
-fail_nomem:
-	return retval;
 }
 
 static int copy_fs(unsigned long clone_flags, struct task_struct *tsk)
_
