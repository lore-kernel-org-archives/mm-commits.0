Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D42317145
	for <mm-commits@vger.kernel.org>; Mon, 24 Aug 2026 20:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787602819; cv=none; b=LWqCHmZjrT4ANae7Q2kfqKWmFwKtLtyoIAUUucXKvP3/acUrVLoiDu5tCHyUyNltnYGTLGdgO8oaX3g4o7/aLJsgBlrqssJ4w21Sfpd3K/TyOS9F3DVT9b80QhKzBEzxM8hi4AYKDydXtKKSM9ktq9Rc4i1mEhrF046VUJXsdts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787602819; c=relaxed/simple;
	bh=GNufW2XQbjYU5ZHzPTOiNNYg7WBN+02kPY45raXj3tE=;
	h=Date:To:From:Subject:Message-Id; b=FwXTtGavQ3VzmhX8sm7DtfMzvKktflqd92TzC0FBQZG4YC1wTP7EfPO6ZTjeMTWOEOOKt37lh2pDIt2VHcf0RIy2Ki/foFNdYjYnvldrYPu6MTPp+5mlfwqJ03OGagA1ULVNy7e8/fxmRYOftSEOZTByki1HzSWtoh4Xa0Chrvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ohsmlIVO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ohsmlIVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547251F000E9;
	Mon, 24 Aug 2026 20:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787602818;
	bh=uVr4qYiZeSqOaFcd2gCzOGhgaorm/vXHCapyw3mrnnA=;
	h=Date:To:From:Subject;
	b=ohsmlIVOBDwQ87EeX4ftQmWiaALb35mRKBzFUEg+O0/Yp5sNLbMxIDq00HCPQMO2I
	 FIqQdOlSV6UMuGhjNeAVvMvNpMdEMzn/jR1raKEd7lSiUYuxpNutq7HwAp4dEYbTuO
	 R45YHpcDwZt3dkQ/fDWTFDvtbhR2pQ20tEyCqFLU=
Date: Mon, 24 Aug 2026 13:20:17 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,liam@infradead.org,leitao@debian.org,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] maple_tree-document-erase-and-allocations-better-fix.patch removed from -mm tree
Message-Id: <20260824202018.547251F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree-document-erase-and-allocations-better-fix
has been removed from the -mm tree.  Its filename was
     maple_tree-document-erase-and-allocations-better-fix.patch

This patch was dropped because it was folded into maple_tree-document-erase-and-allocations-better.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: maple_tree-document-erase-and-allocations-better-fix
Date: Fri Aug 21 03:27:57 PM PDT 2026

tweak mtree_erase() description, per Jason

Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/maple_tree.rst |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/Documentation/core-api/maple_tree.rst~maple_tree-document-erase-and-allocations-better-fix
+++ a/Documentation/core-api/maple_tree.rst
@@ -75,7 +75,8 @@ given index.  You can use mtree_erase()
 knowing one value within that range, or mtree_store() call with an entry of
 NULL may be used to partially erase a range or many ranges at once.  Note that
 mtree_erase() may use GFP_KERNEL | __GFP_NOFAIL for allocations and cannot
-fail, but may need to sleep - do not use mtree_erase() from a blocking context.
+fail.  mtree_erase() can sleep, so it must not be called from an atomic
+context.
 
 If you want to only store a new entry to a range (or index) if that range is
 currently ``NULL``, you can use mtree_insert_range() or mtree_insert() which
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch
maple_tree-document-erase-and-allocations-better.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

