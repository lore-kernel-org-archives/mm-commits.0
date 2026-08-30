Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730A1214A9B
	for <mm-commits@vger.kernel.org>; Sun, 30 Aug 2026 03:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788059382; cv=none; b=pZSLhMlgGxgNj9vgVfSxMHiMuGiV5Wuej8gQm1nG75iq0IHaWX0J6caVMWszJVViWMhK1UVOZApEmYUzvQq0UD+o6+Fp+VYZOvottNMVQv6PfJbXrIYZnz4A0CRpU3Ksgz0+w++1f/Qh6LoHM7OrzioVceu23onVYI50F/5X1H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788059382; c=relaxed/simple;
	bh=Fl9JrD7jT7lbjncerKLqJevXfLf4YV1oSDcMKHmhoh8=;
	h=Date:To:From:Subject:Message-Id; b=WFkhfqaOHyCgobIqKx2YCog4HCcri9AOdIeOVPbGCByphQJbOO7G35Zsf4qe8TF5KOU1MuUHf4F+f8cmjs8IiCZBHg41ZHAzvxz8mrXgnN2y8N5mGymZ0HJW7TtBZot+2GK6CGQwLjWNrUbcXg2ZLx3k4NEBaWTxLOv73T3tOkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i1z8XD6t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i1z8XD6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC211F000E9;
	Sun, 30 Aug 2026 03:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788059381;
	bh=2vjjZQ5T+H4Z5xhfBfmJfO94IX5Lay3Z6OFOu0kGaWs=;
	h=Date:To:From:Subject;
	b=i1z8XD6tzXZs9WpOxzJITVmv2lbmGDb9CmfG16YBoebo/oRCTbNldm3Lx7/2UoYcf
	 InvLD/Mu7+xrwv2pg4VAjuwZm3mloZGstUnhp5N9uWdeajMmnF4jWnufl7F8avsufT
	 f/rPrsNB6X5pqQaXy0ptl38octmOp08EvsJkAdqs=
Date: Sat, 29 Aug 2026 20:09:40 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,rientjes@google.com,mhocko@suse.com,husong@kylinos.cn,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-oom_kill-proc-replace-magic-number-1000-with-oom_score_adj_max.patch added to mm-new branch
Message-Id: <20260830030940.EAC211F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/oom_kill, proc: replace magic number 1000 with OOM_SCORE_ADJ_MAX
has been added to the -mm mm-new branch.  Its filename is
     mm-oom_kill-proc-replace-magic-number-1000-with-oom_score_adj_max.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-oom_kill-proc-replace-magic-number-1000-with-oom_score_adj_max.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/oom_kill, proc: replace magic number 1000 with OOM_SCORE_ADJ_MAX
Date: Tue, 11 Aug 2026 11:36:08 +0800

In oom_badness() and proc_oom_score(), the oom_score_adj normalization
uses a hardcoded 1000, which is the value of OOM_SCORE_ADJ_MAX defined in
include/uapi/linux/oom.h.  Other code in the kernel (e.g.  fs/proc/base.c
oom_adj handling) already uses OOM_SCORE_ADJ_MAX for the same purpose.

Replace the magic number with the macro for consistency and readability. 
No functional change.

Link: https://lore.kernel.org/20260811033609.3992348-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Liu Ye <liuye@kylinos.cn>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Song Hu <husong@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    3 ++-
 mm/oom_kill.c  |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/proc/base.c~mm-oom_kill-proc-replace-magic-number-1000-with-oom_score_adj_max
+++ a/fs/proc/base.c
@@ -594,7 +594,8 @@ static int proc_oom_score(struct seq_fil
 	 * exporting for a long time so userspace might depend on it.
 	 */
 	if (badness != LONG_MIN)
-		points = (1000 + badness * 1000 / (long)totalpages) * 2 / 3;
+		points = (OOM_SCORE_ADJ_MAX +
+			  badness * OOM_SCORE_ADJ_MAX / (long)totalpages) * 2 / 3;
 
 	seq_printf(m, "%lu\n", points);
 
--- a/mm/oom_kill.c~mm-oom_kill-proc-replace-magic-number-1000-with-oom_score_adj_max
+++ a/mm/oom_kill.c
@@ -230,7 +230,7 @@ long oom_badness(struct task_struct *p,
 	task_unlock(p);
 
 	/* Normalize to oom_score_adj units */
-	adj *= totalpages / 1000;
+	adj *= totalpages / OOM_SCORE_ADJ_MAX;
 	points += adj;
 
 	return points;
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-vmalloc-fix-vmap_purge_lock-livelock-under-memory-pressure.patch
tools-mm-page_owner_sort-fix-sort-option-being-silently-ignored.patch
tools-mm-page_owner_sort-add-module-name-sort-cull-filter-support.patch
tools-mm-page_owner_sort-show-available-sort-keys-in-usage-text.patch
mm-oom_kill-remove-unreachable-__gfp_thisnode-check-in-constrained_alloc.patch
mm-oom_kill-proc-replace-magic-number-1000-with-oom_score_adj_max.patch

