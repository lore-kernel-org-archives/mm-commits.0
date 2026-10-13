Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6861647D46C
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865971; cv=none; b=Z4hnWdcB5MATKxSJ5SKSCb6k0MDPjYOBKMXJuF+zA/wU0LyPAayUrHCvcHr30ZVP1erIJdU8WnQ4VzHNYLoMpck/IvnuNBrqYtDv2uvgMhZAUpwD6QRlOPLfIBdmj4HGZV9N4u8e10lPo/Q/nx3JlDgXtjzoWuohxgxgZXPJ7c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865971; c=relaxed/simple;
	bh=VgQv4aqktfq/m2F+Frmp0kWfq5/M12EYIZvnuMsSt7Q=;
	h=Date:To:From:Subject:Message-Id; b=CEXp9gDxtcymNrvJYnRLvu0ieyIokAli9U+R2c4gNWN5PI64s+17aq4ONk+9QWyIwKRq2X8D1c8H4CSMxksLuBRIE+/i0rLpi3IBE8+uUODHl9u1uR0+kn8iwkGrziYI7HNKg4/4/9tJbXZQJd+lMVoiQpPEnQXZimYo8gRHwbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MsfPMLYO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MsfPMLYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3DC1F00893;
	Tue, 13 Oct 2026 04:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865970;
	bh=xQd5o9LnGEG17FpA4UtL9jt+of1/wZlxYgG/TAzdSDI=;
	h=Date:To:From:Subject;
	b=MsfPMLYOhrPXX6kw1urjjIldKYQFO1z4QgjE/vBLkMuAG3n2b7evvHmuceQtcruyu
	 jiAARflpaS/B7K6fKUrK1Ts07MGGeDtA3dSeVWe2ywGL29Qsrw2YWRo/U6A1K3bry9
	 /YkQJVcg4wg72W1YGvusqiViYhU3djbn5hab9F1w=
Date: Mon, 12 Oct 2026 21:32:49 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,gutierrez.asier@huawei-partners.com,david@kernel.org,davidgow@davidgow.net,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-set-damon_ctx-walk_control_obsolete-in-damon_new_ctx.patch removed from -mm tree
Message-Id: <20261013043250.3B3DC1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: set damon_ctx->walk_control_obsolete in damon_new_ctx()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-set-damon_ctx-walk_control_obsolete-in-damon_new_ctx.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: set damon_ctx->walk_control_obsolete in damon_new_ctx()
Date: Thu, 17 Sep 2026 07:22:02 -0700

damos_walk() should be called for a damon_ctx context that has
successfully started at least once.  That's because
damon_ctx->walk_control_obsolete is initialized when kdamond starts.  If
the rule is violated, an indefinite wait can happen.  There is no
existing violation of the rule.

damon_call() had a similar rule, and it turned out keeping the rule is
not easy for damon_call()'s case.  Hence, commit 8023b5f47e09
("mm/damon/core: set ctx->call_controls_obsolete in damon_new_ctx()")
added the initialization in damon_new_ctx() and removed the rule.

Keeping the rule for damos_walk() is relatively easier.  But having
slightly different rules for similar functions could be confusing.
Sashiko, for example, repeatedly asked questions about this.  Do the
initialization of walk_control_obsolete in damon_new_ctx() for
consistency.

Link: https://lore.kernel.org/20260917142210.90829-5-sj@kernel.org
Link: https://lore.kernel.org/20260915011614.102342-1-sj@kernel.org [1]
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/damon/core.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-set-damon_ctx-walk_control_obsolete-in-damon_new_ctx
+++ a/mm/damon/core.c
@@ -939,6 +939,7 @@ struct damon_ctx *damon_new_ctx(void)
 	INIT_LIST_HEAD(&ctx->schemes);
 
 	ctx->call_controls_obsolete = true;
+	ctx->walk_control_obsolete = true;
 	prandom_seed_state(&ctx->rnd_state, get_random_u64());
 
 	return ctx;
@@ -2308,10 +2309,6 @@ canceled:
  * passed at least one &damos->apply_interval_us, kdamond marks the request as
  * completed so that damos_walk() can wakeup and return.
  *
- * Note that this function should be called only after damon_start() with the
- * @ctx has succeeded.  Otherwise, this function could fall into an indefinite
- * wait.
- *
  * Return: 0 on success, negative error code otherwise.
  */
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damos_quota_goal-complement.patch
mm-damon-core-add-complement-argument-to-damos_new_quota_goal.patch
mm-damon-sysfs-schemes-support-quota-goal-complement-flag.patch
mm-damon-tests-core-kunit-test-quota_goal-complement-commit.patch
selftests-damon-sysfssh-test-quota-goal-complement-flag-file.patch
docs-mm-damon-design-document-damos-quota-goal-complement-flag.patch
docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file.patch
docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file.patch

