Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8699C13AD05
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 00:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725235209; cv=none; b=VljS9/QBSOfRBjE2/tiWKPjLr++KRk1Xt8Wj62hynjq5JEWA++PJsDdJacHnnh754fNmcwuldl0AKar3ZiqiQBCDbJ3EHpeIbvzr+rs2bvRtCLtc+gGFgB05ZCZcPWFliQKg0hqiIBQyTHRc2x+vIbD326814Eon1H7PXRRPIjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725235209; c=relaxed/simple;
	bh=qeX8+Q63SdoSCwhtV4NMd461dP/Pe5UMK2Dz43l/R4Y=;
	h=Date:To:From:Subject:Message-Id; b=vA95PRuY/zpwA2hsR0ZVDT6TL8JcST3CS4Ram83FnsFxiduHwTivRqRlj3b8YBNWbIo/b/I+pCwmeBJTUALh91CDngDVFkjOqs5/dMAtEEP7IA8yfArzxqzNV0SjfVY/C8XHhqxiPaS16eH+WRXSQxfdu+xVeqqwY3ngGs4KON8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ClPlvBNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ClPlvBNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE425C4CEC3;
	Mon,  2 Sep 2024 00:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725235209;
	bh=qeX8+Q63SdoSCwhtV4NMd461dP/Pe5UMK2Dz43l/R4Y=;
	h=Date:To:From:Subject:From;
	b=ClPlvBNWj9TUbSBkv8E6siyZTPkPx4jPa35QD+ueDjk7yBmR6x+ldDkSsaaAl7r3E
	 dW0ICleYRaARxP+dDS5pMiXIMYf4GMfOCSFdQTZlVJAYO9KYWpmupn47Dwlg/o53bT
	 25VqfW09EIdMjHI6tJhpL4oFI110boUliPure6XQ=
Date: Sun, 01 Sep 2024 17:00:08 -0700
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-use-ma_data_end-in-mas_data_end.patch added to mm-unstable branch
Message-Id: <20240902000008.EE425C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: use ma_data_end() in mas_data_end()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-use-ma_data_end-in-mas_data_end.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-use-ma_data_end-in-mas_data_end.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-improve-code-consistency-with-zonelist_-helper-functions.patch
mm-memory_hotplug-get-rid-of-__ref.patch
maple_tree-fix-comment-typo-of-ma_root.patch
maple_tree-fix-comment-typo-with-corresponding-maple_status.patch
maple_tree-arange64-node-is-not-a-leaf-node.patch
maple_tree-dump-error-message-based-on-format.patch
maple_tree-cleanup-function-descriptions.patch
maple_tree-fix-comment-typo-on-ma_flag-of-allocation-tree.patch
maple_tree-use-ma_data_end-in-mas_data_end.patch
maple_tree-use-mas_safe_pivot-to-get-the-pivot-range.patch
maple_tree-local-variable-count-is-not-necessary.patch

