Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029AB1DC73A
	for <mm-commits@vger.kernel.org>; Tue,  3 Sep 2024 20:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725394539; cv=none; b=opLuCnnrdiX303frdBT9Px/9u2FE1nGUst8mofRado7PLeGJrq/pIUSEfHXvcFNCDUbnlHsywr8tuQtf/o6j4kunOn5HCt0nRAq1so6DqdSEYFBcyZI2CkVclKyNhbKjIQixM+a7WJ4CztSYdyiEcAktu2YEk551XlMOHaOEffQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725394539; c=relaxed/simple;
	bh=8ddRNviQQHUwWtdGiF3zO/EHhuBtTyL01gXtllNSTDI=;
	h=Date:To:From:Subject:Message-Id; b=R0ekMImQU46jdckzMgzqIPzAxSls3KQyl2ipvjOI06gyOsCJXdNQrHzKXIP0IYOHzdtO+xyOeOMufKATmn4/dtybyhH2zgPmJy73BLvUsTz4z9FPbzwvEhBJBQOkqmb5foZYmSm0rKoUABktK7Q2aGq0qMuNJroxWyKxcLMOKC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SFAob6ue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SFAob6ue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BCEFC4CEC4;
	Tue,  3 Sep 2024 20:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725394538;
	bh=8ddRNviQQHUwWtdGiF3zO/EHhuBtTyL01gXtllNSTDI=;
	h=Date:To:From:Subject:From;
	b=SFAob6ueKsQxqLegOlKKDx8Z+SV5LATtmsPQINyU7kNCO5af1xTUlAuVcsEoIm0bS
	 xmjY1bhJiMuJ+ITF8skyM3fLj4N6PBaPcOQYmKwkBnUzODHZVGDi6/3WS+bnHwNRv9
	 fu595HCnwckbUKxRfk96RCoxHAD4MEzcRqsYu15s=
Date: Tue, 03 Sep 2024 13:15:37 -0700
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] maple_tree-use-ma_data_end-in-mas_data_end.patch removed from -mm tree
Message-Id: <20240903201538.7BCEFC4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: use ma_data_end() in mas_data_end()
has been removed from the -mm tree.  Its filename was
     maple_tree-use-ma_data_end-in-mas_data_end.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: use ma_data_end() in mas_data_end()
Date: Sat, 31 Aug 2024 00:10:51 +0000

These two function share almost the same code and do the same thing.

Let's just call ma_data_end() in mas_data_end() to reduce duplicate
code.

Link: https://lkml.kernel.org/r/20240831001053.4751-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

--- a/lib/maple_tree.c~maple_tree-use-ma_data_end-in-mas_data_end
+++ a/lib/maple_tree.c
@@ -1420,28 +1420,14 @@ static __always_inline unsigned char ma_
  */
 static inline unsigned char mas_data_end(struct ma_state *mas)
 {
-	enum maple_type type;
-	struct maple_node *node;
-	unsigned char offset;
-	unsigned long *pivots;
+	enum maple_type type = mte_node_type(mas->node);
+	struct maple_node *node = mas_mn(mas);
+	unsigned long *pivots = ma_pivots(node, type);
 
-	type = mte_node_type(mas->node);
-	node = mas_mn(mas);
-	if (type == maple_arange_64)
-		return ma_meta_end(node, type);
-
-	pivots = ma_pivots(node, type);
 	if (unlikely(ma_dead_node(node)))
 		return 0;
 
-	offset = mt_pivots[type] - 1;
-	if (likely(!pivots[offset]))
-		return ma_meta_end(node, type);
-
-	if (likely(pivots[offset] == mas->max))
-		return offset;
-
-	return mt_pivots[type];
+	return ma_data_end(node, type, pivots, mas->max);
 }
 
 /*
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

maple_tree-arange64-node-is-not-a-leaf-node.patch
maple_tree-dump-error-message-based-on-format.patch
maple_tree-cleanup-function-descriptions.patch
maple_tree-fix-comment-typo-on-ma_flag-of-allocation-tree.patch
maple_tree-use-mas_safe_pivot-to-get-the-pivot-range.patch
maple_tree-local-variable-count-is-not-necessary.patch

