Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A171E3AC0C5
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 19:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790019228; cv=none; b=XXgoV6ejU43CDXCezFcRHpzQu+X/GUK0nJibA7OGG1nJiUSjO/sGr0Am1CoUlkm6elPTHxpZwI4hyVyVeXdKysjuT4vhN3v61qHcFrQCJx/3t1+4lH00nPB2dz925Fa4vz7AENJ/OQWhWWaHE364C2yIf7ifnCzL/vijPPtI0yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790019228; c=relaxed/simple;
	bh=0kDqDAo2dBtt45xPa9fx3SR3daE7REnmz0Gd5HXNwEU=;
	h=Date:To:From:Subject:Message-Id; b=R+pPEyFeNgdokTukPTMH3qfAh9aCIEhN0vfTTbXP7FyE/8A/MI9BHSWmp58OcuvXuN+4PA4Z6ua63a8OxXSPlV4ogbpB9lC73abBNQGLHgjw8C4lWVTaZjypuW3YvR9NKm0XH1s5TsyVqOenxVDk86REjhu7Exutadu17HLZ61o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HBMCQbgE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HBMCQbgE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F631F00893;
	Mon, 21 Sep 2026 19:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790019227;
	bh=0OLmTuhJXD7eVCnMArjfaIc90jqJUtKniVZ0H1d1vM0=;
	h=Date:To:From:Subject;
	b=HBMCQbgEgk4tXajMXPeUQaRSu+Am86z+Rim3COstAyoO9Sxtcf5coWyxH6eXKIUzK
	 WrpQjzTnrLPs6voUsGsbSO7XtQh5Eplytyyh4o9N2sPgtVrVtVvV/RjYS79NE89hbW
	 a+PI1I0tlR1rrV9jdGRVG8SlOdhSEUDnCrjSWhZI=
Date: Mon, 21 Sep 2026 12:33:47 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,wangxuewen@kylinos.cn,sj@kernel.org,karthiproffesional@gmail.com,aethernet65535@gmail.com,adrianhuang0701@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-fix-typos-in-comments.patch added to mm-new branch
Message-Id: <20260921193347.65F631F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: fix typos in comments
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-fix-typos-in-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-fix-typos-in-comments.patch

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
From: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Subject: mm/damon: fix typos in comments
Date: Mon, 21 Sep 2026 08:15:45 -0700

Correct spelling mistakes. No functional changes.

Link: https://lore.kernel.org/20260921151547.78472-4-sj@kernel.org
Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Karthikeyan KS <karthiproffesional@gmail.com>
Cc: Liew Rui Yan <aethernet65535@gmail.com>
Cc: Xuewen Wang <wangxuewen@kylinos.cn>
---

 mm/damon/core.c     |    6 +++---
 mm/damon/lru_sort.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/mm/damon/core.c~mm-damon-fix-typos-in-comments
+++ a/mm/damon/core.c
@@ -2486,7 +2486,7 @@ static bool damos_valid_target(struct da
  * This function checks if a given region should be skipped or not for the
  * reason.  If only the starting part of the region has previously charged,
  * this function splits the region into two so that the second one covers the
- * area that not charged in the previous charge widnow, and return true.  The
+ * area that not charged in the previous charge window, and return true.  The
  * caller can see the second one on the next iteration of the region walk.
  * Note that this means the caller should use damon_for_each_region() instead
  * of damon_for_each_region_safe().  If damon_for_each_region_safe() is used,
@@ -2652,7 +2652,7 @@ static void damos_walk_call_walk(struct
  * This function is called when kdamond finished applying the action of a DAMOS
  * scheme to all regions that eligible for the given &damos->apply_interval_us.
  * If every scheme of @ctx including @s now finished walking for at least one
- * &damos->apply_interval_us, this function makrs the handling of the given
+ * &damos->apply_interval_us, this function marks the handling of the given
  * DAMOS walk request is done, so that damos_walk() can wake up and return.
  */
 static void damos_walk_complete(struct damon_ctx *ctx, struct damos *s)
@@ -4178,7 +4178,7 @@ static bool damon_find_system_rams_range
  * This function sets the region of @t as requested by @start and @end.  If the
  * values of @start and @end are zero, however, this function finds 'System
  * RAM' resources and sets the region to cover all the resource.  In the latter
- * case, this function saves the start and the end addresseses of the first and
+ * case, this function saves the start and the end addresses of the first and
  * the last resources in @start and @end, respectively.
  *
  * Return: 0 on success, negative error code otherwise.
--- a/mm/damon/lru_sort.c~mm-damon-fix-typos-in-comments
+++ a/mm/damon/lru_sort.c
@@ -260,7 +260,7 @@ static int damon_lru_sort_add_filters(st
 		return -ENOMEM;
 	damos_add_filter(hot_scheme, filter);
 
-	/* disabllow de-prioritizing young pages */
+	/* disallow de-prioritizing young pages */
 	filter = damos_new_filter(DAMOS_FILTER_TYPE_YOUNG, true, false);
 	if (!filter)
 		return -ENOMEM;
_

Patches currently in -mm which might be from adrianhuang0701@gmail.com are

mm-damon-fix-typos-in-comments.patch

