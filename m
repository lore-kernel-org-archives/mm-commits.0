Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D7E2C4167D
	for <mm-commits@archiver.kernel.org>; Wed,  1 Nov 2023 19:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347386AbjKATrf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Nov 2023 15:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347379AbjKATrd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Nov 2023 15:47:33 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711589F
        for <mm-commits@vger.kernel.org>; Wed,  1 Nov 2023 12:47:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFFFC433CA;
        Wed,  1 Nov 2023 19:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698868046;
        bh=JZ4ME/CoRr+tUyg6xCvqLoYscknZZ3KbQGZWH1w5NYc=;
        h=Date:To:From:Subject:From;
        b=QwTOc+lIiKSaTIf50oIoYDBXiwOhj+bW5DlNxUZBt4y/1FTO+S4/KwfNOMTdtaXeg
         pNdYXMlJvpIV49f7dPyIRiRctzuSBI8tBMRi3tua8bzCAhFsZpYv17bjPxkNSvF9S1
         pHR/4tgbhgNWoeiiCHznLQvNHaNIVeXNdyApKxqo=
Date:   Wed, 01 Nov 2023 12:47:25 -0700
To:     mm-commits@vger.kernel.org, ebiederm@xmission.com, oleg@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] do_io_accounting-use-sig-stats_lock.patch removed from -mm tree
Message-Id: <20231101194726.0CFFFC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: do_io_accounting: use sig->stats_lock
has been removed from the -mm tree.  Its filename was
     do_io_accounting-use-sig-stats_lock.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


