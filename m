Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A366E21E3D9
	for <mm-commits@vger.kernel.org>; Tue, 15 Oct 2024 23:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729036677; cv=none; b=op4TWfFAW47WvhIr1RjkrYQ9nEoBSeQyJhDWX8s5S5tNvkVb4oME4B5wNOIRBQ9mb3qGAiy9oaa7Yhq7Vbn9vrpEIXUQfEWCfCeBjD15rNKgZDQjCmlWEBPM7qo1+eeozsn/uUB2FG7P64N90eZwcgC3+6f6zqNflyYPpID0eo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729036677; c=relaxed/simple;
	bh=/fQvRKIk3ZOzO6NYWh5R7lEPIMuzwvu1fNqw35ehs5o=;
	h=Date:To:From:Subject:Message-Id; b=ukUromotl/9oQYVCrGIQUBvCNkXSSlm0KvfPYMgW9CjjxFu32kmSdERPOUXlZLUzBmOZfAZpnTa5lZDPpVOXa6Muh4x/TB1Ja5OO1693K1rCyZtMu9o+I5jJ/mCHRcHysttTUo8jbgAuHN7JHYYm1Yt1+WfxeOgzYUSLmbI2ILA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZUrpm02p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZUrpm02p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F01DC4CEC6;
	Tue, 15 Oct 2024 23:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729036677;
	bh=/fQvRKIk3ZOzO6NYWh5R7lEPIMuzwvu1fNqw35ehs5o=;
	h=Date:To:From:Subject:From;
	b=ZUrpm02pY1H6ueKWq+3B2uvnlTC+NTj9ym0Y7f7kd+bxwKry518UGDY0ouD7CcFT4
	 5X7/WQUIyS3NKaYS7UBCI0gnm5QabqzEq+kSlCR31KjmSMG7WIzhsM41NxCLtY5QGS
	 K1YZ3k+vJlMzKPcgGuYI18gNw1IFVldoSFe417MM=
Date: Tue, 15 Oct 2024 16:57:56 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-not-necessary-to-check-index-last-again.patch added to mm-unstable branch
Message-Id: <20241015235757.3F01DC4CEC6@smtp.kernel.org>
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
Date: Tue, 15 Oct 2024 23:39:08 +0000

Patch series "fix mas_new_root()".

When overwriting the whole range with NULL, current behavior is not correct.


This patch (of 2):

Before calling mas_new_root(), the range has been checked.

Link: https://lkml.kernel.org/r/20241015233909.23592-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20241015233909.23592-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-not-necessary-to-check-index-last-again
+++ a/lib/maple_tree.c
@@ -3670,7 +3670,7 @@ static inline void mas_new_root(struct m
 	void __rcu **slots;
 	unsigned long *pivots;
 
-	if (!entry && !mas->index && mas->last == ULONG_MAX) {
+	if (!entry) {
 		mas->depth = 0;
 		mas_set_height(mas);
 		rcu_assign_pointer(mas->tree->ma_root, entry);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

maple_tree-i-is-always-less-than-or-equal-to-mas_end.patch
maple_tree-goto-complete-directly-on-a-pivot-of-0.patch
maple_tree-remove-maple_big_nodeparent.patch
maple_tree-memset-maple_big_node-as-a-whole.patch
maple_tree-root-node-could-be-handled-by-p_slot-too.patch
maple_tree-clear-request_count-for-new-allocated-one.patch
maple_tree-total-is-not-changed-for-nomem_one-case.patch
maple_tree-simplify-mas_push_node.patch
maple_tree-not-necessary-to-check-index-last-again.patch
maple_tree-one-single-entry-couldnt-represent-the-whole-range.patch

