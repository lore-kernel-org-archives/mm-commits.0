Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C49E17741
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127161; cv=none; b=QwaGIZeYSIsnnM7XU3mf0UT0fJs71nnCD+cseEMKqmZuO6UGKaOLTbw2YS038egV3/cH378YgsVBOCjjWuX7N/LK1H9OCVgOPDdAx1M6fW8fYeRoUXK5ik9aDJjBTl2HK6F+smceAiionJ09/bYUD9tlQadZn3MA/esKQbTHPh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127161; c=relaxed/simple;
	bh=+z5OfVqDjpS7SL3LvVbPuTjyS6Hhtv3+nAat3H6e9co=;
	h=Date:To:From:Subject:Message-Id; b=mSTEeAIyAUhJ7P0H2mfCnj4Qo0w+yEd5SaYkE08Quj3ZLvdwEeJUbsDh3yErTGdSmoWVraqEwjGnQlRFH+W5iM3EsgCaeQ58b3yXwGNUt0kGjLvJlvDhOXrWwYHNQ4t43v720jfYCqa0YMgvP+36wsZ3br/ZwAsM/u5FfxK1mhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HF11sBcd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HF11sBcd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50490C4CEE3;
	Thu, 10 Jul 2025 05:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127161;
	bh=+z5OfVqDjpS7SL3LvVbPuTjyS6Hhtv3+nAat3H6e9co=;
	h=Date:To:From:Subject:From;
	b=HF11sBcd0JrXFVdjtDHdpSO++UoJDlTYdogWqJrrQTyQqud8qiyImcI/Pit0f0MWZ
	 RVAtNanM6g0Kz8CXseMViHAS+S/dJkgEKV3hr4zNZK5DpbgQ/FnnscBbJBhuQysAQ1
	 cEgdVxC3DspCBgogzqu2jGtRPYju7Z5fr7n49c7w=
Date: Wed, 09 Jul 2025 22:59:20 -0700
To: mm-commits@vger.kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,mhocko@suse.com,brauner@kernel.org,andrii@kernel.org,wangfushuai@baidu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] exit-fix-misleading-comment-in-forget_original_parent.patch removed from -mm tree
Message-Id: <20250710055921.50490C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: exit: fix misleading comment in forget_original_parent()
has been removed from the -mm tree.  Its filename was
     exit-fix-misleading-comment-in-forget_original_parent.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


