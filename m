Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E8C1C48BE5
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 22:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6432561245
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 22:06:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbhFPWJE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Jun 2021 18:09:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234186AbhFPWJD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Jun 2021 18:09:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8031E61076;
        Wed, 16 Jun 2021 22:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623881216;
        bh=uZl7qp1zZEJnzBqX+J2MNTCENguSVT4Adg6t2aYz3xw=;
        h=Date:From:To:Subject:From;
        b=bwHkQTVrZ8Jm5OH1xHtX8mjvoAEHrCpnu1qseuTSIwWWP3Bvwziu1khefx32BmUwY
         tWNqstZ2VZoN21NtZiq43RM/gN4UApCSgfGrx9m7g0TUYMrgbLrmdceSJOWBUIbp28
         G15jYqokGTduMmcHRRKVmHPGhRENZEZXg9x4RCP4=
Date:   Wed, 16 Jun 2021 15:06:55 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, areber@redhat.com, axboe@kernel.dk,
        bernd.edlinger@hotmail.de, chaithco@redhat.com,
        christian.brauner@ubuntu.com, deller@gmx.de, ebiederm@xmission.com,
        jamorris@linux.microsoft.com, keescook@chromium.org,
        laoar.shao@gmail.com, luto@amacapital.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, oleg@redhat.com, serge@hallyn.com,
        shuah@kernel.org, surenb@google.com, tglx@linutronix.de,
        viro@zeniv.linux.org.uk, wad@chromium.org, yifeifz2@illinois.edu
Subject:  [folded-merged]
 exec-fix-dead-lock-in-de_thread-with-ptrace_attach-v9.patch removed from
 -mm tree
Message-ID: <20210616220655.TjvxhHHyd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: exec-fix-dead-lock-in-de_thread-with-ptrace_attach-v9
has been removed from the -mm tree.  Its filename was
     exec-fix-dead-lock-in-de_thread-with-ptrace_attach-v9.patch

This patch was dropped because it was folded into exec-fix-dead-lock-in-de_thread-with-ptrace_attach.patch

------------------------------------------------------
From: Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: exec-fix-dead-lock-in-de_thread-with-ptrace_attach-v9

Link: https://lkml.kernel.org/r/AM8PR10MB470896FBC519ABCC20486958E4349@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM
Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Will Drewry <wad@chromium.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: James Morris <jamorris@linux.microsoft.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Charles Haithcock <chaithco@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Helge Deller <deller@gmx.de>
Cc: YiFei Zhu <yifeifz2@illinois.edu>
Cc: Adrian Reber <areber@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

--- a/fs/exec.c~exec-fix-dead-lock-in-de_thread-with-ptrace_attach-v9
+++ a/fs/exec.c
@@ -1056,29 +1056,31 @@ static int de_thread(struct task_struct
 		return -EAGAIN;
 	}
 
-	while_each_thread(tsk, t) {
-		if (unlikely(t->ptrace) && t != tsk->group_leader)
-			sig->unsafe_execve_in_progress = true;
-	}
-
 	sig->group_exit_task = tsk;
 	sig->notify_count = zap_other_threads(tsk);
 	if (!thread_group_leader(tsk))
 		sig->notify_count--;
-	spin_unlock_irq(lock);
 
-	if (unlikely(sig->unsafe_execve_in_progress))
+	while_each_thread(tsk, t) {
+		if (unlikely(t->ptrace) && t != tsk->group_leader)
+			sig->unsafe_execve_in_progress = true;
+	}
+
+	if (unlikely(sig->unsafe_execve_in_progress)) {
+		spin_unlock_irq(lock);
 		mutex_unlock(&sig->cred_guard_mutex);
+		spin_lock_irq(lock);
+	}
 
-	for (;;) {
-		set_current_state(TASK_KILLABLE);
-		if (!sig->notify_count)
-			break;
+	while (sig->notify_count) {
+		__set_current_state(TASK_KILLABLE);
+		spin_unlock_irq(lock);
 		schedule();
 		if (__fatal_signal_pending(tsk))
 			goto killed;
+		spin_lock_irq(lock);
 	}
-	__set_current_state(TASK_RUNNING);
+	spin_unlock_irq(lock);
 
 	if (unlikely(sig->unsafe_execve_in_progress)) {
 		if (mutex_lock_killable(&sig->cred_guard_mutex))
_

Patches currently in -mm which might be from bernd.edlinger@hotmail.de are

exec-fix-dead-lock-in-de_thread-with-ptrace_attach.patch

