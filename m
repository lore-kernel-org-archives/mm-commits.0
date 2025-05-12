Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BD7C2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011120; cv=none; b=gbHeQLuZGdolnIs+/xvG78fcOiovbgSaCZkhIT3dHuH7ookNBoQMr3HO0P+JWZVJ6yrhL8LQRyKX9xCQYbPmQZufMl9Xwgl7TQSolF/I/t493D1WcGbNrtMWiJMvOhbYejJ6APh7CIYuwngglU/XyQlAvFrteJi+GfLK1EYtaYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011120; c=relaxed/simple;
	bh=EoLids2YhGUz67MAkJLOxo9Q1PMKUeuULyf5cY67Os4=;
	h=Date:To:From:Subject:Message-Id; b=N2YhdcP+QZocHSsSELvLxrA0K9PqNEzNiaBE/2cKeI2hmSTUnWW1EWo2HGHxa6vzAHpBFG2JTWZgW+cjkd9ZO6v3TB3bhCi/sVyGloqdWcnXnR6wYlw4bypAWjk3N0pRiglJGKY+EIjavGXy4jVmtK+03M8HDhls/YvmOkNy+00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UvKHPNFX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UvKHPNFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68963C4CEE4;
	Mon, 12 May 2025 00:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011120;
	bh=EoLids2YhGUz67MAkJLOxo9Q1PMKUeuULyf5cY67Os4=;
	h=Date:To:From:Subject:From;
	b=UvKHPNFXhaNXSK3dMPKHS3R8fAuOiDptdMos6GSyIFk/YbjOV1mNf/aXISHD9qQNN
	 IrO+KNLiW7QFyY8qVvEoZa7ZOESpnZcJ8VD+ZI2up6+lrkb2sDWIe+lb0sC/Psptjz
	 1hgh6g1YdaJoTHsUdNS2CLfva5wKSwVqgRd3iGI4=
Date: Sun, 11 May 2025 17:51:59 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,richard.weiyang@gmail.com,Liam.Howlett@Oracle.com,liam.howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-break-on-convergence-in-mas_spanning_rebalance.patch removed from -mm tree
Message-Id: <20250512005200.68963C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: break on convergence in mas_spanning_rebalance()
has been removed from the -mm tree.  Its filename was
     maple_tree-break-on-convergence-in-mas_spanning_rebalance.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: break on convergence in mas_spanning_rebalance()
Date: Thu, 10 Apr 2025 19:14:44 +0000

This allows support for using the vacant height to calculate the worst
case number of nodes needed for wr_rebalance operation. 
mas_spanning_rebalance() was seen to perform unnecessary node allocations.
We can reduce allocations by breaking early during the rebalancing loop
once we realize that we have ascended to a common ancestor.

Link: https://lkml.kernel.org/r/20250410191446.2474640-5-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Suggested-by: Liam Howlett <liam.howlett@oracle.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-break-on-convergence-in-mas_spanning_rebalance
+++ a/lib/maple_tree.c
@@ -2893,11 +2893,21 @@ static void mas_spanning_rebalance(struc
 		mast_combine_cp_right(mast);
 		mast->orig_l->last = mast->orig_l->max;
 
-		if (mast_sufficient(mast))
-			continue;
+		if (mast_sufficient(mast)) {
+			if (mast_overflow(mast))
+				continue;
+
+			if (mast->orig_l->node == mast->orig_r->node) {
+			       /*
+				* The data in b_node should be stored in one
+				* node and in the tree
+				*/
+				slot = mast->l->offset;
+				break;
+			}
 
-		if (mast_overflow(mast))
 			continue;
+		}
 
 		/* May be a new root stored in mast->bn */
 		if (mas_is_root_limits(mast->orig_l))
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


