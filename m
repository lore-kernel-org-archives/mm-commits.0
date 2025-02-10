Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC46194141
	for <mm-commits@vger.kernel.org>; Mon, 10 Feb 2025 23:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739231008; cv=none; b=qKQV71tdIuNnSCmaZZK/ccPPPX4A90JPuUpm0Sm4bbPNxAnksmgxFmel0tXNjXedBW/LkxW6ataBGX13897BbQUECv/wE5k89jzB7UeB0GpaIFsASS6dJSGNKzlGQexfX3x/65Q1empxgaK92EmuMEiXhvXD0i3FVuHxKbdEZew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739231008; c=relaxed/simple;
	bh=PdBd+L4p4rujJOz1T+P8+kHoq5QWtVoSBHi5Pc65Dnw=;
	h=Date:To:From:Subject:Message-Id; b=JwvEUXVlQQu8uHdbY9ynZssW9o1yL0qhAsBS21coFqFHfNEgRPMDOMNBT17e+tBI0C1Nc1rrOs9G9B1HHYoEHi5Ub11Df40gltVD2NvrnLitxBYTB7Gn1xXlO3hOf75/L0FqpEN56cpMScX/en9YiBWVI0trJlwAbPdjGu4sPMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lXkMhumV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lXkMhumV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6564DC4CED1;
	Mon, 10 Feb 2025 23:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739231007;
	bh=PdBd+L4p4rujJOz1T+P8+kHoq5QWtVoSBHi5Pc65Dnw=;
	h=Date:To:From:Subject:From;
	b=lXkMhumVCVZvhj816Qex1r1pp/3Q8T7VxW9zA8IgFVRnJAwMwtwx1ksa13NhphYk3
	 mh32qFbzpARA0Bn2szLnyzVvHeWp9lcBRAunU814rbYpkHyotbbiuYgL/hJf7hClQ+
	 1Jhh70IO3NUqob4A/JOIZyj0rEj8Eqff4UJ6FNPw=
Date: Mon, 10 Feb 2025 15:43:26 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-unset-damos-walk_completed-after-confimed-set.patch added to mm-unstable branch
Message-Id: <20250210234327.6564DC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: unset damos->walk_completed after confimed set
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-unset-damos-walk_completed-after-confimed-set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-unset-damos-walk_completed-after-confimed-set.patch

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
Subject: mm/damon/core: unset damos->walk_completed after confimed set
Date: Mon, 10 Feb 2025 10:27:34 -0800

Patch series "mm/damon/core: fix wrong and/or useless damos_walk()
behaviors".

damos_walk() can finish working earlier or later than expected, and start
earlier than practical.  First two behaviors are clearly wrong behavior
(doesn't follow the documentation) and all three behaviors are only making
the feature useless.  Fix those.


This patch (of 3):

damos->walk_completed is only set, not unset.  This can cause next
damos_walk() finish earlier than expected.  Unset it after all
walk_completed is confirmed.

Link: https://lkml.kernel.org/r/20250210182737.134994-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250210182737.134994-2-sj@kernel.org
Fixes: bf0eaba0ff9c ("mm/damon/core: implement damos_walk()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-unset-damos-walk_completed-after-confimed-set
+++ a/mm/damon/core.c
@@ -1489,6 +1489,9 @@ static void damos_walk_complete(struct d
 		if (!siter->walk_completed)
 			return;
 	}
+	damon_for_each_scheme(siter, ctx)
+		siter->walk_completed = false;
+
 	complete(&control->completion);
 	mutex_lock(&ctx->walk_control_lock);
 	ctx->walk_control = NULL;
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

