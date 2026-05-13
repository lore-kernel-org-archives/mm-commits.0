Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90783EDE5D
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 02:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778638281; cv=none; b=txOHG5xT7LGpD7DKEdYdjkZ1kswshdbOOCDzxS9zb/CpR7vpZMkTr5L4RwEpF2+AdEgx3Z9GTK5oqSi+3ffqAExQfbJSO7L1kRAW2zcxNkn8MapZxDphKEuestFm1C3hUNQvgOGZbD4EHs/IDe4F9Xc8viPOuuXxa24ebP+bVzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778638281; c=relaxed/simple;
	bh=pupNZ6lCnw+8GiUoVHxWrPpJedciEP7GT4MujBvm9pQ=;
	h=Date:To:From:Subject:Message-Id; b=jlvF+gjyzlv1G2HbRzGvvbURViWdX0sST5k2JAUSxsuIs/HKcKUc3wNG2RtzPgxK5C8Lsd19HHi2e6vZmDwwwz4uIHDNzQKT2cPjNSGqYl7ZtVPWjRUSDLuckNLF4iLgMnxVN1l/tcKWt2t+hAynR3vZMH+ukaw/j2b9og/fgn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0n2QzK0q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0n2QzK0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E5BC2BCB0;
	Wed, 13 May 2026 02:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778638281;
	bh=pupNZ6lCnw+8GiUoVHxWrPpJedciEP7GT4MujBvm9pQ=;
	h=Date:To:From:Subject:From;
	b=0n2QzK0qX4AcT9Go5GdO7EsJE4KYiQloBsIVJR2dcf31lggwKrMVzJx61pWaH4qwB
	 XSaYTsqaA5XF1siRWUjo0QJfmgWY/lp+Uy67eg2rJmc9+b0w6Dypas04Xeie30sDXg
	 /kBA6VT1v5RVC4EruikE93V5lm6OXJGxgErqEpDY=
Date: Tue, 12 May 2026 19:11:20 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sj@kernel.org,liam@infradead.org,andrewjballance@gmail.com,aliceryhl@google.com,rostedt@goodmis.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-document-that-last-in-mtree_insert_range-is-inclusive.patch added to mm-new branch
Message-Id: <20260513021121.68E5BC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: document that "last" in mtree_insert_range() is inclusive
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-document-that-last-in-mtree_insert_range-is-inclusive.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-document-that-last-in-mtree_insert_range-is-inclusive.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
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

maple_tree-document-that-last-in-mtree_insert_range-is-inclusive.patch

