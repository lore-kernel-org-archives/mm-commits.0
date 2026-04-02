Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02B435AC1B;
	Thu,  2 Apr 2026 18:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775153854; cv=none; b=IVgaftVJDkoU9JUB77BKqk/Kc3NqkjDWWmLHHh1swHRiYBPtrC9kaeCtzo0LllhOKR/sYJOMzPs0bHASW/EqMjz5FuKez+AXsNyNP5smufa1Q6V0+GuEPYaorDqK9sReV+D6SyaHhpQpm7StXo6L1yB39kyeApEYXbEzZ5k15Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775153854; c=relaxed/simple;
	bh=k1j5trEatp42J/GAwpkXQBO8emp69M+cIR1Do9O1ZUE=;
	h=Date:To:From:Subject:Message-Id; b=saHFVmxzGOUddi75fhUKEgZZlskJKgIms9GOQMlOGzW15FK4jfCWK3iDA3HmUNlCbkQAv7Ab5DBR9DZ4c2z3JQrIl7AiLKY6JOcpgE3uol/ISpXOZSX/HhCKERU3MFzWVurPvFc5k4JtK9Q7z9WsQEYnicKmIjkpgAgiFnQkBuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0F6WEl41; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0F6WEl41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91380C116C6;
	Thu,  2 Apr 2026 18:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775153853;
	bh=k1j5trEatp42J/GAwpkXQBO8emp69M+cIR1Do9O1ZUE=;
	h=Date:To:From:Subject:From;
	b=0F6WEl41kitUOHdN3Dk0jEKvIBlaEfuPcDTF2JW45ICBWmaM2BmT+1xfkS6jVVClM
	 nR9Ys7UFkeBJrE0OK8+Jw9Kmbm1XK+w+VSkZYg4CnQ7qGp3D+roTWJAbw2vEHchsAz
	 fK+t2hF5eljb8s52HGMuVUhRpPeNFHPOT9RJl2b4=
Date: Thu, 02 Apr 2026 11:17:32 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-stat-deallocate-damon_call-failure-leaking-damon_ctx.patch added to mm-hotfixes-unstable branch
Message-Id: <20260402181733.91380C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/stat: deallocate damon_call() failure leaking damon_ctx
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-stat-deallocate-damon_call-failure-leaking-damon_ctx.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-stat-deallocate-damon_call-failure-leaking-damon_ctx.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/stat: deallocate damon_call() failure leaking damon_ctx
Date: Thu, 2 Apr 2026 06:44:17 -0700

damon_stat_start() always allocates the module's damon_ctx object
(damon_stat_context).  Meanwhile, if damon_call() in the function fails,
the damon_ctx object is not deallocated.  Hence, if the damon_call() is
failed, and the user writes Y to “enabled” again, the previously
allocated damon_ctx object is leaked.

This cannot simply be fixed by deallocating the damon_ctx object when
damon_call() fails.  That's because damon_call() failure doesn't guarantee
the kdamond main function, which accesses the damon_ctx object, is
completely finished.  In other words, if damon_stat_start() deallocates
the damon_ctx object after damon_call() failure, the not-yet-terminated
kdamond could access the freed memory (use-after-free).

Fix the leak while avoiding the use-after-free by keeping returning
damon_stat_start() without deallocating the damon_ctx object after
damon_call() failure, but deallocating it when the function is invoked
again and the kdamond is completely terminated.  If the kdamond is not yet
terminated, simply return -EAGAIN, as the kdamond will soon be terminated.

The issue was discovered [1] by sashiko.

Link: https://lkml.kernel.org/r/20260402134418.74121-1-sj@kernel.org
Link: https://lore.kernel.org/20260401012428.86694-1-sj@kernel.org [1]
Fixes: 405f61996d9d ("mm/damon/stat: use damon_call() repeat mode instead of damon_callback")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/stat.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/damon/stat.c~mm-damon-stat-deallocate-damon_call-failure-leaking-damon_ctx
+++ a/mm/damon/stat.c
@@ -245,6 +245,12 @@ static int damon_stat_start(void)
 {
 	int err;
 
+	if (damon_stat_context) {
+		if (damon_is_running(damon_stat_context))
+			return -EAGAIN;
+		damon_destroy_ctx(damon_stat_context);
+	}
+
 	damon_stat_context = damon_stat_build_ctx();
 	if (!damon_stat_context)
 		return -ENOMEM;
@@ -261,6 +267,7 @@ static void damon_stat_stop(void)
 {
 	damon_stop(&damon_stat_context, 1);
 	damon_destroy_ctx(damon_stat_context);
+	damon_stat_context = NULL;
 }
 
 static int damon_stat_enabled_store(
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch
mm-damon-stat-deallocate-damon_call-failure-leaking-damon_ctx.patch
mm-damon-core-fix-damon_call-vs-kdamond_fn-exit-race.patch
mm-damon-core-fix-damos_walk-vs-kdamond_fn-exit-race.patch
mm-damon-core-validate-damos_quota_goal-nid-for-node_mem_usedfree_bp.patch
mm-damon-core-validate-damos_quota_goal-nid-for-node_memcg_usedfree_bp.patch
mm-damon-core-use-time_in_range_open-for-damos-quota-window-start.patch
docs-admin-guide-mm-damon-reclaim-warn-commit_inputs-vs-param-updates-race.patch
docs-admin-guide-mm-damon-lru_sort-warn-commit_inputs-vs-param-updates-race.patch

