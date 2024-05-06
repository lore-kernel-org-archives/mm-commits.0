Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585745CB0
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957049; cv=none; b=Snecwb5fl4f73buPCCrJkE95XZaYzJ1lTOylBzq+7bKd0bBbgNx3Ox545Fd9UhdmlGrY91cCAj6dvNG74ByfgUJfQYvI3CZ9tzFAKEqTZfBDIYYX+wWUOhQje3XGmN+FryFwOpbrLV4ch11nV4auzgtB3qGyTTwI3thJ8odYKl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957049; c=relaxed/simple;
	bh=H1eaj7bWU2b9sWdW5J4V4/7rhMnSQnjS1FvNE8/fWeg=;
	h=Date:To:From:Subject:Message-Id; b=Z93KZ+CC4R7Hkj7jMV4DossAMtwmf0tCS9rmLQc39uSUElyzSC0ievqb37zE/nzJrfW6jKXj3Bkc20Qic73oEVqKqlqZj1MsKHGX8RpUzIDAkWxIw7+l35J7da1kOM2lojTaqKFqnCtcxGJaHg9lu1/7UyC7Zi3+ER0h2GLHvQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bz2ajzjo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bz2ajzjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F724C113CC;
	Mon,  6 May 2024 00:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957049;
	bh=H1eaj7bWU2b9sWdW5J4V4/7rhMnSQnjS1FvNE8/fWeg=;
	h=Date:To:From:Subject:From;
	b=bz2ajzjo1uBt09iqouXXr3XzKIvYnIihsh5nqtjnJiSmVHuLMJJbCE3avvZ87VDA5
	 zMAUdqvT8C1wl2D3oBBPye2XQuM/AbLOAEPNSuiDSmHMfnnQWJs9NPZF3oStNlVxn6
	 iP5KbvnNTfPgniwTRcOGnuyo/u+lEODejBBk0X3M=
Date: Sun, 05 May 2024 17:57:28 -0700
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,mail@maciej.szmigiero.name,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-refactor-limit-checking-from-zswap_store.patch removed from -mm tree
Message-Id: <20240506005729.2F724C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: refactor limit checking from zswap_store()
has been removed from the -mm tree.  Its filename was
     mm-zswap-refactor-limit-checking-from-zswap_store.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: zswap: refactor limit checking from zswap_store()
Date: Sat, 13 Apr 2024 02:24:05 +0000

Refactor limit and acceptance threshold checking outside of zswap_store().
This code will be moved around in a following patch, so it would be
cleaner to move a function call around.

Link: https://lkml.kernel.org/r/20240413022407.785696-3-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/mm/zswap.c~mm-zswap-refactor-limit-checking-from-zswap_store
+++ a/mm/zswap.c
@@ -517,6 +517,21 @@ unsigned long zswap_total_pages(void)
 	return total;
 }
 
+static bool zswap_check_limits(void)
+{
+	unsigned long cur_pages = zswap_total_pages();
+	unsigned long max_pages = zswap_max_pages();
+
+	if (cur_pages >= max_pages) {
+		zswap_pool_limit_hit++;
+		zswap_pool_reached_full = true;
+	} else if (zswap_pool_reached_full &&
+		   cur_pages <= zswap_accept_thr_pages()) {
+			zswap_pool_reached_full = false;
+	}
+	return zswap_pool_reached_full;
+}
+
 /*********************************
 * param callbacks
 **********************************/
@@ -1406,7 +1421,6 @@ bool zswap_store(struct folio *folio)
 	struct zswap_entry *entry, *old;
 	struct obj_cgroup *objcg = NULL;
 	struct mem_cgroup *memcg = NULL;
-	unsigned long max_pages, cur_pages;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
@@ -1429,22 +1443,8 @@ bool zswap_store(struct folio *folio)
 		mem_cgroup_put(memcg);
 	}
 
-	/* Check global limits */
-	cur_pages = zswap_total_pages();
-	max_pages = zswap_max_pages();
-
-	if (cur_pages >= max_pages) {
-		zswap_pool_limit_hit++;
-		zswap_pool_reached_full = true;
+	if (zswap_check_limits())
 		goto reject;
-	}
-
-	if (zswap_pool_reached_full) {
-		if (cur_pages > zswap_accept_thr_pages())
-			goto reject;
-		else
-			zswap_pool_reached_full = false;
-	}
 
 	/* allocate entry */
 	entry = zswap_entry_cache_alloc(GFP_KERNEL, folio_nid(folio));
_

Patches currently in -mm which might be from yosryahmed@google.com are


