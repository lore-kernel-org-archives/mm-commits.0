Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E747E107
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247811; cv=none; b=swUw8cgXrHrQzw3eulJKdJ6iEoxabBIyq8oR+DdpVbDn95XkjDTxaG3BEgErrrkF/FjcFInQoh11IQg7OESQDC3F0yG/WgKQ/zCS15fxB9+ITfobGpqfEI4R/zcjGtYKDPJTWbOVDaOQPT5KgvKtfOqvfYtoSaulwzh+uq5tncc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247811; c=relaxed/simple;
	bh=nscsVU06tCUlO2i6rgB24wDrMXdZ/gqRMR/y0ImwUN4=;
	h=Date:To:From:Subject:Message-Id; b=hxddJNm7SLiz9IKeuy2NnltY1Q54RV/yOF8dITCoFi3h6jcavMik1g0U/ilaIjvMkpEg3P70dmXrOMG6TEakpUBcttiOkobjBaSjz0ZWFHtHSkY/wLYchicNKvjdEz0wGMV9sHGjHA79z459ZLNtSx5yhEiwkvxp2Lk6IUOeyfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o61ezGWz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o61ezGWz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B915AC4CEC2;
	Mon,  2 Sep 2024 03:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247810;
	bh=nscsVU06tCUlO2i6rgB24wDrMXdZ/gqRMR/y0ImwUN4=;
	h=Date:To:From:Subject:From;
	b=o61ezGWzU63CuXXmm2iGIDKOFxXq3UL2ba0FGt4mPK4PBbILJ2RwVekXURZIP4drp
	 cbKhyL4YC58RmsPNfcoEnL9yNu0uBKFdEQD0/YEyL4iVaOaD6ldbdjNl532VSI2nXT
	 txlUSJAvFubKpK4EJuGM1bAMaNLQ8f+NL5X8jVTg=
Date: Sun, 01 Sep 2024 20:30:10 -0700
To: mm-commits@vger.kernel.org,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-fix-comment-typo-with-corresponding-maple_status.patch removed from -mm tree
Message-Id: <20240902033010.B915AC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: fix comment typo with corresponding maple_status
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-comment-typo-with-corresponding-maple_status.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: fix comment typo with corresponding maple_status
Date: Mon, 12 Aug 2024 15:09:25 +0000

In comment of function mas_start(), we list the return value of different
cases.  According to the comment context, tell the maple_status here is
more consistent with others.

Let's correct it with ma_active in the case it's a tree.

Link: https://lkml.kernel.org/r/20240812150925.31551-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-fix-comment-typo-with-corresponding-maple_status
+++ a/lib/maple_tree.c
@@ -1347,7 +1347,7 @@ static void mas_node_count(struct ma_sta
  * - If mas->node is an error or not mas_start, return NULL.
  * - If it's an empty tree:     NULL & mas->status == ma_none
  * - If it's a single entry:    The entry & mas->status == ma_root
- * - If it's a tree:            NULL & mas->status == safe root node.
+ * - If it's a tree:            NULL & mas->status == ma_active
  */
 static inline struct maple_enode *mas_start(struct ma_state *mas)
 {
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

maple_tree-arange64-node-is-not-a-leaf-node.patch
maple_tree-dump-error-message-based-on-format.patch
maple_tree-cleanup-function-descriptions.patch
maple_tree-fix-comment-typo-on-ma_flag-of-allocation-tree.patch
maple_tree-use-ma_data_end-in-mas_data_end.patch
maple_tree-use-mas_safe_pivot-to-get-the-pivot-range.patch
maple_tree-local-variable-count-is-not-necessary.patch

