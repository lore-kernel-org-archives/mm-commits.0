Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148105381E
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247824; cv=none; b=rNWw7A17LMziIUT3cfNaUq1qt40hh7wi8PCnOId84wC9Ph0OEgmOok5vxbecVpU6kGDbTw1pktme+KfovzmVO8cWwkFpoPP4ZWWShyEg8YJz8aAbTABIkrO8zV9s6iJiliiQG3OSMyQAVXMuNZbT6rQR14z+gNAShKmeIUSz3uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247824; c=relaxed/simple;
	bh=VsBW4goYmLJLmyrPTeI9IcL1oJVolTnZmM/qolaZ0xo=;
	h=Date:To:From:Subject:Message-Id; b=jCx9IUznx2IagN+4MgxyQ2WOxvD5ifJ/E4W1FL61b1IwEuGzNPu9hFaKHo2/ftedOlR0V9mNrtYESLay+SISMia/Q2wkizyCzMNkZY5yhPkuL0PYEcIzoH5Du1KgEJ15a1Hkizu8zv8nokbTvoet7f1WNjNWlDryiuSS3IAjjRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T2+9I91b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T2+9I91b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A6AC4CEC2;
	Mon,  2 Sep 2024 03:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247824;
	bh=VsBW4goYmLJLmyrPTeI9IcL1oJVolTnZmM/qolaZ0xo=;
	h=Date:To:From:Subject:From;
	b=T2+9I91bS/BaL1w/y36Sfx3n/zsM8GJ1HNbrhHLLAplSkToMeqP8Din7yKMIowqgg
	 /BCmclGkwvDBYPXHguTTfN9CpjPulusqL0ryU9/PnZ370JZQVOGlC032GPNBRDCaI+
	 YTKsOOG6zrMi9fJ/kLzx5vAN6Xoh0hIxcnN/RPYY=
Date: Sun, 01 Sep 2024 20:30:23 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-introduce-store_type-enum.patch removed from -mm tree
Message-Id: <20240902033023.E1A6AC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: introduce store_type enum
has been removed from the -mm tree.  Its filename was
     maple_tree-introduce-store_type-enum.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


