Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CAE156236
	for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2024 20:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713212527; cv=none; b=hnCm3rNbKqh/FSHblOvbqHGvhiNiDhqaImYQnfFgiXWGOPzF2DXv8vLwiSEApDGgwDe853xhUMd7G8EiUMwnEKKzNGARThpzDUUdt7cw5Hc+FZydSolu5j/nL/KIsOUqhICtbZapBMBI7kcqDbytar/poCh1I+x/BDlznszAkjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713212527; c=relaxed/simple;
	bh=KZp/THrMbfTl72j0QSkoF17PPCkdQg9Jtls8golIpJQ=;
	h=Date:To:From:Subject:Message-Id; b=t2TrVVCYZkUgYlnKIfsMRidss5g8SQldsd9ud5FFOeDnPYgTTCuJt1Xo5MH/yakMgjsZB9ZMAmTWRZvKIftQtvjIDg7wjIA/f3dsytkd2q/IJuYaXUcGku4v5uKoRwy67ROdZ3e1aNMKyTPUifBO5ccjQiwBkEN/SZQ0T0rJdas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OlTxR0mJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OlTxR0mJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE78DC2BD11;
	Mon, 15 Apr 2024 20:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713212526;
	bh=KZp/THrMbfTl72j0QSkoF17PPCkdQg9Jtls8golIpJQ=;
	h=Date:To:From:Subject:From;
	b=OlTxR0mJ1d66Hpo9SaTGWVMm+FkSsfb/6wnKNNw7tErGUivFxy/DwFg9NMzN0dF2p
	 z/bMRVlq1DzP75CrJ9RLboZL+eWi8sP4weSpYRa0FTYsWidZjh6y0BMZOJ8SwSwZHe
	 V37KHZ936up1EfOcm5u/7w4SV8m5Mb8uWd3/noMM=
Date: Mon, 15 Apr 2024 13:22:06 -0700
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,mail@maciej.szmigiero.name,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-refactor-limit-checking-from-zswap_store.patch added to mm-unstable branch
Message-Id: <20240415202206.CE78DC2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: refactor limit checking from zswap_store()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-refactor-limit-checking-from-zswap_store.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-refactor-limit-checking-from-zswap_store.patch

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
Subject: mm: zswap: refactor limit checking from zswap_store()
Date: Sat, 13 Apr 2024 02:24:05 +0000

Refactor limit and acceptance threshold checking outside of zswap_store().
This code will be moved around in a following patch, so it would be
cleaner to move a function call around.

Link: https://lkml.kernel.org/r/20240413022407.785696-3-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Nhat Pham <nphamcs@gmail.com>
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
@@ -1399,7 +1414,6 @@ bool zswap_store(struct folio *folio)
 	struct zswap_entry *entry, *old;
 	struct obj_cgroup *objcg = NULL;
 	struct mem_cgroup *memcg = NULL;
-	unsigned long max_pages, cur_pages;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
@@ -1422,22 +1436,8 @@ bool zswap_store(struct folio *folio)
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

mm-memcg-add-null-check-to-obj_cgroup_put.patch
mm-zswap-remove-unnecessary-check-in-zswap_find_zpool.patch
percpu-clean-up-all-mappings-when-pcpu_map_pages-fails.patch
mm-zswap-remove-nr_zswap_stored-atomic.patch
mm-zswap-always-shrink-in-zswap_store-if-zswap_pool_reached_full.patch
mm-zswap-refactor-limit-checking-from-zswap_store.patch
mm-zswap-move-more-same-filled-pages-checks-outside-of-zswap_store.patch
mm-zswap-remove-same_filled-module-params.patch
mm-zswap-remove-same_filled-module-params-fix.patch

