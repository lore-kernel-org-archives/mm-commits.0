Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2634B156236
	for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2024 20:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713212531; cv=none; b=uDp6Ogm84Eiy0tbhoq6w0aZWzXWgESAISkRnT9n1cRwVe972r5/yRL+8dlr43vO9yMZQPU5GGWFkbIXOAR/NbvRNW3jh9VaywV/ZdjF+44IiXrYxjZdBgjDQTu5poGPvR7VR9tNdfTZvMbWcM8nobgs5SVzWXrWdrILROzvCMls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713212531; c=relaxed/simple;
	bh=hvJP4nr4hguA0J3BCPtU8SLg79Ynpya3ev80Uw9lZZ0=;
	h=Date:To:From:Subject:Message-Id; b=cfTfsTmbLTSEF9D4eVtjDrM6xKF1j7ld+Y0NKjsrlgO210IZ4FcWEZDxJfEK3JsJ3GeztctqIPv4euzUc/Nv0YtrPmUTfatQn2zuGtyDr9SqUz1WeiVHc/6VF1+oJYjNio0HBm85GSTbVq0QGFThQhgx8+IxqXOpfnrU/pa4YoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=14wTEDKB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="14wTEDKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0249C2BD11;
	Mon, 15 Apr 2024 20:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713212530;
	bh=hvJP4nr4hguA0J3BCPtU8SLg79Ynpya3ev80Uw9lZZ0=;
	h=Date:To:From:Subject:From;
	b=14wTEDKBHmPPOJHPyIeRDYgNcX3pMv4M7iZMu/zZd522Zy67qN/iZK4ABJ8QwL/qn
	 6513MU/+U17UopobBfCUpg8Lmevu9kWLDVrgaqpOEUUuhguovc/kSKauiFNGRzWgCU
	 YIk922EMDb+XGOmOLXAocSjUe4slgRlmJ3hnzKU8=
Date: Mon, 15 Apr 2024 13:22:10 -0700
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,mail@maciej.szmigiero.name,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-remove-same_filled-module-params.patch added to mm-unstable branch
Message-Id: <20240415202210.A0249C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: remove same_filled module params
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-remove-same_filled-module-params.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-remove-same_filled-module-params.patch

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
Subject: mm: zswap: remove same_filled module params
Date: Sat, 13 Apr 2024 02:24:07 +0000

These knobs offer more fine-grained control to userspace than needed and
directly expose/influence kernel implementation; remove them.

For disabling same_filled handling, there is no logical reason to refuse
storing same-filled pages more efficiently and opt for compression. 
Scanning pages for patterns may be an argument, but the page contents will
be read into the CPU cache anyway during compression.  Also, removing the
same_filled handling code does not move the needle significantly in terms
of performance anyway [1].

For disabling non_same_filled handling, it was added when the compressed
pages in zswap were not being properly charged to memcgs, as workloads
could escape the accounting with compression [2].  This is no longer the
case after commit f4840ccfca25 ("zswap: memcg accounting"), and using
zswap without compression does not make much sense.

[1]https://lore.kernel.org/lkml/CAJD7tkaySFP2hBQw4pnZHJJwe3bMdjJ1t9VC2VJd=khn1_TXvA@mail.gmail.com/
[2]https://lore.kernel.org/lkml/19d5cdee-2868-41bd-83d5-6da75d72e940@maciej.szmigiero.name/

Link: https://lkml.kernel.org/r/20240413022407.785696-5-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Cc: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   19 -------------------
 1 file changed, 19 deletions(-)

--- a/mm/zswap.c~mm-zswap-remove-same_filled-module-params
+++ a/mm/zswap.c
@@ -123,19 +123,6 @@ static unsigned int zswap_accept_thr_per
 module_param_named(accept_threshold_percent, zswap_accept_thr_percent,
 		   uint, 0644);
 
-/*
- * Enable/disable handling same-value filled pages (enabled by default).
- * If disabled every page is considered non-same-value filled.
- */
-static bool zswap_same_filled_pages_enabled = true;
-module_param_named(same_filled_pages_enabled, zswap_same_filled_pages_enabled,
-		   bool, 0644);
-
-/* Enable/disable handling non-same-value filled pages (enabled by default) */
-static bool zswap_non_same_filled_pages_enabled = true;
-module_param_named(non_same_filled_pages_enabled, zswap_non_same_filled_pages_enabled,
-		   bool, 0644);
-
 /* Number of zpools in zswap_pool (empirically determined for scalability) */
 #define ZSWAP_NR_ZPOOLS 32
 
@@ -1386,9 +1373,6 @@ static bool zswap_is_folio_same_filled(s
 	unsigned int pos, last_pos = PAGE_SIZE / sizeof(*page) - 1;
 	bool ret = false;
 
-	if (!zswap_same_filled_pages_enabled)
-		return false;
-
 	page = kmap_local_folio(folio, 0);
 	val = page[0];
 
@@ -1466,9 +1450,6 @@ bool zswap_store(struct folio *folio)
 		goto store_entry;
 	}
 
-	if (!zswap_non_same_filled_pages_enabled)
-		goto freepage;
-
 	/* if entry is successfully added, it keeps the reference */
 	entry->pool = zswap_pool_current_get();
 	if (!entry->pool)
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

