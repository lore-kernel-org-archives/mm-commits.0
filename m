Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CDC7F56F
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Op3xLF5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF36CC433C9;
	Tue, 12 Dec 2023 18:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407556;
	bh=19jBe9Asz96gdNf93wrK5HTANzKWGC25khIr32858n8=;
	h=Date:To:From:Subject:From;
	b=Op3xLF5bw3xr69t3VWAMZ45ii8ukVrfrYGk0cE/iaOee5FWBy8fQM3oQTACpsylY4
	 PpNq8e+/Su6DhEJCgGgwu8AM0XSDzb2E8KdNMFncneZRdysZrrFTEQ3rx8ztOjgIsc
	 SJqTndZw2SlEru1boF3rsMbLZvaTw3lYIpFJpLgU=
Date: Tue, 12 Dec 2023 10:59:16 -0800
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,dan.carpenter@linaro.org,zhangpeng.00@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-simplify-mas_leaf_set_meta.patch removed from -mm tree
Message-Id: <20231212185916.AF36CC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: simplify mas_leaf_set_meta()
has been removed from the -mm tree.  Its filename was
     maple_tree-simplify-mas_leaf_set_meta.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: simplify mas_leaf_set_meta()
Date: Mon, 20 Nov 2023 15:09:37 +0800

Now it seems that the incoming 'end' is already pointing to the last item,
so we can simplify this function, considering only whether the last slot
is being used.  This has passed the maple tree test suite.

Link: https://lkml.kernel.org/r/20231120070937.35481-6-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

--- a/lib/maple_tree.c~maple_tree-simplify-mas_leaf_set_meta
+++ a/lib/maple_tree.c
@@ -1964,27 +1964,13 @@ complete:
 
 /*
  * mas_leaf_set_meta() - Set the metadata of a leaf if possible.
- * @mas: The maple state
  * @node: The maple node
- * @pivots: pointer to the maple node pivots
  * @mt: The maple type
- * @end: The assumed end
- *
- * Note, end may be incremented within this function but not modified at the
- * source.  This is fine since the metadata is the last thing to be stored in a
- * node during a write.
+ * @end: The node end
  */
-static inline void mas_leaf_set_meta(struct ma_state *mas,
-		struct maple_node *node, unsigned long *pivots,
+static inline void mas_leaf_set_meta(struct maple_node *node,
 		enum maple_type mt, unsigned char end)
 {
-	/* There is no room for metadata already */
-	if (mt_pivots[mt] <= end)
-		return;
-
-	if (pivots[end] && pivots[end] < mas->max)
-		end++;
-
 	if (end < mt_slots[mt] - 1)
 		ma_set_meta(node, mt, 0, end);
 }
@@ -2041,7 +2027,7 @@ static inline void mab_mas_cp(struct map
 
 		ma_set_meta(node, mt, offset, end);
 	} else {
-		mas_leaf_set_meta(mas, node, pivots, mt, end);
+		mas_leaf_set_meta(node, mt, end);
 	}
 }
 
@@ -3962,7 +3948,7 @@ static inline bool mas_wr_node_store(str
 		dst_pivots[new_end] = mas->max;
 
 done:
-	mas_leaf_set_meta(mas, newnode, dst_pivots, maple_leaf_64, new_end);
+	mas_leaf_set_meta(newnode, maple_leaf_64, new_end);
 	if (in_rcu) {
 		struct maple_enode *old_enode = mas->node;
 
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are


