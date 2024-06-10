Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62791422A2
	for <mm-commits@vger.kernel.org>; Mon, 10 Jun 2024 17:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718042016; cv=none; b=dppIlF0sR3AeB9t8Z/MEsvPUFH42eo9yBznCiXxp/oaagntehz2s47G1d9+f0MKMJATSXYV6HYARrwkgmSGpBJ+s4e75X9fFlvyefprCGaDK61K6saXPQCQGgZ/3zFZffxeh8NygvCfAGHuFP+of3fkLlbYFy4/GweXShMTuR9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718042016; c=relaxed/simple;
	bh=X+cX/DBHF8tqVba9g4JknZA7hLPVrjCquj1mR0R8hq8=;
	h=Date:To:From:Subject:Message-Id; b=o0b3rmoOil78bpiXF6itUefAfIIO1oL29hh5oXTvolru8DDpHXdKA9l1zDdl2GsY2+qMETEJeeTxHLQ48XGbRuiqgI1lGw/J3l7SzmruW1VZmnmPFMpDNmCshBVlCzpIph64GIzfW9qP4TYKniFen/MYpoajjGBYo8LGBEFks34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YSYFy7gG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YSYFy7gG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5843BC2BBFC;
	Mon, 10 Jun 2024 17:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718042015;
	bh=X+cX/DBHF8tqVba9g4JknZA7hLPVrjCquj1mR0R8hq8=;
	h=Date:To:From:Subject:From;
	b=YSYFy7gGSxNOcpBKaVGfDRgJF2qOJoHhPxY4hFghjRNWbVtDFSxL3Quci8HEDbwjD
	 YeLs3xclksDsXjnVjJWGyOczT9Xy5XUPeKshYUyyEwU0uhLWYNouhtcD5eLU1/2DM6
	 qsA6CkOBzpG8QAKd2uxM7ngvQ3wgOBenvLNmjyZA=
Date: Mon, 10 Jun 2024 10:53:34 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,lsahn@ooseel.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-use-memblock_alloc_accessible-enum-instead-of-0.patch added to mm-unstable branch
Message-Id: <20240610175335.5843BC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse: use MEMBLOCK_ALLOC_ACCESSIBLE enum instead of 0
has been added to the -mm mm-unstable branch.  Its filename is
     mm-sparse-use-memblock_alloc_accessible-enum-instead-of-0.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-use-memblock_alloc_accessible-enum-instead-of-0.patch

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
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
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

mm-sparse-use-memblock_alloc_accessible-enum-instead-of-0.patch

