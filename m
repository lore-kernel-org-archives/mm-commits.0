Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2952475F2
	for <mm-commits@vger.kernel.org>; Tue, 24 Jun 2025 21:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750799571; cv=none; b=ReuPvC+7pZo1nc7jzCgsEvqdMK/b5X5Vq+s5hgOCfzP7CSrZyWNlnCgvdZD0XHSr713CIbAsL/ZSOD9XvRG7jLFK1HEAFTYIPHxGdox3KyogoKpGa1RY/8jh5kGVR63jTmu56bEbyvXEO1yNpuqiXegNqNP6XvUOSoAzfMiNZ3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750799571; c=relaxed/simple;
	bh=aGqZ8NGCIGKxwjt9X9Ks4ataRXYemsFUUpTxiD4/Bl4=;
	h=Date:To:From:Subject:Message-Id; b=orWHmMxmp8Y7KiQrTEhr3qyQi9fFZvnqP4Xb/WpaRRe276QnNpTGJaBj5SMuFzn3hP9gYVP1q4ibEdDfpa0Ac2KCfnL0vkmaC17KLr3xdi2jeMk4cwxtSamRzI+qnkxkkw6ZdahcXYPaxN9OeOI0RT8lqotqbnI4z6jL68rEN5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DmuLrEIZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DmuLrEIZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0A7C4CEE3;
	Tue, 24 Jun 2025 21:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750799570;
	bh=aGqZ8NGCIGKxwjt9X9Ks4ataRXYemsFUUpTxiD4/Bl4=;
	h=Date:To:From:Subject:From;
	b=DmuLrEIZa1FHtPXr09zEa7+fIx7bfkIsi72zzKZJwlyjYnd2RoyPf7/4PhKFxsjCd
	 wZ/wx/7nPBkLMWLQ/dCPmBotf85dFkqGTPLqO03VVgyeaNt0Yj7c5VLhVXgr0MXYIr
	 95gX0XSma3SB8kJ9SGN4zFzdQ62MzN91y/+MS7pA=
Date: Tue, 24 Jun 2025 14:12:50 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,oliver.sang@intel.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-testing-for-restoring-maple-state-to-active.patch added to mm-new branch
Message-Id: <20250624211250.AD0A7C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: add testing for restoring maple state to active
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-add-testing-for-restoring-maple-state-to-active.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-testing-for-restoring-maple-state-to-active.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
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

tools-testing-radix-tree-test-maple-tree-chaining-mas_preallocate-calls.patch
maple_tree-fix-status-setup-on-restore-to-active.patch
maple_tree-add-testing-for-restoring-maple-state-to-active.patch

