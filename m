Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BB713D52B
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854714; cv=none; b=nKiq8An6H/aWTtdv32qSk6+5WunAdAhrxzpqON651hy9X496O6jUV1Te/UhL96YposXG41uEKpGPcp7YPyl+Ro3Y8RRKfHl/yAoDVPQUkKzC5MJTKySlswH9s4owKRZpESMjrzK/V2ntLKi5XlQ76jbTx5uflgURUuMSCfDRooc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854714; c=relaxed/simple;
	bh=sQsUW6QFDMD4goUc51VeONZKdSgIuB8XPmW8sANpR7U=;
	h=Date:To:From:Subject:Message-Id; b=gG0TVhNcF2P7CO3Dxtonp+eptxaEBE3d2wBWm5ry0y4nFSw4P2PhejpE1Y4eAVhVBwgD9R6KRLxVWkZM28hcCYXglga00XuWvXRDm/H8So+RRlbOR2+hCEcQXTKgkNzanp/J9yTMJCX1zcp8LRDgSorfXqJQ9VY/o6UtxLXvpU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kcrt6fBE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kcrt6fBE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1536C4CED1;
	Wed,  6 Nov 2024 00:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854714;
	bh=sQsUW6QFDMD4goUc51VeONZKdSgIuB8XPmW8sANpR7U=;
	h=Date:To:From:Subject:From;
	b=kcrt6fBEubrxWdhw/A3B1z5xj7uq3tjkXwD+80GeZdgoJNDrrLBoTtHomnPFrpEyB
	 Zq+u2foR/lPfd5ZcdoTsTE5NmMVicKhygw8b4DoQ4xCooqAOE+2F2yC9mx7NytwBGI
	 Pvj44N6zvD8uWcUUNzi8EImgDzxR59vHcTCrQQ+4=
Date: Tue, 05 Nov 2024 16:58:33 -0800
To: mm-commits@vger.kernel.org,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-goto-complete-directly-on-a-pivot-of-0.patch removed from -mm tree
Message-Id: <20241106005833.E1536C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: goto complete directly on a pivot of 0
has been removed from the -mm tree.  Its filename was
     maple_tree-goto-complete-directly-on-a-pivot-of-0.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: goto complete directly on a pivot of 0
Date: Wed, 11 Sep 2024 14:27:59 +0000

When we break the loop after assigning a pivot, the index i/j is not
changed.  Then the following code assign pivot, which means we do the
assignment with same i/j by mas_safe_pivot.

Since the loop condition is (i < piv_end), from which we can get i is less
than mt_pivots[mt].  It implies mas_safe_pivot() return pivot[i] which is
the same value we get in loop.

Now we can conclude it does a redundant assignment on a pivot of 0.  Let's
just go to complete to avoid it.

Link: https://lkml.kernel.org/r/20240911142759.20989-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-goto-complete-directly-on-a-pivot-of-0
+++ a/lib/maple_tree.c
@@ -1943,7 +1943,7 @@ static inline void mas_mab_cp(struct ma_
 	for (; i < piv_end; i++, j++) {
 		b_node->pivot[j] = pivots[i];
 		if (unlikely(!b_node->pivot[j]))
-			break;
+			goto complete;
 
 		if (unlikely(mas->max == b_node->pivot[j]))
 			goto complete;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-mlock-set-the-correct-prev-on-failure.patch
maple_tree-print-empty-for-an-empty-tree-on-mt_dump.patch
maple_tree-the-return-value-of-mas_root_expand-is-not-used.patch
maple_tree-not-necessary-to-check-index-last-again.patch
maple_tree-refine-mas_store_root-on-storing-null.patch
maple_tree-add-a-test-checking-storing-null.patch

