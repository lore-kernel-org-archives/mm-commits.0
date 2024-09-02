Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D267B7DA73
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247809; cv=none; b=nq8UIs3I+sysa+YyIvBWwev5GCaHnwLWdkiF96jqjvkwGI2LaI61JnhDg2ZMlrxbD+9W1ZwET4Igmm8C+eFEDPb+Csfj0vn8BGJ0GChV2+7fdC8RWgQged/N1LwxASmwefrdeZoVN4sLjuz8Iq+fXaOAUmUgYsVwo35/FlRrF2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247809; c=relaxed/simple;
	bh=mOLfOOXrVNq3zWW/lfwMyJuLO07q6NrNu7WQvztt7XI=;
	h=Date:To:From:Subject:Message-Id; b=CpAaPWDAbXMIthb/hN63JpFMbdK6PjJ+dzv0sNzWtcAWDq/C0iYwWcFWQmFOp18+VM6zFfjyCt+SMzRT69LH6DZ/qccG0QmKxxqLKIO/nwJgSsAFbLYcWQIG2C2HatMCl7dCB0tV7k/QIJx+RhKkEL+pSY8ZhEV7uYIgHby3XHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gwFVEONM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gwFVEONM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7C5C4CEC2;
	Mon,  2 Sep 2024 03:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247809;
	bh=mOLfOOXrVNq3zWW/lfwMyJuLO07q6NrNu7WQvztt7XI=;
	h=Date:To:From:Subject:From;
	b=gwFVEONMuX6dFGkeClxLjAs7OUvsbJOhLiC/KWhEYIKDa4opBvlOWcUo1cxP5s2Jx
	 fp3YDvel8VN0YHezowLO9KN98ww35vcgQ262ePigMH6AYytQRqybObtHOucFKQvt3F
	 vg6sbwH/GDafUaZuVjpY60yyfWligvpcBUUgKC1c=
Date: Sun, 01 Sep 2024 20:30:09 -0700
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-fix-comment-typo-of-ma_root.patch removed from -mm tree
Message-Id: <20240902033009.AA7C5C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: fix comment typo of ma_root
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-comment-typo-of-ma_root.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: fix comment typo of ma_root
Date: Mon, 12 Aug 2024 15:09:24 +0000

In comment of mas_start(), we lists the return value for different cases. 
In case of a single entry, we set mas->status to ma_root, while the
comment uses mas_root, which is not a maple_status.

Fix the typo according to the code.

Link: https://lkml.kernel.org/r/20240812150925.31551-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-fix-comment-typo-of-ma_root
+++ a/lib/maple_tree.c
@@ -1346,7 +1346,7 @@ static void mas_node_count(struct ma_sta
  * Return:
  * - If mas->node is an error or not mas_start, return NULL.
  * - If it's an empty tree:     NULL & mas->status == ma_none
- * - If it's a single entry:    The entry & mas->status == mas_root
+ * - If it's a single entry:    The entry & mas->status == ma_root
  * - If it's a tree:            NULL & mas->status == safe root node.
  */
 static inline struct maple_enode *mas_start(struct ma_state *mas)
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

maple_tree-arange64-node-is-not-a-leaf-node.patch
maple_tree-dump-error-message-based-on-format.patch
maple_tree-cleanup-function-descriptions.patch
maple_tree-fix-comment-typo-on-ma_flag-of-allocation-tree.patch
maple_tree-use-ma_data_end-in-mas_data_end.patch
maple_tree-use-mas_safe_pivot-to-get-the-pivot-range.patch
maple_tree-local-variable-count-is-not-necessary.patch

