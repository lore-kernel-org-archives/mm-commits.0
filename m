Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3CD13C691
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291684; cv=none; b=PDvx9z+/NSJSX/jrMaZnNj5ndv+cZStrt+YcvInbJHePyaHkDaFi6xXmMLaWjAg8gwMqlJVy8Ph6jtIWHya7M8drtDirmdXKjwFsfTkodOjEXcynzgbAjC6zqLOAWpjxtKubdSei5/FUq3KKsjFAeaMM9jvDRdZd/C7Ur3+W4Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291684; c=relaxed/simple;
	bh=jevvNFxf7LgGjbqcrht+hj+/9OxCm1ZyAknC2I6O2yM=;
	h=Date:To:From:Subject:Message-Id; b=ehcVRooO6q4+/h0XqXTVpvzDmokBZTnJCkHUEJa5eTZon8nMc52ChKe2uuP/j7xyt43Fqx1+qV0CB08U7DtfN1RqDHpTftNK4xPkMA9+r0Msa38a82iQCtZiryp0aK5L8Qmp1PvikL7uPWd9p7cDxdWPOVJ4iY4ipj/3SDfgvk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qCuWpqa+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qCuWpqa+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94669C32789;
	Tue, 25 Jun 2024 05:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291684;
	bh=jevvNFxf7LgGjbqcrht+hj+/9OxCm1ZyAknC2I6O2yM=;
	h=Date:To:From:Subject:From;
	b=qCuWpqa+VymAaHbSsYicPNeIQVCE4vzEhXykFX9iMV/WZYE/Qa5ZloapBKdNy7209
	 yE84jQZCDDRkmcUAtgDP8zSLxLewP8Txa2HdFWhGvTRxvm5x9j1gFhULdQ8B0FxFaS
	 d0b/qRYY3TsfuBAAXNiXRjJVr7u0TtFiSEVTppmE=
Date: Mon, 24 Jun 2024 22:01:24 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,richard.weiyang@gmail.com,lsahn@ooseel.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-use-memblock_alloc_accessible-enum-instead-of-0.patch removed from -mm tree
Message-Id: <20240625050124.94669C32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse: use MEMBLOCK_ALLOC_ACCESSIBLE enum instead of 0
has been removed from the -mm tree.  Its filename was
     mm-sparse-use-memblock_alloc_accessible-enum-instead-of-0.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Leesoo Ahn <lsahn@ooseel.net>
Subject: mm/sparse: use MEMBLOCK_ALLOC_ACCESSIBLE enum instead of 0
Date: Tue, 11 Jun 2024 00:15:28 +0900

Setting 'limit' variable to 0 might seem like it means "no limit".  But in
the memblock API, 0 actually means the 'MEMBLOCK_ALLOC_ACCESSIBLE' enum,
which limits the physical address range end based on
'memblock.current_limit'.  This could be confusing.

Use the enum instead of 0 to make it clear.

Link: https://lkml.kernel.org/r/20240610151528.943680-1-lsahn@wewakecorp.com
Signed-off-by: Leesoo Ahn <lsahn@ooseel.net>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/sparse.c~mm-sparse-use-memblock_alloc_accessible-enum-instead-of-0
+++ a/mm/sparse.c
@@ -351,7 +351,7 @@ sparse_early_usemaps_alloc_pgdat_section
 again:
 	usage = memblock_alloc_try_nid(size, SMP_CACHE_BYTES, goal, limit, nid);
 	if (!usage && limit) {
-		limit = 0;
+		limit = MEMBLOCK_ALLOC_ACCESSIBLE;
 		goto again;
 	}
 	return usage;
_

Patches currently in -mm which might be from lsahn@ooseel.net are


