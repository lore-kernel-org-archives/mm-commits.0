Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A696C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E12B16117A
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:11:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbhKICNw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:13:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:43900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230190AbhKICNv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:13:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4534D610D2;
        Tue,  9 Nov 2021 02:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636423866;
        bh=pNx3mRHbnjZymo3C52++AlzR++z8IhY36OJzsREmAsU=;
        h=Date:From:To:Subject:From;
        b=HnmvTN84oVzIZiB8eSZq4C7ht3iRimm0e96KvK62KAHxj0XlR0tlFzen1/330+eRc
         hD+GnfryVz4ucjf/GflPg8anbv/BWBhUx1QkRi6vw7XzaxBfLJOKV8H5+dodqzBvzh
         YoeFSQ2GN57jciQiI9Ti/ILPkqD00Y096U+Oylfg=
Date:   Mon, 08 Nov 2021 18:11:05 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, fweimer@redhat.com,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch removed from -mm tree
Message-ID: <20211109021105.cqX1dOD1x%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: procfs-do-not-list-tid-0-in-proc-pid-task-fix
has been removed from the -mm tree.  Its filename was
     procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch

This patch was dropped because it was folded into procfs-do-not-list-tid-0-in-proc-pid-task.patch

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

procfs-do-not-list-tid-0-in-proc-pid-task.patch
delay-replace-kernelh-with-the-necessary-inclusions-fix.patch
delay-replace-kernelh-with-the-necessary-inclusions-fix-2-fix.patch
generic-radix-tree-replace-kernelh-with-the-necessary-inclusions-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch
mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
revert-acct_reclaim_writeback-for-next.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios.patch
mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

