Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF2161FCE
	for <mm-commits@vger.kernel.org>; Thu, 25 Jul 2024 20:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721940764; cv=none; b=OvuRDDxrApR8bR2jGvYcLoX8tI2D4JP3ttvcDCCipurr039HWnMSTDuyBy/mv9RgIhGqyjG9T7kNaASQzFh7jFG+ovp9Z6mTDzD4xinljReMiq1oYHoufTzbLvs//fvo4XQLYut3rGKcz00yoUYAbzFQwy0c31Bjocagq06R3nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721940764; c=relaxed/simple;
	bh=/t8wsgGFs48cQpZoYaYJWiF4Vm5+ZdlQa8BHAOPy+F0=;
	h=Date:To:From:Subject:Message-Id; b=ORdk9KplGLUvqxzAS8TLwkVAVeXB6e06G23KgZVfu6XgLJumvmygxZBthf9mxNHe51vzNuu12b7FEOcwgtCL1Om4kgY3EAlU/t1O4iF44YJH36ntV0Y68/4TVTSTq55qCmXS4u+f1ONS4Amc+6nWX4qrtsxXqGYW5yLTv8f5f1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=10YE/UKp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="10YE/UKp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71B0C116B1;
	Thu, 25 Jul 2024 20:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721940763;
	bh=/t8wsgGFs48cQpZoYaYJWiF4Vm5+ZdlQa8BHAOPy+F0=;
	h=Date:To:From:Subject:From;
	b=10YE/UKp6h1Vj/CeGd3F1ZjayOYrpIidzzwYowXqDvM3V/UixDrsw6ffxe7Lv8mxa
	 1ox3lKvpFNBvo+mUlVHmcLrgEUa/vUixfYE3GkfjxcqTEcq9DRW0aglTdRDmpePG4I
	 Tp760ipYrM0+eZvkVFERdNMvBuEIftJCBiYRYC/c=
Date: Thu, 25 Jul 2024 13:52:43 -0700
To: mm-commits@vger.kernel.org,philipp.reisner@linbit.com,lars.ellenberg@linbit.com,christoph.boehmwalder@linbit.com,deshan@nfschina.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-lru_cache-fix-spelling-mistake-colision-collision.patch added to mm-nonmm-unstable branch
Message-Id: <20240725205243.B71B0C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/lru_cache: fix spelling mistake "colision"->"collision"
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-lru_cache-fix-spelling-mistake-colision-collision.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-lru_cache-fix-spelling-mistake-colision-collision.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Deshan Zhang <deshan@nfschina.com>
Subject: lib/lru_cache: fix spelling mistake "colision"->"collision"
Date: Thu, 25 Jul 2024 17:30:45 +0800

There is a spelling mistake in a literal string and in cariable names. 
Fix these.

Link: https://lkml.kernel.org/r/20240725093044.1742842-1-deshan@nfschina.com
Signed-off-by: Deshan Zhang <deshan@nfschina.com>
Cc: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lru_cache.h |    4 ++--
 lib/lru_cache.c           |   10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/lru_cache.h~lib-lru_cache-fix-spelling-mistake-colision-collision
+++ a/include/linux/lru_cache.h
@@ -119,7 +119,7 @@ write intent log information, three of w
 */
 
 /* this defines an element in a tracked set
- * .colision is for hash table lookup.
+ * .collision is for hash table lookup.
  * When we process a new IO request, we know its sector, thus can deduce the
  * region number (label) easily.  To do the label -> object lookup without a
  * full list walk, we use a simple hash table.
@@ -145,7 +145,7 @@ write intent log information, three of w
  * But it avoids high order page allocations in kmalloc.
  */
 struct lc_element {
-	struct hlist_node colision;
+	struct hlist_node collision;
 	struct list_head list;		 /* LRU list or free list */
 	unsigned refcnt;
 	/* back "pointer" into lc_cache->element[index],
--- a/lib/lru_cache.c~lib-lru_cache-fix-spelling-mistake-colision-collision
+++ a/lib/lru_cache.c
@@ -243,7 +243,7 @@ static struct lc_element *__lc_find(stru
 
 	BUG_ON(!lc);
 	BUG_ON(!lc->nr_elements);
-	hlist_for_each_entry(e, lc_hash_slot(lc, enr), colision) {
+	hlist_for_each_entry(e, lc_hash_slot(lc, enr), collision) {
 		/* "about to be changed" elements, pending transaction commit,
 		 * are hashed by their "new number". "Normal" elements have
 		 * lc_number == lc_new_number. */
@@ -303,7 +303,7 @@ void lc_del(struct lru_cache *lc, struct
 	BUG_ON(e->refcnt);
 
 	e->lc_number = e->lc_new_number = LC_FREE;
-	hlist_del_init(&e->colision);
+	hlist_del_init(&e->collision);
 	list_move(&e->list, &lc->free);
 	RETURN();
 }
@@ -324,9 +324,9 @@ static struct lc_element *lc_prepare_for
 	PARANOIA_LC_ELEMENT(lc, e);
 
 	e->lc_new_number = new_number;
-	if (!hlist_unhashed(&e->colision))
-		__hlist_del(&e->colision);
-	hlist_add_head(&e->colision, lc_hash_slot(lc, new_number));
+	if (!hlist_unhashed(&e->collision))
+		__hlist_del(&e->collision);
+	hlist_add_head(&e->collision, lc_hash_slot(lc, new_number));
 	list_move(&e->list, &lc->to_be_changed);
 
 	return e;
_

Patches currently in -mm which might be from deshan@nfschina.com are

lib-lru_cache-fix-spelling-mistake-colision-collision.patch

