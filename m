Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57A4264FB4
	for <mm-commits@vger.kernel.org>; Sun, 15 Jun 2025 21:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750023788; cv=none; b=C+ixLzHnsNrxH5jVlweGSY8g9JDMSK4SK6JLRuAHbrz3lVFtCHB0Juf89IAVGPxCdMB9V7vEdLYN/Lqm6JcI/0TEJfm/hyS/EQfRU8YqZARaU3by/JAPekiNLGJH5xICfIxEy6Id1IvZFXnUypPssHazmfhtTOHVCu6ZwnvxhfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750023788; c=relaxed/simple;
	bh=Talgcrh9qTbBzNAWUbaTPAMUL35JNUtjTH+EkEZn19c=;
	h=Date:To:From:Subject:Message-Id; b=er739U4PHQd/idLsTFpx1w604sIXXXNA3TX0qDdzW9syag8UkqFkqI1jjLMZNIQdQNJYgOiXKsMeJjOXBkjlPZGNoFw8bCqR6V5icVzpr2yrxuGTLDkfGXbQASLm/n55xZBWHsMrSI4/0Mfsu5UTKgXI7iPGIlKKJmqLpOpQx3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zlLUuqIO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zlLUuqIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424A8C4CEE3;
	Sun, 15 Jun 2025 21:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750023788;
	bh=Talgcrh9qTbBzNAWUbaTPAMUL35JNUtjTH+EkEZn19c=;
	h=Date:To:From:Subject:From;
	b=zlLUuqIOP/btrOse0Km+xSN8lQKqc5w6hX39HXrXOpDDnpcYR8wuCvLEAttYdrvRO
	 jDZMVTX2p3prUmOYUCdg1HSG7Kjx+fo91lQxTpulUxfNfRnNw0SoL/UJfRS4ei0xnM
	 DDagdUAb9fRIG/qj4QKpsgHOBZ2OQ3AxgkT/BgEI=
Date: Sun, 15 Jun 2025 14:43:07 -0700
To: mm-commits@vger.kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,mhocko@suse.com,brauner@kernel.org,andrii@kernel.org,wangfushuai@baidu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + exit-fix-misleading-comment-in-forget_original_parent.patch added to mm-nonmm-unstable branch
Message-Id: <20250615214308.424A8C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: exit: fix misleading comment in forget_original_parent()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     exit-fix-misleading-comment-in-forget_original_parent.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/exit-fix-misleading-comment-in-forget_original_parent.patch

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
From: Fushuai Wang <wangfushuai@baidu.com>
Subject: exit: fix misleading comment in forget_original_parent()
Date: Sun, 15 Jun 2025 11:09:30 +0800

The commit 482a3767e508 ("exit: reparent: call forget_original_parent()
under tasklist_lock") moved the comment from exit_notify() to
forget_original_parent().  However, the forget_original_parent() only
handles (A), while (B) is handled in kill_orphaned_pgrp().  So remove the
unrelated part.

Link: https://lkml.kernel.org/r/20250615030930.58051-1-wangfushuai@baidu.com
Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: wangfushuai <wangfushuai@baidu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/kernel/exit.c~exit-fix-misleading-comment-in-forget_original_parent
+++ a/kernel/exit.c
@@ -692,12 +692,7 @@ static void reparent_leader(struct task_
 }
 
 /*
- * This does two things:
- *
- * A.  Make init inherit all the child processes
- * B.  Check to see if any process groups have become orphaned
- *	as a result of our exiting, and if they have any stopped
- *	jobs, send them a SIGHUP and then a SIGCONT.  (POSIX 3.2.2.2)
+ * Make init inherit all the child processes
  */
 static void forget_original_parent(struct task_struct *father,
 					struct list_head *dead)
_

Patches currently in -mm which might be from wangfushuai@baidu.com are

exit-fix-misleading-comment-in-forget_original_parent.patch

