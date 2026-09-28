Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FFF218592;
	Mon, 28 Sep 2026 22:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790634880; cv=none; b=FQkWPwc6A/rs0cXzeG1pg11SoyevJrdDU8Aq5oYUq4l6dPeDkoAsfp7PPs7WCUw1l0lyOXYm1uNZ6DjwnZEqVKckEfBmBHuxUO+MBAlCfu+kFJ3u0PsXMSt6S6NUbwTE76U+rMbuEhb+JHEFnbgXLn2BnxpzBsdOl7gb50IMoS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790634880; c=relaxed/simple;
	bh=lUdR03ciUJHWptADdFwWN8mGqjaPBnQo1aUmIo2lBh8=;
	h=Date:To:From:Subject:Message-Id; b=o7/e5F9R79o1ykqfu8UPiBKdCwK2c8Gx5t7c75s5UG7RLpOKaf7m8QXtUQUmAzh1u3dHammusXmd/9Xp96C87DbbwLPCuY30XG1264L6iySSmlN3qEBmaD8OK7qRH+1YknNaTAF58F7XzCPzvjJRls2V2LdOmx82qZ+Hr8FKCQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JvId+d8n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JvId+d8n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7901F000FF;
	Mon, 28 Sep 2026 22:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790634878;
	bh=sKjePeqCrtKbM6G/X/meOkomsmYHGJ7GiOkFQnbn81I=;
	h=Date:To:From:Subject;
	b=JvId+d8nWEvfnskZjs3AdHOyGnpuCJz+7xU0Ll8o91z8qmkjVvuOyry1LsYrTURPx
	 WeGI01lNPtSPrb7GmRpNUPHXP2Umrj3OFAA1AWVkQ74IDZshYIlMSW1XJ8kG+cZPxR
	 k7O0h2aSk0AV9lX5/lI23nrLOGP76mPI/2EVE8WA=
Date: Mon, 28 Sep 2026 15:34:37 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,donggeunyoo.kernel@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-prevent-size-quota-overflow-in-the-temporal-goal-tuner.patch added to mm-new branch
Message-Id: <20260928223438.3A7901F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: prevent size quota overflow in the temporal goal tuner
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-prevent-size-quota-overflow-in-the-temporal-goal-tuner.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-prevent-size-quota-overflow-in-the-temporal-goal-tuner.patch

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
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Subject: mm/damon/core: prevent size quota overflow in the temporal goal tuner
Date: Mon, 28 Sep 2026 01:48:14 -0700

Patch series "mm/damon: fix the temporal goal tuner's size quota
conversion", v5.

damos_goal_tune_esz_bp_temporal() hands the size quota to
damos_set_effective_quota() through quota->esz_bp in basis points, and the
multiply that gets it there is unchecked.  On 32-bit it wraps above 429496
bytes, and a wrapped product below 10000 divides to a zero effective
quota.  damos_quota_is_full() is then true on the first test of every
charge window, so the scheme makes no progress for as long as the goal is
unachieved.

Patch 1 bounds the conversion.  Patch 2 pins the boundary in the core
kunit suite, where the new test would fail without patch 1 on any word
size.


This patch (of 2):

damos_goal_tune_esz_bp_temporal() converts the scheme's size quota into
basis points with "quota->esz_bp = quota->sz * 10000", both unsigned long,
and damos_set_effective_quota() divides the result back by 10000. 
quotas/bytes is unbounded; bytes_store() hands it to kstrtoul() as is.

On 32-bit the product wraps for any size quota above ULONG_MAX / 10000,
that is 429496 bytes.  A wrapped product below 10000 divides to a zero
effective quota: 429497 gives 0.  damos_quota_is_full() is then true on
the first test of every charge window.  Other wrapped values are wrong
without being zero: 500000 gives 70503.

Triggering this needs a scheme with a quota goal, the temporal goal tuner,
and a size quota above ULONG_MAX / 10000 -- 429496 bytes on 32-bit,
1844674407370955 on 64-bit.  The scheme then makes no progress for as long
as the goal is unachieved, which is easy to notice, and writing a smaller
size quota restores it.  Nothing is corrupted and nothing leaks.  This is
unlikely to be hit on a tested setup.

addr_unit does not cover this.  It only scales the numbers a paddr context
writes to quotas/bytes, so a large enough scaled value wraps just the
same, and vaddr and fvaddr contexts take raw byte values.

Bound the multiply.

Link: https://lore.kernel.org/20260928084816.5575-1-sj@kernel.org
Link: https://lore.kernel.org/20260928084816.5575-2-sj@kernel.org
Fixes: af738a6a00c1 ("mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 7.1.x
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-prevent-size-quota-overflow-in-the-temporal-goal-tuner
+++ a/mm/damon/core.c
@@ -3291,7 +3291,7 @@ static void damos_goal_tune_esz_bp_tempo
 
 	if (score >= 10000)
 		quota->esz_bp = 0;
-	else if (quota->sz)
+	else if (quota->sz && quota->sz <= ULONG_MAX / 10000)
 		quota->esz_bp = quota->sz * 10000;
 	else
 		quota->esz_bp = ULONG_MAX;
_

Patches currently in -mm which might be from donggeunyoo.kernel@gmail.com are

userfaultfd-clear-the-inherited-uffd-bit-in-move_swap_pte.patch
selftests-mm-add-tests-for-uffdio_move-of-a-uffd-protected-swap-entry.patch
mm-damon-core-charge-only-the-part-of-a-region-the-filter-left.patch
mm-damon-tests-core-kunit-test-the-size-charged-for-a-filter-trimmed-region.patch
mm-damon-core-prevent-size-quota-overflow-in-the-temporal-goal-tuner.patch
mm-damon-tests-core-kunit-test-the-temporal-tuners-size-quota-conversion.patch

