Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E84218589
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409696; cv=none; b=L/jdxykrwv7b4GnUj3yO9bP/lFEldjWV2lEXAsRGHqDrhihezu4ape+HOiTTH/d0uahqo6kjEbqLVtsTjjWy2kPeiMfp9fiL6VOoE8e3mzHBF7vfx3uIFPQFlTvtJounwMDN8LTW0CjlYFaYA4Xl4mW4RhaoracdSSfOYriXSXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409696; c=relaxed/simple;
	bh=yrXYrLYKuzU2nPDaD7n2XV3RX3bc2TwYyfX8YBMHBQk=;
	h=Date:To:From:Subject:Message-Id; b=ucIED8biXLzr/CygKPbsHMY6z9EoOwbdk+G9Uz4MVaV8ceIITKubYo5GJH7iQ8j+mIHkX1KjQ0Fk7eMtTIWYpuo2tfn59BdJnNN+NXm4LCoTclPFkWriZTl/0QVKxiTRufscUVhLgLMhuT0PdbzL+3nT5HC6PZjY+XgSaWGBzlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f0b4sr+c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f0b4sr+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EE6C4CEED;
	Fri, 25 Jul 2025 02:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409696;
	bh=yrXYrLYKuzU2nPDaD7n2XV3RX3bc2TwYyfX8YBMHBQk=;
	h=Date:To:From:Subject:From;
	b=f0b4sr+cJoGOnM1qif6goDyiMt7PiqmZDvQrrDiVCNnSMoeP/ekmwla83tVQTxUxB
	 czC7pUR05aPiCYWL+7bQhO8uyQlMLcWJefPQbFOzFnNjjhSFOOeTbEYyIQCm/v2KTP
	 /8X7o9E6bFzBsZ5VOZBavK/kQDsQryiw8jKszC34=
Date: Thu, 24 Jul 2025 19:14:55 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,hannes@cmpxchg.org,bhe@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-remove-stale-comment-stale-comment-in-cluster_alloc_swap_entry.patch removed from -mm tree
Message-Id: <20250725021456.75EE6C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: remove stale comment stale comment in cluster_alloc_swap_entry()
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-stale-comment-stale-comment-in-cluster_alloc_swap_entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: swap: remove stale comment stale comment in cluster_alloc_swap_entry()
Date: Thu, 22 May 2025 20:25:54 +0800

As cluster_next_cpu was already dropped, the associated comment is stale
now.

Link: https://lkml.kernel.org/r/20250522122554.12209-5-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swap-remove-stale-comment-stale-comment-in-cluster_alloc_swap_entry
+++ a/mm/swapfile.c
@@ -956,9 +956,8 @@ new_cluster:
 	}
 
 	/*
-	 * We don't have free cluster but have some clusters in
-	 * discarding, do discard now and reclaim them, then
-	 * reread cluster_next_cpu since we dropped si->lock
+	 * We don't have free cluster but have some clusters in discarding,
+	 * do discard now and reclaim them.
 	 */
 	if ((si->flags & SWP_PAGE_DISCARD) && swap_do_scheduled_discard(si))
 		goto new_cluster;
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


