Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242E918A925
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925232; cv=none; b=R8lu2o9YxAhssfF9nY1zilAhBdx0HNk1OQmn573OabfhokwjGNb7Nl5pp5TvKvwOuVJisNRxOaT9WmsNzKqxO1wOpxWB5ZiAGscmQ1zOJSd1nZPm+i2OzlynV9ndycjm/ZgIn0dghUhI24ZK5HchEEn0dF/vbuFTeUKPtwIBK8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925232; c=relaxed/simple;
	bh=bGCfHaHY+63WODc8NAJjlgMn8O045m0s+6jrFGSFCic=;
	h=Date:To:From:Subject:Message-Id; b=pa7AitLaxtRWSq6aFzmfGUJxsyRZ/BBOLprjeuHZVUw6h+CtPu+gBzKjaNAaJkfzoNmt6xsNYtL1Lng5ngf60x0nSvUiwyVuobcVxCnasnP0f/S1nX5PVthsU9mPhDg3htv9mAk4721FLcKg0SvQfTYZqO8aZGAl2jt3Rb/ONgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j0Mv7ut9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j0Mv7ut9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCB5C4CEC5;
	Mon,  9 Sep 2024 23:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925232;
	bh=bGCfHaHY+63WODc8NAJjlgMn8O045m0s+6jrFGSFCic=;
	h=Date:To:From:Subject:From;
	b=j0Mv7ut99ru2kaSuFcN/wiC1VdeHQacDBajZrURGaJ4JKXMPrmHQbk5aKSy7geKqf
	 hfOc2ub/akKnSwvTl6OAuFtvaszN/IHGMRlYJYlqrj9/jvI/L7NHASEdKccJmL8xss
	 zo7mZ7Q/pRQ2JMFAlTROR459q4e/sAUAtNFCK5W8=
Date: Mon, 09 Sep 2024 16:40:31 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,baolin.wang@linux.alibaba.com,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-fix-minor-off-by-one-in-shrinkable-calculation.patch removed from -mm tree
Message-Id: <20240909234031.ECCB5C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: fix minor off-by-one in shrinkable calculation
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-minor-off-by-one-in-shrinkable-calculation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2348,7 +2348,7 @@ alloced:
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


