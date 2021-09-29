Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5589CC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 29 Sep 2021 23:20:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27C5F61406
	for <mm-commits@archiver.kernel.org>; Wed, 29 Sep 2021 23:20:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347504AbhI2XWY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Sep 2021 19:22:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347487AbhI2XWX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 29 Sep 2021 19:22:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE56961406;
        Wed, 29 Sep 2021 23:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632957641;
        bh=gbX1htg4VHh/FqNuIxJU1kZwXCaGDtCp5CcHCRz/Chg=;
        h=Date:From:To:Subject:From;
        b=2OwNZOkPYLQrfA9PfvT6ZDkZy6TK3DhxhxoaOoESQO7BIOZ3Cb03rZLdnNTc/T8vZ
         QKPBwlM2wIqeBlRNCWJiV/iTpR1nZbSw785QXUsEEZLbI3DhYTX15586MEwhWvCBZx
         NuQqW9fBk76xHXa4fHPqBiVrwbNss5Lz7eW7+soY=
Date:   Wed, 29 Sep 2021 16:20:41 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, fweimer@redhat.com,
        mm-commits@vger.kernel.org
Subject:  + procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
 added to -mm tree
Message-ID: <20210929232041.WC3PQ-p5d%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: procfs-do-not-list-tid-0-in-proc-pid-task-fix
has been added to the -mm tree.  Its filename is
     procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: procfs-do-not-list-tid-0-in-proc-pid-task-fix

coding style tweaks

Cc: Florian Weimer <fweimer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/proc/base.c~procfs-do-not-list-tid-0-in-proc-pid-task-fix
+++ a/fs/proc/base.c
@@ -3799,10 +3799,10 @@ static int proc_task_readdir(struct file
 	     task = next_tid(task), ctx->pos++) {
 		char name[10 + 1];
 		unsigned int len;
+
 		tid = task_pid_nr_ns(task, ns);
 		if (!tid)
-			/* The task has just exited. */
-			continue;
+			continue;	/* The task has just exited. */
 		len = snprintf(name, sizeof(name), "%u", tid);
 		if (!proc_fill_cache(file, ctx, name, len,
 				proc_task_instantiate, task, NULL)) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
kfence-limit-currently-covered-allocations-when-pool-nearly-full-fix-fix.patch
procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

