Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B235325570
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957050; cv=none; b=ixlDLRcLh0hbC+ol8V6xxgCZOLVKQ6r1odzAL+nWAOAdWCdV1QwYxNlxth46k4zhC4vm9TV53wBmI9ohffOpy4S5lH2yKdQQO/UZo8eEq026v2YD2DgUun7KHP3+NM2Nph4Rek98YKTHOtlJ9pwpNxttWUgzMCHEpSb4NaIUuGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957050; c=relaxed/simple;
	bh=/5GaS8TEF+SXyfM1YT6KferadSQwgzVMO8ji3DTS+1M=;
	h=Date:To:From:Subject:Message-Id; b=hcSD+eYw5IiNWGCBl6ykicsfYY1TNMIkxyMSSFyjwtCD8U0JWlV2ljjVgtsBKNv2OJaYdCar959l++N3j0qS701l6nFepHiQshaOSeqOOD881rq66VWoKVW3MM7fmyylUjqCfnnKH4xRAR4fEZv503RRriNWXzhhvmkRnM/DtGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=srMu/O54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="srMu/O54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43193C113CC;
	Mon,  6 May 2024 00:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957050;
	bh=/5GaS8TEF+SXyfM1YT6KferadSQwgzVMO8ji3DTS+1M=;
	h=Date:To:From:Subject:From;
	b=srMu/O54LUGEO/B7sV3YHhCie0KR8BvI+YrG5r3WAO17K/bWiGQn/7+gQTriPWTlr
	 GIxGO7ifFPz24fiP6g9gIxFy4i4PoDofop+/46ZddC/qlCwWSGXbw9CMbINYI8RzNC
	 yAO4LGKIZJTicK+G1RoI59n+Bc6SBOFx4FPFV/Vw=
Date: Sun, 05 May 2024 17:57:29 -0700
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,mail@maciej.szmigiero.name,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-move-more-same-filled-pages-checks-outside-of-zswap_store.patch removed from -mm tree
Message-Id: <20240506005730.43193C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: move more same-filled pages checks outside of zswap_store()
has been removed from the -mm tree.  Its filename was
     mm-zswap-move-more-same-filled-pages-checks-outside-of-zswap_store.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: zswap: move more same-filled pages checks outside of zswap_store()
Date: Sat, 13 Apr 2024 02:24:06 +0000

Currently, zswap_store() checks zswap_same_filled_pages_enabled, kmaps the
folio, then calls zswap_is_page_same_filled() to check the folio contents.
Move this logic into zswap_is_page_same_filled() as well (and rename it
to use 'folio' while we are at it).

This makes zswap_store() cleaner, and makes following changes to that
logic contained within the helper.

While we are at it:
- Rename the insert_entry label to store_entry to match xa_store().
- Add comment headers for same-filled functions and the main API
  functions (load, store, invalidate, swapon, swapoff).

No functional change intended.

Link: https://lkml.kernel.org/r/20240413022407.785696-4-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

--- a/mm/zswap.c~mm-zswap-move-more-same-filled-pages-checks-outside-of-zswap_store
+++ a/mm/zswap.c
@@ -1383,26 +1383,35 @@ resched:
 	} while (zswap_total_pages() > thr);
 }
 
-static int zswap_is_page_same_filled(void *ptr, unsigned long *value)
+/*********************************
+* same-filled functions
+**********************************/
+static bool zswap_is_folio_same_filled(struct folio *folio, unsigned long *value)
 {
 	unsigned long *page;
 	unsigned long val;
 	unsigned int pos, last_pos = PAGE_SIZE / sizeof(*page) - 1;
+	bool ret = false;
 
-	page = (unsigned long *)ptr;
+	if (!zswap_same_filled_pages_enabled)
+		return false;
+
+	page = kmap_local_folio(folio, 0);
 	val = page[0];
 
 	if (val != page[last_pos])
-		return 0;
+		goto out;
 
 	for (pos = 1; pos < last_pos; pos++) {
 		if (val != page[pos])
-			return 0;
+			goto out;
 	}
 
 	*value = val;
-
-	return 1;
+	ret = true;
+out:
+	kunmap_local(page);
+	return ret;
 }
 
 static void zswap_fill_page(void *ptr, unsigned long value)
@@ -1413,6 +1422,9 @@ static void zswap_fill_page(void *ptr, u
 	memset_l(page, value, PAGE_SIZE / sizeof(unsigned long));
 }
 
+/*********************************
+* main API
+**********************************/
 bool zswap_store(struct folio *folio)
 {
 	swp_entry_t swp = folio->swap;
@@ -1421,6 +1433,7 @@ bool zswap_store(struct folio *folio)
 	struct zswap_entry *entry, *old;
 	struct obj_cgroup *objcg = NULL;
 	struct mem_cgroup *memcg = NULL;
+	unsigned long value;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
@@ -1453,19 +1466,11 @@ bool zswap_store(struct folio *folio)
 		goto reject;
 	}
 
-	if (zswap_same_filled_pages_enabled) {
-		unsigned long value;
-		u8 *src;
-
-		src = kmap_local_folio(folio, 0);
-		if (zswap_is_page_same_filled(src, &value)) {
-			kunmap_local(src);
-			entry->length = 0;
-			entry->value = value;
-			atomic_inc(&zswap_same_filled_pages);
-			goto insert_entry;
-		}
-		kunmap_local(src);
+	if (zswap_is_folio_same_filled(folio, &value)) {
+		entry->length = 0;
+		entry->value = value;
+		atomic_inc(&zswap_same_filled_pages);
+		goto store_entry;
 	}
 
 	if (!zswap_non_same_filled_pages_enabled)
@@ -1488,7 +1493,7 @@ bool zswap_store(struct folio *folio)
 	if (!zswap_compress(folio, entry))
 		goto put_pool;
 
-insert_entry:
+store_entry:
 	entry->swpentry = swp;
 	entry->objcg = objcg;
 
_

Patches currently in -mm which might be from yosryahmed@google.com are


