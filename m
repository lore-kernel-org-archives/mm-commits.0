Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B198635CBBF
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966126; cv=none; b=kV2OvGDZWJcskm8onTf4nYljYuzIOUboXKeYPJEy84UN5y5rhjmc1C5CmJ+h6rcWUjL86feF/Yhw5PVmX/CrNvKW3dG10KN2UFqiPn1X+3IrMpXP0NLLox7mHrw1/NVxzwtNNxIHHWYJsLDKOr1vhYoDcsesxt55TjjaDJSR/yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966126; c=relaxed/simple;
	bh=WXZPdNohDKHqDQhTHosA5iUtZuCfXniFomFQLhsRsVc=;
	h=Date:To:From:Subject:Message-Id; b=fK3zFWZ9tYsCSXmJqeBfhYjb0kLFmdX5box+hfAbd07X0q/YtQulpbfKZq9+4ZhBqnOqHC6TxKOEuZ3cOChlkkYjUUUjYf/5pZyjvsREcLQcnKatzH0n5lCSVXGbw19u8NSpef9rJBOGofRt5s0VmlcZ+96239rKYn1Dk3DSEII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=znypjc5B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="znypjc5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87865C16AAE;
	Wed, 21 Jan 2026 03:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966126;
	bh=WXZPdNohDKHqDQhTHosA5iUtZuCfXniFomFQLhsRsVc=;
	h=Date:To:From:Subject:From;
	b=znypjc5BC10EUvNKI/9IX1xgqXJ9p0LHLDXOlbjsYbLm0EkLLOAhfxQOvGgRkXt16
	 64PFksE7So7HHn0GUb6uO1lre+LRlS04cpNtcnp2Yw0XwMtBUvpvvIlOmx7nHLXTzA
	 ZZfyQ4SrksaH4/dUkN2+TelqChFjQFBTX1nITG1w=
Date: Tue, 20 Jan 2026 19:28:46 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,rientjes@google.com,mhocko@suse.com,kdipendra88@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-oom_kill-remove-unnecessary-integer-promotion-in-format-string.patch removed from -mm tree
Message-Id: <20260121032846.87865C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/oom_kill: remove unnecessary integer promotion in format string
has been removed from the -mm tree.  Its filename was
     mm-oom_kill-remove-unnecessary-integer-promotion-in-format-string.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dipendra Khadka <kdipendra88@gmail.com>
Subject: mm/oom_kill: remove unnecessary integer promotion in format string
Date: Sun, 28 Dec 2025 15:44:55 +0000

The 'h' length modifier in '%hd' is unnecessary as short integers are
promoted to int in variadic functions.  Use '%d' instead.

Checkpatch flags the 'h' modifier as unnecessary for this reason, and
many other subsystems have moved to using %d for promoted types. 
Hence, I think this patch aligns with kernel coding practices.

Link: https://lkml.kernel.org/r/20251228154456.2386-1-kdipendra88@gmail.com
Signed-off-by: Dipendra Khadka <kdipendra88@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/oom_kill.c~mm-oom_kill-remove-unnecessary-integer-promotion-in-format-string
+++ a/mm/oom_kill.c
@@ -458,7 +458,7 @@ static void dump_oom_victim(struct oom_c
 
 static void dump_header(struct oom_control *oc)
 {
-	pr_warn("%s invoked oom-killer: gfp_mask=%#x(%pGg), order=%d, oom_score_adj=%hd\n",
+	pr_warn("%s invoked oom-killer: gfp_mask=%#x(%pGg), order=%d, oom_score_adj=%d\n",
 		current->comm, oc->gfp_mask, &oc->gfp_mask, oc->order,
 			current->signal->oom_score_adj);
 	if (!IS_ENABLED(CONFIG_COMPACTION) && oc->order)
@@ -958,7 +958,7 @@ static void __oom_kill_process(struct ta
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


