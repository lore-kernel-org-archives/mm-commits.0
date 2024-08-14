Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0492A1D6DCE
	for <mm-commits@vger.kernel.org>; Wed, 14 Aug 2024 20:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723668041; cv=none; b=PJOVAWFaKk6fFdKKC7A7cSH5eWRvEbTx/rdOiHX7TGHc5NMAnwrcKxYHnjpUAp0f8gLpmYKk+UxGLErw3Fdei61M2TZnujWkrY/rmMhwnJsCfuZnG52EVqKQNC1BhrdTn15tKwaX7pec+bGZMWBriewui5HohH8idGDUug4jGVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723668041; c=relaxed/simple;
	bh=by3pUell7JOjpsk7BWU1XLmb4lo7DuaaMqdveM5eZ1I=;
	h=Date:To:From:Subject:Message-Id; b=R45+r0AoA5voE6BDZrJYYCB/wtjw6jgtxYhm0/qWoxoG0a8/WSSFxBTQpDMvbrjScB0hNxUO6K5QJ5s8MB7NHDF2pFNkLeazTq2n3qa6Bl9SxG5yncXFYtT40aSTiil99z4vXGYojSP6rd3DknkNlP4NAqHAVgUqqGZNxOwz6ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AB2DywZL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AB2DywZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD441C116B1;
	Wed, 14 Aug 2024 20:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723668040;
	bh=by3pUell7JOjpsk7BWU1XLmb4lo7DuaaMqdveM5eZ1I=;
	h=Date:To:From:Subject:From;
	b=AB2DywZLRiyHOBP0NRLCzhj5jSMZLa8h71B3IEavJU+nNQYZ/M5f6bEOETF7M0e9v
	 JT2o7J/xahg1HTy7cW3AqX72qJK1/OPgiNxcGrRuGTi13dc8LwHnb4rniH9od+MA2N
	 9VMxyB+7pxHDUMyQjfhIZFbyQl6Gtylu3198y3xg=
Date: Wed, 14 Aug 2024 13:40:40 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-remove-repeated-sanity-checks-from-write-helper-functions.patch added to mm-unstable branch
Message-Id: <20240814204040.BD441C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: remove repeated sanity checks from write helper functions
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-remove-repeated-sanity-checks-from-write-helper-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-remove-repeated-sanity-checks-from-write-helper-functions.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: remove repeated sanity checks from write helper functions
Date: Wed, 14 Aug 2024 12:19:42 -0400

These sanity checks are now redundant as they are already checked in
mas_wr_store_type(). We can remove them from mas_wr_append() and
mas_wr_node_store().

Link: https://lkml.kernel.org/r/20240814161944.55347-16-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-repeated-sanity-checks-from-write-helper-functions
+++ a/lib/maple_tree.c
@@ -3816,11 +3816,6 @@ static inline bool mas_wr_node_store(str
 	unsigned char copy_size, node_pivots = mt_pivots[wr_mas->type];
 	bool in_rcu = mt_in_rcu(mas->tree);
 
-	/* Check if there is enough data. The room is enough. */
-	if (!mte_is_root(mas->node) && (new_end < mt_min_slots[wr_mas->type]) &&
-	    !(mas->mas_flags & MA_STATE_BULK))
-		return false;
-
 	if (mas->last == wr_mas->end_piv)
 		offset_end++; /* don't copy this offset */
 	else if (unlikely(wr_mas->r_max == ULONG_MAX))
@@ -4018,17 +4013,9 @@ static inline unsigned char mas_wr_new_e
 static inline bool mas_wr_append(struct ma_wr_state *wr_mas,
 		unsigned char new_end)
 {
-	struct ma_state *mas;
+	struct ma_state *mas = wr_mas->mas;
 	void __rcu **slots;
-	unsigned char end;
-
-	mas = wr_mas->mas;
-	if (mt_in_rcu(mas->tree))
-		return false;
-
-	end = mas->end;
-	if (mas->offset != end)
-		return false;
+	unsigned char end = mas->end;
 
 	if (new_end < mt_pivots[wr_mas->type]) {
 		wr_mas->pivots[new_end] = wr_mas->pivots[end];
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

maple_tree-reset-mas-index-and-mas-last-on-write-retries.patch
maple_tree-add-test-to-replicate-low-memory-race-conditions.patch
maple_tree-introduce-store_type-enum.patch
maple_tree-introduce-mas_wr_prealloc_setup.patch
maple_tree-move-up-mas_wr_store_setup-and-mas_wr_prealloc_setup.patch
maple_tree-introduce-mas_wr_store_type.patch
maple_tree-remove-mas_destroy-from-mas_nomem.patch
maple_tree-preallocate-nodes-in-mas_erase.patch
maple_tree-use-mas_store_gfp-in-mtree_store_range.patch
maple_tree-print-store-type-in-mas_dump.patch
maple_tree-use-store-type-in-mas_wr_store_entry.patch
maple_tree-convert-mas_insert-to-preallocate-nodes.patch
maple_tree-simplify-mas_commit_b_node.patch
maple_tree-remove-mas_wr_modify.patch
maple_tree-have-mas_store-allocate-nodes-if-needed.patch
maple_tree-remove-node-allocations-from-various-write-helper-functions.patch
maple_tree-remove-repeated-sanity-checks-from-write-helper-functions.patch
maple_tree-remove-unneeded-mas_wr_walk-in-mas_store_prealloc.patch
maple_tree-make-write-helper-functions-void.patch

