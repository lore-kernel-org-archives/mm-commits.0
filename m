Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E117C25783C
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 19:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766949386; cv=none; b=omMeJ5FuK/aaMlDkVyEPeKjZr1OzYIRFFYgxGUpF11FsOVcy4NjbMuKY+2+YK2aKBbOflwqCITKCRraEr5EzMpHD78RSha8cWdrsY4teiLz85Hna3SgzPo3v/xYrT0hUJm7uZeKPpyEU2BjeMPGpiJQEU5I501a73Kw9XTLvMNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766949386; c=relaxed/simple;
	bh=ENdZLyuIlwBEfeuWnINlSUsht+iDTcx6n+5ctnZMCSE=;
	h=Date:To:From:Subject:Message-Id; b=sygkcyRQAFVbDftEL07BOZDLXeqPUSy6epBzzq9ZFf20n+nLJDsUWFO1Swqf6iRcjQFVjL6ugMuLfJ0anIID1SbpSoZ9eY+InLR25CcbfkV46dWmKR7UCThmRX0qGbKzz5ifXDEHp50z3Ce1Nf6e5IuXNoXVefnAWrB+wEjHi8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T6WaCCk4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T6WaCCk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2351AC4CEFB;
	Sun, 28 Dec 2025 19:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766949385;
	bh=ENdZLyuIlwBEfeuWnINlSUsht+iDTcx6n+5ctnZMCSE=;
	h=Date:To:From:Subject:From;
	b=T6WaCCk4eiizB7OOMSgiuBJ4v3AT+W7XgIpJCD31J0kHP7usrlIPlJdbd3Ihrh4UJ
	 3a1FfulzIpqamAyZyDSzd7TVo3+Cwy9cmGw42zVkQ88IwP5qo28ohfzyEggiLhElSp
	 ZFj/JAxVNa3F/I/i2/bfo6hI0vHbKAASwi4/t7cw=
Date: Sun, 28 Dec 2025 11:16:24 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,rientjes@google.com,mhocko@suse.com,kdipendra88@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-oom_kill-remove-unnecessary-integer-promotion-in-format-string.patch added to mm-new branch
Message-Id: <20251228191625.2351AC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/oom_kill: remove unnecessary integer promotion in format string
has been added to the -mm mm-new branch.  Its filename is
     mm-oom_kill-remove-unnecessary-integer-promotion-in-format-string.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-oom_kill-remove-unnecessary-integer-promotion-in-format-string.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Dipendra Khadka <kdipendra88@gmail.com>
Subject: mm/oom_kill: remove unnecessary integer promotion in format string
Date: Sun, 28 Dec 2025 15:44:55 +0000

The 'h' length modifier in '%hd' is unnecessary as short integers are
promoted to int in variadic functions.  Use '%d' instead.

Link: https://lkml.kernel.org/r/20251228154456.2386-1-kdipendra88@gmail.com
Signed-off-by: Dipendra Khadka <kdipendra88@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/oom_kill.c~mm-oom_kill-remove-unnecessary-integer-promotion-in-format-string
+++ a/mm/oom_kill.c
@@ -506,7 +506,7 @@ static void dump_oom_victim(struct oom_c
 
 static void dump_header(struct oom_control *oc)
 {
-	pr_warn("%s invoked oom-killer: gfp_mask=%#x(%pGg), order=%d, oom_score_adj=%hd\n",
+	pr_warn("%s invoked oom-killer: gfp_mask=%#x(%pGg), order=%d, oom_score_adj=%d\n",
 		current->comm, oc->gfp_mask, &oc->gfp_mask, oc->order,
 			current->signal->oom_score_adj);
 	if (!IS_ENABLED(CONFIG_COMPACTION) && oc->order)
@@ -1006,7 +1006,7 @@ static void __oom_kill_process(struct ta
 	 */
 	do_send_sig_info(SIGKILL, SEND_SIG_PRIV, victim, PIDTYPE_TGID);
 	mark_oom_victim(victim);
-	pr_err("%s: Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB, UID:%u pgtables:%lukB oom_score_adj:%hd\n",
+	pr_err("%s: Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB, UID:%u pgtables:%lukB oom_score_adj:%d\n",
 		message, task_pid_nr(victim), victim->comm, K(mm->total_vm),
 		K(get_mm_counter(mm, MM_ANONPAGES)),
 		K(get_mm_counter(mm, MM_FILEPAGES)),
_

Patches currently in -mm which might be from kdipendra88@gmail.com are

mm-oom_kill-remove-unnecessary-integer-promotion-in-format-string.patch

