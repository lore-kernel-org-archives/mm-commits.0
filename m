Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F497F56F
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gmiYFFKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F13C433C9;
	Tue, 12 Dec 2023 18:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407551;
	bh=DbJga0zxi3234CPRHqwlRHeRhpdsQypJm+KMk9agy9c=;
	h=Date:To:From:Subject:From;
	b=gmiYFFKtXLO1BEyHXqiOixWR/Pu9XmEt441fZgze0d6VDSiWJjuz9wsYJrQSQ7EwB
	 0ZVlRsVK5mddtPrA044hkEI/ggtSDlu3dxPiCp5W4mr36N+WuDaBS5S1cMwei9HlNv
	 7b+lrtvBIaMKJsOSEqTLxS5DfmfU3TQePL2fhP1o=
Date: Tue, 12 Dec 2023 10:59:11 -0800
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,david@redhat.com,abaci@linux.alibaba.com,jiapeng.chong@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-remove-unused-function.patch removed from -mm tree
Message-Id: <20231212185911.C4F13C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: remove unused function
has been removed from the -mm tree.  Its filename was
     maple_tree-remove-unused-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: maple_tree: remove unused function
Date: Fri, 27 Oct 2023 16:49:44 +0800

The function are defined in the maple_tree.c file, but not called
elsewhere, so delete the unused function.

lib/maple_tree.c:689:29: warning: unused function 'mas_pivot'.

Link: https://lkml.kernel.org/r/20231027084944.24888-1-jiapeng.chong@linux.alibaba.com
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=7064
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   29 -----------------------------
 1 file changed, 29 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-unused-function
+++ a/lib/maple_tree.c
@@ -685,35 +685,6 @@ static inline unsigned long *ma_gaps(str
 }
 
 /*
- * mas_pivot() - Get the pivot at @piv of the maple encoded node.
- * @mas: The maple state.
- * @piv: The pivot.
- *
- * Return: the pivot at @piv of @mn.
- */
-static inline unsigned long mas_pivot(struct ma_state *mas, unsigned char piv)
-{
-	struct maple_node *node = mas_mn(mas);
-	enum maple_type type = mte_node_type(mas->node);
-
-	if (MAS_WARN_ON(mas, piv >= mt_pivots[type])) {
-		mas_set_err(mas, -EIO);
-		return 0;
-	}
-
-	switch (type) {
-	case maple_arange_64:
-		return node->ma64.pivot[piv];
-	case maple_range_64:
-	case maple_leaf_64:
-		return node->mr64.pivot[piv];
-	case maple_dense:
-		return 0;
-	}
-	return 0;
-}
-
-/*
  * mas_safe_pivot() - get the pivot at @piv or mas->max.
  * @mas: The maple state
  * @pivots: The pointer to the maple node pivots
_

Patches currently in -mm which might be from jiapeng.chong@linux.alibaba.com are

maple_tree-fix-warning-comparing-pointer-to-0.patch

