Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9BBC48BE0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Jun 2021 23:16:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4205E613EE
	for <mm-commits@archiver.kernel.org>; Fri, 11 Jun 2021 23:16:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbhFKXSD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Jun 2021 19:18:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230017AbhFKXSD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 11 Jun 2021 19:18:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18610613DF;
        Fri, 11 Jun 2021 23:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623453364;
        bh=Os2/+QMlxa4nNVB4M2Fv9Y9zTZC+Bs8KwJeDZ+zz1AU=;
        h=Date:From:To:Subject:From;
        b=BzDioLkIwMBN1j5ZQMwU0sI0Esvo972Z3l6wqEyXwFdcjYTJ3pZ/BfR3e2X4ITOyi
         N/CnokuuYc1jWHfEtnF3zoL86qCOXmxrkLy/FHJJVy6L5eSUo7KLdzxWkAhwSaUd7Z
         rcXtkFQlGK2hB5PUjmZccCXijNTjcuwS05kx+UDA=
Date:   Fri, 11 Jun 2021 16:16:03 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, areber@redhat.com, axboe@kernel.dk,
        bernd.edlinger@hotmail.de, chaithco@redhat.com,
        christian.brauner@ubuntu.com, deller@gmx.de, ebiederm@xmission.com,
        jamorris@linux.microsoft.com, keescook@chromium.org,
        laoar.shao@gmail.com, luto@amacapital.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, oleg@redhat.com, serge@hallyn.com,
        shuah@kernel.org, surenb@google.com, tglx@linutronix.de,
        viro@zeniv.linux.org.uk, wad@chromium.org, yifeifz2@illinois.edu
Subject:  +
 exec-fix-dead-lock-in-de_thread-with-ptrace_attach-v9.patch added to -mm
 tree
Message-ID: <20210611231603.v-x3791Yd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: exec-fix-dead-lock-in-de_thread-with-ptrace_attach-v9
has been added to the -mm tree.  Its filename is
     exec-fix-dead-lock-in-de_thread-with-ptrace_attach-v9.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/exec-fix-dead-lock-in-de_thread-with-ptrace_attach-v9.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/exec-fix-dead-lock-in-de_thread-with-ptrace_attach-v9.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
exec-fix-dead-lock-in-de_thread-with-ptrace_attach-v9.patch

