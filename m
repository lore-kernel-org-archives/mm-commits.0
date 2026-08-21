Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A583B7753
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 22:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787352263; cv=none; b=LmYI8q9Yrlxt34aOqFcGQTC1myguq7bg5TajzzsJjRBNFFSULcNK+BTZELTRkClBchmDoCkbkn/xX9V8LoScqj5wGwgoCxXTIpj9zn/2yfn5RVWuL+gucrlP7gRmJHEv6DM6oaRdrwCD2KCM/ffvJTC03bCE+glWgQaVcG2xeb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787352263; c=relaxed/simple;
	bh=42ZKCspLKjxCoPIdXs7dhvEXt67nTWPqAJJdW1LcFhg=;
	h=Date:To:From:Subject:Message-Id; b=Osdzg8VNeHOlEawW8fup1e0ZnN8SWk21e2IC17qKzUnzPKLxPVVnG4Wp3+mTCldiP11Ivvq2yEAvUzhi7UY4JBjCiALfpWhVc8snUdGcE9K9QjpY1G8jwIRwcCwsLhNI6K/npFzA6mqalpHr3k14I5F2iMKy8eCnzfO2+7jw7Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uQrqKC6l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uQrqKC6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6537C1F000E9;
	Fri, 21 Aug 2026 22:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787352261;
	bh=InisavcDBiVJwek98QIDA7I7+iYK9nHiKkntKpdGw4I=;
	h=Date:To:From:Subject;
	b=uQrqKC6lT35kx7Zou1xZzpJ0OXJ2Qk1FCYgcxi7vNl7QZkmczVgtKyI5+uoRu5onK
	 94q44uHBZqSNVjsNR+5iH0J1JD/maMUB4YtW+woCk1SqwE0hMgqfp+RYPf64SrCI+Y
	 LGAjUGTA2o08oI/9c+UrHdWitcyL4TQTzSW010EY=
Date: Fri, 21 Aug 2026 15:44:20 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-helper-mas_make_walkable.patch added to mm-unstable branch
Message-Id: <20260821224421.6537C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: add helper mas_make_walkable()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-add-helper-mas_make_walkable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-helper-mas_make_walkable.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: add helper mas_make_walkable()
Date: Fri, 21 Aug 2026 15:26:27 -0400

A check in mas_walk() was incorrect and caused inefficient use of the
maple state.  The same issue existed in mas_erase(), but was left unfixed.
Making a helper function is the obvious answer.

Link: https://lore.kernel.org/20260821192627.4085470-20-liam@infradead.org
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
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

 lib/maple_tree.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/lib/maple_tree.c~maple_tree-add-helper-mas_make_walkable
+++ a/lib/maple_tree.c
@@ -261,6 +261,12 @@ static inline bool mas_is_underflow(stru
 	return mas->status == ma_underflow;
 }
 
+static inline void mas_make_walkable(struct ma_state *mas)
+{
+	if (!mas_is_active(mas) && !mas_is_start(mas))
+		mas->status = ma_start;
+}
+
 static __always_inline struct maple_node *mte_to_node(
 		const struct maple_enode *entry)
 {
@@ -4447,8 +4453,7 @@ void *mas_walk(struct ma_state *mas)
 	void *entry;
 
 	mas_may_init_lock_check(mas);
-	if (!mas_is_active(mas) && !mas_is_start(mas))
-		mas->status = ma_start;
+	mas_make_walkable(mas);
 retry:
 	entry = mas_state_walk(mas);
 	if (mas_is_start(mas)) {
@@ -5685,9 +5690,7 @@ void *mas_erase(struct ma_state *mas)
 	if (mt_external_lock(mas->tree))
 		might_alloc(GFP_KERNEL);
 
-	if (!mas_is_active(mas) || !mas_is_start(mas))
-		mas->status = ma_start;
-
+	mas_make_walkable(mas);
 write_retry:
 	entry = mas_state_walk(mas);
 	if (!entry)
_

Patches currently in -mm which might be from liam@infradead.org are

maple_tree-add-rcu-locking-check-when-lockdep-is-enabled.patch
locking-lockdep-add-sequence-counter-to-held_lock.patch
maple_tree-add-write-lock-checking-with-lockdep-sequence-numbers.patch
maple_tree-documentation-fix.patch
maple_tree-drop-dead-code-from-mas_extend_spanning_null.patch
maple_tree-drop-maple_alloc_slots.patch
maple_tree-clarify-comments-on-mas_nomem.patch
maple_tree-use-prefetched-value-in-mas_wr_store_type.patch
maple_tree-optimise-mas_wr_node_store-when-not-in-rcu-mode.patch
maple_tree-micro-optimisation-of-mas_wr_store_type.patch
maple_tree-add-bulk-parent-set-helper.patch
maple_tree-catch-race-in-mas_alloc_cyclic.patch
maple_tree-document-that-erase-may-use-gfp_kernel-for-allocations.patch
maple_tree-avoid-mas_erase-and-mtree_erase-failures.patch
maple_tree-document-erase-and-allocations-better.patch
maple_tree-change-two-gfp-flags-in-tests.patch
maple_tree-fix-argument-name-in-header.patch
maple_tree-avoid-extra-gap-calculation.patch
maple_tree-add-helper-mas_make_walkable.patch

