Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450113A1DB
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854811; cv=none; b=QTJfqqcXmLpLoz+Yg4DJCAoi2Fri0aT3oWfMWLviUj3+t79aHuX6IhfJ0cqusiiqYbIUwwV/SKBu5TA5OwkCnQKKUUm/aWL0O6DeSgeAMnDQ9ZjFUt6OIJ58Lz0DIY6Lbk2BoDmF29Zi1tJE6SZH5XzqOCNooi/FIE8MKIIpEjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854811; c=relaxed/simple;
	bh=iNYUmU/quJFcZjSEBZDdm07W6KFE9KvreQfdnldfut4=;
	h=Date:To:From:Subject:Message-Id; b=s4TKMYMsIueJA7p3tkw0s9vpq9n0STdk9kKrVytVXpT5b1eiMVsMUagk/vTm0dJAi83Dsg72UotxiAYRHAiFaqP3H4xBbe4rOHtLUNPHB8dkagX/Uij3Z3luxUk1k7yxOM/bFYb8zeVi8FHip9+uoRFPqMnzj1jfJjQTFIqLuZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x55mVhCV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x55mVhCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8020C4CECF;
	Wed,  6 Nov 2024 01:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854810;
	bh=iNYUmU/quJFcZjSEBZDdm07W6KFE9KvreQfdnldfut4=;
	h=Date:To:From:Subject:From;
	b=x55mVhCVpU/jrgYZM0Gv2dHoN3tRlLOQSXjWssfM4PUCpUKPWmy9BY3nUoBJfmMvx
	 43gtGOeaWpboSyqnfaLjTEtLghD+sfAavCrcUdz1JQ16wOe1uwtYQRzEOxe4ZDsoYL
	 3W4Dau/Bl9b0LUMqNYiElrUWSv46kKO55rDVcRO0=
Date: Tue, 05 Nov 2024 17:00:10 -0800
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-simplify-mas_push_node.patch removed from -mm tree
Message-Id: <20241106010010.C8020C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: simplify mas_push_node()
has been removed from the -mm tree.  Its filename was
     maple_tree-simplify-mas_push_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: simplify mas_push_node()
Date: Tue, 15 Oct 2024 12:07:46 +0000

When count is not 0, we know head is valid.  So we can put the assignment
in if (count) instead of checking the head pointer again.

Also count represents current total, we can assign the new total by
increasing the count by one.

Link: https://lkml.kernel.org/r/20241015120746.15850-4-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/lib/maple_tree.c~maple_tree-simplify-mas_push_node
+++ a/lib/maple_tree.c
@@ -1207,19 +1207,17 @@ static inline void mas_push_node(struct
 
 	reuse->request_count = 0;
 	reuse->node_count = 0;
-	if (count && (head->node_count < MAPLE_ALLOC_SLOTS)) {
-		head->slot[head->node_count++] = reuse;
-		head->total++;
-		goto done;
-	}
-
-	reuse->total = 1;
-	if ((head) && !((unsigned long)head & 0x1)) {
+	if (count) {
+		if (head->node_count < MAPLE_ALLOC_SLOTS) {
+			head->slot[head->node_count++] = reuse;
+			head->total++;
+			goto done;
+		}
 		reuse->slot[0] = head;
 		reuse->node_count = 1;
-		reuse->total += head->total;
 	}
 
+	reuse->total = count + 1;
 	mas->alloc = reuse;
 done:
 	if (requested > 1)
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-mlock-set-the-correct-prev-on-failure.patch
maple_tree-print-empty-for-an-empty-tree-on-mt_dump.patch
maple_tree-the-return-value-of-mas_root_expand-is-not-used.patch
maple_tree-not-necessary-to-check-index-last-again.patch
maple_tree-refine-mas_store_root-on-storing-null.patch
maple_tree-add-a-test-checking-storing-null.patch

