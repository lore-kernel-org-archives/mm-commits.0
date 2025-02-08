Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812152913
	for <mm-commits@vger.kernel.org>; Sat,  8 Feb 2025 03:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738983896; cv=none; b=WJ5jmOf9YLt2sh3No7YRJvDY8WcRwK/XWiO/8+gvDstpQaJyJTGMeXLJvXNGY8vHmfuba/PusleIljNH7eWwUpBxzl4y+afkNM2pRVzy+yzMQMvKsrBCoqekC7/UEPLmLO0QKvPyQNi8EJfOKzgGnHBheMO1Sfidb9pBjMX/fyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738983896; c=relaxed/simple;
	bh=lQHgUcxG7ErqbP+IOM8FBaeQMW83tMTi3wKSTSHe84E=;
	h=Date:To:From:Subject:Message-Id; b=lr6RTa7b9txDatok9oCJLYXFm59sT0+ebmthsTY51SzOLtrHdjaPfwurHOV8bn7NAWhNh9tyxfievAVUKZCY04brSB4WyVtoTKL+V9H3+EbL91wGGwxZM/2ID6DF7FqwUh+pHAfLJGUqmuhgWP58l3CQBEHKssCZFnNmgewEqik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=abAs3UeN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="abAs3UeN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A16C4CED1;
	Sat,  8 Feb 2025 03:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738983896;
	bh=lQHgUcxG7ErqbP+IOM8FBaeQMW83tMTi3wKSTSHe84E=;
	h=Date:To:From:Subject:From;
	b=abAs3UeNzPRi7sMz8gGjF3AipU3Q7SVzB+xPxUyjkR23ApLJYvC5mlVeNkv/u5OIw
	 ZX0LRrdJ1W1BBKdQcSJD5m6gM5o31rkJN/kTHeeVKgolxCWKnPcbw3ZCsgaPxEIACx
	 zZwcs1DvFsE+zR0BqI2My4mRd3XlTvkGJ0tQkY/s=
Date: Fri, 07 Feb 2025 19:04:55 -0800
To: mm-commits@vger.kernel.org,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-remove-fadvise-comments.patch added to mm-unstable branch
Message-Id: <20250208030455.E0A16C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: remove 'fadvise()' comments
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-remove-fadvise-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-remove-fadvise-comments.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: remove 'fadvise()' comments
Date: Fri, 7 Feb 2025 17:44:18 +0800

Similar to commit 255ff62d1586 ("docs: tmpfs: drop 'fadvise()' from the
documentation"), fadvise() has no HUGEPAGE advise currently.  Remove the
confusing fadvise() comments.

Link: https://lkml.kernel.org/r/fae702b9775f58b55b45be5eaad22d8586d0290a.1738918357.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickens <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-remove-fadvise-comments
+++ a/mm/shmem.c
@@ -525,9 +525,9 @@ static bool shmem_confirm_swap(struct ad
  *	enables huge pages for the mount;
  * SHMEM_HUGE_WITHIN_SIZE:
  *	only allocate huge pages if the page will be fully within i_size,
- *	also respect fadvise()/madvise() hints;
+ *	also respect madvise() hints;
  * SHMEM_HUGE_ADVISE:
- *	only allocate huge pages if requested with fadvise()/madvise();
+ *	only allocate huge pages if requested with madvise();
  */
 
 #define SHMEM_HUGE_NEVER	0
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-drop-the-unused-macro.patch
mm-shmem-remove-fadvise-comments.patch
mm-shmem-remove-duplicate-error-validation.patch
mm-shmem-change-the-return-value-of-shmem_find_swap_entries.patch
mm-shmem-factor-out-the-within_size-logic-into-a-new-helper.patch
maintainers-add-myself-as-shmem-reviewer.patch

