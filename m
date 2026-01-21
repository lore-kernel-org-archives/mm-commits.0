Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8569334D90E
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967351; cv=none; b=UxRZv7CNv+mrjfZKhEoZ9cUwT8gk7Mi0uo05dXsciOFm4b2/2oTA6kNEmNO5EyK6hWHiG2G7HxKViSbJKQPqKfCWkiS8NB/2iZWkMXHNSDYKfYhycpBvM08S7IaqUGA/AISQrrAwLFEx7sVbIusjSJOV/syRp2xXDpsyILjU/zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967351; c=relaxed/simple;
	bh=cXKp+6DnPCkPo/aWuDA5clD7EnSbleo0TBMZBSn4ilE=;
	h=Date:To:From:Subject:Message-Id; b=Xnn8W8mvgW89iPoqqkWRNMVA2n9SiVEfS9ec3cFN/mLT5pffWw7/5yYhqFctZoQqibJJmebUnt34R3cj+jZ63hC5YxQs9c/UNYgRgzBlIwk4A0clxuHXDOvBXeh9OdsVCR0Kqps6uJjlFXL48vn5SMAPyS2PAVr5OfxEhgbxFlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n8pftznc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n8pftznc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD53CC16AAE;
	Wed, 21 Jan 2026 03:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967351;
	bh=cXKp+6DnPCkPo/aWuDA5clD7EnSbleo0TBMZBSn4ilE=;
	h=Date:To:From:Subject:From;
	b=n8pftzncZveHkeN1x4wKaTxNgRzD6WLnmr3ulVIS728gBcJWWAzqUl+JPqKjeiGpL
	 8ZyFfNiYCDbZPFNY/apc7uaZMZmNNyn5psu0VMyxA+93N38+quliNMxaahkqOPgaUr
	 NvfvXk1e6gEbKo33zwSoRVmlihtwMhiPWNPXhGoQ=
Date: Tue, 20 Jan 2026 19:49:10 -0800
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,oleg@redhat.com,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kees@kernel.org,juri.lelli@redhat.com,dietmar.eggemann@arm.com,bsegall@google.com,s9430939@naver.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fork-comment-fix-remove-ambiguous-question-mark-in-clone_child_cleartid-comment.patch removed from -mm tree
Message-Id: <20260121034910.DD53CC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fork-comment-fix: remove ambiguous question mark in CLONE_CHILD_CLEARTID comment
has been removed from the -mm tree.  Its filename was
     fork-comment-fix-remove-ambiguous-question-mark-in-clone_child_cleartid-comment.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2071,7 +2071,7 @@ __latent_entropy struct task_struct *cop
 
 	p->set_child_tid = (clone_flags & CLONE_CHILD_SETTID) ? args->child_tid : NULL;
 	/*
-	 * Clear TID on mm_release()?
+	 * TID is cleared in mm_release() when the task exits
 	 */
 	p->clear_child_tid = (clone_flags & CLONE_CHILD_CLEARTID) ? args->child_tid : NULL;
 
_

Patches currently in -mm which might be from s9430939@naver.com are


