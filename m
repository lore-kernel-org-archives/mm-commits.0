Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792947246;
	b=WNL1bdHSaQmxs0xNN81OK9yb/SlPo/1fWXOUWJH+oVVYLWEnDvwM3YhZWQRXFfPonxWd
	 SwsU9G1bPDIJKCg996KvYSigLa+76TFGXnhY+p+XtzFA0tbOiEZ8Bk1PA3jV6G+YGsjI1
	 bcufClH58lQXUGIhXC14gQ9jAk8pagI+9+GsUAhUMkIA1W8B/rDm5xkn+B6tIjT/GvstI
	 /Fy4I5EjRU2YRsRWKxbJI23Eu7ogqBuqGjv4owjrTU0surgNi6SRpNxpNTfszWnc3UDQc
	 RrClPhpZQt0wvA99Jr1IN7X/vjqoTnzVwGYxTsuhNpR76pCz7e/jq6pt9TTIvsUjnfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792947246;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=gmkWe9/DTLOraKZ8CTlcaXUmsoz4oBuFv050yDQdCEs=;
	b=20Prcwc6Zy5zphMEyRsv70y30YJ7fXadn9bOkwJ8NIfKWjAXmBKqRibxJ4Orf5axsm1F
	 UEpHSUA8ZynNr3MUPHgprEPPsxaivNecLfw2761PEVcoknPpbxakVHlyQXk2RHp9S6kwd
	 kP/hjXZX8p3G47uCPw6BofCyvlfhyqIlVO0bg87n3rYwaIF8lVvyQdQQw838yeoGPgngM
	 2EvOMFh9AuQiCdDVsW6bzUu/Vp//C0Nqf/CtftlEX19jN0czOHLNHXjPpm08TYa4gd16I
	 Hd9YyWqXfv8ht5PFdsARsyPR4y5zLcn677pmGE0o6ryj4ICNYsfj497cvxHaoGtQzqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=v2iXxWff;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73868606A31A;
	Sun, 25 Oct 2026 16:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=v2iXxWff
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D912B1F01825;
	Sun, 25 Oct 2026 16:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792947246;
	bh=gmkWe9/DTLOraKZ8CTlcaXUmsoz4oBuFv050yDQdCEs=;
	h=Date:To:From:Subject;
	b=v2iXxWffEUapOi9WEg6FBVaADUr91wAFdkz8/G7EMNZ18Etjiw69gqoJp34tIIOXx
	 6wKqBbXsfahoVjdsJpNOtXGDZxttTN6Am7su5GikLZmz64EO4TbifnU4wLoCbFnEkX
	 1fBUMU0+TBtJ6TdlaJ/IvljG6u/TbBMJVJy8w7gE=
Date: Sun, 25 Oct 2026 09:54:05 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-hold-damon_sysfs_lock-in-target_metric_store.patch added to mm-unstable branch
Message-Id: <20261025165405.D912B1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/sysfs-schemes: hold damon_sysfs_lock in target_metric_store()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-hold-damon_sysfs_lock-in-target_metric_store.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-hold-damon_sysfs_lock-in-target_metric_store.patch

This patch will later appear in the mm-unstable branch at
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
From: SJ Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: hold damon_sysfs_lock in target_metric_store()
Date: Sun, 25 Oct 2026 09:48:04 -0700

Patch series "mm/damon: fix three race bugs in sysfs and core", v1.

There are three race condition bugs in DAMON sysfs interface and the
core layer.  User impacts are not critical but better to fix sooner than
later.

Patch 1 fixes a toctou bug in DAMON sysfs interface that can mess up
DAMOS auto-tuning.  Patches 2 and 3 move static variables that can be
wrongly shared with multiple kdamonds and therefore make DAMON
monitoring results be a little more indeterministic.

Note for Andrew.  These are not urgent but better to take the hotfix
track in my humble opinion.


This patch (of 3):

damon_sysfs_add_quota_score() reads damos_sysfs_quota_goal->metric
twice, once to set damos_quota_goal->metric to the value, and once again
to set the metric-dependent damos_quota_goal unions based on the value.

target_metrics_score() can update damos_sysfs_quota_goal->metric between
the two reads.  This time-of-check to time-of-use (toctou) race can make
the union fields incorrectly set.  The incorrect damos_quota_goal will
be passed to the core layer and make DAMOS incorrectly behave.

Users could reproduce the race by writing a new value to the
target_metric sysfs file while DAMON is starting, or online parameters
update is ongoing.  The issue will only rarely happen in the real use
cases.  It requires sysfs write permission.  The race window is short.
Sane users wouldn't do such writes while DAMON enablement and/or online
parameters update is ongoing.

The user impact is not very critical.  The race is not easy to
unintentionally trigger.  No leak or crash happens.  Nonetheless, DAMOS
could be unexpectedly more or less aggressive and does not achieve the
auto-tune goal.  Because of the nature of races, investigating will be
difficult.  Users can control the impact from unexpected aggressiveness
using additional quotas and resolve the issue in runtime by
re-installing the quota goal, though.

Avoid the race by protecting damos_sysfs_quota_goal->metric write in
target_metric_store() with damon_sysfs_lock.  Because
damon_sysfs_add_quota_score() is called while holding the same lock, the
race is removed.

The issue was discovered as a part of a bug report [1] from Sashiko,
which is partially outdated.  In more detail, the Sashiko report [1] was
mainly for an outdated bug [2].  But it was also mentioning the issue of
this patch as a similar class bug.

Link: https://lore.kernel.org/20261025164808.152048-1-sj@kernel.org
Link: https://lore.kernel.org/20261025164808.152048-2-sj@kernel.org
Link: https://sashiko.dev/#/bug/linux-7f814c9a-986f-4103-a55a-ef9537dcf62b [1]
Link: https://lore.kernel.org/20261021005234.94107-1-sj@kernel.org [2]
Fixes: 85fcf0ffc460 ("mm/damon/sysfs-schemes: connect damos_quota_goal nid with core layer")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org> # 6.16.x
---

 mm/damon/sysfs-schemes.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-hold-damon_sysfs_lock-in-target_metric_store
+++ a/mm/damon/sysfs-schemes.c
@@ -1310,7 +1310,10 @@ static ssize_t target_metric_store(struc
 
 		metric_name = &damos_sysfs_qgoal_metric_names[i];
 		if (sysfs_streq(buf, metric_name->name)) {
+			if (!mutex_trylock(&damon_sysfs_lock))
+				return -EBUSY;
 			goal->metric = metric_name->metric;
+			mutex_unlock(&damon_sysfs_lock);
 			return count;
 		}
 	}
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-hold-damon_sysfs_lock-in-target_metric_store.patch
mm-damon-core-move-static-variable-last_nr_regions-to-damon_ctx.patch
mm-damon-core-move-static-variable-rotation-to-damon_ctx.patch

