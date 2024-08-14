Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02ABC1C8FB1
	for <mm-commits@vger.kernel.org>; Wed, 14 Aug 2024 20:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723668025; cv=none; b=Pv5P2nz/oBzIRQESx3IEjrSoKogqTA/Zm9c3c0H/VDkl0MujvbWutLp2Q6Qq+IIIhc50Y38fiMQLP9T+yTB0Rx30TOXWUju0G1fogeIWC7Z76gpWABhESzoke3nFObcNbiOlAqrj+YuTbwmb+TAr7+KPviVooADCEV1mNnhjUdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723668025; c=relaxed/simple;
	bh=8zGD7TRoNBE2PXbJ9fWrB0jJom5IWa1XovBWYnt6Wzk=;
	h=Date:To:From:Subject:Message-Id; b=XE9X/+ldu1HY86I0UZ/UmSx11c3OcZY2rdRsqaI54EN3IbWCIoQO6JLw8UukRG3/kFoe1+OAqQhUwryOOXFfOqJcRjQDTe/JoGEuRQm6DBYse+CAO3JgDNVWI3xqguOy4ep2AATvVNQdPmQDTlNAvomthqkDzo8d7nzeiM4bclM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yz05H0iS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yz05H0iS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3CCC116B1;
	Wed, 14 Aug 2024 20:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723668024;
	bh=8zGD7TRoNBE2PXbJ9fWrB0jJom5IWa1XovBWYnt6Wzk=;
	h=Date:To:From:Subject:From;
	b=Yz05H0iS2wbcVoXkvc8MuJ7Crc1PPJbzQVIyz+Qgsk4y/jWCua6NDaUFf2APs4j5h
	 SuzYf8/x4BHrr3qN8D4Fn1zUIginYCUPSBhOMaOfaJrXFXM7VGQcupr8GRJgnR6oKF
	 0onlRp2MP9rZ25GCx3DTsPdE4BnJF4B78RrsakNY=
Date: Wed, 14 Aug 2024 13:40:23 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-move-up-mas_wr_store_setup-and-mas_wr_prealloc_setup.patch added to mm-unstable branch
Message-Id: <20240814204024.6D3CCC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: move up mas_wr_store_setup() and mas_wr_prealloc_setup()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-move-up-mas_wr_store_setup-and-mas_wr_prealloc_setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-move-up-mas_wr_store_setup-and-mas_wr_prealloc_setup.patch

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
Subject: maple_tree: move up mas_wr_store_setup() and mas_wr_prealloc_setup()
Date: Wed, 14 Aug 2024 12:19:30 -0400

Subsequent patches require these definitions to be higher, no functional
changes intended.

Link: https://lkml.kernel.org/r/20240814161944.55347-4-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   96 ++++++++++++++++++++++-----------------------
 1 file changed, 48 insertions(+), 48 deletions(-)

--- a/lib/maple_tree.c~maple_tree-move-up-mas_wr_store_setup-and-mas_wr_prealloc_setup
+++ a/lib/maple_tree.c
@@ -4227,6 +4227,54 @@ static inline void mas_wr_store_entry(st
 		mas_wr_modify(wr_mas);
 }
 
+static void mas_wr_store_setup(struct ma_wr_state *wr_mas)
+{
+	if (!mas_is_active(wr_mas->mas)) {
+		if (mas_is_start(wr_mas->mas))
+			return;
+
+		if (unlikely(mas_is_paused(wr_mas->mas)))
+			goto reset;
+
+		if (unlikely(mas_is_none(wr_mas->mas)))
+			goto reset;
+
+		if (unlikely(mas_is_overflow(wr_mas->mas)))
+			goto reset;
+
+		if (unlikely(mas_is_underflow(wr_mas->mas)))
+			goto reset;
+	}
+
+	/*
+	 * A less strict version of mas_is_span_wr() where we allow spanning
+	 * writes within this node.  This is to stop partial walks in
+	 * mas_prealloc() from being reset.
+	 */
+	if (wr_mas->mas->last > wr_mas->mas->max)
+		goto reset;
+
+	if (wr_mas->entry)
+		return;
+
+	if (mte_is_leaf(wr_mas->mas->node) &&
+	    wr_mas->mas->last == wr_mas->mas->max)
+		goto reset;
+
+	return;
+
+reset:
+	mas_reset(wr_mas->mas);
+}
+
+static inline void mas_wr_prealloc_setup(struct ma_wr_state *wr_mas)
+{
+	struct ma_state *mas = wr_mas->mas;
+
+	mas_wr_store_setup(wr_mas);
+	wr_mas->content = mas_start(mas);
+}
+
 /**
  * mas_insert() - Internal call to insert a value
  * @mas: The maple state
@@ -5358,54 +5406,6 @@ static inline void mte_destroy_walk(stru
 		mt_destroy_walk(enode, mt, true);
 	}
 }
-
-static void mas_wr_store_setup(struct ma_wr_state *wr_mas)
-{
-	if (!mas_is_active(wr_mas->mas)) {
-		if (mas_is_start(wr_mas->mas))
-			return;
-
-		if (unlikely(mas_is_paused(wr_mas->mas)))
-			goto reset;
-
-		if (unlikely(mas_is_none(wr_mas->mas)))
-			goto reset;
-
-		if (unlikely(mas_is_overflow(wr_mas->mas)))
-			goto reset;
-
-		if (unlikely(mas_is_underflow(wr_mas->mas)))
-			goto reset;
-	}
-
-	/*
-	 * A less strict version of mas_is_span_wr() where we allow spanning
-	 * writes within this node.  This is to stop partial walks in
-	 * mas_prealloc() from being reset.
-	 */
-	if (wr_mas->mas->last > wr_mas->mas->max)
-		goto reset;
-
-	if (wr_mas->entry)
-		return;
-
-	if (mte_is_leaf(wr_mas->mas->node) &&
-	    wr_mas->mas->last == wr_mas->mas->max)
-		goto reset;
-
-	return;
-
-reset:
-	mas_reset(wr_mas->mas);
-}
-
-static inline void mas_wr_prealloc_setup(struct ma_wr_state *wr_mas)
-{
-	struct ma_state *mas = wr_mas->mas;
-
-	mas_wr_store_setup(wr_mas);
-	wr_mas->content = mas_start(mas);
-}
 /* Interface */
 
 /**
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

