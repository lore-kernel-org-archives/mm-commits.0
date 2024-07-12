Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46F712F5A0
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824905; cv=none; b=X4Oc3OVIuaapK8ZkihuV9/wtuhFtKpJP1I08bCQakSi+MMMsq1685iPjphY9LQ0i/CNN/UQ3OjRSjL9rI76bxmCfmyugOzHFUWU/maU71wg1TMtrf9IRrfOzPLWHCnYjfUW0JG4VJUWQHCzYkaI+/FHQny8stg/5hOxbNutGod8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824905; c=relaxed/simple;
	bh=caUbDY+1A5Bt0EXuPCqStsJqbLr2Oesf+gQZqaRE+Hk=;
	h=Date:To:From:Subject:Message-Id; b=eyGvaf5N3uVa8hmIBfZX5BgGqUOLQOCxD1V73419h3WpilZdwTAhRsOj3Ja6pOusim9d0vY5BGsEK6vfjhpiOA2ImoJq7EHbYzss+mYjLMBUBr8vvbgqQgUAYyGtmrhddb86ce4OcFaWhGjyHm9rX1B59gKM/zdnb8MQ3JAC0SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=omUPGJ6w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="omUPGJ6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCD9C32782;
	Fri, 12 Jul 2024 22:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824904;
	bh=caUbDY+1A5Bt0EXuPCqStsJqbLr2Oesf+gQZqaRE+Hk=;
	h=Date:To:From:Subject:From;
	b=omUPGJ6wppb2zltVxxSZlxHqFNOWHenawCDijLmlzv9B8nas9Ld3D4aNA/OGGBBom
	 zaEJSrYswZ/c6LTwtlIXkdgeDyjIuCwjZsdlIqgDY2J97TG7n3iw8O8nUx9SwB5XzX
	 r2hv8zWXHqFjeQ29aWTIQLXculXPU5QKCGU3qX1k=
Date: Fri, 12 Jul 2024 15:55:04 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap_state-use-folio_alloc_mpol-in-__read_swap_cache_async.patch removed from -mm tree
Message-Id: <20240712225504.BBCD9C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap_state: use folio_alloc_mpol() in __read_swap_cache_async()
has been removed from the -mm tree.  Its filename was
     mm-swap_state-use-folio_alloc_mpol-in-__read_swap_cache_async.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: swap_state: use folio_alloc_mpol() in __read_swap_cache_async()
Date: Tue, 9 Jul 2024 18:55:08 +0800

Convert to use folio_alloc_mpol() helper() in __read_swap_cache_async().

Link: https://lkml.kernel.org/r/20240709105508.3933823-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/swap_state.c~mm-swap_state-use-folio_alloc_mpol-in-__read_swap_cache_async
+++ a/mm/swap_state.c
@@ -470,8 +470,7 @@ struct folio *__read_swap_cache_async(sw
 		 * before marking swap_map SWAP_HAS_CACHE, when -EEXIST will
 		 * cause any racers to loop around until we add it to cache.
 		 */
-		folio = (struct folio *)alloc_pages_mpol(gfp_mask, 0,
-						mpol, ilx, numa_node_id());
+		folio = folio_alloc_mpol(gfp_mask, 0, mpol, ilx, numa_node_id());
 		if (!folio)
                         goto fail_put_swap;
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


