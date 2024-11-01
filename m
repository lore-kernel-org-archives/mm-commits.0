Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7487BBE4F
	for <mm-commits@vger.kernel.org>; Fri,  1 Nov 2024 00:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730420445; cv=none; b=BEsOFjaFrFHcUu3WDr8or0TKMalsyhaJ3vLDP+K2KMA/1plzhi4tx+z5XDAspggLRuRL5wWaaC7iJPMNcAjo9P9qx4PkOhQy6JS/X1x2oW8C2RGDzNrG2mPg3jyZRxuK7NkOCwU5Thvh4qAZfMcZZYPT3CmeBaXvblNZnyTmrnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730420445; c=relaxed/simple;
	bh=ZdLD0hdcC/Evde5hFQJMmGMaKXL7yzTdp1Cov7EBbVU=;
	h=Date:To:From:Subject:Message-Id; b=pgxFci+R+acTHEKFRJ3vvDR5f3TUpN0bRHeIo0O8iOm3rNLvbfNVgTAiEB9wm8+pyT1oNxoOcAI7L7cNXsi5mktW3TrgXIP7hXqREauYLmRv5RwV06OJzyI2nRB0IjTF2glh0XhS2T8nFHLIalKBSlghGxLJ/9Jx9CQGBEVUjg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NIiIX+qK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NIiIX+qK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97D2C4CEC3;
	Fri,  1 Nov 2024 00:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730420444;
	bh=ZdLD0hdcC/Evde5hFQJMmGMaKXL7yzTdp1Cov7EBbVU=;
	h=Date:To:From:Subject:From;
	b=NIiIX+qKfQ7Yk6Ap08HmHw3XT+LV4qzglr5MpNBrd340RtJlRvUwaRZZAhldYn+02
	 K9i2PPWWcQl7UsdjcwlDRkx55foc9P0lDgBEdaLX7Dh+TEdss2/dNhBg7moY4TN6CX
	 VGJbZLVNQp6qOnXEw1SzKR3Nim20p8vQWkVnDbMU=
Date: Thu, 31 Oct 2024 17:20:43 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-not-necessary-to-check-index-last-again.patch added to mm-unstable branch
Message-Id: <20241101002043.E97D2C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: not necessary to check index/last again
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-not-necessary-to-check-index-last-again.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-not-necessary-to-check-index-last-again.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: not necessary to check index/last again
Date: Thu, 31 Oct 2024 23:16:25 +0000

Before calling mas_new_root(), the range has been checked.

Link: https://lkml.kernel.org/r/20241031231627.14316-4-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-not-necessary-to-check-index-last-again
+++ a/lib/maple_tree.c
@@ -3670,7 +3670,9 @@ static inline void mas_new_root(struct m
 	void __rcu **slots;
 	unsigned long *pivots;
 
-	if (!entry && !mas->index && mas->last == ULONG_MAX) {
+	WARN_ON_ONCE(mas->index || mas->last != ULONG_MAX);
+
+	if (!entry) {
 		mas->depth = 0;
 		mas_set_height(mas);
 		rcu_assign_pointer(mas->tree->ma_root, entry);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-mlock-set-the-correct-prev-on-failure.patch
maple_tree-i-is-always-less-than-or-equal-to-mas_end.patch
maple_tree-goto-complete-directly-on-a-pivot-of-0.patch
maple_tree-remove-maple_big_nodeparent.patch
maple_tree-memset-maple_big_node-as-a-whole.patch
maple_tree-root-node-could-be-handled-by-p_slot-too.patch
maple_tree-clear-request_count-for-new-allocated-one.patch
maple_tree-total-is-not-changed-for-nomem_one-case.patch
maple_tree-simplify-mas_push_node.patch
maple_tree-calculate-new_end-when-needed.patch
maple_tree-remove-sanity-check-from-mas_wr_slot_store.patch
mm-vma-the-pgoff-is-correct-if-can_merge_right.patch
maple_tree-print-empty-for-an-empty-tree-on-mt_dump.patch
maple_tree-the-return-value-of-mas_root_expand-is-not-used.patch
maple_tree-not-necessary-to-check-index-last-again.patch
maple_tree-refine-mas_store_root-on-storing-null.patch
maple_tree-add-a-test-checking-storing-null.patch

