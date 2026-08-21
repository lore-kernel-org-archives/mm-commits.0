Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426B13DAABA
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 22:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787350908; cv=none; b=H1v5pNAl11cQpiz/by7YW8Fh2UKXKGzp5yUz+4/JpXgKa0mRnE2hLTqysTgzKqJTS3yuGugs0UoSJQiJzrj2A/yh9BADbbzYSKARH6/TnxD7ffVjil4z1L050iVFMVboXvGRDnKPPyFZZKU72JySrqMO/8mT64YpJqrsUHmPBJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787350908; c=relaxed/simple;
	bh=rMxwyfuD03I968T2aVakcIjg/36KpAP+kWU9HCW/5zY=;
	h=Date:To:From:Subject:Message-Id; b=fTmcyM5b7bfr1SshAm+qOsN3ajQRZkJdNDPUnAAhaEeXJsF9JkNMcHGD9PNDPqhut8qxnQ1emqyLffGHvXIQWm07GWg/LizBqB02+22RJu1v3gz8dwDiA98GfehyUsNz/NPYoXWf/k5E2nwsxFrX3Kh+sqjBXemT9RFENN6voG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VnLp1PV+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VnLp1PV+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D402C1F000E9;
	Fri, 21 Aug 2026 22:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787350906;
	bh=oIK6mexcz4V3gij5m3ZUmf0dodyIxemYcCt5gHaOnP8=;
	h=Date:To:From:Subject;
	b=VnLp1PV+e53eIfzJuut+eJdm7oIV8os9PB8CstHI7p9l7dyxagXds5deaZ6HKDyvE
	 H7raPTklE9C95s4seMxwvKEbkSu+kSFVfc6Z3zlGOSWdrI/Dm/fFv9yHf5aX9pizWu
	 kyuwW68nI3Bt3VlcR8hKPXAuzhfrW3ylxlI5TPaM=
Date: Fri, 21 Aug 2026 15:21:46 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] maple_tree-clarify-comments-on-mas_nomem.patch removed from -mm tree
Message-Id: <20260821222146.D402C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: clarify comments on mas_nomem()
has been removed from the -mm tree.  Its filename was
     maple_tree-clarify-comments-on-mas_nomem.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: clarify comments on mas_nomem()
Date: Tue, 30 Jun 2026 15:08:31 -0400

When an allocation completely fails, the return is false.  If the
allocation succeeds or partially succeeds, return true to indicate a retry
of the operation.  Note that since the lock may have been dropped, the
operation is retried from the start - including potentially allocating
more memory.

Link: https://lore.kernel.org/20260630190843.3563858-8-liam@infradead.org
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-clarify-comments-on-mas_nomem
+++ a/lib/maple_tree.c
@@ -5677,10 +5677,11 @@ EXPORT_SYMBOL_GPL(mas_erase);
 
 /**
  * mas_nomem() - Check if there was an error allocating and do the allocation
- * if necessary If there are allocations, then free them.
+ * if necessary.
+ *
  * @mas: The maple state
  * @gfp: The GFP_FLAGS to use for allocations
- * Return: true on allocation, false otherwise.
+ * Return: False on no memory.  True otherwise (partial success as well)
  */
 bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 	__must_hold(mas->tree->ma_lock)
@@ -5696,6 +5697,10 @@ bool mas_nomem(struct ma_state *mas, gfp
 		mas_alloc_nodes(mas, gfp);
 	}
 
+	/*
+	 * Return false on zero forward progress.  Partial allocations are kept
+	 * so the retry path will attempt to get the rest.
+	 */
 	if (!mas->sheaf && !mas->alloc)
 		return false;
 
_

Patches currently in -mm which might be from liam@infradead.org are

maple_tree-use-prefetched-value-in-mas_wr_store_type.patch
maple_tree-optimise-mas_wr_node_store-when-not-in-rcu-mode.patch
maple_tree-micro-optimisation-of-mas_wr_store_type.patch
maple_tree-add-bulk-parent-set-helper.patch
maple_tree-catch-race-in-mas_alloc_cyclic.patch
maple_tree-document-that-erase-may-use-gfp_kernel-for-allocations.patch
maple_tree-warn_on_once-when-allocations-fail.patch
maple_tree-document-erase-and-allocations-better.patch
maple_tree-change-two-gfp-flags-in-tests.patch
maple_tree-fix-argument-name-in-header.patch
maple_tree-avoid-extra-gap-calculation.patch
maple_tree-add-helper-mas_make_walkable.patch

