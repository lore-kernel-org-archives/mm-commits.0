Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832293;
	b=xWX/IfgoGWOLaSucY4BQcAAjdO2D6mzI+Wbfx480pBGGrAHZjow2AtNq4fAS1VDtAlpk
	 S6izdPusIam4upT/gsAaL/iVdtID4rpJe0byIFe4CPIMv1qfSmyZBiXeeUp9x51Je9FPw
	 Yg161OfLcjO6sVEyyE0foi9MI0v1FpnWrYywm8yKQ60LbEcIlSATZeniv+iy76zpmu4LO
	 wIg4gnDlt4tBIthDkcN5T2Mw3X+2P2KfPD14iItZtzLeNWC8XXNoWKQ2qsNaVzPlnrZ3L
	 qYtVVy/nqpRaqvgZTdElfA6jt2VQoSjy/0+KKaBnfOemihGunA75LGJB9I0GiIiosFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832293;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=v9zU+KnHC0W6Wln2UZOFx35AXOA7ocWVy25y+SkOQPI=;
	b=rFbzj2DykGyh74XxjI0kker+SWzB2Gv1CE2JlBkAQnXfXYMTVwmeY7qsxgkDolZOmDPH
	 KCHdjV+0vI0ZqBVxD5ZEXmxFjIDUIjaD4TuofhaHg/4isFbtDm9GUsAe2RRhs3VtkkPtu
	 t563AN4sZ6ftjnNZIZRbHbz2+PF5gpco1meBDb+E6zksYG1vFW3ofAly/CmZFIkUMjxqa
	 6GYzCe1CmoAB4tPD9Py5hl4KT2W44GMk9ct15Lauopdo88xtzcesYZi6OW/6ucRqXZFI3
	 Z3nWybKlJz2JhpX+ViS6a4DuaAPF8ZFBD3pvOi9zNJThOImkZEQI9NBljUL7S3raegQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=L2pfV2jq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1891F606A320;
	Sat, 24 Oct 2026 08:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=L2pfV2jq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B521F01825;
	Sat, 24 Oct 2026 08:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832293;
	bh=v9zU+KnHC0W6Wln2UZOFx35AXOA7ocWVy25y+SkOQPI=;
	h=Date:To:From:Subject;
	b=L2pfV2jqWM+hOfHXF80bwcS5ILvhYxfCe8nJhM73K99OpjdbRc3Eh2xWF3DRR7Arb
	 Ch0yOb9j6CZ6Fy8UA3QVgrYn3r2EvrFP30P1//BbNsjfEmsaOyG5yqUuliAU7Nhm95
	 oLdn8u4zcIIbjGHZJOKeuUi4xZGWVn0DRfj75wZQ=
Date: Sat, 24 Oct 2026 01:58:12 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,donggeunyoo.kernel@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-prevent-size-quota-overflow-in-the-temporal-goal-tuner.patch removed from -mm tree
Message-Id: <20261024085812.D6B521F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/damon/core: prevent size quota overflow in the temporal goal tuner
has been removed from the -mm tree.  Its filename was
     mm-damon-core-prevent-size-quota-overflow-in-the-temporal-goal-tuner.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

