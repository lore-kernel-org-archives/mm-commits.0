Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EFE21E3D9
	for <mm-commits@vger.kernel.org>; Tue, 15 Oct 2024 23:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729036680; cv=none; b=Du8RxQ1wc/R0Ke9atfljwg68Mi2PF3Rhn5T3ndwlBBE7dshqgc1ySO+QHghk8IUw+rcMlMgGNc4rBKukuk7QoZb1Ohn2kunb5TusnzQOaFBUgS1EZT2DbQs++9vusj0BP+yTE3Gbz65IsQqXsSIccnM/Ih8lNu61RBO9wKNZeCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729036680; c=relaxed/simple;
	bh=cJqs7j12QPr26WxZhmBtirVPdTVgfKMlAv5clKNAvb8=;
	h=Date:To:From:Subject:Message-Id; b=AEH0Oeb5kLwp4yLkV1gn2zV6QxYE8Gu8XbbiCkdZFNKnepqtWNnLnBMoMXqDU1BVph0rxKW5s4Tx7afIqjYsjZ7cfb4AoMVnTNGiPaRgvS32bb2zIW0jLChLw48tdjRXJeCmLCHpk3Z7Utu8e+7HGD+lpwEHAEtT9VISJiy3cqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yK+tSzCr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yK+tSzCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEB2C4CEC6;
	Tue, 15 Oct 2024 23:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729036679;
	bh=cJqs7j12QPr26WxZhmBtirVPdTVgfKMlAv5clKNAvb8=;
	h=Date:To:From:Subject:From;
	b=yK+tSzCrejV/xKIdfmVLhxETwmZtKN6pR+KW9wQWEM/W1+xEWmOpLCYw9FqU9betm
	 apJ3cDTq0ZMeob1OoCI3WgGrFYVXcckMeLNPn8hFpSITJY8zgo74R7VgYeDlG/jLW7
	 gTXy0r1u829JBGYTJq79K0to+s4LQHXzznwobaaE=
Date: Tue, 15 Oct 2024 16:57:58 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-one-single-entry-couldnt-represent-the-whole-range.patch added to mm-unstable branch
Message-Id: <20241015235759.2CEB2C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: one single entry couldn't represent the whole range
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-one-single-entry-couldnt-represent-the-whole-range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-one-single-entry-couldnt-represent-the-whole-range.patch

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
Subject: maple_tree: one single entry couldn't represent the whole range
Date: Tue, 15 Oct 2024 23:39:09 +0000

The current behavior of overwriting the whole range with NULL is not
correct.

For example, we store range [0, ULONG_MAX] to a new tree:

  mas_set_range(&ms, 0, ULONG_MAX);
  mas_store(&ms, NULL);
  mt_dump(mt, mt_dump_dec);

The dump result shows:

  maple_tree(0x7ffd9506e350) flags 7, height 1 root 0x61500000010e
  0-18446744073709551615: node 0x615000000100 depth 0 type 1 parent 0x7ffd9506e351 contents: (nil) 18446744073709551615 (nil) 0 (nil) 0 (nil) 0 (nil) 0 (nil) 0 (nil) 0 (nil) 0 (nil) 0 (nil) 0 (nil) 0 (nil) 0 (nil) 0 (nil) 0 (nil) 0 (nil)
    0-18446744073709551615: (nil)

But if we do the store on a tree with value:

  mas_set_range(&ms, 5, ULONG_MAX);
  mas_store(&ms, NULL);
  mas_set_range(&ms, 0, ULONG_MAX);
  mas_store(&ms, NULL);
  mt_dump(mt, mt_dump_dec);

The dump result shows:

  maple_tree(0x7ffd9506e350) flags 3, height 0 root (nil)
  0: (nil)

We can see even we write the same range, these two trees are different.
The second tree only has an entry represent range [0, 0] instead of range
[0, ULONG_MAX], which is not correct.

The good news is it doesn't affect user, because mtree_load() still
return NULL for each index.

Let's create a node to represent the entire range even for NULL entry.

Link: https://lkml.kernel.org/r/20241015233909.23592-3-richard.weiyang@gmail.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/lib/maple_tree.c~maple_tree-one-single-entry-couldnt-represent-the-whole-range
+++ a/lib/maple_tree.c
@@ -3670,14 +3670,6 @@ static inline void mas_new_root(struct m
 	void __rcu **slots;
 	unsigned long *pivots;
 
-	if (!entry) {
-		mas->depth = 0;
-		mas_set_height(mas);
-		rcu_assign_pointer(mas->tree->ma_root, entry);
-		mas->status = ma_start;
-		goto done;
-	}
-
 	node = mas_pop_node(mas);
 	pivots = ma_pivots(node, type);
 	slots = ma_slots(node, type);
@@ -3690,7 +3682,6 @@ static inline void mas_new_root(struct m
 	mas_set_height(mas);
 	rcu_assign_pointer(mas->tree->ma_root, mte_mk_root(mas->node));
 
-done:
 	if (xa_is_node(root))
 		mte_destroy_walk(root, mas->tree);
 
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

