Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D318438F84
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706596806; cv=none; b=kcs6T7yg2zM1RmBvcHfajX0Dg0MnBDXk/WG+zieTIbHTE2swt1+82YVmK0T7dTRb7+GEr91m7u70CLy4SflVYARkCYs/pkMAEFDL9LPErpZyL4dyYQieg+N7v0Uu7PzEe5E4b1uoonIKbTpEJERmcxwmiakO0rLwrKW5kI+eexE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706596806; c=relaxed/simple;
	bh=lbpNq1qLgRD8DHa11etBp/3IHrmiEk28aZFEOYNL0nE=;
	h=Date:To:From:Subject:Message-Id; b=YUJCKwINg6x2E1XlOT9hI74tdrMSTo4bL57MxhQv0Qm4GmnrTdqOTLBHadcpVIKsvo8B1lgx0lcqBwO6Xuw7XQX8J6heYJT/9jU4nCtmzM5AT2ZbJn9H0yLy3I6GN62essZ49xaj4rc41CcwEbk5ObhsqsC2M3MxLQ1McdMU8YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ro7hrSUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ro7hrSUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228ACC433F1;
	Tue, 30 Jan 2024 06:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706596806;
	bh=lbpNq1qLgRD8DHa11etBp/3IHrmiEk28aZFEOYNL0nE=;
	h=Date:To:From:Subject:From;
	b=ro7hrSUbftt7++90jLAWGfYobGEE19JtfCnXFR3+AI1plhiNTmXYiytS8bWGREvuX
	 JArU7NUr64l6d/NA1wLJa78JswgBxNMsOfJ18dej7YKbpG4ywdY44mH+iSZb9azBR9
	 DC36lNisnl03O6kp7cuGRnnqbgYVKTmdT26g6Ib0=
Date: Mon, 29 Jan 2024 22:39:52 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-inline-and-remove-zswap_entry_find_get.patch added to mm-unstable branch
Message-Id: <20240130064005.228ACC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: inline and remove zswap_entry_find_get()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-inline-and-remove-zswap_entry_find_get.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-inline-and-remove-zswap_entry_find_get.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: inline and remove zswap_entry_find_get()
Date: Mon, 29 Jan 2024 20:36:38 -0500

There is only one caller and the function is trivial. Inline it.

Link: https://lkml.kernel.org/r/20240130014208.565554-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

--- a/mm/zswap.c~mm-zswap-inline-and-remove-zswap_entry_find_get
+++ a/mm/zswap.c
@@ -559,19 +559,6 @@ static void zswap_entry_put(struct zswap
 	}
 }
 
-/* caller must hold the tree lock */
-static struct zswap_entry *zswap_entry_find_get(struct rb_root *root,
-				pgoff_t offset)
-{
-	struct zswap_entry *entry;
-
-	entry = zswap_rb_search(root, offset);
-	if (entry)
-		zswap_entry_get(entry);
-
-	return entry;
-}
-
 /*********************************
 * shrinker functions
 **********************************/
@@ -1708,13 +1695,13 @@ bool zswap_load(struct folio *folio)
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 
-	/* find */
 	spin_lock(&tree->lock);
-	entry = zswap_entry_find_get(&tree->rbroot, offset);
+	entry = zswap_rb_search(&tree->rbroot, offset);
 	if (!entry) {
 		spin_unlock(&tree->lock);
 		return false;
 	}
+	zswap_entry_get(entry);
 	spin_unlock(&tree->lock);
 
 	if (entry->length)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-zswap-fix-objcg-use-after-free-in-entry-destruction.patch
mm-zswap-rename-zswap_free_entry-to-zswap_entry_free.patch
mm-zswap-inline-and-remove-zswap_entry_find_get.patch
mm-zswap-move-zswap_invalidate_entry-to-related-functions.patch
mm-zswap-warn-when-referencing-a-dead-entry.patch
mm-zswap-clean-up-zswap_entry_put.patch
mm-zswap-rename-__zswap_load-to-zswap_decompress.patch
mm-zswap-break-out-zwap_compress.patch
mm-zswap-further-cleanup-zswap_store.patch
mm-zswap-simplify-zswap_invalidate.patch
mm-zswap-function-ordering-pool-alloc-free.patch
mm-zswap-function-ordering-pool-refcounting.patch
mm-zswap-function-ordering-zswap_pools.patch
mm-zswap-function-ordering-pool-params.patch
mm-zswap-function-ordering-public-lru-api.patch
mm-zswap-function-ordering-move-entry-sections-out-of-lru-section.patch
mm-zswap-function-ordering-move-entry-section-out-of-tree-section.patch
mm-zswap-function-ordering-compress-decompress-functions.patch
mm-zswap-function-ordering-per-cpu-compression-infra.patch
mm-zswap-function-ordering-writeback.patch
mm-zswap-function-ordering-shrink_memcg_cb.patch

