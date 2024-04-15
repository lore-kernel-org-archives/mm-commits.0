Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F557156236
	for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2024 20:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713212529; cv=none; b=Ex+k2Jq7GLFHNbMUD0diTbxrBz9qZxSBOFL5PVqRybnP0u4jCh4nXHugWBjxIJsqt25nsfVP0NyzTWZBVXMBSRjpjpVzu/ZMaH5btZuiDvywOAN04mFdcMljSWE831pMr5pjrb2txlG0foog+DZu5jgV2xkc+3Ic9sF2TvbP20A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713212529; c=relaxed/simple;
	bh=u3KbzkQedL2y1+FzBnKwX1iBsYi8Q+c6IlPtK1PAqfY=;
	h=Date:To:From:Subject:Message-Id; b=R96Azn/0V1eWQ/8Eqaxme+8+zJrZNvu0BXIdAvCbvApUCx0aEBKUdAFwG/WPakN+xVSueGRNxm5nTdcatrd8o5IING0MskuX4wHJZLk7bPFrpoSIbJXZNoHpkk34ANyvrGmqZN4goBiNM3uYycU3pDFOqMPyFf1KyMYOiQVEBY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xr4lkDhv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xr4lkDhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B682FC2BD11;
	Mon, 15 Apr 2024 20:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713212528;
	bh=u3KbzkQedL2y1+FzBnKwX1iBsYi8Q+c6IlPtK1PAqfY=;
	h=Date:To:From:Subject:From;
	b=xr4lkDhvA8TVTMmvf815VN5J3EbKOAFm2fR4x5babC1Hv4sRdhtLq74naJD8OAFeI
	 9tO7gx5peBSQaRedZ+t3GuLvRMMObbQc6MpS7Qdh3OLVUrCMacgixvFkdHm3RFDR7Y
	 zGJiy9UU9kIoCA9Jk8HZ1s/33CvoDXBenLlgL3SM=
Date: Mon, 15 Apr 2024 13:22:08 -0700
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,mail@maciej.szmigiero.name,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-move-more-same-filled-pages-checks-outside-of-zswap_store.patch added to mm-unstable branch
Message-Id: <20240415202208.B682FC2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: move more same-filled pages checks outside of zswap_store()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-move-more-same-filled-pages-checks-outside-of-zswap_store.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-move-more-same-filled-pages-checks-outside-of-zswap_store.patch

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
@@ -1376,26 +1376,35 @@ resched:
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
@@ -1406,6 +1415,9 @@ static void zswap_fill_page(void *ptr, u
 	memset_l(page, value, PAGE_SIZE / sizeof(unsigned long));
 }
 
+/*********************************
+* main API
+**********************************/
 bool zswap_store(struct folio *folio)
 {
 	swp_entry_t swp = folio->swap;
@@ -1414,6 +1426,7 @@ bool zswap_store(struct folio *folio)
 	struct zswap_entry *entry, *old;
 	struct obj_cgroup *objcg = NULL;
 	struct mem_cgroup *memcg = NULL;
+	unsigned long value;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
@@ -1446,19 +1459,11 @@ bool zswap_store(struct folio *folio)
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
@@ -1481,7 +1486,7 @@ bool zswap_store(struct folio *folio)
 	if (!zswap_compress(folio, entry))
 		goto put_pool;
 
-insert_entry:
+store_entry:
 	entry->swpentry = swp;
 	entry->objcg = objcg;
 
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

