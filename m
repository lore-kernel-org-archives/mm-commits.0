Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD04B3A1DB
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854808; cv=none; b=UuuCl8ahqHovIdajEJXmB2A3Tjq9ntqj+RK5PyAFFhKoJZeL3fBMJqn2Xun71eT/KpOu2p3cnWOkaNzuh4/sguZ38Rl7X7oUgm4u+kb6j42PzH+arbuk1jpLv5Fq1XSDqxKo2FeiKzc3N30MRg5GwTfj3uxiU0KigwdYyfcxZR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854808; c=relaxed/simple;
	bh=lu/2uXQoApugDRJW0WVynpY+eCIGwunl08W01AtLWis=;
	h=Date:To:From:Subject:Message-Id; b=Kx5mC1ATHFbGrjJu+pIbyX+CQoEIHUmqe/cK2Tes+AahiwFf7kx4jg3fsqVjKbBpD5JyMJjYEiw8A69wrtuHv5Z2DBUJl6sN0WTguTNdrREOy+QrLI3zyjHmqi+eumPX5cu55lttFHvzm8WlL1Gs5IWO3Slbm3bbBmWl9FUjGJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E4q+CG59; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E4q+CG59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB77FC4CECF;
	Wed,  6 Nov 2024 01:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854808;
	bh=lu/2uXQoApugDRJW0WVynpY+eCIGwunl08W01AtLWis=;
	h=Date:To:From:Subject:From;
	b=E4q+CG59BZK/fOPEjlcH8rrqOqItpU8/xgNTJpZEiOYaz6zDPbqnZnCks+4PzWSuo
	 +qsq0hS8fhAw2nCDlbdLC0UAi9jDakNy74VDX6xdDQwcPbbieCxJz7UvoA9jVDcNe6
	 0fTITsDo7tjBLIUstAFVQmFIGE5OnO4k4aS1/Rz8=
Date: Tue, 05 Nov 2024 17:00:08 -0800
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-clear-request_count-for-new-allocated-one.patch removed from -mm tree
Message-Id: <20241106010008.AB77FC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: clear request_count for new allocated one
has been removed from the -mm tree.  Its filename was
     maple_tree-clear-request_count-for-new-allocated-one.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-mlock-set-the-correct-prev-on-failure.patch
maple_tree-print-empty-for-an-empty-tree-on-mt_dump.patch
maple_tree-the-return-value-of-mas_root_expand-is-not-used.patch
maple_tree-not-necessary-to-check-index-last-again.patch
maple_tree-refine-mas_store_root-on-storing-null.patch
maple_tree-add-a-test-checking-storing-null.patch

