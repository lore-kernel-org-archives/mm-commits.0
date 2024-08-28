Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787464594A
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 02:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724810404; cv=none; b=ZQPKiBaFFn/fjgFq0rekS5c1rMhRAhf0nXccS0p4Edz2Brniiv+khFK0vu78Eqs0AXUv844RTZIplYVxZMjldFdmXWU3g+bfVzy4r+G8ehMBXZaHrmCgEHUXj6Yn+3hflY2UFJBiI7/JZRz4D4qXDSgS6zoVwAvFEuq0g5YysOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724810404; c=relaxed/simple;
	bh=+ziFCY5X/XLO4USFTJ0TvY85hOwMiO2+nqkBgBOke1I=;
	h=Date:To:From:Subject:Message-Id; b=uVi/s3C7LrL1t2jtROwzGBVTXUisQn/yDwqVjGjdVFvqks36HKvggu3f5HE4QcuzzohtYnmIIVggEJ3apcm/efzVLPs9aEHeF7tvC07dEa9W7BnTD3OCgfPQuRXX/UAwsMvIsS7/IRZ7Twnu5gs4kT5tRkA+T2Xo6UosPMKg9Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j8NNUjK2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j8NNUjK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA276C4FF10;
	Wed, 28 Aug 2024 02:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724810403;
	bh=+ziFCY5X/XLO4USFTJ0TvY85hOwMiO2+nqkBgBOke1I=;
	h=Date:To:From:Subject:From;
	b=j8NNUjK2+BsPP//j2/DD1IeIxNqIBuWaB0VbIBYfUbSKdKpHJ04tvU7ObQLJ5tG/h
	 MR5uff1IHBdol+gvaXT5szOwWnRLZJMfGQaQBsLbjrSluR5xKOntjRoabd/r6m34AQ
	 YGV8zbjNQQMYdFkG1bKgJgQNjTkPJr9L5mbCe+8A=
Date: Tue, 27 Aug 2024 19:00:02 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,baolin.wang@linux.alibaba.com,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-minor-off-by-one-in-shrinkable-calculation.patch added to mm-unstable branch
Message-Id: <20240828020002.EA276C4FF10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: fix minor off-by-one in shrinkable calculation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-fix-minor-off-by-one-in-shrinkable-calculation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fix-minor-off-by-one-in-shrinkable-calculation.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: mm: shmem: fix minor off-by-one in shrinkable calculation
Date: Sun, 25 Aug 2024 15:42:45 -0700 (PDT)

There has been a long-standing and very minor off-by-one, where
shmem_get_folio_gfp() decides if a large folio extends beyond i_size far
enough to leave a page or more for freeing later under pressure.

This is not something needed for stable: but it will be proportionately
more significant as support for smaller large folios is added, and is best
fixed before duplicating the check in other places.

Link: https://lkml.kernel.org/r/d8e75079-af2d-8519-56df-6be1dccc247a@google.com
Fixes: 779750d20b93 ("shmem: split huge pages beyond i_size under memory pressure")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-fix-minor-off-by-one-in-shrinkable-calculation
+++ a/mm/shmem.c
@@ -2326,7 +2326,7 @@ alloced:
 	alloced = true;
 	if (folio_test_large(folio) &&
 	    DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE) <
-					folio_next_index(folio) - 1) {
+					folio_next_index(folio)) {
 		struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 		struct shmem_inode_info *info = SHMEM_I(inode);
 		/*
_

Patches currently in -mm which might be from hughd@google.com are

mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix.patch
mm-shmem-fix-minor-off-by-one-in-shrinkable-calculation.patch

