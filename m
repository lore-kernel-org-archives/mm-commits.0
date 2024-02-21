Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46464A1D
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 22:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708554256; cv=none; b=tIS6HmbGVI5LoTEeST425N/GrwpNLu4VpT6+Mwd4MZVArFpTx0ZWgx6MzzhLW9UgwlBc6opFTXLRKJEy5ios7TdG7sIRXTwtXdiAC8GZt9gba72owEyjFYTdOK7eM2sbz3nQ8j+oCltWLdxDWoUKxfZJLxwbAiQXuS/vzNjNhwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708554256; c=relaxed/simple;
	bh=QEBInbT32dxx5wjfwt09rEkUUYN3uG4QiqgXoKgcboM=;
	h=Date:To:From:Subject:Message-Id; b=fz2Hd6+JsgsfFMDN4tWmWC460sHAqNrvPlPuom48sPDSfcQFfNHCFA14Lxl/pQsrO7wMjIUJp/hjIU0nKS78IHCn8krfbax8/Eo+frxqqCRxDMRCZaRtkPGO6/kHxMCIKvAHebnF1aa+WxtcrA7Pg+ZYlXQAtyoGo/m/T1MjaD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Txo11F1a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Txo11F1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2F5C43390;
	Wed, 21 Feb 2024 22:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708554256;
	bh=QEBInbT32dxx5wjfwt09rEkUUYN3uG4QiqgXoKgcboM=;
	h=Date:To:From:Subject:From;
	b=Txo11F1anjczktFuhHvl8hKYRL9UrLw9ocIt6pbKGzyaIvI/1PdocQE8V4TiOE/U7
	 ZfYQP0xQ5cpw/gDoa229e9KJwA/ypUk/2HSXAMleAyRcEVzt4ACSholHS3kAt7afh2
	 DRpQomrzoQGvk29dzZyEwMZUk+ahv68sWy4N77T8=
Date: Wed, 21 Feb 2024 14:24:15 -0800
To: mm-commits@vger.kernel.org,hannes@cmpxchg.org,cerasuolodomenico@gmail.com,hezhongkun.hzk@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-z3fold-remove-unneeded-spinlock-in-z3fold_alloc.patch removed from -mm tree
Message-Id: <20240221222416.3B2F5C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/z3fold: remove unneeded spinlock in z3fold_alloc
has been removed from the -mm tree.  Its filename was
     mm-z3fold-remove-unneeded-spinlock-in-z3fold_alloc.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Zhongkun He <hezhongkun.hzk@bytedance.com>
Subject: mm/z3fold: remove unneeded spinlock in z3fold_alloc
Date: Sun, 4 Feb 2024 21:15:43 +0800

The spinlock in z3fold_alloc() is used to protect page->lru, but now it
was removed in commit e774a7bc7f0ad ("mm: zswap: remove page reclaim logic
from z3fold"), so remove the spinlock too.

Link: https://lkml.kernel.org/r/20240204131543.1469661-1-hezhongkun.hzk@bytedance.com
Signed-off-by: Zhongkun He <hezhongkun.hzk@bytedance.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/z3fold.c~mm-z3fold-remove-unneeded-spinlock-in-z3fold_alloc
+++ a/mm/z3fold.c
@@ -1070,9 +1070,7 @@ found:
 	add_to_unbuddied(pool, zhdr);
 
 headless:
-	spin_lock(&pool->lock);
 	*handle = encode_handle(zhdr, bud);
-	spin_unlock(&pool->lock);
 	if (bud != HEADLESS)
 		z3fold_page_unlock(zhdr);
 
_

Patches currently in -mm which might be from hezhongkun.hzk@bytedance.com are

mm-z3fold-fix-the-comment-for-__encode_handle.patch

