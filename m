Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED50199B8
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759295; cv=none; b=aKOsyCTMI/29xFCGrg2p/IPhpQkHUN4fUpC+q1/TleAfzyxSlK3g43ZKy2t1NxinBg1CwheIEbF37V8gN5hmJ/3TxAMq9iX9vCuU8CJPrFIMUVjrwrY7rPfrFAWgumKA/05M0QgX9Ylh3qi9oLVDl3coH1mU1kLGcwIs/ZsTk2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759295; c=relaxed/simple;
	bh=uCfI0UOtHPK59YZjfh5OitxZwg9luRO3jTjDgoqDDhY=;
	h=Date:To:From:Subject:Message-Id; b=oaF88My7E+SgHFxnIdpgLUcFzRz0TM0JldwzCe7oDsDYNCILve3hmu1XeFl5plgyzpVSUPKHyetUpJcqNEZBs7+Fl3xD2DjVOpTNch2/cfyNDFx/OugxmDeIgqqMmckcikoTPwP9zdxX6061BHYBrOiQ1QbBrjg/rjKXAiMxivk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GZE/WTJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GZE/WTJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EECC43394;
	Wed,  6 Mar 2024 21:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759295;
	bh=uCfI0UOtHPK59YZjfh5OitxZwg9luRO3jTjDgoqDDhY=;
	h=Date:To:From:Subject:From;
	b=GZE/WTJRUe1lU+0FWOcHfHQPg1/6SYgvXum7Sqz9cA+RVZB/a44M8Ab2yGEBaZvax
	 +Mm7I9u47fFzp2QHOF+RO9NSFxEq4mIlq8rbb/HEMg5sOMce4Pq/5ZwmbT4P5uCCl8
	 E6KwQ9Tj0ZVpVG6wZBuT3rOlMzHylBtX6ErylmbE=
Date: Wed, 06 Mar 2024 13:08:14 -0800
To: mm-commits@vger.kernel.org,wenyang.linux@foxmail.com,pcc@google.com,ebiederm@xmission.com,brauner@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] get_signal-dont-initialize-ksig-info-if-signal_group_exit-group_exec_task.patch removed from -mm tree
Message-Id: <20240306210815.75EECC43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: get_signal: don't initialize ksig->info if SIGNAL_GROUP_EXIT/group_exec_task
has been removed from the -mm tree.  Its filename was
     get_signal-dont-initialize-ksig-info-if-signal_group_exit-group_exec_task.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: get_signal: don't initialize ksig->info if SIGNAL_GROUP_EXIT/group_exec_task
Date: Mon, 26 Feb 2024 17:56:53 +0100

This initialization is incomplete and unnecessary, neither do_group_exit()
nor PF_USER_WORKER need ksig->info.

Link: https://lkml.kernel.org/r/20240226165653.GA20834@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Wen Yang <wenyang.linux@foxmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/kernel/signal.c~get_signal-dont-initialize-ksig-info-if-signal_group_exit-group_exec_task
+++ a/kernel/signal.c
@@ -2727,12 +2727,15 @@ relock:
 		/* Has this task already been marked for death? */
 		if ((signal->flags & SIGNAL_GROUP_EXIT) ||
 		     signal->group_exec_task) {
-			clear_siginfo(&ksig->info);
-			ksig->info.si_signo = signr = SIGKILL;
+			signr = SIGKILL;
 			sigdelset(&current->pending.signal, SIGKILL);
 			trace_signal_deliver(SIGKILL, SEND_SIG_NOINFO,
-				&sighand->action[SIGKILL - 1]);
+					     &sighand->action[SIGKILL-1]);
 			recalc_sigpending();
+			/*
+			 * implies do_group_exit() or return to PF_USER_WORKER,
+			 * no need to initialize ksig->info/etc.
+			 */
 			goto fatal;
 		}
 
_

Patches currently in -mm which might be from oleg@redhat.com are


