Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B77E223710
	for <mm-commits@vger.kernel.org>; Wed, 17 Dec 2025 21:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766007229; cv=none; b=kqnt8RQ9nvBPWl+vOOOJ1vTZaPcMYpaAnB+oFzlX9UrzQeOSiKgR+0NnZGDsWAzhiHCFYxZDmRpUEG4/Nu+2jvEo3RQRQ/iBgGqQQneJKsmCyVhyWVqrDW7qYRzZzYrMcL0EF1zbCNv+dGcpr4djeDbolc2hwVP3ZL6ZEnaO+6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766007229; c=relaxed/simple;
	bh=X1BvhWlDfK74s9r7Wbhq+NMn0eIJVY3QxaLjFSvt6lw=;
	h=Date:To:From:Subject:Message-Id; b=oGwGoXLU8YA7hPg1YIJxqfCu7uYlsleEXthK5L6lLvqJ0q/eYRAwx4R5eKP0MTZaiZDWC4bD8BNGW/hiiyxsj/Pd8qMC4/I202Gin/fjqryjfiSS5LQPAp4Rd1NeyYIs8NH9eUDc9JlvUuDibRbuZDH7VQD0w+SWDw7iLY6PFfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YuE8AIfj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YuE8AIfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CEDC4CEF5;
	Wed, 17 Dec 2025 21:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766007228;
	bh=X1BvhWlDfK74s9r7Wbhq+NMn0eIJVY3QxaLjFSvt6lw=;
	h=Date:To:From:Subject:From;
	b=YuE8AIfjC/vwY4gHNBRE2l9Y/6sGLnY9bOWlsrdWp0MdzIMdtqHk7KQ76hQ4O6j8Z
	 VhRgltVvh0l+FNo1ol0SHzXJWAnRtwAp/381mS37ukVLqOf5uA9bzt/YjsN/T2BHIl
	 VmmA1ZYxRE24zOHfdm6bqAcVQOFxNUzzb0/mXlXA=
Date: Wed, 17 Dec 2025 13:33:47 -0800
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,oleg@redhat.com,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kees@kernel.org,juri.lelli@redhat.com,dietmar.eggemann@arm.com,bsegall@google.com,s9430939@naver.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fork-comment-fix-remove-ambiguous-question-mark-in-clone_child_cleartid-comment.patch added to mm-nonmm-unstable branch
Message-Id: <20251217213348.47CEDC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fork-comment-fix: remove ambiguous question mark in CLONE_CHILD_CLEARTID comment
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fork-comment-fix-remove-ambiguous-question-mark-in-clone_child_cleartid-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fork-comment-fix-remove-ambiguous-question-mark-in-clone_child_cleartid-comment.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Minu Jin <s9430939@naver.com>
Subject: fork-comment-fix: remove ambiguous question mark in CLONE_CHILD_CLEARTID comment
Date: Tue, 25 Nov 2025 09:04:07 +0900

The current comment "Clear TID on mm_release()?" ends with a question
mark, implying uncertainty about whether the TID is actually cleared in
mm_release().

However, the code flow is deterministic.  When a task exits, mm_release()
explicitly checks 'tsk->clear_child_tid' and clears.

Since this behavior is unambiguous, remove the confusing question mark and
rephrase the comment to clearly state that TID is cleared in mm_release().

Link: https://lkml.kernel.org/r/20251125000407.24470-1-s9430939@naver.com
Signed-off-by: Minu Jin <s9430939@naver.com>
Cc: Ben Segall <bsegall@google.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mel Gorman <mgorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/fork.c~fork-comment-fix-remove-ambiguous-question-mark-in-clone_child_cleartid-comment
+++ a/kernel/fork.c
@@ -2075,7 +2075,7 @@ __latent_entropy struct task_struct *cop
 
 	p->set_child_tid = (clone_flags & CLONE_CHILD_SETTID) ? args->child_tid : NULL;
 	/*
-	 * Clear TID on mm_release()?
+	 * TID is cleared in mm_release() when the task exits
 	 */
 	p->clear_child_tid = (clone_flags & CLONE_CHILD_CLEARTID) ? args->child_tid : NULL;
 
_

Patches currently in -mm which might be from s9430939@naver.com are

fork-comment-fix-remove-ambiguous-question-mark-in-clone_child_cleartid-comment.patch

