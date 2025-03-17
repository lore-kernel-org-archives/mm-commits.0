Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2842E215782
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188295; cv=none; b=FvKkAbrgpUoGsbpbGVw1X+nRS1DCFUnZplbZm7Jy/2bc2MsY2fptuTaPPcHbVCLILCSBML+v4fXc3QU3+Xt+NOx1+ZrPLoXWqUA9fRub190ZpQEa9cIKZX6kTHKMd8gIrDviSCdmnl+CsVslwAX7TfzUoHmrHJ2kvI6QgWzXYE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188295; c=relaxed/simple;
	bh=ZgD1yLBZHR7gA4qeHXTiwXzr6BA4ZXN0aw/0mugAdII=;
	h=Date:To:From:Subject:Message-Id; b=pzQjD43p9GRm4akOLI0Oz7m4BDc38+50PMYaFsrjTJ4zj99HqP79/Lze4blBj6rlva9Lskyyq7Mgj8XFpIUhAreHMHAxgNPaeT7rAIZz9TGbPj3AQ+KCqoYe2sFa5+YHcEPyz5HdfkOLEbmd8IHPc7dxrM8MLKBxxxJ65ord9gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MRyCCjvF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MRyCCjvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89BCC4CEEC;
	Mon, 17 Mar 2025 05:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188295;
	bh=ZgD1yLBZHR7gA4qeHXTiwXzr6BA4ZXN0aw/0mugAdII=;
	h=Date:To:From:Subject:From;
	b=MRyCCjvFH2Jyz/1M2XBJzD90N5sdODlZzfuCoN+Qe1Lu60SwK1CTBSlC3qxQ1GmQ+
	 +N0VhxeKw+xp+Fg5zv19PFqX10TtRSz3GzoKn6BmlkSruNx4UYfNpSlo3Vcg4Sw2pK
	 Dz4EvQ5JqDhFrm/3r7Mq9vXrPY0v+SOXrrHY/9RY=
Date: Sun, 16 Mar 2025 22:11:34 -0700
To: mm-commits@vger.kernel.org,Liam.Howlett@Oracle.com,ptesarik@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-remove-a-bug_on-in-mas_alloc_nodes.patch removed from -mm tree
Message-Id: <20250317051134.E89BCC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: remove a BUG_ON() in mas_alloc_nodes()
has been removed from the -mm tree.  Its filename was
     maple_tree-remove-a-bug_on-in-mas_alloc_nodes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Petr Tesarik <ptesarik@suse.com>
Subject: maple_tree: remove a BUG_ON() in mas_alloc_nodes()
Date: Thu, 13 Feb 2025 12:44:53 +0100

Remove a BUG_ON() right before a WARN_ON() with the same condition.

Calling WARN_ON() and BUG_ON() here is definitely wrong.  Since the goal is
generally to remove BUG_ON() invocations from the kernel, keep only the
WARN_ON().

Link: https://lkml.kernel.org/r/20250213114453.1078318-1-ptesarik@suse.com
Fixes: 067311d33e65 ("maple_tree: separate ma_state node from status")
Signed-off-by: Petr Tesarik <ptesarik@suse.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    1 -
 1 file changed, 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-remove-a-bug_on-in-mas_alloc_nodes
+++ a/lib/maple_tree.c
@@ -1242,7 +1242,6 @@ static inline void mas_alloc_nodes(struc
 	if (mas->mas_flags & MA_STATE_PREALLOC) {
 		if (allocated)
 			return;
-		BUG_ON(!allocated);
 		WARN_ON(!allocated);
 	}
 
_

Patches currently in -mm which might be from ptesarik@suse.com are


