Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D7C43ACB
	for <mm-commits@vger.kernel.org>; Tue, 15 Oct 2024 04:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728967096; cv=none; b=ntpFQ17sqzzGuJ7yrHCm6f2n1IfqwuNG0Tqth87XdPfaS4nnh3y7lluuzyuHRO/hBNs3e0K+kAIR1Sw9MRK56aBw02wUhRI1EZc6HSbD1XtNjj/+L0YBbyhU9PP+fGAffDnNXrmQVE6xCNwIwUZgHCVqTg1rST1XY8XQ+ENnt/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728967096; c=relaxed/simple;
	bh=1YIldJnfLrszUBNjmOpYmlQXfih6aw7JDsEBoUAVLXw=;
	h=Date:To:From:Subject:Message-Id; b=uH155DuVyPw/RvbZ5/iJDmxRD9o98jyieOyINScD0QXv2DPYRPsFo3Luhj/+tjXMW4pHj3MbrUPRVXKFHjrMr1SWbKd5QAZAy4oynoitOyIBSRyzEBQXRhvJVSy+kTUv+345Z5U63z3kUaPK4xZ3tnnu08nwsO0ZLv7mkVbfxNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X/l5Q657; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X/l5Q657"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7602DC4CEC7;
	Tue, 15 Oct 2024 04:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728967095;
	bh=1YIldJnfLrszUBNjmOpYmlQXfih6aw7JDsEBoUAVLXw=;
	h=Date:To:From:Subject:From;
	b=X/l5Q657AIU8TpbP0Yq526Apl0eJ87b2UCtGtoMxcIutKzDmLS7rvvHJ3gmg/gPil
	 FjQR1c0Jhyy0AKY0OJdgvUFXPhQhs7q8l9ZqidBW7+vvcN2xYMm3VC5b1nCw4nCSH6
	 C9O4xKoNw6HUoWwq6kBVgwZuM6/VVfwtAMp1nYBg=
Date: Mon, 14 Oct 2024 21:38:14 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,Liam.Howlett@oracle.com,jqqlijiazi@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-alloc-node-fail-issue.patch added to mm-unstable branch
Message-Id: <20241015043815.7602DC4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: fix alloc node fail issue
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-fix-alloc-node-fail-issue.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-alloc-node-fail-issue.patch

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
From: Jiazi Li <jqqlijiazi@gmail.com>
Subject: maple_tree: fix alloc node fail issue
Date: Wed, 26 Jun 2024 12:06:30 -0400

In the following code, the second call to the mas_node_count will return
-ENOMEM:

	mas_node_count(mas, MAPLE_ALLOC_SLOTS + 1);
	mas_node_count(mas, MAPLE_ALLOC_SLOTS * 2 + 2);

This is because there may be some full maple_alloc node in current maple
state.  Use full maple_alloc node will make max_req equal to 0.  And it
leads to mt_alloc_bulk return 0.  As a result, mas_node_count set mas.node
to MA_ERROR(-ENOMEM).

Find a non-full maple_alloc node, and if necessary, use this non-full node
in the next while loop.

Link: https://lkml.kernel.org/r/20240626160631.3636515-1-Liam.Howlett@oracle.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Jiazi Li <jqqlijiazi@gmail.com>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Suggested-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-fix-alloc-node-fail-issue
+++ a/lib/maple_tree.c
@@ -1285,7 +1285,10 @@ static inline void mas_alloc_nodes(struc
 
 		node->node_count += count;
 		allocated += count;
-		node = node->slot[0];
+		/* find a non-full node*/
+		do {
+			node = node->slot[0];
+		} while (unlikely(node->node_count == MAPLE_ALLOC_SLOTS));
 		requested -= count;
 	}
 	mas->alloc->total = allocated;
_

Patches currently in -mm which might be from jqqlijiazi@gmail.com are

maple_tree-fix-alloc-node-fail-issue.patch
maple_tree-add-some-alloc-node-test-case.patch

