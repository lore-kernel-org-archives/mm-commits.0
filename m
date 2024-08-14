Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193D81D47CD
	for <mm-commits@vger.kernel.org>; Wed, 14 Aug 2024 20:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723668022; cv=none; b=d1A9v3H3Ip2g2Ercg6mbhbSDRUkqpHluxNPd6KTBmXIQ+RnyUttzHlNDS8A1hexCWv+NSUJpL4k0vKUd2+NozHjVYIwd1bEpDtYOhycH2v6xF2iAKmZZt7ZL1uxtoA7zx0TQEeNylkrJScmRs8687Ar7yRNOlKt8LvKEpogSFBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723668022; c=relaxed/simple;
	bh=fxOuSz+aKVf79slvOFhlXb/WvgP0lkADh7Rq7hdRUME=;
	h=Date:To:From:Subject:Message-Id; b=IbialtNPeegtQbLkKScyKJWYis4tYhfinoU7HpaJHM8RjzkhjRosMBRb+btmhYzkQ/scpGS8x6podmVe4Woe7jJLZ8IIznyCCGS83j2vEYff47UUH2y5Z+ujy8ylTJXJ2EoxK3lQ9qPrTHEnzd/HluXEC7/gvceMYEEKAIyOh8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NHLpTE/0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NHLpTE/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16B2C4AF0D;
	Wed, 14 Aug 2024 20:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723668021;
	bh=fxOuSz+aKVf79slvOFhlXb/WvgP0lkADh7Rq7hdRUME=;
	h=Date:To:From:Subject:From;
	b=NHLpTE/0NFxCafuOtVvugkHinpc6yxnHC11I0kD28dP9JoY2blQBpf+F+llRXcAMj
	 kfXRaSALsRcr9RDAgtM+7ZEJo+mZTGWoZW9Qj6hYNRn/reaEBvkZuSJ4W+JipVpg7Y
	 /NqDySSyebxplEi6as5EILdYGCaw/N0jhHYUXUn0=
Date: Wed, 14 Aug 2024 13:40:21 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-introduce-store_type-enum.patch added to mm-unstable branch
Message-Id: <20240814204021.A16B2C4AF0D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: introduce store_type enum
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-introduce-store_type-enum.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-introduce-store_type-enum.patch

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
Subject: maple_tree: introduce store_type enum
Date: Wed, 14 Aug 2024 12:19:28 -0400

Patch series "Introduce a store type enum for the Maple tree", v4.

================================ OVERVIEW ================================

This series implements two work items[3]: "aligning mas_store_gfp() with
mas_preallocate()" and "enum for store type".

mas_store_gfp() is modified to preallocate nodes.  This simplies many of
the write helper functions by allowing them to use mas_store_gfp() rather
than open coding node allocation and error handling.

The enum defines the following store types:

enum store_type {
    wr_invalid,
    wr_new_root,
    wr_store_root,
    wr_exact_fit,
    wr_spanning_store,
    wr_split_store,
    wr_rebalance,
    wr_append,
    wr_node_store,
    wr_slot_store,
};

In the current maple tree code, a walk down the tree is done in
mas_preallocate() to determine the number of nodes needed for this write. 
After node allocation, mas_wr_store_entry() will perform another walk to
determine which write helper function to use to complete the write.

Rather than performing the second walk, we can store the type of write in
the maple write state during node allocation and read this field to
complete the write.

Patches 1-16 implement this store type feature.
Patch 17 is a cleanup patch to change functions that have unused return
types to be void.

================================ RESULTS =================================

Phoronix t-test-1 (Seconds < Lower Is Better)
    v6.10-rc6
        Threads: 1
            33.15

        Threads: 2
            10.81

    v6.10-rc6 + this series
            Threads: 1
            32.69

        Threads: 2
            10.45

Stress-ng mmap
                    6.10_base  store_type_v4
Duration User        2744.65     2769.40
Duration System     10862.69    10817.59
Duration Elapsed     1477.58     1478.35



================================ TESTING =================================

Testing was done with the maple tree test suite.  A new test case is also
added to validate the order in which we test for and assign the store
type.

[1]: https://lore.kernel.org/linux-mm/80926b22-a8d2-9992-eb5e-27e2c99cf460@google.com/T/#m81044feb66765265f8ca7f21e4b4b3725b18780a
[2]: https://lore.kernel.org/linux-mm/80926b22-a8d2-9992-eb5e-27e2c99cf460@google.com/T/#mb36c6526486638e82518c0f37a428fb279c84d8a
[3]: https://lists.infradead.org/pipermail/maple-tree/2023-December/003098.html


This patch (of 17):

Add a store_type enum that is stored in ma_state.  This will be used to
keep track of partial walks of the tree so that subsequent walks can pick
up where a previous walk left off.

Link: https://lkml.kernel.org/r/20240814161944.55347-1-sidhartha.kumar@oracle.com
Link: https://lkml.kernel.org/r/20240814161944.55347-2-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/include/linux/maple_tree.h~maple_tree-introduce-store_type-enum
+++ a/include/linux/maple_tree.h
@@ -148,6 +148,18 @@ enum maple_type {
 	maple_arange_64,
 };
 
+enum store_type {
+	wr_invalid,
+	wr_new_root,
+	wr_store_root,
+	wr_exact_fit,
+	wr_spanning_store,
+	wr_split_store,
+	wr_rebalance,
+	wr_append,
+	wr_node_store,
+	wr_slot_store,
+};
 
 /**
  * DOC: Maple tree flags
@@ -436,6 +448,7 @@ struct ma_state {
 	unsigned char offset;
 	unsigned char mas_flags;
 	unsigned char end;		/* The end of the node */
+	enum store_type store_type;	/* The type of store needed for this operation */
 };
 
 struct ma_wr_state {
@@ -477,6 +490,7 @@ struct ma_wr_state {
 		.max = ULONG_MAX,					\
 		.alloc = NULL,						\
 		.mas_flags = 0,						\
+		.store_type = wr_invalid,				\
 	}
 
 #define MA_WR_STATE(name, ma_state, wr_entry)				\
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

