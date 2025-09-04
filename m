Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90C72C1580
	for <mm-commits@vger.kernel.org>; Thu,  4 Sep 2025 21:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757021819; cv=none; b=PvZ+3ql3M2cPCTNxnamnJlFuFLPgz9+F2hlObN8Y6H7bvGw2TYA7qAq3364Izu5uXAJ2Om7oz1Na5750MCqOvp6Fnb765KBX8B1WUaGymrt/sv5P3YBIkq+XV42TwSpMoe9Tf8FsJ2AUwA5xCkD9kbTtsQ6PErKQc2kyxnamr88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757021819; c=relaxed/simple;
	bh=o6spQ1Kw0ROYMlNJYowKkcRfFJwmXYygDdmVECw8MZk=;
	h=Date:To:From:Subject:Message-Id; b=jKzyDR5PPufQS00AgH3MkcKdJVI/BMsMY5LD3oFasJ4qJuIOLJX6bW9hq4JbvA3KANAMgxBzFM2u1pp15AGyLXvxMCwgcdaPpdQD5NjJV4mp/BXw9GkrtXwlxG9fk++4ejc/WLqwNqFcNJLFsmNenepSY2Jo/VqR7w3vS6WYy3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tP3bX1sl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tP3bX1sl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63334C4CEF0;
	Thu,  4 Sep 2025 21:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757021819;
	bh=o6spQ1Kw0ROYMlNJYowKkcRfFJwmXYygDdmVECw8MZk=;
	h=Date:To:From:Subject:From;
	b=tP3bX1sl2fIaOT82sBRrZRDoknd93anPqrCZ2cTIpWXOK9TBRk9Qo6ZmU0mD4CBAJ
	 s5OkzPOOEv2opYKUBJYkR/PmtJzIaF4z6DlHvzm1RoAksmJ/hFYcTVTy8Kdpq4524F
	 c8LEAB71KN6k1LGGOOby7Q8t0/KuVo9P8SLuY4Mg=
Date: Thu, 04 Sep 2025 14:36:58 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,richard.weiyang@gmail.com,Liam.Howlett@oracle.com,rongqianfeng@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] maple_tree-remove-redundant-__gfp_nowarn.patch removed from -mm tree
Message-Id: <20250904213659.63334C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: remove redundant __GFP_NOWARN
has been removed from the -mm tree.  Its filename was
     maple_tree-remove-redundant-__gfp_nowarn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: maple_tree: remove redundant __GFP_NOWARN
Date: Mon, 4 Aug 2025 20:56:57 +0800

Commit 16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT") made
GFP_NOWAIT implicitly include __GFP_NOWARN.

Therefore, explicit __GFP_NOWARN combined with GFP_NOWAIT (e.g.,
`GFP_NOWAIT | __GFP_NOWARN`) is now redundant.  Let's clean up these
redundant flags across subsystems.

No functional changes.

Link: https://lkml.kernel.org/r/20250804125657.482109-1-rongqianfeng@vivo.com
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-redundant-__gfp_nowarn
+++ a/lib/maple_tree.c
@@ -1344,11 +1344,11 @@ static void mas_node_count_gfp(struct ma
  * @mas: The maple state
  * @count: The number of nodes needed
  *
- * Note: Uses GFP_NOWAIT | __GFP_NOWARN for gfp flags.
+ * Note: Uses GFP_NOWAIT for gfp flags.
  */
 static void mas_node_count(struct ma_state *mas, int count)
 {
-	return mas_node_count_gfp(mas, count, GFP_NOWAIT | __GFP_NOWARN);
+	return mas_node_count_gfp(mas, count, GFP_NOWAIT);
 }
 
 /*
_

Patches currently in -mm which might be from rongqianfeng@vivo.com are

xarray-remove-redundant-__gfp_nowarn.patch
mm-remove-redundant-__gfp_nowarn.patch
ref_tracker-remove-redundant-__gfp_nowarn.patch

