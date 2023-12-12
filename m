Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4169180042
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kU7R2hBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7F3C433CA;
	Tue, 12 Dec 2023 18:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407596;
	bh=F7iVUeL8sfuocbxgxnQnj/zN88OGvKkLil+Cwk8fr0M=;
	h=Date:To:From:Subject:From;
	b=kU7R2hBZmBR9h0iwX6yULm3WK3eKJIu3jCvDVay0XpWymezCKDff+pQ2wYzV7O9s8
	 LR8VoG8WdSUJdU+eeKPlqk1VabtTdmXr/kl+tR6MLeJD2SK0lxn9a35cH571BARY3C
	 yCeZwhjV3RMcQJDCjDQG+ev6/hPz4VZfHQ5uTBR0=
Date: Tue, 12 Dec 2023 10:59:55 -0800
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,ppbuk5246@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-change-return-type-of-mas_split_final_node-as-void.patch removed from -mm tree
Message-Id: <20231212185956.0B7F3C433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: change return type of mas_split_final_node as void.
has been removed from the -mm tree.  Its filename was
     maple_tree-change-return-type-of-mas_split_final_node-as-void.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Levi Yun <ppbuk5246@gmail.com>
Subject: maple_tree: change return type of mas_split_final_node as void.
Date: Thu, 9 Nov 2023 16:08:22 +0000

mas_split_final_node() always returns true and its return value is never
checked.

Change return type to void.

Link: https://lkml.kernel.org/r/20231109160821.16248-2-ppbuk5246@gmail.com
Signed-off-by: Levi Yun <ppbuk5246@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-change-return-type-of-mas_split_final_node-as-void
+++ a/lib/maple_tree.c
@@ -3132,7 +3132,7 @@ done:
  * @mas: The maple state
  * @height: The height of the tree in case it's a new root.
  */
-static inline bool mas_split_final_node(struct maple_subtree_state *mast,
+static inline void mas_split_final_node(struct maple_subtree_state *mast,
 					struct ma_state *mas, int height)
 {
 	struct maple_enode *ancestor;
@@ -3156,7 +3156,6 @@ static inline bool mas_split_final_node(
 	mast->l->node = ancestor;
 	mab_mas_cp(mast->bn, 0, mt_slots[mast->bn->type] - 1, mast->l, true);
 	mas->offset = mast->bn->b_end - 1;
-	return true;
 }
 
 /*
_

Patches currently in -mm which might be from ppbuk5246@gmail.com are


