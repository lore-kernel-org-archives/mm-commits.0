Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947811552E2
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 20:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712176124; cv=none; b=WeD5Fy0jo+xx9j26dEfKQ8SRD5+DoGHTOabi+DpQ8jPfPlEBJPGIswoeWZ0RbtsP76ibrhrjFXuoDkShMLg41l4X4M71t41e9vlAsNnJW7+smv7+qMtiC4GtyGn+b7wjCkj/4GhBcpLNyF4Zdne2G5yBlZWaMARZJI4peYpGaAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712176124; c=relaxed/simple;
	bh=b6CQ3Tn1v85jT0+W9Rwde/yXFRFJU4URx0wEBSw+WFE=;
	h=Date:To:From:Subject:Message-Id; b=mkFCOcQls7kquuC36pJQ6iUQ0l9I0sWewlbhp2RnCGdoJ8E2B84rTF+azrIoJ+WD53QOG0yNwuNzIwwECDi5ooBD0lcvPoMteuTj2ye0tt4+smGR77k0Yg+0UQJ4DpdZwZSJIYNcDH1RWor4+3BhJXcqKobUfBqYl1ezaZY8TCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MbRuqGQe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MbRuqGQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0D0C433F1;
	Wed,  3 Apr 2024 20:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712176124;
	bh=b6CQ3Tn1v85jT0+W9Rwde/yXFRFJU4URx0wEBSw+WFE=;
	h=Date:To:From:Subject:From;
	b=MbRuqGQeZihr2RGdnEh8gItZCjo2Sfqkh2R8+BYHBKOcbubcRUzNyy/I0aGwZUsIg
	 xodDKtf3HZeO5MGrVbmCrbcafsKP1yQ/HDf4AXJKhWGSX+B5HBtkNfJ6tLdrkTOs5w
	 w2lCTTumLnAbDEyk6PHtg5uyaG/xyUJ8xzp41OdQ=
Date: Wed, 03 Apr 2024 13:28:43 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-slab-move-memcg-charging-to-post-alloc-hook-fix-2.patch added to mm-unstable branch
Message-Id: <20240403202843.EB0D0C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-slab-move-memcg-charging-to-post-alloc-hook-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-slab-move-memcg-charging-to-post-alloc-hook-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-slab-move-memcg-charging-to-post-alloc-hook-fix-2.patch

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
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm-slab-move-memcg-charging-to-post-alloc-hook-fix-2
Date: Wed, 3 Apr 2024 10:02:40 -0700

comment fixup

Link: https://lkml.kernel.org/r/Zg2LsNm6twOmG69l@P9FQF9L96D.corp.robot.car
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-slab-move-memcg-charging-to-post-alloc-hook-fix-2
+++ a/mm/memcontrol.c
@@ -350,7 +350,7 @@ static void memcg_reparent_objcgs(struct
 
 /*
  * A lot of the calls to the cache allocation functions are expected to be
- * inlined by the compiler. Since the calls to memcg_slab_pre_alloc_hook() are
+ * inlined by the compiler. Since the calls to memcg_slab_post_alloc_hook() are
  * conditional to this static branch, we'll have to allow modules that does
  * kmem_cache_alloc and the such to see this symbol as well
  */
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-slab-move-memcg-charging-to-post-alloc-hook-fix-2.patch

