Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9760AC25B46
	for <mm-commits@archiver.kernel.org>; Mon, 23 Oct 2023 17:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjJWRyx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Oct 2023 13:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjJWRyw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 23 Oct 2023 13:54:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C7BB4
        for <mm-commits@vger.kernel.org>; Mon, 23 Oct 2023 10:54:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C882C433C8;
        Mon, 23 Oct 2023 17:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698083689;
        bh=a7V+zADw60heqYS/j7vXZFg0binVGkYQy94rpuJfCZ8=;
        h=Date:To:From:Subject:From;
        b=S3kNbjr94iVSgzTHUTqus45nAI/BYXipDOsVBdwTZ+y1tKmya4sBStVLkEivEQv5F
         SXR/l/BLrJhRNChrqEmmb6NGvWdOsI3YGJwtKcem7GfOnhLv9aBcAQoAvt0Uel9ype
         Aa4CovPGfqpbLsEce97goVsVJRg+P053e78Ze74I=
Date:   Mon, 23 Oct 2023 10:54:48 -0700
To:     mm-commits@vger.kernel.org, ebiederm@xmission.com, oleg@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + do_io_accounting-use-sig-stats_lock.patch added to mm-nonmm-unstable branch
Message-Id: <20231023175449.8C882C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: do_io_accounting: use sig->stats_lock
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     do_io_accounting-use-sig-stats_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/do_io_accounting-use-sig-stats_lock.patch

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
Subject: do_io_accounting: use sig->stats_lock
Date: Mon, 23 Oct 2023 17:34:05 +0200

Rather than lock_task_sighand(), sig->stats_lock was specifically designed
for this type of use.

This way the "if (whole)" branch runs lockless in the likely case.

Link: https://lkml.kernel.org/r/20231023153405.GA4639@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/fs/proc/base.c~do_io_accounting-use-sig-stats_lock
+++ a/fs/proc/base.c
@@ -2973,7 +2973,6 @@ static const struct file_operations proc
 static int do_io_accounting(struct task_struct *task, struct seq_file *m, int whole)
 {
 	struct task_io_accounting acct;
-	unsigned long flags;
 	int result;
 
 	result = down_read_killable(&task->signal->exec_update_lock);
@@ -2985,15 +2984,24 @@ static int do_io_accounting(struct task_
 		goto out_unlock;
 	}
 
-	if (whole && lock_task_sighand(task, &flags)) {
+	if (whole) {
 		struct signal_struct *sig = task->signal;
 		struct task_struct *t;
+		unsigned int seq = 1;
+		unsigned long flags;
 
-		acct = sig->ioac;
-		__for_each_thread(sig, t)
-			task_io_accounting_add(&acct, &t->ioac);
+		rcu_read_lock();
+		do {
+			seq++; /* 2 on the 1st/lockless path, otherwise odd */
+			flags = read_seqbegin_or_lock_irqsave(&sig->stats_lock, &seq);
 
-		unlock_task_sighand(task, &flags);
+			acct = sig->ioac;
+			__for_each_thread(sig, t)
+				task_io_accounting_add(&acct, &t->ioac);
+
+		} while (need_seqretry(&sig->stats_lock, seq));
+		done_seqretry_irqrestore(&sig->stats_lock, seq, flags);
+		rcu_read_unlock();
 	} else {
 		acct = task->ioac;
 	}
_

Patches currently in -mm which might be from oleg@redhat.com are

do_io_accounting-use-__for_each_thread.patch
do_io_accounting-use-sig-stats_lock.patch

