Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F31173357
	for <mm-commits@vger.kernel.org>; Tue, 15 Oct 2024 23:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729033687; cv=none; b=GtneIoU+riRDz/DR14pEZLC+65WpsuyKnDL6+3b9BZetW2EVjnkKQ7HtM9H4BFjnl3nqhgc6Qs18efi6GWOEcSnQB4V3L9cjveBGuB6Zt0GfsJTW3GqrFBZfZWb0B3TW6SFfc/rngGKEtvpWH6QSI8mXRI1PSeC1BwEHF13stXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729033687; c=relaxed/simple;
	bh=9l+9wsh9SOFY76UM8M3rR8C1RzxaGntUqc2aWquhMmU=;
	h=Date:To:From:Subject:Message-Id; b=nlGMnmL9JkHRRL6g3BkmviTUHD8ohYvqg2E3tyQ3dhH0ciALWstY9EposV5i5ukpfo+AigK/EkFfC/VRfpqS9PSc2L7f4HNUuvnS5fkkU4R0eYJ8CCH43vcXRoOgfOXruVqtwOfwW7NEVBgmWWy4zpxFCn6kVSgHHLNxsjNE1LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MF+SsrHW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MF+SsrHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 513A6C4CEC6;
	Tue, 15 Oct 2024 23:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729033687;
	bh=9l+9wsh9SOFY76UM8M3rR8C1RzxaGntUqc2aWquhMmU=;
	h=Date:To:From:Subject:From;
	b=MF+SsrHWw7P1FjR6EktxEvrctfYS4oFCGnjo/s8z+Tu6UPGLWqsjUAMuOU1dSYhvy
	 57NvBTXD1ouCZ3muoYuObcotD3HEdpjx7sK9ffHfGm82fSzLm9mJi8P4ZLjOa2sCfM
	 gd6KVlFAY/znHltMkbnkP3OGIR8DDniHyWNr4mEE=
Date: Tue, 15 Oct 2024 16:08:06 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-clear-request_count-for-new-allocated-one.patch added to mm-unstable branch
Message-Id: <20241015230807.513A6C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: clear request_count for new allocated one
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-clear-request_count-for-new-allocated-one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-clear-request_count-for-new-allocated-one.patch

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
Subject: maple_tree: clear request_count for new allocated one
Date: Tue, 15 Oct 2024 12:07:44 +0000

Patch series "maple_tree: simplify mas_push_node()", v2.

When count is not 0, we know head is valid.  So we can put the assignment
in if (count) instead of checking the head pointer again.

Also count represents current total, we can assign the new total by
increasing the count by one.


This patch (of 3):

If this is not a new allocated one, the request_count has already been
cleared in mas_set_alloc_req().

Link: https://lkml.kernel.org/r/20241015120746.15850-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20241015120746.15850-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-clear-request_count-for-new-allocated-one
+++ a/lib/maple_tree.c
@@ -1265,11 +1265,11 @@ static inline void mas_alloc_nodes(struc
 
 		mas->alloc = node;
 		node->total = ++allocated;
+		node->request_count = 0;
 		requested--;
 	}
 
 	node = mas->alloc;
-	node->request_count = 0;
 	while (requested) {
 		max_req = MAPLE_ALLOC_SLOTS - node->node_count;
 		slots = (void **)&node->slot[node->node_count];
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

