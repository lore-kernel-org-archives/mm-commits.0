Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D30BC4167B
	for <mm-commits@archiver.kernel.org>; Wed,  1 Nov 2023 19:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347371AbjKATrc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Nov 2023 15:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347370AbjKATrb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Nov 2023 15:47:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D31F10F
        for <mm-commits@vger.kernel.org>; Wed,  1 Nov 2023 12:47:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8AFC433C9;
        Wed,  1 Nov 2023 19:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698868045;
        bh=/3+A4Y42sVqu4Giq9jG2mV++Np1/km3hoBn83IOcgXQ=;
        h=Date:To:From:Subject:From;
        b=tX2z3XA9s2quUXtBGhZA0ezJIHDo5PB6HidMuiOvyoBz28wAKnCOWpjosglzPygo7
         Z0267LHtIsumiLU9Ud11iTc2OKc1bvUtmhQO5OuAfcn7EnbeCbOP0L+ckIYvlrbuNs
         pUpjtJPT6usdwKVqjioROAke/TvdfjcUHaGutW5k=
Date:   Wed, 01 Nov 2023 12:47:24 -0700
To:     mm-commits@vger.kernel.org, ebiederm@xmission.com, oleg@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] do_io_accounting-use-__for_each_thread.patch removed from -mm tree
Message-Id: <20231101194725.1D8AFC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: do_io_accounting: use __for_each_thread()
has been removed from the -mm tree.  Its filename was
     do_io_accounting-use-__for_each_thread.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: do_io_accounting: use __for_each_thread()
Date: Mon, 23 Oct 2023 17:33:43 +0200

Rather than while_each_thread() which should be avoided when possible.

This makes the code more clear and allows the next change.

Link: https://lkml.kernel.org/r/20231023153343.GA4629@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/proc/base.c~do_io_accounting-use-__for_each_thread
+++ a/fs/proc/base.c
@@ -2972,7 +2972,7 @@ static const struct file_operations proc
 #ifdef CONFIG_TASK_IO_ACCOUNTING
 static int do_io_accounting(struct task_struct *task, struct seq_file *m, int whole)
 {
-	struct task_io_accounting acct = task->ioac;
+	struct task_io_accounting acct;
 	unsigned long flags;
 	int result;
 
@@ -2986,14 +2986,18 @@ static int do_io_accounting(struct task_
 	}
 
 	if (whole && lock_task_sighand(task, &flags)) {
-		struct task_struct *t = task;
+		struct signal_struct *sig = task->signal;
+		struct task_struct *t;
 
-		task_io_accounting_add(&acct, &task->signal->ioac);
-		while_each_thread(task, t)
+		acct = sig->ioac;
+		__for_each_thread(sig, t)
 			task_io_accounting_add(&acct, &t->ioac);
 
 		unlock_task_sighand(task, &flags);
+	} else {
+		acct = task->ioac;
 	}
+
 	seq_printf(m,
 		   "rchar: %llu\n"
 		   "wchar: %llu\n"
_

Patches currently in -mm which might be from oleg@redhat.com are


