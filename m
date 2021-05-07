Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D91CC43460
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:04:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D114610FA
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234090AbhEGBF3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:05:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234073AbhEGBF2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:05:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16F86613B5;
        Fri,  7 May 2021 01:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349469;
        bh=vvrQ1k3FbumfTbXi5p7S89PC9Za3U76Fn2hQPDctZKI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Ni4fSESV8aMv/ChezJ0nvytTYQsea+p9Fh3/Aguh4oX3uXI9qiK4a3jKJAawv6roT
         2ym+I1mhKnoc6UeeIWepSTRHJ3Zgk3edeQYGxKl7QrUOccdbjPuDLHwwlAWYxMLdna
         f3xzXjOrwrsp01fa5zVZkJhsTORIW8yu5ExlZ6ig=
Date:   Thu, 06 May 2021 18:04:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk, caoxiaofeng@yulong.com,
        christian.brauner@ubuntu.com, cxfcosmos@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 47/91] kernel/fork.c: fix typos
Message-ID: <20210507010428.EGHlz4IUa%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Xiaofeng Cao <cxfcosmos@gmail.com>
Subject: kernel/fork.c: fix typos

change 'ancestoral' to 'ancestral'
change 'reuseable' to 'reusable'
delete 'do' grammatically

Link: https://lkml.kernel.org/r/20210317082031.11692-1-caoxiaofeng@yulong.com
Signed-off-by: Xiaofeng Cao <caoxiaofeng@yulong.com>
Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/fork.c~kernel-fork-fix-typo-issue
+++ a/kernel/fork.c
@@ -1145,7 +1145,7 @@ void mmput_async(struct mm_struct *mm)
  * invocations: in mmput() nobody alive left, in execve task is single
  * threaded. sys_prctl(PR_SET_MM_MAP/EXE_FILE) also needs to set the
  * mm->exe_file, but does so without using set_mm_exe_file() in order
- * to do avoid the need for any locks.
+ * to avoid the need for any locks.
  */
 void set_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file)
 {
@@ -1736,7 +1736,7 @@ static int pidfd_release(struct inode *i
  * /proc/<pid>/status where Pid and NSpid are always shown relative to
  * the  pid namespace of the procfs instance. The difference becomes
  * obvious when sending around a pidfd between pid namespaces from a
- * different branch of the tree, i.e. where no ancestoral relation is
+ * different branch of the tree, i.e. where no ancestral relation is
  * present between the pid namespaces:
  * - create two new pid namespaces ns1 and ns2 in the initial pid
  *   namespace (also take care to create new mount namespaces in the
@@ -2728,8 +2728,8 @@ static bool clone3_args_valid(struct ker
 		return false;
 
 	/*
-	 * - make the CLONE_DETACHED bit reuseable for clone3
-	 * - make the CSIGNAL bits reuseable for clone3
+	 * - make the CLONE_DETACHED bit reusable for clone3
+	 * - make the CSIGNAL bits reusable for clone3
 	 */
 	if (kargs->flags & (CLONE_DETACHED | CSIGNAL))
 		return false;
_
