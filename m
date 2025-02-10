Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CD7253F27
	for <mm-commits@vger.kernel.org>; Mon, 10 Feb 2025 23:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739231010; cv=none; b=NQNcDdYcR3woejdqAG31qyQqdirmbV1P4uxaVP28+oZ/uAcedUDXf2N8wDFMOgn0OiWFODh1egOprrexYHRbii12kCE5VpZg46yW10LcayfyE9tmagEIX0UwMSMEuQjJVN4liJpSxFBHFaizcXdGl1XhcUJXm0AQZvjdHy6pRhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739231010; c=relaxed/simple;
	bh=Yu3HZbjj8xkaYgfeCWSXOQmF8m0+x/aY1cBcZ/L7Ks0=;
	h=Date:To:From:Subject:Message-Id; b=tvDPi2n0+ycIK1BkBxb2Uy91pfjxs2pMGEGGZrALVTM9an27i79pVTfQbF5d00dqbM2fsehtYWH+UK+3FdqLD+AtnQSvW1f86+qQVIyrso6o/nSOXQLQM3czOBC6AhEG8w/wa0t0+mY9lM3KNtVqikcRqPji27Ni48mLNh0O6fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PYmAvaq9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PYmAvaq9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55998C4CED1;
	Mon, 10 Feb 2025 23:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739231009;
	bh=Yu3HZbjj8xkaYgfeCWSXOQmF8m0+x/aY1cBcZ/L7Ks0=;
	h=Date:To:From:Subject:From;
	b=PYmAvaq9gGxZuEPC0lpWA22AUEjUf1f87pvK8FUItihLKMU4WjPyhF5upk6Bi7LSh
	 XZoBYFHrneg4Tap1l3P5eagV86YdJhQCxAGam9Mu5kIYSozqbKkTunEm/N8xgwDkUh
	 KX9YevP8yI+TuI4jLrLpKzhJjvQld73UaHu1rKLU=
Date: Mon, 10 Feb 2025 15:43:28 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-do-not-call-damos_walk_control-walk-if-walk-is-completed.patch added to mm-unstable branch
Message-Id: <20250210234329.55998C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: do not call damos_walk_control->walk() if walk is completed
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-do-not-call-damos_walk_control-walk-if-walk-is-completed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-do-not-call-damos_walk_control-walk-if-walk-is-completed.patch

This patch will later appear in the mm-unstable branch at
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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: do not call damos_walk_control->walk() if walk is completed
Date: Mon, 10 Feb 2025 10:27:35 -0800

damos_walk() invokes callback functions of schemes until all schemes
finishes at least one round of walks.  If there are multiple DAMOS schemes
having different apply_interval, the callback functions for longer apply
interval scheme will be called for more than a round of the walk.

The behavior is different from the document (see damos_walk() kernel-doc
comment), and not useful.  Make the behavior be same to the documented
one, by stopping invoking the callback if the walk for the given scheme is
completed.

Link: https://lkml.kernel.org/r/20250210182737.134994-3-sj@kernel.org
Fixes: bf0eaba0ff9c ("mm/damon/core: implement damos_walk()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-do-not-call-damos_walk_control-walk-if-walk-is-completed
+++ a/mm/damon/core.c
@@ -1453,6 +1453,9 @@ static void damos_walk_call_walk(struct
 {
 	struct damos_walk_control *control;
 
+	if (s->walk_completed)
+		return;
+
 	mutex_lock(&ctx->walk_control_lock);
 	control = ctx->walk_control;
 	mutex_unlock(&ctx->walk_control_lock);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-madvise-split-out-mmap-locking-operations-for-madvise.patch
mm-madvise-split-out-madvise-input-validity-check.patch
mm-madvise-split-out-madvise-behavior-execution.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise.patch
mm-damon-avoid-applying-damos-action-to-same-entity-multiple-times.patch
mm-damon-core-unset-damos-walk_completed-after-confimed-set.patch
mm-damon-core-do-not-call-damos_walk_control-walk-if-walk-is-completed.patch
mm-damon-core-do-damos-walking-in-entire-regions-granularity.patch

