Return-Path: <SRS0=v6Vt=IE=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5CFBC433E6
	for <mm-commits@archiver.kernel.org>; Sat,  6 Mar 2021 01:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 876216508F
	for <mm-commits@archiver.kernel.org>; Sat,  6 Mar 2021 01:05:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhCFBEg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Mar 2021 20:04:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:42212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229493AbhCFBEM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Mar 2021 20:04:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A55E565085;
        Sat,  6 Mar 2021 01:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614992651;
        bh=tXCR7+L20lJFRGQqS6swWoWdXWCb6ZWGZL0+pfYxF7k=;
        h=Date:From:To:Subject:From;
        b=a33MXqcX0dLVmVkmIeG4HaQRMbLVJyIKM6G/20WkEqS4NbHp6O0gZrfiG72oIg75p
         5PF4gNbWurRYv1jJjsMhNedHhxLP8k181SG6wo1YbO6LpqmR5LIuAtMVZ1gPMTpuEE
         O3DB59ys/8GThcuDxusysqBhHAB1K0WOSXzaJBv4=
Date:   Fri, 05 Mar 2021 17:04:11 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, eb@emlix.com, mm-commits@vger.kernel.org
Subject:  + simplify-copy_mm.patch added to -mm tree
Message-ID: <20210306010411.GJa5_WJGF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/fork.c: simplify copy_mm()
has been added to the -mm tree.  Its filename is
     simplify-copy_mm.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/simplify-copy_mm.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/simplify-copy_mm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1393,7 +1393,6 @@ fail_nomem:
 static int copy_mm(unsigned long clone_flags, struct task_struct *tsk)
 {
 	struct mm_struct *mm, *oldmm;
-	int retval;
 
 	tsk->min_flt = tsk->maj_flt = 0;
 	tsk->nvcsw = tsk->nivcsw = 0;
@@ -1420,21 +1419,15 @@ static int copy_mm(unsigned long clone_f
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

simplify-copy_mm.patch

