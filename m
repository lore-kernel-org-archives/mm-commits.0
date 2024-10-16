Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2F8187555
	for <mm-commits@vger.kernel.org>; Wed, 16 Oct 2024 20:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729110781; cv=none; b=M0+2E5SvrQVMqvrSCHw29PanIiNFIOy/3hUMy1J2cFTs7GyUUBNz5BEX1jGN32JMeTX/G36j8IssOjI3uekMN6NVV4UK34H2wFZCG9xZV/IVKja8OZaoWL/0ID+16ngNq7G++ZHhJ/xmcecDo3bohhLZaI+7ACq9AwKUPSRF+9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729110781; c=relaxed/simple;
	bh=F+Q1kP7fPcBNcX1YlQrkYHwcpTuOX9Icy6VZ7z6DxkI=;
	h=Date:To:From:Subject:Message-Id; b=S6k4PWxJo51hQBiLoW4ite1+g+qiBwamO8TgRHI3NVVKcMLel9eQSEFf8r24JVO8gh5EapOJixjeIbXc5J6pweRWSS66NkUvgdR3bRwyB2BiPRfOSzM1yDNEFS74CeHgH416Df3BwUH+5m30Xrw1f1KGOazuolRhrCSUJE519Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yPkiOuqe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yPkiOuqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC26C4CEC5;
	Wed, 16 Oct 2024 20:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729110780;
	bh=F+Q1kP7fPcBNcX1YlQrkYHwcpTuOX9Icy6VZ7z6DxkI=;
	h=Date:To:From:Subject:From;
	b=yPkiOuqeAxl2EHUjnRKseG725LH+6f2dq5/xJiCpI5iqSNnFuTjAtqz5pSJfWjh9C
	 Tvu0Mq3hEjLrM+dtsfY+Do4yAfpDl+ZjMR9vvhGO6+msVCrcJE2TFYyN2Oj6HMBE2e
	 cJsiMsiKhhvRqIBD3uRkxAo7KJLGRgSr362kZw/w=
Date: Wed, 16 Oct 2024 13:32:59 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] maple_tree-one-single-entry-couldnt-represent-the-whole-range.patch removed from -mm tree
Message-Id: <20241016203300.9AC26C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: one single entry couldn't represent the whole range
has been removed from the -mm tree.  Its filename was
     maple_tree-one-single-entry-couldnt-represent-the-whole-range.patch

This patch was dropped because an updated version will be issued

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
maple_tree-calculate-new_end-when-needed.patch
maple_tree-remove-sanity-check-from-mas_wr_slot_store.patch

