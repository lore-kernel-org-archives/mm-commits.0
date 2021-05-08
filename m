Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE43AC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCCA361448
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhEHWyi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:54:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229672AbhEHWyg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:54:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87AD461432;
        Sat,  8 May 2021 22:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514411;
        bh=MzZzpqh/zxQ3hG7y8No3LxXxOT5l85YFttABWI9onTI=;
        h=Date:From:To:Subject:From;
        b=GoM7nHkdaiYzWtI+4w817K7S8Tw4ELGYgL4xxSwZKkTrRx7AibOYrWtnrgD1LDUuP
         dC0OPYFEWo+T7LRUC9XV/8OcdfNZ+r514KxTBJmOLmoHGpj51pItR4BQinF8uCARzK
         /MNRsxog9bdAdT0Yn/Koor8pRf7Sup9OKdpXYxMs=
Date:   Sat, 08 May 2021 15:53:31 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, eb@emlix.com, mm-commits@vger.kernel.org
Subject:  [merged] simplify-copy_mm.patch removed from -mm tree
Message-ID: <20210508225331.cz3YBv0gC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/fork.c: simplify copy_mm()
has been removed from the -mm tree.  Its filename was
     simplify-copy_mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from eb@emlix.com are


