Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9A223A103
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836956; cv=none; b=LQ8aJnBSVTD50BcFrduzCR1+vTBODPrCrXirlufWFf5i+Sip1Q986fj9Ol4a+iYIQzGlY4gcZVuhCS7M2gX66P6A46e890XhbJ5laRSghtLpvSCf/MVzBf/mh/sdQhm0SZtABcRBhjaH3HW6VTw/qbIMdfCPHwWt0JW5BmqmQCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836956; c=relaxed/simple;
	bh=d4ZGzL3rdfchICLHV/lKdSakQIplheRkmrilYUZTiPA=;
	h=Date:To:From:Subject:Message-Id; b=MA+HUpJBzR15VmUWznrN2U6fALgE+ncmzO4wWI6vU0OquQ0qqQCOTXIAxvilp2UnNA25Q0DFCUwdj/8nWOlMElfnZqOFgASMleuoqcw/ciRsvC2maCfBKDTqWiDAI67UMWCEfr1VT87053cofkvoc+H/5ibiKKNoyWMCyg8bycM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WfqmyUjA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WfqmyUjA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F78EC4CEDD;
	Tue, 14 Jan 2025 06:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836956;
	bh=d4ZGzL3rdfchICLHV/lKdSakQIplheRkmrilYUZTiPA=;
	h=Date:To:From:Subject:From;
	b=WfqmyUjAy6Q1IH6E9ctwPMfiIrBMKzZPjvySxmm+7tsxtG80NyybJ2H8qiAWzFiti
	 CfC5RbaNF+Cd4jbEOCC7v1pc8xIn5Z/PB9FyUB0dC7Ize2CIsW4T0WNZ+2UQflOu8a
	 pVlL2w+xbvr22HHQPuc9ILp8mDa0xcCUj0/MFddI=
Date: Mon, 13 Jan 2025 22:42:35 -0800
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-we-dont-set-offset-to-maple_node_slots-on-error.patch removed from -mm tree
Message-Id: <20250114064236.0F78EC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: we don't set offset to MAPLE_NODE_SLOTS on error
has been removed from the -mm tree.  Its filename was
     maple_tree-we-dont-set-offset-to-maple_node_slots-on-error.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: we don't set offset to MAPLE_NODE_SLOTS on error
Date: Sat, 16 Nov 2024 01:48:05 +0000

When mas_anode_descend() not find gap, it sets -EBUSY instead of setting
offset to MAPLE_NODE_SLOTS.

Link: https://lkml.kernel.org/r/20241116014805.11547-4-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/lib/maple_tree.c~maple_tree-we-dont-set-offset-to-maple_node_slots-on-error
+++ a/lib/maple_tree.c
@@ -5000,8 +5000,8 @@ static inline void mas_awalk(struct ma_s
 	 * There are 4 options:
 	 * go to child (descend)
 	 * go back to parent (ascend)
-	 * no gap found. (return, slot == MAPLE_NODE_SLOTS)
-	 * found the gap. (return, slot != MAPLE_NODE_SLOTS)
+	 * no gap found. (return, error == -EBUSY)
+	 * found the gap. (return)
 	 */
 	while (!mas_is_err(mas) && !mas_anode_descend(mas, size)) {
 		if (last == mas->node)
@@ -5086,9 +5086,6 @@ int mas_empty_area(struct ma_state *mas,
 		return xa_err(mas->node);
 
 	offset = mas->offset;
-	if (unlikely(offset == MAPLE_NODE_SLOTS))
-		return -EBUSY;
-
 	node = mas_mn(mas);
 	mt = mte_node_type(mas->node);
 	pivots = ma_pivots(node, mt);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


