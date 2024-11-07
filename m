Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00C3215C6D
	for <mm-commits@vger.kernel.org>; Thu,  7 Nov 2024 22:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731017600; cv=none; b=as7TpInJe7UIVmjcmOtV84qLaZOxd7AlES3ZMd+nXXGAl+wMw1eKcZ70JK7ycv1ftGo39ivePggQjDma2Jsg7EyzUcKJIw1jNX9LozhPrLUX0l4tyoDhHqyVt8dMCM4G03TLbYzvNGL3OuR+N3by94D8Tj8UiR2QaeOhAJHjyeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731017600; c=relaxed/simple;
	bh=pMgu7trvhU4RP9BrZJy7wTkRbFWyvqfEGYYBBC1LP+Q=;
	h=Date:To:From:Subject:Message-Id; b=suThQGd9aEGIY2nGb2ejyv6Uf/vGFMJe+X9A/HZwUMt9wFriAhdLqaRPv005ckErSuE4vNEPFkn+jhse6kmw+qj7ROaaS1g7hTyvGxzu91CfnMLIuChLRJfsDU4LeZl1+JH/1VhQd73NKoDr1Yf3rZoAeBagQ1JmTH0Ew4Yq9vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RrAMhz3P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RrAMhz3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E4BC4CECC;
	Thu,  7 Nov 2024 22:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731017600;
	bh=pMgu7trvhU4RP9BrZJy7wTkRbFWyvqfEGYYBBC1LP+Q=;
	h=Date:To:From:Subject:From;
	b=RrAMhz3P4+yYwSoad1t5QMk5cutQH/RlaWvk6akJQFNaSu6bvTHuJV0JDYxg8qyaz
	 3FmSInvtbPA3Wws+RjQHUyDWcl51k0k6O0tDVLU1ot2jWe5vpbCWajqv76l5n10oQl
	 ClAi6oXcMeGGcyOHfypYsV/YSwvJSyLNNOU8n6t4=
Date: Thu, 07 Nov 2024 14:13:19 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,vbabka@suse.cz,rientjes@google.com,linkl@google.com,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-keep-track-of-free-highatomic-fix.patch removed from -mm tree
Message-Id: <20241107221320.16E4BC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-page_alloc-keep-track-of-free-highatomic-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-keep-track-of-free-highatomic-fix.patch

This patch was dropped because it was folded into mm-page_alloc-keep-track-of-free-highatomic.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-keep-track-of-free-highatomic-fix
Date: Tue Oct 29 05:37:30 PM PDT 2024

s/if/else if/, per Johannes, stealth whitespace tweak

Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Link Lin <linkl@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-keep-track-of-free-highatomic-fix
+++ a/mm/page_alloc.c
@@ -644,9 +644,9 @@ static inline void account_freepages(str
 
 	if (is_migrate_cma(migratetype))
 		__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, nr_pages);
-
-	if (is_migrate_highatomic(migratetype))
-		WRITE_ONCE(zone->nr_free_highatomic, zone->nr_free_highatomic + nr_pages);
+	else if (is_migrate_highatomic(migratetype))
+		WRITE_ONCE(zone->nr_free_highatomic,
+			   zone->nr_free_highatomic + nr_pages);
 }
 
 /* Used for pages not on another list */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-keep-track-of-free-highatomic.patch
bootmem-stop-using-page-index-fix.patch
vma-detect-infinite-loop-in-vma-tree-fix.patch
maple_tree-add-a-test-checking-storing-null-fix.patch

