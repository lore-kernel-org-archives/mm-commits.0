Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9341F23D7E3
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 22:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764024641; cv=none; b=FBaa8E8jCR8mcFVO8taRMgqXZ0SuQNYgdJ5uWwckXmzJmGslQS4iIiUqIcvhzWFo6nWsvKIgh2aDTQz2MMB1ca56f/ywZ7J0bAlb6V6l6s7Z0jb6HACKeXK8dxjIyC62hDPd5ng3LXIpUhqFpXtxDDlIshpiDGm7juSDyU+l66g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764024641; c=relaxed/simple;
	bh=8vyQOyXO4Ksx0ABKF/gutBepsZgLaPWaU12XEcEmHnA=;
	h=Date:To:From:Subject:Message-Id; b=WCpwk07SdVk6sgGFEnuDEnV9MfbhI42+x2IPburTsWFEzJSczixtSmEQxsk4KTcmcdONEVm/psG4jdJ7CmLCs6ZHxVhbZdDMkcddlgxuPvZzyQQa0LWq9WorjzFb4896EdXMtglHWpgmxyMSzi/GXKv4pCf+ojIAjQk4GIRL5nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c8xvu6iT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c8xvu6iT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254B1C4CEF1;
	Mon, 24 Nov 2025 22:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764024641;
	bh=8vyQOyXO4Ksx0ABKF/gutBepsZgLaPWaU12XEcEmHnA=;
	h=Date:To:From:Subject:From;
	b=c8xvu6iTSAz7+gMk2lLFPgjzAdNpKfDYFjRqbRs5sn7yEGyGEeE2GvXwwEZhHpLB3
	 g8bGe+FlOOXEgdcIFYeVQUjzklX1IYnCyWM0Sz22kzgo5SR8He7hbb0E6yOsI10XbN
	 fhjsrzC7+wi10o1Ptf2L52Nzf5kC77ETwmHroPBo=
Date: Mon, 24 Nov 2025 14:50:40 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch removed from -mm tree
Message-Id: <20251124225041.254B1C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-huge_memory-introduce-enum-split_type-for-clarity-fix
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch

This patch was dropped because it was folded into mm-huge_memory-introduce-enum-split_type-for-clarity.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-huge_memory-introduce-enum-split_type-for-clarity-fix
Date: Thu Nov  6 04:39:51 PM PST 2025

tweak layout, per David

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-introduce-enum-split_type-for-clarity-fix
+++ a/mm/huge_memory.c
@@ -4046,7 +4046,7 @@ int __split_huge_page_to_list_to_order(s
 	struct folio *folio = page_folio(page);
 
 	return __folio_split(folio, new_order, &folio->page, page, list,
-				SPLIT_TYPE_UNIFORM, unmapped);
+			     SPLIT_TYPE_UNIFORM, unmapped);
 }
 
 /**
@@ -4077,7 +4077,7 @@ int folio_split(struct folio *folio, uns
 		struct page *split_at, struct list_head *list)
 {
 	return __folio_split(folio, new_order, split_at, &folio->page, list,
-				SPLIT_TYPE_NON_UNIFORM, false);
+			     SPLIT_TYPE_NON_UNIFORM, false);
 }
 
 int min_order_for_split(struct folio *folio)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-huge_memory-introduce-enum-split_type-for-clarity.patch
mm-correctly-handle-uffd-pte-markers-fix.patch
mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix-fix.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch

