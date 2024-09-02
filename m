Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790B0152E02
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248793; cv=none; b=dfPqyXdWAGypAF4yinb/eobWsZbQ+JUFnVSxrVth8EUrSxsGVvtQ/BudZf49cRb8ExBL+S5EQc2fCqIq1ozEBU5oBzS+nsDQQ+wu0fTeQOq2ow2tFUxAARCSznrHqxsCb5IF/vtG+Phx5W2kPwaPPiVRhfNqLpFt2v2+XGj3Po4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248793; c=relaxed/simple;
	bh=uVHc7WQ5g6BZDE95VkRH2aA/ho4lPaoAr2WaP+iSUQU=;
	h=Date:To:From:Subject:Message-Id; b=erNfJEeXTa12NLCm+vdfpk0iDVlxtFs5Klc6pWA5n8NinZk4BMICq1E+LBtPdkB4G0THgKEtUAXYAH0GvwD8wiIeq1WYSNUkmDsHwRIsHY7R+02IORae3l0C96pRlusrCrfIPshiGlx0oA/Y8XPbfMzAgHXoLPUYASYn3LdijcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oNEB5c5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oNEB5c5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FB0C4CEC2;
	Mon,  2 Sep 2024 03:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248791;
	bh=uVHc7WQ5g6BZDE95VkRH2aA/ho4lPaoAr2WaP+iSUQU=;
	h=Date:To:From:Subject:From;
	b=oNEB5c5iCb6vi+rd9IgF98i50p34msr4+v6bR2QIhjtBeggkoXtIbf4QvLrxTzXW+
	 d/yhkWFQlR4uqgzGGYXiGjMPEghj1KbdkIJ3e7KRcKbOMQyPTwu0lKPGtl6uy1Mw/3
	 mTCZ+FUBBobktE1KlKRmaPZxdzLc8TvNwTjnX8EE=
Date: Sun, 01 Sep 2024 20:46:30 -0700
To: mm-commits@vger.kernel.org,philipp.reisner@linbit.com,lars.ellenberg@linbit.com,christoph.boehmwalder@linbit.com,deshan@nfschina.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-lru_cache-fix-spelling-mistake-colision-collision.patch removed from -mm tree
Message-Id: <20240902034630.E4FB0C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/lru_cache: fix spelling mistake "colision"->"collision"
has been removed from the -mm tree.  Its filename was
     lib-lru_cache-fix-spelling-mistake-colision-collision.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


