Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FF31632C2
	for <mm-commits@vger.kernel.org>; Fri, 22 Nov 2024 06:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732257320; cv=none; b=um+UZIT01cXBFrRFER4tCaYnB7dK+tZdvSWKzsoOijWVEKUvyfoWwE7YWqPVqFaHwioDS8et99pD88pMgQlx2vRPChZOJthxTYhJ2ttD57lUSxyUqHJfhxRqYsPzijcMJFvzwQmzSMkXTKMEHNY1H+S1Q5aV+3dTPkqoazPq0Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732257320; c=relaxed/simple;
	bh=MUqVmFCZcmYUCBkxE1vK5SW2+A/LhmD4xrXlfqaJHdE=;
	h=Date:To:From:Subject:Message-Id; b=A4BEkpGTTQa7+fmCvukAwCHzgCBCK2o7tIQhkL2PoAerFeed68DraAV5fRYv+D6mpZPIlpdDHFRhkwVaxf+rC6gFwqJcNlF2lOMVexdBPwgPBgP3l1njtPiH+S0kbViWWqkJKni1jZDlYKakADsAvtNLK29JxAuphcobziFGKis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d6GAbNr/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d6GAbNr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 309E8C4CECE;
	Fri, 22 Nov 2024 06:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732257318;
	bh=MUqVmFCZcmYUCBkxE1vK5SW2+A/LhmD4xrXlfqaJHdE=;
	h=Date:To:From:Subject:From;
	b=d6GAbNr//B+AHdadcNlMOgOJ0KRJeabbjT4fLRtiK7EkviHR1Rb7KGhxTMVmzjkz/
	 DCypawmtH9R7hG+2cMNpyNsb+j4qlxljM2hq29D++zJPcmg68lNqxZAUCtLQkW8uJo
	 ztbmp5FZWJV9Q8xCa6BzNmfgnCpBYW+lFZ+q4FMg=
Date: Thu, 21 Nov 2024 22:35:15 -0800
To: mm-commits@vger.kernel.org,oleg@redhat.com,mjguzik@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + get_task_exe_file-check-pf_kthread-locklessly.patch added to mm-nonmm-unstable branch
Message-Id: <20241122063518.309E8C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: get_task_exe_file: check PF_KTHREAD locklessly
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     get_task_exe_file-check-pf_kthread-locklessly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/get_task_exe_file-check-pf_kthread-locklessly.patch

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
From: Mateusz Guzik <mjguzik@gmail.com>
Subject: get_task_exe_file: check PF_KTHREAD locklessly
Date: Tue, 19 Nov 2024 15:35:26 +0100

Same thing as 8ac5dc66599c ("get_task_mm: check PF_KTHREAD lockless")

Nowadays PF_KTHREAD is sticky and it was never protected by ->alloc_lock. 
Move the PF_KTHREAD check outside of task_lock() section to make this code
more understandable.

Link: https://lkml.kernel.org/r/20241119143526.704986-1-mjguzik@gmail.com
Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/kernel/fork.c~get_task_exe_file-check-pf_kthread-locklessly
+++ a/kernel/fork.c
@@ -1496,12 +1496,13 @@ struct file *get_task_exe_file(struct ta
 	struct file *exe_file = NULL;
 	struct mm_struct *mm;
 
+	if (task->flags & PF_KTHREAD)
+		return NULL;
+
 	task_lock(task);
 	mm = task->mm;
-	if (mm) {
-		if (!(task->flags & PF_KTHREAD))
-			exe_file = get_mm_exe_file(mm);
-	}
+	if (mm)
+		exe_file = get_mm_exe_file(mm);
 	task_unlock(task);
 	return exe_file;
 }
_

Patches currently in -mm which might be from mjguzik@gmail.com are

get_task_exe_file-check-pf_kthread-locklessly.patch

