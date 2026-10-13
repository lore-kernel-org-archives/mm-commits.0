Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D940484230
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865972; cv=none; b=NpC0fD8gYZRMGcKCvNxtTFNVEF+4LECixGaWmvgIWamI1//qBBNsVIt0/SR6QBDNbadV8YIBrDBjv1RLY+qSu4KahMQqSTkNoK/d6kCuk7mY1ePTaX5LZBaoSu8oecbm6JvfCG4QYge9oD0M24mnQXP1ZWnJCKDaAkR/5MSGKfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865972; c=relaxed/simple;
	bh=O8UVcvhxtNzeIVJ+ZH83uJhIc/vzcyS+WErRB4fkPLg=;
	h=Date:To:From:Subject:Message-Id; b=c+yKShdVG/NtR0fe5ZlDfUZ02J6agTPcrm8LTjHYDgiiUpUszIzxlAARFtIvxvF8f01dHDwq/N1JXZiege8Z6HnF4E6qgRHcPKKY3dC4N0CKknckwjgKtvrlJ+IgvRuHBqgjHQZhS7hXYSnv420d3V+dfCtv4VihKrkqnKQFWfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OOAa+7If; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OOAa+7If"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425B11F00898;
	Tue, 13 Oct 2026 04:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865971;
	bh=odq2E4ER7/VwhvPDFk5oCI911OyKXVc2MxvoUfqFEsI=;
	h=Date:To:From:Subject;
	b=OOAa+7IfQLZT71KQSkKXLYPUCqbejt6VtKEFHUTV9sksFSDHR0LgCt45/7qMebvM8
	 JU3POxIftHhIIFDqztU6fseJv7DFVi4TgKvibaXJ1blA/hIUdx7CdURnCD9Vlz8jn6
	 YjlKK3i9Xdr1/8Elu6hayTvRVVZ9+wEMTwKcxz5w=
Date: Mon, 12 Oct 2026 21:32:50 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,gutierrez.asier@huawei-partners.com,david@kernel.org,davidgow@davidgow.net,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-document-damon_call-damon_start-race-hang-issue.patch removed from -mm tree
Message-Id: <20261013043251.425B11F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: document damon_call()/damon_start() race hang issue
has been removed from the -mm tree.  Its filename was
     mm-damon-core-document-damon_call-damon_start-race-hang-issue.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: document damon_call()/damon_start() race hang issue
Date: Thu, 17 Sep 2026 07:22:03 -0700

Let's suppose damon_start() and damon_call() are executed in parallel
for the same DAMON context.  Then, damon_call() could show
ctx->damon_calls_obsolete set while ctx->kdamond is unset.  If
damon_start() sets ctx->kdamond before damon_call() starts the
cancelling, damon_call() can indefinitely hang.  No DAMON API caller
does such parallel execution of damon_start() and damon_call(), so the
issue doesn't exist.  But who knows what will happen in future.  Add a
clarification comment for caution.

Link: https://lore.kernel.org/20260917142210.90829-6-sj@kernel.org
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

 mm/damon/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-document-damon_call-damon_start-race-hang-issue
+++ a/mm/damon/core.c
@@ -2258,6 +2258,9 @@ int damon_kdamond_pid(struct damon_ctx *
  *
  * When this function is failed, the @ctx is guaranteed to be stopped.
  *
+ * This function should not be called in parallel to damon_start() for the
+ * @ctx.  In the case, this function could indefinitely hang.
+ *
  * Return: 0 on success, negative error code otherwise.
  */
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
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

