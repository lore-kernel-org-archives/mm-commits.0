Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2587F56F
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UbncKTbM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66E2C433C7;
	Tue, 12 Dec 2023 18:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407554;
	bh=qCO8/VrVdlHaDUZdVjH3bwW0+Z170qLEkWh/eWf6iWo=;
	h=Date:To:From:Subject:From;
	b=UbncKTbMbbLwJgVF4RoI3jk9nGJcRWS42f91A6t0XTYKMRVwzlCGW264GscddyAdr
	 iZXJA25TMSHP0EHcOpJJkBPDub1zj/13d9UE4tfMqvJvCmJzukUsSgxguYzdTqYAxz
	 g+22MyeA3q6OIzMPy20ULuMOrc6Ci0MdV5XBTGSw=
Date: Tue, 12 Dec 2023 10:59:14 -0800
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,dan.carpenter@linaro.org,zhangpeng.00@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-remove-an-unused-parameter-for-ma_meta_end.patch removed from -mm tree
Message-Id: <20231212185914.A66E2C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: remove an unused parameter for ma_meta_end()
has been removed from the -mm tree.  Its filename was
     maple_tree-remove-an-unused-parameter-for-ma_meta_end.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: remove an unused parameter for ma_meta_end()
Date: Mon, 20 Nov 2023 15:09:35 +0800

The parameter maple_type is not used, so remove it.

Link: https://lkml.kernel.org/r/20231120070937.35481-4-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-an-unused-parameter-for-ma_meta_end
+++ a/lib/maple_tree.c
@@ -930,10 +930,8 @@ static inline unsigned char ma_meta_end(
 /*
  * ma_meta_gap() - Get the largest gap location of a node from the metadata
  * @mn: The maple node
- * @mt: The maple node type
  */
-static inline unsigned char ma_meta_gap(struct maple_node *mn,
-					enum maple_type mt)
+static inline unsigned char ma_meta_gap(struct maple_node *mn)
 {
 	return mn->ma64.meta.gap;
 }
@@ -1587,7 +1585,7 @@ static inline unsigned long mas_max_gap(
 
 	node = mas_mn(mas);
 	MAS_BUG_ON(mas, mt != maple_arange_64);
-	offset = ma_meta_gap(node, mt);
+	offset = ma_meta_gap(node);
 	gaps = ma_gaps(node, mt);
 	return gaps[offset];
 }
@@ -1618,7 +1616,7 @@ static inline void mas_parent_gap(struct
 
 ascend:
 	MAS_BUG_ON(mas, pmt != maple_arange_64);
-	meta_offset = ma_meta_gap(pnode, pmt);
+	meta_offset = ma_meta_gap(pnode);
 	meta_gap = pgaps[meta_offset];
 
 	pgaps[offset] = new;
@@ -7260,7 +7258,7 @@ static void mas_validate_gaps(struct ma_
 counted:
 	if (mt == maple_arange_64) {
 		MT_BUG_ON(mas->tree, !gaps);
-		offset = ma_meta_gap(node, mt);
+		offset = ma_meta_gap(node);
 		if (offset > i) {
 			pr_err("gap offset %p[%u] is invalid\n", node, offset);
 			MT_BUG_ON(mas->tree, 1);
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are


