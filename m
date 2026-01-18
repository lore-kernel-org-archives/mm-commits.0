Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72332FF14F
	for <mm-commits@vger.kernel.org>; Sun, 18 Jan 2026 20:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768769172; cv=none; b=q4hyM/yCrzMdttJbL/CD/uy97grMPeoPUKe5ANA953JvzBhh/tcyhlOf9sDBYZbmTmNsH/brCEydZnQDzQq1gRZM3r6rr3CoR46WDVOq/+x8YxsDrz/xObJR/fs/j+GO3qsdl/TVIxcjsJ+Dqird13IEjn3TAZ4PltmA+Ujt4VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768769172; c=relaxed/simple;
	bh=gbRFFMkSCaFp/T+RcVA4+rG5hihs+5kI3t6jwT5hfdk=;
	h=Date:To:From:Subject:Message-Id; b=lOTj3ixd8rZU6OdpXzFX4fGyZ9BTs4JZhnvSaPYWBTMrcOYi4KGsBl0khmaku3XqANGRcir+uAXS6PipwGQZbRUSWKzrGZsrGjx5cvfSVcLhp5Se00DN2FeLTuPAgpsVY9F+ZnvZIQuCx9efamIFr09F4YFlQK195zhpsdoEl0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HGMoLrVR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HGMoLrVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52DC6C116D0;
	Sun, 18 Jan 2026 20:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768769172;
	bh=gbRFFMkSCaFp/T+RcVA4+rG5hihs+5kI3t6jwT5hfdk=;
	h=Date:To:From:Subject:From;
	b=HGMoLrVRJWF1cq7INFLPtW4ucScodhRzquxquf2EGD62UfL6Ksj9iWlfYsbudzV93
	 1kTvZ8MOQoHYTy8Xj0ZP2n4DsgtaRQFqbO/FyczRXaOOgyiXmTJmaWIGgc8Ixea7yF
	 cMVHWKnvidUfqcyEGEH3gdLS/BkP9WJJEqdjvQsI=
Date: Sun, 18 Jan 2026 12:46:11 -0800
To: mm-commits@vger.kernel.org,liam.howlett@oracle.com,andrewjballance@gmail.com,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-update-mas_next-docs.patch added to mm-new branch
Message-Id: <20260118204612.52DC6C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: update mas_next[_range] docs
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-update-mas_next-docs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-update-mas_next-docs.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Alice Ryhl <aliceryhl@google.com>
Subject: maple_tree: update mas_next[_range] docs
Date: Sun, 18 Jan 2026 11:00:41 +0000

If you read the docs, it sounds like the difference between these
functions is whether mas->index and mas->last are updated.  However, if
you read the implementation, you will instead find that the difference is
whether NULL entries are skipped.

Link: https://lkml.kernel.org/r/20260118-mas-next-doc-v1-1-827d9f4924ce@google.com
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/lib/maple_tree.c~maple_tree-update-mas_next-docs
+++ a/lib/maple_tree.c
@@ -5293,13 +5293,14 @@ static bool mas_next_setup(struct ma_sta
 }
 
 /**
- * mas_next() - Get the next entry.
+ * mas_next() - Advance the maple state to the next range, skipping zero entries.
  * @mas: The maple state
  * @max: The maximum index to check.
  *
  * Returns the next entry after @mas->index.
+ * Updates @mas->index and @mas->last to the range.
  * Must hold rcu_read_lock or the write lock.
- * Can return the zero entry.
+ * Skips entries reserved with XA_ZERO_ENTRY.
  *
  * Return: The next entry or %NULL
  */
@@ -5316,11 +5317,12 @@ void *mas_next(struct ma_state *mas, uns
 EXPORT_SYMBOL_GPL(mas_next);
 
 /**
- * mas_next_range() - Advance the maple state to the next range
+ * mas_next_range() - Advance the maple state to the next range.
  * @mas: The maple state
  * @max: The maximum index to check.
  *
- * Sets @mas->index and @mas->last to the range.
+ * Returns the next entry after @mas->index.
+ * Updates @mas->index and @mas->last to the range.
  * Must hold rcu_read_lock or the write lock.
  * Can return the zero entry.
  *
_

Patches currently in -mm which might be from aliceryhl@google.com are

vmalloc-export-vrealloc_node_align_noprof.patch
maple_tree-update-mas_next-docs.patch
rust-task-restrict-task-group_leader-to-current.patch

