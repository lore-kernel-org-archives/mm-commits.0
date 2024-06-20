Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9D72E859;
	Thu, 20 Jun 2024 20:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718914892; cv=none; b=L2uADCkREosWahnPEe13NU2AErEgJPYU3o79Ed1ki8FOH8sGAml0fZdAoaXi/Di1S/8L4Gk1E5Q5PL8A0OlT5g+X6LGwoBWrXjIOqnLdUa2DrFv5XhbJE9f6TSjxIG/lxVZtPnpmHmQ5GntavRRmkFpOU8YQ0E3vqnTJn6t5B08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718914892; c=relaxed/simple;
	bh=TBH/liEzIynZTou4cLDfKvLvQeEIyYB9kvw/22kAOCI=;
	h=Date:To:From:Subject:Message-Id; b=KTAW/xGjL1QYvqdIpoDkF0dPBlFFwWniZwrd7eFlFC9dHD7A//ByLhicbe7iUQfRgb/XwMRgNG5AiN1VOrtgtgrokoGzCmqowhh+jaThlLTxYMBxhPmmQoCy+1/HSayZ18mMEKJmlHRLNbvCwmmqfA57xbdQJ7LzZMZ8kuxPdGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mdiXQFFo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mdiXQFFo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A86C2BD10;
	Thu, 20 Jun 2024 20:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718914890;
	bh=TBH/liEzIynZTou4cLDfKvLvQeEIyYB9kvw/22kAOCI=;
	h=Date:To:From:Subject:From;
	b=mdiXQFFovnE/0dY3Ig6HUvsbSKwBlrVkfSwvdwpdRBc7gjmkuY1MwyWGSZ7g7TrlM
	 034REZBouPcqblGvJJO2HbO/iPtE1na8KW5APn+Bv6dPPS64zfvqDu92873BVo2n4a
	 8xFPBLcQY3h6hkBEgicoXtQPYecgXUFICEIkAYIA=
Date: Thu, 20 Jun 2024 13:21:30 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tandersen@netflix.com,stable@vger.kernel.org,oleg@redhat.com,mjguzik@gmail.com,brauner@kernel.org,axboe@kernel.dk,alexjlzheng@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-optimize-the-redundant-loop-of-mm_update_owner_next.patch added to mm-hotfixes-unstable branch
Message-Id: <20240620202130.B9A86C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: optimize the redundant loop of mm_update_owner_next()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-optimize-the-redundant-loop-of-mm_update_owner_next.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-optimize-the-redundant-loop-of-mm_update_owner_next.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Jinliang Zheng <alexjlzheng@tencent.com>
Subject: mm: optimize the redundant loop of mm_update_owner_next()
Date: Thu, 20 Jun 2024 20:21:24 +0800

When mm_update_owner_next() is racing with swapoff (try_to_unuse()) or
/proc or ptrace or page migration (get_task_mm()), it is impossible to
find an appropriate task_struct in the loop whose mm_struct is the same as
the target mm_struct.

If the above race condition is combined with the stress-ng-zombie and
stress-ng-dup tests, such a long loop can easily cause a Hard Lockup in
write_lock_irq() for tasklist_lock.

Recognize this situation in advance and exit early.

Link: https://lkml.kernel.org/r/20240620122123.3877432-1-alexjlzheng@tencent.com
Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tycho Andersen <tandersen@netflix.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/exit.c~mm-optimize-the-redundant-loop-of-mm_update_owner_next
+++ a/kernel/exit.c
@@ -484,6 +484,8 @@ retry:
 	 * Search through everything else, we should not get here often.
 	 */
 	for_each_process(g) {
+		if (atomic_read(&mm->mm_users) <= 1)
+			break;
 		if (g->flags & PF_KTHREAD)
 			continue;
 		for_each_thread(g, c) {
_

Patches currently in -mm which might be from alexjlzheng@tencent.com are

mm-optimize-the-redundant-loop-of-mm_update_owner_next.patch

