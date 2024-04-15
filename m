Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919B8156236
	for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2024 20:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713212525; cv=none; b=GOpBRdnNAotcbIk8CaZ03osZDdzGv16mPxHTXCfOXhMaQQl/+PT+jJjZS3/H5NkDtFwwNaxl4YTlCX5x9K8IjA7KRaM4WvN8W125hE6CtbKr58kvIKkFb1EvWhwbRu5ZYsH8pmCyxKEiPoC4UYs9AiP7NS1+IJXEBldeWJOL1vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713212525; c=relaxed/simple;
	bh=MDVQJXm6ODPdCUMhxUD1XTyxofKGqkbp7cZanq+anpQ=;
	h=Date:To:From:Subject:Message-Id; b=fJqSGwmPztGjjSjweNYtlQ8wziUPxz1u7A8R/tD3GMhMR+ysXgGj0/9t6jAu93FpAQJQhE+fHwf1czrATtug1bEF9D7GDYo0R+Fvy1FtZ7jq6BBsK9H1UbKllxIllGuHt9llrRf1XLTYyxrzZz9fBrjzSMcxwfnNUsmjQ2Dv5Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JNa3RSFg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JNa3RSFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016DDC2BD11;
	Mon, 15 Apr 2024 20:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713212525;
	bh=MDVQJXm6ODPdCUMhxUD1XTyxofKGqkbp7cZanq+anpQ=;
	h=Date:To:From:Subject:From;
	b=JNa3RSFgCNIArITuotDDqdjgu35k76wONojXmsO//Iz47sWWmcQnI3YM9BB1J/hhy
	 ltbW/H2eNUtgQJD2ruK//4hp/cx4AHYm/a2m/zjk11887MlavbYJFth24qQQ6UMXDu
	 4IqyFsaDQwTeklZIL9oVheRw3vyQiQvCXcd35iWA=
Date: Mon, 15 Apr 2024 13:22:04 -0700
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,mail@maciej.szmigiero.name,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-always-shrink-in-zswap_store-if-zswap_pool_reached_full.patch added to mm-unstable branch
Message-Id: <20240415202205.016DDC2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: always shrink in zswap_store() if zswap_pool_reached_full
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-always-shrink-in-zswap_store-if-zswap_pool_reached_full.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-always-shrink-in-zswap_store-if-zswap_pool_reached_full.patch

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
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: zswap: always shrink in zswap_store() if zswap_pool_reached_full
Date: Sat, 13 Apr 2024 02:24:04 +0000

Patch series "zswap same-filled and limit checking cleanups", v3.

Miscellaneous cleanups for limit checking and same-filled handling in the
store path.  This series was broken out of the "zswap: store zero-filled
pages more efficiently" series [1].  It contains the cleanups and drops
the main functional changes.

[1]https://lore.kernel.org/lkml/20240325235018.2028408-1-yosryahmed@google.com/


This patch (of 4):

The cleanup code in zswap_store() is not pretty, particularly the 'shrink'
label at the bottom that ends up jumping between cleanup labels.

Instead of having a dedicated label to shrink the pool, just use
zswap_pool_reached_full directly to figure out if the pool needs
shrinking.  zswap_pool_reached_full should be true if and only if the pool
needs shrinking.

The only caveat is that the value of zswap_pool_reached_full may be
changed by concurrent zswap_store() calls between checking the limit and
testing zswap_pool_reached_full in the cleanup code.  This is fine
because:

- If zswap_pool_reached_full was true during limit checking then became
  false during the cleanup code, then someone else already took care of
  shrinking the pool and there is no need to queue the worker. That
  would be a good change.
- If zswap_pool_reached_full was false during limit checking then became
  true during the cleanup code, then someone else hit the limit
  meanwhile. In this case, both threads will try to queue the worker,
  but it never gets queued more than once anyway. Also, calling
  queue_work() multiple times when the limit is hit could already happen
  today, so this isn't a significant change in any way.

Link: https://lkml.kernel.org/r/20240413022407.785696-1-yosryahmed@google.com
Link: https://lkml.kernel.org/r/20240413022407.785696-2-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/zswap.c~mm-zswap-always-shrink-in-zswap_store-if-zswap_pool_reached_full
+++ a/mm/zswap.c
@@ -1429,12 +1429,12 @@ bool zswap_store(struct folio *folio)
 	if (cur_pages >= max_pages) {
 		zswap_pool_limit_hit++;
 		zswap_pool_reached_full = true;
-		goto shrink;
+		goto reject;
 	}
 
 	if (zswap_pool_reached_full) {
 		if (cur_pages > zswap_accept_thr_pages())
-			goto shrink;
+			goto reject;
 		else
 			zswap_pool_reached_full = false;
 	}
@@ -1540,6 +1540,8 @@ freepage:
 	zswap_entry_cache_free(entry);
 reject:
 	obj_cgroup_put(objcg);
+	if (zswap_pool_reached_full)
+		queue_work(shrink_wq, &zswap_shrink_work);
 check_old:
 	/*
 	 * If the zswap store fails or zswap is disabled, we must invalidate the
@@ -1550,10 +1552,6 @@ check_old:
 	if (entry)
 		zswap_entry_free(entry);
 	return false;
-
-shrink:
-	queue_work(shrink_wq, &zswap_shrink_work);
-	goto reject;
 }
 
 bool zswap_load(struct folio *folio)
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-memcg-add-null-check-to-obj_cgroup_put.patch
mm-zswap-remove-unnecessary-check-in-zswap_find_zpool.patch
percpu-clean-up-all-mappings-when-pcpu_map_pages-fails.patch
mm-zswap-remove-nr_zswap_stored-atomic.patch
mm-zswap-always-shrink-in-zswap_store-if-zswap_pool_reached_full.patch
mm-zswap-refactor-limit-checking-from-zswap_store.patch
mm-zswap-move-more-same-filled-pages-checks-outside-of-zswap_store.patch
mm-zswap-remove-same_filled-module-params.patch
mm-zswap-remove-same_filled-module-params-fix.patch

