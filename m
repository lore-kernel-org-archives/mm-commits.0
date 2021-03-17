Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 825F8C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 22:37:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2953164F2B
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 22:37:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhCQWhO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Mar 2021 18:37:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230036AbhCQWhF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Mar 2021 18:37:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D885964EEC;
        Wed, 17 Mar 2021 22:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616020625;
        bh=IlckXt7rs3nnk4jOwB3M53eC/6VQqAz+fFAEeopj4qA=;
        h=Date:From:To:Subject:From;
        b=DpN2Wp/s0RAiJztAB02Q/yqlBcjuVHBkCnnBYqaq/KIhdpFb3NyCFGLkJv9mynmFy
         ZvchZvAl/PO/ZWRwAm9NSyoLloydU5UyZq/lSYOJvZKGiZGcvZuqnFEPOIM8AgcUhk
         pR0LEPpuuG6Ac2QtcbpO4e4sLfOi/vZ/LGHhoU5g=
Date:   Wed, 17 Mar 2021 15:37:04 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, caoxiaofeng@yulong.com,
        christian.brauner@ubuntu.com, cxfcosmos@gmail.com,
        mm-commits@vger.kernel.org
Subject:  + kernel-fork-fix-typo-issue.patch added to -mm tree
Message-ID: <20210317223704.36NiwQXRH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/fork.c: fix typos
has been added to the -mm tree.  Its filename is
     kernel-fork-fix-typo-issue.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-fork-fix-typo-issue.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-fork-fix-typo-issue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -1142,7 +1142,7 @@ void mmput_async(struct mm_struct *mm)
  * invocations: in mmput() nobody alive left, in execve task is single
  * threaded. sys_prctl(PR_SET_MM_MAP/EXE_FILE) also needs to set the
  * mm->exe_file, but does so without using set_mm_exe_file() in order
- * to do avoid the need for any locks.
+ * to avoid the need for any locks.
  */
 void set_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file)
 {
@@ -1733,7 +1733,7 @@ static int pidfd_release(struct inode *i
  * /proc/<pid>/status where Pid and NSpid are always shown relative to
  * the  pid namespace of the procfs instance. The difference becomes
  * obvious when sending around a pidfd between pid namespaces from a
- * different branch of the tree, i.e. where no ancestoral relation is
+ * different branch of the tree, i.e. where no ancestral relation is
  * present between the pid namespaces:
  * - create two new pid namespaces ns1 and ns2 in the initial pid
  *   namespace (also take care to create new mount namespaces in the
@@ -2722,8 +2722,8 @@ static bool clone3_args_valid(struct ker
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

Patches currently in -mm which might be from cxfcosmos@gmail.com are

kernel-user_namespace-fix-typo-issue.patch
kernel-fork-fix-typo-issue.patch

