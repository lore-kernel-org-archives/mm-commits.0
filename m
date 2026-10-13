Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DAF485503
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791866050; cv=none; b=Uvinqo4FkWZ5lls8G+2QVOEi8x6T1v7vgXrnrRUYBeBLKpX0CmPincdXcepL2Sgo9OGyYazj14BvQeuOYXLu2Jz7I9lv2mbfiQUZc29hEPv/oT3/fVjxozbZEQJSi01lmBbOZt4Aod3DPYFDCO5mPbJKdLQagsCcyUesJyf+GbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791866050; c=relaxed/simple;
	bh=56JDLUxHs5kSK6hs1TB+IQDVHfprvAIRleRvnERgWK0=;
	h=Date:To:From:Subject:Message-Id; b=hDX0y5+4ByLie598ImDIviiDM4pP2NuuqvqQd+NnO++tvn3uencAujLl+ukfSzVKVnbioyiM+RI3h789jqOrKrVPkRU2rY3yZgpQEHDuCni9lJNZvsphlki1VTT6ZZ7KWcca39hi+N7xOESKRiQrTy14G1whMUnGupcyMzMwWJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NO6Iv/SW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NO6Iv/SW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37AF1F000FF;
	Tue, 13 Oct 2026 04:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791866048;
	bh=Y0uIKyspucfouOuXXZiy8d2qrOjZ43GIUjEuapCm8TQ=;
	h=Date:To:From:Subject;
	b=NO6Iv/SW+ixX01h0SLSRkTK8pTJqs3dpY0ffbBNNRaeCrnsaE1VMZHhxX7uJ41ZQd
	 0HfJKkQrYLyNUOtmxBm+YJX3AFXRYMc1BYUBnGUb4BJXGIyRHPYl4YBTjtrhzr1aKu
	 KSaULA8yBT3UwJ6Dj6GoyQQ67Qjb/dPAFHdBfGiI=
Date: Mon, 12 Oct 2026 21:34:08 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,wangxuewen@kylinos.cn,sj@kernel.org,karthiproffesional@gmail.com,aethernet65535@gmail.com,adrianhuang0701@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-fix-typos-in-comments.patch removed from -mm tree
Message-Id: <20261013043408.A37AF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: fix typos in comments
has been removed from the -mm tree.  Its filename was
     mm-damon-fix-typos-in-comments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -4194,7 +4194,7 @@ static bool damon_find_system_rams_range
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


