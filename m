Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1FD20E702
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388477; cv=none; b=aF7Qm9z8GVGnWXODJNqcxPkd8zzi25blRWz35Wcnr/sVaQ/tWzy82R6MTjzaqHzMIV2dbTeD10E4OmO6WK8LHdaOIadEZerSxCwHqhKkkFVsnFb6yk6+tXO4hfDh9vdV0GYetcTeekSiQcYNsB8HBrm9YXyyat3QzCR23SnHnhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388477; c=relaxed/simple;
	bh=sqUDYZOILON82/EGWtIJLuUDVAaan8Csqwrt9Xheq/4=;
	h=Date:To:From:Subject:Message-Id; b=JyD1ayG/oOIWZNqeqDEumiO642n/ntGFuhcH3B6Qhj8E6KH+XgB+Gwzax8eJuZRuGMOZQudjZA/nxFKRxiPWzESlDtjk7XgksILNBTzIDuTQpCym89SlIZ4UhSXpgKmkBO83aaqoHqKrnsJm0it1gqghjcFd2BE9Iz5v/yWs4AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oPNfnoLM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oPNfnoLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C962BC19424;
	Tue, 24 Mar 2026 21:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388476;
	bh=sqUDYZOILON82/EGWtIJLuUDVAaan8Csqwrt9Xheq/4=;
	h=Date:To:From:Subject:From;
	b=oPNfnoLMaLJZXeqnfJF0JEoiatC2j6kZ3YR+hVRdBME69QFW/gWD2McIz+t7nvrDo
	 OGTbALQHUnml1Z6JFjSjiZVBfK4jGovbgQQdcWQuLZ22o8fqgN996sADaHyCSGh6j3
	 rPwDQX9Cjx3a6I/J/Gr+blfGJy01zkW59ht/C1q8=
Date: Tue, 24 Mar 2026 14:41:16 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,roman.gushchin@linux.dev,muchun.song@linux.dev,david@fromorbit.com,ahacigu.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shrinker-fix-refcount-leak-in-shrink_slab_memcg.patch removed from -mm tree
Message-Id: <20260324214116.C962BC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shrinker: fix refcount leak in shrink_slab_memcg()
has been removed from the -mm tree.  Its filename was
     mm-shrinker-fix-refcount-leak-in-shrink_slab_memcg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Altan Hacigumus <ahacigu.linux@gmail.com>
Subject: mm/shrinker: fix refcount leak in shrink_slab_memcg()
Date: Tue, 3 Feb 2026 19:35:53 -0800

When kmem is disabled for memcg, slab-backed shrinkers are skipped. 
However, shrink_slab_memcg() doesn't drop the reference acquired via
shrinker_try_get() before continuing.

Add the missing shrinker_put().

Also, since memcg_kmem_online() and shrinker flags cannot change
dynamically, remove the shrinker from the bitmap to avoid unnecessary
future scans.

Link: https://lkml.kernel.org/r/20260204033553.50039-1-ahacigu.linux@gmail.com
Fixes: 50d09da8e119 ("mm: shrinker: make memcg slab shrink lockless")
Signed-off-by: Altan Hacigumus <ahacigu.linux@gmail.com>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
  Link: https://lore.kernel.org/r/20260203073757.135088-1-ahacigu.linux@gmail.com
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shrinker.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/shrinker.c~mm-shrinker-fix-refcount-leak-in-shrink_slab_memcg
+++ a/mm/shrinker.c
@@ -544,8 +544,11 @@ again:
 
 			/* Call non-slab shrinkers even though kmem is disabled */
 			if (!memcg_kmem_online() &&
-			    !(shrinker->flags & SHRINKER_NONSLAB))
+			    !(shrinker->flags & SHRINKER_NONSLAB)) {
+				clear_bit(offset, unit->map);
+				shrinker_put(shrinker);
 				continue;
+			}
 
 			ret = do_shrink_slab(&sc, shrinker, priority);
 			if (ret == SHRINK_EMPTY) {
_

Patches currently in -mm which might be from ahacigu.linux@gmail.com are


