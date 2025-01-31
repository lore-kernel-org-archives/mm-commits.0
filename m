Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FC523A9;
	Fri, 31 Jan 2025 01:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738287876; cv=none; b=csZnHu/PUvXfYaI6oJWQl76LOnEpXRi/uhG0LEbUe8kFichLPusH/VrnAkM8JQJpLl4qTZZ1ytMbQXjPpJcWJ5SJ5ceKEXbll4usL6C2A8SrksAqC0sNpiYNYwwPYLi6LEYgsUmmN7GMnsw1hhLXSWTUxiOzku81AJEEhX3Wp40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738287876; c=relaxed/simple;
	bh=V5XXWtC72CVWnAF75ZdXH3wBassW4aNhCpFJtKue878=;
	h=Date:To:From:Subject:Message-Id; b=ngFw/wUGUzUm1FJWKZyPStVzKEsPWxw56oz71fYA/Y8k8NihY+Qa4xaxf5lWqf1+GUMB/QWCVma4IG8otsV8+F5Ea8xfhiEwpFEBmF+fKhXT5O4oHKrcnxCTm7HCno/jJU3sjjikXReka4Mrd3oWIXDkDiGHJMKBAKPYNuPz95Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l8y8jHkE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l8y8jHkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617DBC4CED2;
	Fri, 31 Jan 2025 01:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738287875;
	bh=V5XXWtC72CVWnAF75ZdXH3wBassW4aNhCpFJtKue878=;
	h=Date:To:From:Subject:From;
	b=l8y8jHkE0XAy1aZdTe0ZurWFn0UcwgYRko4uRKjoTwYlvgMESYgcwlcEggVSFuEKX
	 DhLP8gC+22WY31lI+YaRqixlU03wywZrehIPuj8YjyLMKoQTzMoiY253ek4LqsIYiX
	 gLG85vGKM0b/6e6i6UzYe2RU0RjQl0Vs7oc3zZVs=
Date: Thu, 30 Jan 2025 17:44:34 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,stable@vger.kernel.org,nphamcs@gmail.com,kanchana.p.sridhar@intel.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,42.hyeyoo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-fix-inconsistency-when-zswap_store_page-fails.patch added to mm-hotfixes-unstable branch
Message-Id: <20250131014435.617DBC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: fix inconsistency when zswap_store_page() fails
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-zswap-fix-inconsistency-when-zswap_store_page-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-fix-inconsistency-when-zswap_store_page-fails.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: mm/zswap: fix inconsistency when zswap_store_page() fails
Date: Wed, 29 Jan 2025 19:08:44 +0900

Commit b7c0ccdfbafd ("mm: zswap: support large folios in zswap_store()")
skips charging any zswap entries when it failed to zswap the entire folio.

However, when some base pages are zswapped but it failed to zswap the
entire folio, the zswap operation is rolled back.  When freeing zswap
entries for those pages, zswap_entry_free() uncharges the zswap entries
that were not previously charged, causing zswap charging to become
inconsistent.

This inconsistency triggers two warnings with following steps:
  # On a machine with 64GiB of RAM and 36GiB of zswap
  $ stress-ng --bigheap 2 # wait until the OOM-killer kills stress-ng
  $ sudo reboot

  The two warnings are:
    in mm/memcontrol.c:163, function obj_cgroup_release():
      WARN_ON_ONCE(nr_bytes & (PAGE_SIZE - 1));

    in mm/page_counter.c:60, function page_counter_cancel():
      if (WARN_ONCE(new < 0, "page_counter underflow: %ld nr_pages=%lu\n",
	  new, nr_pages))

zswap_stored_pages also becomes inconsistent in the same way.

As suggested by Kanchana, increment zswap_stored_pages and charge zswap
entries within zswap_store_page() when it succeeds.  This way,
zswap_entry_free() will decrement the counter and uncharge the entries
when it failed to zswap the entire folio.

While this could potentially be optimized by batching objcg charging and
incrementing the counter, let's focus on fixing the bug this time and
leave the optimization for later after some evaluation.

After resolving the inconsistency, the warnings disappear.

Link: https://lkml.kernel.org/r/20250129100844.2935-1-42.hyeyoo@gmail.com
Fixes: b7c0ccdfbafd ("mm: zswap: support large folios in zswap_store()")
Co-developed-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/zswap.c~mm-zswap-fix-inconsistency-when-zswap_store_page-fails
+++ a/mm/zswap.c
@@ -1504,11 +1504,14 @@ static ssize_t zswap_store_page(struct p
 	entry->pool = pool;
 	entry->swpentry = page_swpentry;
 	entry->objcg = objcg;
+	if (objcg)
+		obj_cgroup_charge_zswap(objcg, entry->length);
 	entry->referenced = true;
 	if (entry->length) {
 		INIT_LIST_HEAD(&entry->lru);
 		zswap_lru_add(&zswap_list_lru, entry);
 	}
+	atomic_long_inc(&zswap_stored_pages);
 
 	return entry->length;
 
@@ -1526,7 +1529,6 @@ bool zswap_store(struct folio *folio)
 	struct obj_cgroup *objcg = NULL;
 	struct mem_cgroup *memcg = NULL;
 	struct zswap_pool *pool;
-	size_t compressed_bytes = 0;
 	bool ret = false;
 	long index;
 
@@ -1569,15 +1571,11 @@ bool zswap_store(struct folio *folio)
 		bytes = zswap_store_page(page, objcg, pool);
 		if (bytes < 0)
 			goto put_pool;
-		compressed_bytes += bytes;
 	}
 
-	if (objcg) {
-		obj_cgroup_charge_zswap(objcg, compressed_bytes);
+	if (objcg)
 		count_objcg_events(objcg, ZSWPOUT, nr_pages);
-	}
 
-	atomic_long_add(nr_pages, &zswap_stored_pages);
 	count_vm_events(ZSWPOUT, nr_pages);
 
 	ret = true;
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are

mm-zsmalloc-add-__maybe_unused-attribute-for-is_first_zpdesc.patch
mm-zswap-fix-inconsistency-when-zswap_store_page-fails.patch

