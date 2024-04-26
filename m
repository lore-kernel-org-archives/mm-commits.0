Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04482763E2
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714102000; cv=none; b=oZTcW9uLFiR9LABqVM4KCGcTCsaBbrCUMbUOqX82PKxd34UyYBsROEp2eMTrpgtKrRSg0wlItm7B+GVT4POsH5ZljEfMP+qh1dLp+MsgoI/KTCxAab2PjuQCbbzZBkRTmOdBuCd0/lmx/FYBKbjvwStgimmrpnMFLWpBIQuqVMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714102000; c=relaxed/simple;
	bh=0K1T/7myFhz0AnASJ8zdjOB9HIKlLV7RNxPqZhbcrOY=;
	h=Date:To:From:Subject:Message-Id; b=GxPaoXCZIV1zdS5N3delD1lxWe+53MBFDgmGQ1NufYF2HkHV96zp+v8i744fCgzRLWGZHWtJdNV7HH2DTBT3Q5FKkpAON2w4SO8CHO70uazbUCaAgjOT92s9Dkoqx1y2TL6m//dFVtiR3WU7i0m187rgdKasqFbKKB9C2SlljoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eaXU1ySv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eaXU1ySv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8182C113CD;
	Fri, 26 Apr 2024 03:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714101999;
	bh=0K1T/7myFhz0AnASJ8zdjOB9HIKlLV7RNxPqZhbcrOY=;
	h=Date:To:From:Subject:From;
	b=eaXU1ySvYkrMU9vW+fD0iG5nzWJp794Kbg0ktsHM1gR0qG6VDHQpy4lvtciMWdFEq
	 oSHSKs4aaFkf0cwP0ZmK6Lltc8qWssaRWQc6YKsfCHKNoZU2e9g3bh4vrFbOq17s/o
	 xKYqndUSyBjlx341pIN0uASWJ7zIPORDh+LkwHvI=
Date: Thu, 25 Apr 2024 20:26:39 -0700
To: mm-commits@vger.kernel.org,viro@ZenIV.linux.org.uk,torvalds@linux-foundation.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,muchun.song@linux.dev,mhocko@kernel.org,kees@kernel.org,jpoimboe@kernel.org,jlayton@kernel.org,jack@suse.cz,iamjoonsoo.kim@lge.com,hannes@cmpxchg.org,cl@linux.com,chuck.lever@oracle.com,chengming.zhou@linux.dev,brauner@kernel.org,aishwarya.tcv@arm.com,42.hyeyoo@gmail.com,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-slab-move-memcg-charging-to-post-alloc-hook-fix.patch removed from -mm tree
Message-Id: <20240426032639.B8182C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fixup! mm, slab: move memcg charging to post-alloc hook
has been removed from the -mm tree.  Its filename was
     mm-slab-move-memcg-charging-to-post-alloc-hook-fix.patch

This patch was dropped because it was folded into mm-slab-move-memcg-charging-to-post-alloc-hook.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: fixup! mm, slab: move memcg charging to post-alloc hook
Date: Wed, 3 Apr 2024 17:45:15 +0200

The call to memcg_alloc_abort_single() is wrong, it expects a pointer to
single object, not an array.

Link: https://lkml.kernel.org/r/4af50be2-4109-45e5-8a36-2136252a635e@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Aishwarya TCV <aishwarya.tcv@arm.com>
Tested-by: Aishwarya TCV <aishwarya.tcv@arm.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c~mm-slab-move-memcg-charging-to-post-alloc-hook-fix
+++ a/mm/slub.c
@@ -2172,7 +2172,7 @@ bool memcg_slab_post_alloc_hook(struct k
 		return true;
 
 	if (likely(size == 1)) {
-		memcg_alloc_abort_single(s, p);
+		memcg_alloc_abort_single(s, *p);
 		*p = NULL;
 	} else {
 		kmem_cache_free_bulk(s, size, p);
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-change-move_freepages-to-__move_freepages_block.patch
mm-slab-move-memcg-charging-to-post-alloc-hook.patch
mm-slab-move-slab_memcg-hooks-to-mm-memcontrolc.patch

