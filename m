Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03F0309EFC
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 05:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782709433; cv=none; b=lHT9/roGFuO88WziiIAoN5sTQQ2lp7E9Po+g80jzEJQFD6x9cqTnu4uNbbGN1Sb8NjTQqDrVhOFQM0OmOmImPj3+MQnUKHV8upYCrGo3GtihNuZJuMkwlffF6FdBZVVO+KpubFPWQAnlLr6GXhmXZuxvDu1HCWxuEuYUgndJ7gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782709433; c=relaxed/simple;
	bh=0Kljec2+LcLa3x7jVceNDSXMHukmXY0ihj12F/HRxdI=;
	h=Date:To:From:Subject:Message-Id; b=lujpz3DHO5tZz68NDn4Bz2lkvz+QJSVVij1nJ/qxec1JkepyImEGAklQYJAy0YFQooBRyUW2tlE0JpPurlg1q5SPUx3lvrWzfx3kR99z6M8EtptSSWdrXeKMy761AWPuWl1d/zoQaZNsfpijM4YErdBFxFc9zuGVwc23E2Y5LCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g15i4sm+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g15i4sm+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3A91F000E9;
	Mon, 29 Jun 2026 05:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782709432;
	bh=RbBX67dQYcF4P1VwJ43UFce9ELJs9jzIJO/y5SQJHE8=;
	h=Date:To:From:Subject;
	b=g15i4sm+EBMdzk3btKRj9a6ccj3z3i7QpVpgS5O4lrTwn3Er+OoYnVvKh/a3vhW/i
	 sMPLXr/o5XLWd3d6FyM0IqVqBp+TTi6GJq3s07APdAaEBprvh600j9ijyELbfLCefZ
	 G6WCALcdlrFGzxi8106mn9fZKZPlvmW4f7UcH4B4=
Date: Sun, 28 Jun 2026 22:03:51 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-add-a-kernel-doc-comment-for-damon_ctx-probes.patch added to mm-hotfixes-unstable branch
Message-Id: <20260629050352.3A3A91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: add a kernel-doc comment for damon_ctx->probes
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-add-a-kernel-doc-comment-for-damon_ctx-probes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-add-a-kernel-doc-comment-for-damon_ctx-probes.patch

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
From: SJ Park <sj@kernel.org>
Subject: mm/damon: add a kernel-doc comment for damon_ctx->probes
Date: Sun, 28 Jun 2026 15:08:03 -0700

The two fields of damon_ctx struct dont have their kernel-doc comments.
That causes kernel document builds to warn.  Fix those.


This patch (of 2):

Fix below document build warning:

    WARNING: ../include/linux/damon.h:909 struct member 'probes' not described in 'damon_ctx'

Link: https://lore.kernel.org/20260628220808.98931-1-sj@kernel.org
Link: https://lore.kernel.org/20260628220808.98931-2-sj@kernel.org
Fixes: 18c777859f28 ("mm/damon/core: embed damon_probe objects in damon_ctx")
Signed-off-by: SJ Park <sj@kernel.org>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Closes: https://lore.kernel.org/4df95955-b255-4e5a-90c4-35db02f3111f@infradead.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/damon.h~mm-damon-add-a-kernel-doc-comment-for-damon_ctx-probes
+++ a/include/linux/damon.h
@@ -841,6 +841,7 @@ struct damon_attrs {
  * including damon_call() and damos_walk().
  *
  * @ops:	Set of monitoring operations for given use cases.
+ * @probes:	Head of probes (&damon_probe) list.
  * @addr_unit:	Scale factor for core to ops address conversion.
  * @min_region_sz:	Minimum region size.
  * @pause:	Pause kdamond main loop.
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-fix-dir-put-orders-in-access_pattern_add_dirs.patch
mm-damon-sysfs-schemes-put-stats-for-scheme_add_dirs-internal-error.patch
mm-damon-ops-common-handle-extreme-intervals-in-damon_hot_score.patch
maintainers-s-seongjae-sj.patch
mm-damon-add-a-kernel-doc-comment-for-damon_ctx-probes.patch
mm-damon-add-a-kernel-doc-comment-for-damon_ctx-rnd_state.patch
samples-damon-wsse-handle-damon_start-failure.patch
samples-damon-prcl-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_stop-failure.patch
samples-damon-wsse-stop-and-free-damon-ctx-when-damon_call-fails.patch
samples-damon-prcl-stop-and-free-damon-ctx-when-damon_call-fails.patch
mm-damon-sysfs-kobject_del-target-normal-context-and-kdamond-dirs.patch
mm-damon-sysfs-kobject_del-region-and-target-error-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-region-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-filter-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-quota-goal-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-action-destination-dirs.patch
mm-damon-sysfs-kobject_del-probe-dirs.patch
mm-damon-sysfs-kobject_del-probe-filter-dirs.patch
mm-damon-sysfs-kobject_del-probe-dirs-in-probes_addd_dir-error-path.patch
mm-damon-sysfs-schemes-kobject_del-region-for-populate_region-error.patch

