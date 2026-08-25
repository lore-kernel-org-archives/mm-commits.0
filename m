Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F569346FB3
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622860; cv=none; b=L8cSzt2Bb3J+7SRNH+DARx5guvsyI7dbKVCfyvcxZHj7YvMRAXFZIRI8spmqcANfDkRQSr8czLzZl0SJoxokqrBVOz6QrLZZh3z6NdBHy35ma5DO2EHPBqln/oJxEcDwd1OCNmetQ2bTKGMmyVDaQSyNzkHUwIDyTDPYtbA3WxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622860; c=relaxed/simple;
	bh=nJFtBdQY1TELpgMa1UleE7UADrsB7Lr/66Fu6z777ec=;
	h=Date:To:From:Subject:Message-Id; b=BkNSsncraIhaLLYP6KGgmX2Sz1NQa3E9gtr+fmNBi6GB/wfF4/629enF+ljOvN01vBQabTtxVM1ORQ01kRuE0jWkBgx8tRDG1fp7CNW5oD7nzayJjpvkNMAVLIjmP80mLXZImjU3WaBDkETRcfNe1agGsImzpPyWzSftb5oYvCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yaVB78uu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yaVB78uu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B221F00A3A;
	Tue, 25 Aug 2026 01:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622859;
	bh=Ge9s33VHa0dwvmNKxqAdfbOuLjzkwykuWm1AwAcJ51o=;
	h=Date:To:From:Subject;
	b=yaVB78uuGkCmb/HA2BPxqk2qLDFgEDdt+RzMYckJxZsnpoJYUMaXsNOKUKU0JEoGu
	 t90vLT1B13yhG5yP8tNCrvuS0YDc2/1k130RiFL5YLqUiVX9n21UATmp82LXJYM1Fa
	 xvBx+eBNUyYDkph9fqZGHlgTsblnHG59znDq2TwQ=
Date: Mon, 24 Aug 2026 18:54:19 -0700
To: mm-commits@vger.kernel.org,zhanxusheng@xiaomi.com,liam@infradead.org,andrewjballance@gmail.com,aliceryhl@google.com,zhanxusheng1024@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-remove-unused-mas_is_root_limits.patch removed from -mm tree
Message-Id: <20260825015419.76B221F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: remove unused mas_is_root_limits()
has been removed from the -mm tree.  Its filename was
     maple_tree-remove-unused-mas_is_root_limits.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
Subject: maple_tree: remove unused mas_is_root_limits()
Date: Wed, 5 Aug 2026 15:05:29 +0800

The last callers of mas_is_root_limits() were removed by commit
b8852ef30c67 ("maple_tree: remove maple big node and subtree structs"),
together with the maple subtree state (mast_*) code that used it.  As a
static inline it does not trigger -Wunused-function, so it went unnoticed.

Remove it. No functional change.

Link: https://lore.kernel.org/20260805070529.4118794-1-zhanxusheng@xiaomi.com
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-unused-mas_is_root_limits
+++ a/lib/maple_tree.c
@@ -356,11 +356,6 @@ static __always_inline bool mte_is_root(
 	return ma_is_root(mte_to_node(node));
 }
 
-static inline bool mas_is_root_limits(const struct ma_state *mas)
-{
-	return !mas->min && mas->max == ULONG_MAX;
-}
-
 static __always_inline bool mt_is_alloc(struct maple_tree *mt)
 {
 	return (mt->ma_flags & MT_FLAGS_ALLOC_RANGE);
_

Patches currently in -mm which might be from zhanxusheng1024@gmail.com are


