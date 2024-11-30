Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A311EB3D
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 04:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732939504; cv=none; b=S9+uiaIkah1vAJS1OG86JllVOvCCYf2CkcY1QsBg/IzlPZHPcsKw/+iWosn1965ZM7T8Ux0PuqemW0Xjn5dUbCFuUaULY6Dk2iy53T35rV6KqNslI8q7fpeOt5Wqwkx8MW2WzxQ04yVA7BIRinwL+Ig6jr+5CATZUW8X3NIG42k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732939504; c=relaxed/simple;
	bh=DbK4jiBeyJi1Rlsd1tm1zN0zrHPP0yvwx07CS5+uxU0=;
	h=Date:To:From:Subject:Message-Id; b=SUiRqY93dJ4YF7J31WxI6igM+X0qTXMJEg16NbVzft/xMwRDcPTeQmS+pCEVXnQQF21sIWlQSyl9v7n5hs9u9GHEZ8x//RMAmNYsCPe6LdWmyI3bI8aKC6Zt0hwKN3gyp03Vw+UwBXNtYytBehKRelKAK9zLm/W1gIRdxRPd2Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hDIY4Ncn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hDIY4Ncn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0695AC4CECC;
	Sat, 30 Nov 2024 04:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732939504;
	bh=DbK4jiBeyJi1Rlsd1tm1zN0zrHPP0yvwx07CS5+uxU0=;
	h=Date:To:From:Subject:From;
	b=hDIY4Ncn4LXRRhXZMq4kiGN+9M6Foxo8Ise0PtVyHg/DYCgJyVM/u8cf2Pj9vWT2p
	 h362E4tUi9rScFOKZuyQpepoCX+byn9PsgdGiUXPyDVKpR9HYptTjsmJCxSyNGGsEE
	 DJvgNeTCmpU+1ktaTapSr9DQwcO09gSJuJoF6VFY=
Date: Fri, 29 Nov 2024 20:05:03 -0800
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-we-dont-set-offset-to-maple_node_slots-on-error.patch added to mm-unstable branch
Message-Id: <20241130040504.0695AC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: we don't set offset to MAPLE_NODE_SLOTS on error
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-we-dont-set-offset-to-maple_node_slots-on-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-we-dont-set-offset-to-maple_node_slots-on-error.patch

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
@@ -4999,8 +4999,8 @@ static inline void mas_awalk(struct ma_s
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
@@ -5085,9 +5085,6 @@ int mas_empty_area(struct ma_state *mas,
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

maple_tree-use-mas_next_slot-directly.patch
maple_tree-index-has-been-checked-to-be-smaller-than-pivot.patch
maple_tree-not-possible-to-be-a-root-node-after-loop.patch
maple_tree-we-dont-set-offset-to-maple_node_slots-on-error.patch

