Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3DA1A3029
	for <mm-commits@vger.kernel.org>; Thu,  1 Jan 2026 01:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767231817; cv=none; b=WagnMtoCt9qSAswZqC5WbkRxQ3jf9z/THH9gD5bfq4t95SLx8pU5UOUXl07weeBAd3lWXszk5B5EbCTfNmdODkdSTO0zr6FbnGjLSG5xtcTMsRpRu9RH7T1NMpjcpBJwwQUq5pxuJ4ekTAeO5u3MZCrrwxYkuyaEfIzQy8FaYrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767231817; c=relaxed/simple;
	bh=5Fw4eiF1lKPd0piUp2S2/K9KI5lH4Ykib5tXSLIqYPo=;
	h=Date:To:From:Subject:Message-Id; b=MPbsfY6YHBNyaCJ+Luyfoz/VXkxJOm596zqHfZ9Fb4ZFaYZbo3SK3rgHG9Pag56rSmf9DygBalGa9TBlYer+KFNQ7G/Mmt/JfKrXJWSf5AOFDR0VFhBFM/SH4dHsjluPd3pT2zkC0C1ru9pOCmDJYSw8tjOHfb4j7kQx7hY+tRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H1COETq7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H1COETq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434C6C113D0;
	Thu,  1 Jan 2026 01:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767231817;
	bh=5Fw4eiF1lKPd0piUp2S2/K9KI5lH4Ykib5tXSLIqYPo=;
	h=Date:To:From:Subject:From;
	b=H1COETq7zg0tEmXmffoVVm1Uniqhf93iGfCwMHCUgp5S+BfOnGLIMw47S3lecBZJG
	 EnOuA2NWg4ZchHo7StQNv0hlZSQoAyj1DNi5cttRhFFXIicU9YiehjslmVx6cGgG6d
	 qN5uXjeme4LYCHwQOfOJQJVVULSybwiJbuwOL9gw=
Date: Wed, 31 Dec 2025 17:43:36 +9900
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,rientjes@google.com,mhocko@suse.com,kdipendra88@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-oom_kill-remove-unnecessary-integer-promotion-in-format-string.patch added to mm-new branch
Message-Id: <20260101014337.434C6C113D0@smtp.kernel.org>
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
Acked-by: David Rientjes <rientjes@google.com>
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

