Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564BF19BA6
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957048; cv=none; b=rj7iVmUK+EQMYcKJJRJZ0dxW9qWAChbJdJHrZCwwo7XZFftiWA9xpn35WDOgunzx52ulo7Mhc6YD/EC5wac1hvvvD74l8eaBDQKuNpFn8yENhq9oQunacIm46f2vrH0fsbJuE4XJmC2oLCdJKz7XyfvPfvc64BuK9jUvyAULy94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957048; c=relaxed/simple;
	bh=WrB2r3wIp3WM1l5RONRS55YU1/0BC7L4aY38IEHQNFA=;
	h=Date:To:From:Subject:Message-Id; b=oyuwAjcJiSh4yX814ck2ThnFh3y2Ho869MCDOKaSUvMeBNccgmhEq4YCfswvn+WSJ4Ox+26e1QSytcT6dV6a08flhfpy82NTOethHBiqZhy8n7gitTTQQlEdMpKs4HNcO7jDx81CuNXVSmCQWTXcnzi08i2fpAmc/AryatmLzoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HZPDQMJY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HZPDQMJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFACC113CC;
	Mon,  6 May 2024 00:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957048;
	bh=WrB2r3wIp3WM1l5RONRS55YU1/0BC7L4aY38IEHQNFA=;
	h=Date:To:From:Subject:From;
	b=HZPDQMJYnAQv6t5uEuqH//curl6A88i4GsLdSvZoP6WMeVqbjfBUGtCRlnGgK+VH4
	 DmxizeOe1a6pZEBOeTHRfup9LRj+HeusfypJAwFsh3j3R0Ev8tmiKOhXcT9jfPndNa
	 ekcSuMxjgXLF9UOAnEjEqBtcmJuujW2b57UWeRUU=
Date: Sun, 05 May 2024 17:57:27 -0700
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,mail@maciej.szmigiero.name,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-always-shrink-in-zswap_store-if-zswap_pool_reached_full.patch removed from -mm tree
Message-Id: <20240506005728.2AFACC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: always shrink in zswap_store() if zswap_pool_reached_full
has been removed from the -mm tree.  Its filename was
     mm-zswap-always-shrink-in-zswap_store-if-zswap_pool_reached_full.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1436,12 +1436,12 @@ bool zswap_store(struct folio *folio)
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
@@ -1547,6 +1547,8 @@ freepage:
 	zswap_entry_cache_free(entry);
 reject:
 	obj_cgroup_put(objcg);
+	if (zswap_pool_reached_full)
+		queue_work(shrink_wq, &zswap_shrink_work);
 check_old:
 	/*
 	 * If the zswap store fails or zswap is disabled, we must invalidate the
@@ -1557,10 +1559,6 @@ check_old:
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


