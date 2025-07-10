Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA42285CA6
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126384; cv=none; b=XTU/KMch0c0Vmj6mktm8oZFQivIHrBidbxi3RqG++eSiUd40P1aIWLoy0f0yfTbnrDKfac6ZPMCygekh4zpzsfVl+b0zKYxRwZCUnrRULMjepAnc0cb72Vjz35LT+bejoNVvg0i3tiyN15Ash7aNPnBB+xIjHwu9xiWiO0lrOvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126384; c=relaxed/simple;
	bh=G80SUnP7WNf/9GY8ArqOzrjfjNGDtDZDX5TpxQgXuiM=;
	h=Date:To:From:Subject:Message-Id; b=I+bLtab5SREZ8hS4pIbQOsnJUkjlsWODrxjPGBpzBsy7TBsYYSgmhIbdRqWCwwJQ1GqfvmPoOaJYO8ra9mpIwOEd9j8KZIFml32RFVG3Y8EGjODu1jMGmb+Mlvnw9XpmqiBJO2FIQdqV0Mmiw+Y55TaSNvY3kd0vI+91JCPf/Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tmKSmdoe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tmKSmdoe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EEBC4CEE3;
	Thu, 10 Jul 2025 05:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126384;
	bh=G80SUnP7WNf/9GY8ArqOzrjfjNGDtDZDX5TpxQgXuiM=;
	h=Date:To:From:Subject:From;
	b=tmKSmdoeCE2Xht7kQ9ATBB81eVsKv7NL/7L+JBi5er7MXsETdQYOX8TIN86O+IjkQ
	 8mYA/SQKRz4ZCVVVrH86aLuejAubpIoagx6yw5FDmVPCW+W1cm6i1NuI9+gaa6Y3+t
	 lh/Qr3nUPz37RGbHqoT6IJ+Z4h2zjvhOm/saFTvA=
Date: Wed, 09 Jul 2025 22:46:22 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-add-testing-for-restoring-maple-state-to-active.patch removed from -mm tree
Message-Id: <20250710054624.70EEBC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: add testing for restoring maple state to active
has been removed from the -mm tree.  Its filename was
     maple_tree-add-testing-for-restoring-maple-state-to-active.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: add testing for restoring maple state to active
Date: Tue, 24 Jun 2025 11:48:23 -0400

Restoring maple status to ma_active on overflow/underflow when mas->node
was NULL could have happened in the past, but was masked by a bug in
mas_walk().  Add test cases that triggered the bug when the node was
mas->node prior to fixing the maple state setup.

Add a few extra tests around restoring the active maple status.

Link: https://lore.kernel.org/all/202506191556.6bfc7b93-lkp@intel.com/
Link: https://lkml.kernel.org/r/20250624154823.52221-2-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_maple_tree.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

--- a/lib/test_maple_tree.c~maple_tree-add-testing-for-restoring-maple-state-to-active
+++ a/lib/test_maple_tree.c
@@ -3177,6 +3177,7 @@ static noinline void __init check_state_
 	void *entry, *ptr = (void *) 0x1234500;
 	void *ptr2 = &ptr;
 	void *ptr3 = &ptr2;
+	unsigned long index;
 
 	/* Check MAS_ROOT First */
 	mtree_store_range(mt, 0, 0, ptr, GFP_KERNEL);
@@ -3707,6 +3708,37 @@ static noinline void __init check_state_
 	MT_BUG_ON(mt, !mas_is_active(&mas));
 
 	mas_unlock(&mas);
+	mtree_destroy(mt);
+
+	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
+	mas_lock(&mas);
+	for (int count = 0; count < 30; count++) {
+		mas_set(&mas, count);
+		mas_store_gfp(&mas, xa_mk_value(count), GFP_KERNEL);
+	}
+
+	/* Ensure mas_find works with MA_UNDERFLOW */
+	mas_set(&mas, 0);
+	entry = mas_walk(&mas);
+	mas_set(&mas, 0);
+	mas_prev(&mas, 0);
+	MT_BUG_ON(mt, mas.status != ma_underflow);
+	MT_BUG_ON(mt, mas_find(&mas, ULONG_MAX) != entry);
+
+	/* Restore active on mas_next */
+	entry = mas_next(&mas, ULONG_MAX);
+	index = mas.index;
+	mas_prev(&mas, index);
+	MT_BUG_ON(mt, mas.status != ma_underflow);
+	MT_BUG_ON(mt, mas_next(&mas, ULONG_MAX) != entry);
+
+	/* Ensure overflow -> active works */
+	mas_prev(&mas, 0);
+	mas_next(&mas, index - 1);
+	MT_BUG_ON(mt, mas.status != ma_overflow);
+	MT_BUG_ON(mt, mas_next(&mas, ULONG_MAX) != entry);
+
+	mas_unlock(&mas);
 }
 
 static noinline void __init alloc_cyclic_testing(struct maple_tree *mt)
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


