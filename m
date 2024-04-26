Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FD97EF06
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104035; cv=none; b=d15gJQBEy+ZCZ2mREW9FOEQH3MILYkDM9unku3tI+uvQOxb7QLVWRRoMl5qigCx7p1xqr6RSVOmimGQzdEPEowu/2KH83n68ye9XGUVfaGg0fuIiIMeURzEzL8kQ9z4eFfFXeHegDF4gbzOXl/5I+duslP4ygFT+/RJXYu7L4UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104035; c=relaxed/simple;
	bh=grHZ10DAqb0T9nPRIGT2B8r0desy1ZdTayTg4vBinLg=;
	h=Date:To:From:Subject:Message-Id; b=oi0ILlPi4v37v6MNFeO3APqcxq4Y50BsO3Q3g1SGYgOmg+Wfv3lZZ56O+kRvGZXD8Cxnt8L6cTwyuUsiRNHh18d8e2VbOl6gtp2sprZ/1LSXx5/6qEltZw1E1YxbycxuYGBB16fbXJwJnPzs7NknLKMTRwNzQzNFGahg1CsjmKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I65pFH8h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I65pFH8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C180C113CD;
	Fri, 26 Apr 2024 04:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104035;
	bh=grHZ10DAqb0T9nPRIGT2B8r0desy1ZdTayTg4vBinLg=;
	h=Date:To:From:Subject:From;
	b=I65pFH8huhSnOBd1u2QGdJNSyKpxzDqj19MVr4wHgNABWxxU0teagSNhPvTGMSG4j
	 x2zLUJjPxJQzYUxnBNDi44oblQ4nLgfsZMdBiXrDgtbV/j2KuI3a7bSOhW8k6lIR2/
	 yN+ztMNAZvCNwEnQ18KFPmUnnpIkZDsRp6QM92iY=
Date: Thu, 25 Apr 2024 21:00:34 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,mgorman@suse.de,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_initc-remove-the-outdated-code-comment-above-deferred_grow_zone.patch removed from -mm tree
Message-Id: <20240426040035.5C180C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init.c: remove the outdated code comment above deferred_grow_zone()
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-remove-the-outdated-code-comment-above-deferred_grow_zone.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/mm_init.c: remove the outdated code comment above deferred_grow_zone()
Date: Tue, 26 Mar 2024 14:11:31 +0800

The noinline attribute has been taken off in commit 9420f89db2dd ("mm:
move most of core MM initialization to mm/mm_init.c").  So remove the
unneeded code comment above deferred_grow_zone().

And also remove the unneeded bracket in deferred_init_pages().

Link: https://lkml.kernel.org/r/20240326061134.1055295-6-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/mm_init.c~mm-mm_initc-remove-the-outdated-code-comment-above-deferred_grow_zone
+++ a/mm/mm_init.c
@@ -2014,7 +2014,7 @@ static unsigned long  __init deferred_in
 		__init_single_page(page, pfn, zid, nid);
 		nr_pages++;
 	}
-	return (nr_pages);
+	return nr_pages;
 }
 
 /*
@@ -2216,10 +2216,6 @@ zone_empty:
  * Return true when zone was grown, otherwise return false. We return true even
  * when we grow less than requested, to let the caller decide if there are
  * enough pages to satisfy the allocation.
- *
- * Note: We use noinline because this function is needed only during boot, and
- * it is called from a __ref function _deferred_grow_zone. This way we are
- * making sure that it is not inlined into permanent text section.
  */
 bool __init deferred_grow_zone(struct zone *zone, unsigned int order)
 {
_

Patches currently in -mm which might be from bhe@redhat.com are

documentation-kdump-clean-up-the-outdated-description.patch
kexec-fix-the-unexpected-kexec_dprintk-macro.patch
crash-add-prefix-for-crash-dumping-messages.patch

