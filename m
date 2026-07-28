Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9B73B38B6
	for <mm-commits@vger.kernel.org>; Tue, 28 Jul 2026 18:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785262606; cv=none; b=GZmgbwjVLAMpiT87FsPchpTCuQYQZVlX6ieo/iGF4JoZGhzkR0ol0J+UhNFR336/a0zl7LEQbPooxaZ3qtvg9YQf5bjolSM/dWBhXIYKja35n3Y1mHkslMfTKc0v6G8xfYdTm1Dq9Z/WcxXRmpIHAcgqoXKcPq3vhSI7OxO0Q5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785262606; c=relaxed/simple;
	bh=YRh8QgFuBmZF1MJoFrYUhhsVh+QumEtWLZGT2m4tQf4=;
	h=Date:To:From:Subject:Message-Id; b=I4gI3mNbe2kVli1AlTv7foisYGO8iEV5Tffd89lekTLcub3HgPSo4yYPyGqFJg7zyurUqxYpgrNjJ3dymGA/wKCxSlWdQJOs9DoV7LQCGtr9y8JSKWDLi1DxfhnZ+gZWLry6OnjV8wKCVYG+QoAqZgRcn2dcnDcMGBaUd1uAlMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zlVk1wzH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zlVk1wzH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2CFC1F000E9;
	Tue, 28 Jul 2026 18:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785262604;
	bh=mlBSpzTQD017f/AKjZPqjs72Nd/eYjVoQElXSNIIJfs=;
	h=Date:To:From:Subject;
	b=zlVk1wzHdDCn9SQQAIb2HZRqKuycElxo6AQqnmzeba4Xl3/wwtKFPTyobFAMMnNTQ
	 N6J010QtJ4kiTyPvKi3EHXPlvIBzTWOZST9XgKRKDS2YFJiZQJlJlHmaRxbrqzQdV6
	 DdBUOlyTgK7nmwtkqYzENKEEvllYvm3dY14nYmaw=
Date: Tue, 28 Jul 2026 11:16:44 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,liumartin@google.com,richardycc@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-fix-release-order-of-locks-in-zs_page_migrate.patch added to mm-new branch
Message-Id: <20260728181644.A2CFC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: fix release order of locks in zs_page_migrate()
has been added to the -mm mm-new branch.  Its filename is
     mm-zsmalloc-fix-release-order-of-locks-in-zs_page_migrate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-fix-release-order-of-locks-in-zs_page_migrate.patch

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
From: Richard Chang <richardycc@google.com>
Subject: mm/zsmalloc: fix release order of locks in zs_page_migrate()
Date: Tue, 28 Jul 2026 05:53:33 +0000

In zs_page_migrate(), locks are acquired in the following order:
  1. write_lock(&pool->lock)
  2. spin_lock(&class->lock)
  3. zspage_write_trylock(zspage)

However, upon successful page migration, they were being released in
forward acquisition (FIFO) order:
  1. write_unlock(&pool->lock)
  2. spin_unlock(&class->lock)
  3. zspage_write_unlock(zspage)

Fix the unlocking order to release locks in strict reverse (LIFO)
order of acquisition:
  3. zspage_write_unlock(zspage)
  2. spin_unlock(&class->lock)
  1. write_unlock(&pool->lock)

Releasing locks in reverse order of acquisition adheres to standard
kernel locking hygiene, prevents potential lock ordering and lockdep
inconsistencies.

Link: https://lore.kernel.org/20260728055333.421080-1-richardycc@google.com
Signed-off-by: Richard Chang <richardycc@google.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Martin Liu <liumartin@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-fix-release-order-of-locks-in-zs_page_migrate
+++ a/mm/zsmalloc.c
@@ -1926,9 +1926,9 @@ static int zs_page_migrate(struct page *
 	 * Since we complete the data copy and set up new zspage structure,
 	 * it's okay to release migration_lock.
 	 */
-	write_unlock(&pool->lock);
-	spin_unlock(&class->lock);
 	zspage_write_unlock(zspage);
+	spin_unlock(&class->lock);
+	write_unlock(&pool->lock);
 
 	zpdesc_get(newzpdesc);
 	if (zpdesc_zone(newzpdesc) != zpdesc_zone(zpdesc)) {
_

Patches currently in -mm which might be from richardycc@google.com are

mm-vmscan-abort-proactive-reclaim-early-when-freezing-for-suspend.patch
mm-zsmalloc-fix-release-order-of-locks-in-zs_page_migrate.patch

