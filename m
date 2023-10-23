Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16FDEC25B46
	for <mm-commits@archiver.kernel.org>; Mon, 23 Oct 2023 17:54:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbjJWRyu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Oct 2023 13:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbjJWRyt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 23 Oct 2023 13:54:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28ADA97
        for <mm-commits@vger.kernel.org>; Mon, 23 Oct 2023 10:54:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E76C433C7;
        Mon, 23 Oct 2023 17:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698083687;
        bh=Xh9LrjVYOCi9hJxTFkJt23BR7v810Vch1YS7ISfLqAI=;
        h=Date:To:From:Subject:From;
        b=A6CBTvgTAzsVvTrFzN6cfNHtLvGQYXP8X6txs13awZtw2AR+GB41kg2wRv0s+dXHf
         PeYMJNRazEeIH2rLdP8Zu+mwwMKIkhA9Aht5HRoOpD2IC2vtBji7lQuAj9rJUjabV2
         GyzJuZ/e3V0SR/LKvoPBbtKWg1JTpxU+xdVxHXQE=
Date:   Mon, 23 Oct 2023 10:54:47 -0700
To:     mm-commits@vger.kernel.org, ebiederm@xmission.com, oleg@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + do_io_accounting-use-__for_each_thread.patch added to mm-nonmm-unstable branch
Message-Id: <20231023175447.B5E76C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: do_io_accounting: use __for_each_thread()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     do_io_accounting-use-__for_each_thread.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/do_io_accounting-use-__for_each_thread.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

do_io_accounting-use-__for_each_thread.patch
do_io_accounting-use-sig-stats_lock.patch

