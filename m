Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4355F3B961E
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439035; cv=none; b=RG+RNM5Zr6pL6J1fx+8jvbuYZtTtTMyRE+PyeGyIeS2s9VMcWEqyFI7dv6VnGFq9cXr3+cAUP5R34M2nxXi1DYwLldJfM9HsogwVdr4OQPKdgK1Xm8YVHmdwfCHtNDEMd5H8J421JVRCR0nv4PD9WwEfmcH0CFw4Vw0vJSEJNts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439035; c=relaxed/simple;
	bh=2ILLmbfk294QzHJl7MnuyIdQZFluvmNvUYfe0dL5sdQ=;
	h=Date:To:From:Subject:Message-Id; b=lwrmzCikKRO8ltfb7nqig+Y8Nlwiljq9OJai74vwnb3nlyvgycHrmevqD7wn/AHgVQvJ9pNT0Pzcpa8pA3lo3yHIj+uEgylNpnn/r6Z0/Qat6jpMmXx1oP6GF2P4b9JbvmToUT09cZ6mIWWCC4YqXXk5j2AybUuJomCFxDIbzcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aY1HsDt3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aY1HsDt3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E311F00893;
	Tue,  2 Jun 2026 22:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439034;
	bh=8hq5z7uCdXPgnfOGidylSVaSuSLPEv3QZUSL20OV1io=;
	h=Date:To:From:Subject;
	b=aY1HsDt3PS31K5uL3tmTvkEGkmzroPat2AYSdT8iPWPVOcC+AYwMTGXzm02zRvJaR
	 Ft3Kbwkq/hldu/GepAS4V9SRkZWNjjsXCF0sdXspi3wTUnRYEykFlOnoF9UhuRQftV
	 GBVb8NpPBRrjQmptQ9Gp2w42lkV6fzA1mv2ZCTK4=
Date: Tue, 02 Jun 2026 15:23:53 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sj@kernel.org,liam@infradead.org,andrewjballance@gmail.com,aliceryhl@google.com,rostedt@goodmis.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-document-that-last-in-mtree_insert_range-is-inclusive.patch removed from -mm tree
Message-Id: <20260602222354.17E311F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: document that "last" in mtree_insert_range() is inclusive
has been removed from the -mm tree.  Its filename was
     maple_tree-document-that-last-in-mtree_insert_range-is-inclusive.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Steven Rostedt <rostedt@goodmis.org>
Subject: maple_tree: document that "last" in mtree_insert_range() is inclusive
Date: Tue, 12 May 2026 17:56:23 -0400

The kernel doc of mtree_insert_range() does not state if the address
represented by the "last" parameter is inclusive or exclusive.  This can
lead to bugs by code that assumes it is exclusive.  Explicitly state that
the parameter is inclusive.

Link: https://lore.kernel.org/20260512175623.4c5ca8d2@gandalf.local.home
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: "Liam R. Howlett" <liam@infradead.org>
Acked-by: SeongJae Park <sj@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-document-that-last-in-mtree_insert_range-is-inclusive
+++ a/lib/maple_tree.c
@@ -5727,13 +5727,16 @@ int mtree_store(struct maple_tree *mt, u
 EXPORT_SYMBOL(mtree_store);
 
 /**
- * mtree_insert_range() - Insert an entry at a given range if there is no value.
+ * mtree_insert_range() - Insert an entry from [first, last] at a given range
+ *                        if there is no value.
  * @mt: The maple tree
  * @first: The start of the range
- * @last: The end of the range
+ * @last: The end of the range (inclusive)
  * @entry: The entry to store
  * @gfp: The GFP_FLAGS to use for allocations.
  *
+ * Note that @last is inclusive. That is, @last = @first + length - 1;
+ *
  * Return: 0 on success, -EEXISTS if the range is occupied, -EINVAL on invalid
  * request, -ENOMEM if memory could not be allocated.
  */
_

Patches currently in -mm which might be from rostedt@goodmis.org are


