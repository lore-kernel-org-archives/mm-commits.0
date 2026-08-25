Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD1A37DEBA
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622986; cv=none; b=XBInUJXkol0Kq2PMB/spT2nIWFDorJP0UGAQq7hhGHszolMDUSOB8hbxkRw5N3c6qToCU3MvbioK41RgbLL0tv+bQpa9j5i+0tZEXKBA24BxtgrU01IaHnW6UjsaxMgNQjnP3KkNlfVXA3ivvsfBhtihBO0nBOrjeSl7rOS1U34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622986; c=relaxed/simple;
	bh=00Kmw91RU5FcwIKZZPHBhwcNlOU++oV3bi+DyM8o4gI=;
	h=Date:To:From:Subject:Message-Id; b=gNltyP3RAqQ9LR3VggP8AmqYqB+xAe/WBZvuIgwAuQwQ0RER7HJqFYnChCl4A0T+zMceT52z42eaj1VxtXtONw3Rv4CKjn91hHWICjTqaeDC2zHXSt307w2AVZWeUyuKNJll+QCPAyMzCwLWJ4yLKklXDgJv64QNMBGYBaTBS6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oD0jeWmm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oD0jeWmm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A461F000E9;
	Tue, 25 Aug 2026 01:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622985;
	bh=m1adPe1GKOP/eRtoyOMVgSeD8warpyjk0V1IBYuNE4I=;
	h=Date:To:From:Subject;
	b=oD0jeWmmfp3IGoKvTQk0hxZUicWf9KpEa4scwAStkFGw5dzkHLyjAQkj+zx/CUoBV
	 lIwK5TkVNWwAkmxFa03eRQS8zkufenCcLkwSnj0rEqJME9xqnxVum79pxS+SfwRCO3
	 /mjpXVRcLMacUGNsqrFQp5cKphckGGaN16XExLiU=
Date: Mon, 24 Aug 2026 18:56:24 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,leitao@debian.org,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-change-two-gfp-flags-in-tests.patch removed from -mm tree
Message-Id: <20260825015625.22A461F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: change two GFP flags in tests
has been removed from the -mm tree.  Its filename was
     maple_tree-change-two-gfp-flags-in-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: change two GFP flags in tests
Date: Fri, 21 Aug 2026 15:26:24 -0400

The GFP flags in two tests are obviously incorrect.  Make the tests
correctly run by updating the GFP flags.

Link: https://lore.kernel.org/all/d9cbb89faa5bdb71d451781d214a51ce8923a83e.camel@perches.com/
Link: https://lore.kernel.org/20260821192627.4085470-17-liam@infradead.org
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Reported-by: Joe Perches <joe@perches.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/maple.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/radix-tree/maple.c~maple_tree-change-two-gfp-flags-in-tests
+++ a/tools/testing/radix-tree/maple.c
@@ -35234,7 +35234,7 @@ static noinline void __init check_preall
 	mt_set_non_kernel(1);
 	/* Spanning store */
 	mas_set_range(&mas, 1, 100);
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL & GFP_NOWAIT) == 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_NOWAIT) == 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated != 0);
@@ -35257,7 +35257,7 @@ static noinline void __init check_preall
 	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
 	mas_set_range(&mas, 0, 200);
 	mt_set_non_kernel(1);
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL & GFP_NOWAIT) == 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_NOWAIT) == 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated != 0);
_

Patches currently in -mm which might be from liam@infradead.org are


