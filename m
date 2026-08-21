Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6985361977
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 22:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787350917; cv=none; b=slNwfbtizUxb5TyGzF1kh/ObIArG6LyvS1qrBDQDvGiksV16dhLkIRHFNHQhdo1tA4weO9lQ157FffESD2K32zs33IPh5IbbRSeOYedDPl/P7xn7We5twhOjujRoCjOkjSRAGwSEopC7+tu5S/tJ37NFOyhIOENL5scjBVsXqZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787350917; c=relaxed/simple;
	bh=aN+sexkNueB0eNeVJkkIS4a8RlLU+1Cic4ODSBhWJR4=;
	h=Date:To:From:Subject:Message-Id; b=EUPFRFAmQckCoBUJRaIIJM8vN1mgItWx0gAEpPfBvFxfIN3AdoTQqbfbot1FS08+GPg274+RvTQcRabGThLtK0m2dmPTD+2+6EFhxxs2f0+SSv3sOxoyqOE7cZeuUgzP2Vm8AJvtgb//izUWLJeF0HiCxogmgZ1UD5NjAaA1UiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wT+jwPpM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wT+jwPpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6EB1F00A3A;
	Fri, 21 Aug 2026 22:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787350915;
	bh=O0XfRx/1bycT3PYI20bO2PXAdcoYCGH/CRu30QSq1lo=;
	h=Date:To:From:Subject;
	b=wT+jwPpMLXvGeJ7Kki1+7y5mLlm23mviq3velrwwmbrsaIZ3ga1nxuwFHf7yqaU6K
	 zLDWAQMhy8BOOQEcV8k2Qm33yfyB8biMEszt/1kq6Y5gblZJEiC5y6BIdS5b4YFzNw
	 RQDrRhDGRe5RA+5VmSGtEd658xoDFAVS7OocwADs=
Date: Fri, 21 Aug 2026 15:21:55 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] maple_tree-warn_on_once-when-allocations-fail.patch removed from -mm tree
Message-Id: <20260821222155.8E6EB1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: WARN_ON_ONCE when allocations fail
has been removed from the -mm tree.  Its filename was
     maple_tree-warn_on_once-when-allocations-fail.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: WARN_ON_ONCE when allocations fail
Date: Tue, 30 Jun 2026 15:08:38 -0400

Allocations should never fail in the circumstances that are expected to
occur.  Add checks in the code to ensure the circumstances are correctly
set up by the user and warn if they are not.

Also add a warning on failure to allocate, which should never happen.

Link: https://lore.kernel.org/20260630190843.3563858-15-liam@infradead.org
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-warn_on_once-when-allocations-fail
+++ a/lib/maple_tree.c
@@ -5721,6 +5721,10 @@ bool mas_nomem(struct ma_state *mas, gfp
 	if (likely(mas->node != MA_ERROR(-ENOMEM)))
 		return false;
 
+	/* Allocations can fail, don't do this. */
+	WARN_ON_ONCE(!gfpflags_allow_blocking(gfp) &&
+		     mt_external_lock(mas->tree));
+
 	if (gfpflags_allow_blocking(gfp) && !mt_external_lock(mas->tree)) {
 		mtree_unlock(mas->tree);
 		mas_alloc_nodes(mas, gfp);
@@ -5731,9 +5735,12 @@ bool mas_nomem(struct ma_state *mas, gfp
 
 	/*
 	 * Return false on zero forward progress.  Partial allocations are kept
-	 * so the retry path will attempt to get the rest.
+	 * so the retry path will attempt to get the rest.  The failure should
+	 * not happen as we try our best to reclaim.  The user would need an
+	 * external lock with a non-blocking gfp in a low memory situation -
+	 * which would have triggered the first warning in this function.
 	 */
-	if (!mas->sheaf && !mas->alloc)
+	if (WARN_ON_ONCE(!mas->sheaf && !mas->alloc))
 		return false;
 
 	mas_reset(mas);
_

Patches currently in -mm which might be from liam@infradead.org are

maple_tree-document-erase-and-allocations-better.patch
maple_tree-change-two-gfp-flags-in-tests.patch
maple_tree-fix-argument-name-in-header.patch
maple_tree-avoid-extra-gap-calculation.patch
maple_tree-add-helper-mas_make_walkable.patch

