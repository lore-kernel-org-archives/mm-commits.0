Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDFF15C131
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 10:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727259138; cv=none; b=qpWhXsW7sEzXUo+0iXcLBx92h8kUvi+9QKTlqzETQoDdTtOh8WXqf+OOoEQVWNBfAbT0TfwXXXfz1Xwn/n4MrACjyhrlCRyQdDCPsMb7zoWMmSA7SXs3+/et0UoKhhCaIocb6eq9f8oAY3mMNRF0ToKwJGrtdgaMq/tvEjgxqwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727259138; c=relaxed/simple;
	bh=7bhx9D52JHafJKXD9IOlL6eYKi9gYYK4mEdssxpI6mI=;
	h=Date:To:From:Subject:Message-Id; b=OTn2DD5n2Nk8yKoBM3bbUntakt7WwzyAQMb3pQ5cjQe1iEGA4hLU1Hs8aR8lUBfDtrJoBvjaIg+fdGAwMXKFmd5z+VdcpJChThwWqQd32Ox+1a5kQZ0BXbEcn/BiethMZRG12t2aI+U5KzjZ8n5KtVQjusZ25jq0exgRazyKZwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0PTDtAAp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0PTDtAAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFDEC4CEC3;
	Wed, 25 Sep 2024 10:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727259138;
	bh=7bhx9D52JHafJKXD9IOlL6eYKi9gYYK4mEdssxpI6mI=;
	h=Date:To:From:Subject:From;
	b=0PTDtAApZuNSgIOpplCzebAvQDpDyTIAEMfggWLP1V+VPGmWsAuCN0jISwRgZ7gzQ
	 8UxGET3udJHBnegzYyXpTd/f1ooe7rlqk+coWj7vgxDqmYMRFMynRk1LkuwMQZEyHr
	 qTua9M9nb58VPCy5zmZNBKAYbGS5iIj/Ayv2xngI=
Date: Wed, 25 Sep 2024 03:12:17 -0700
To: mm-commits@vger.kernel.org,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-memset-maple_big_node-as-a-whole.patch added to mm-unstable branch
Message-Id: <20240925101217.ECFDEC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: memset maple_big_node as a whole
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-memset-maple_big_node-as-a-whole.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-memset-maple_big_node-as-a-whole.patch

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
Subject: maple_tree: memset maple_big_node as a whole
Date: Sun, 8 Sep 2024 14:05:54 +0000

In mast_fill_bnode(), we first clear some fields of maple_big_node and set
the 'type' unconditionally before return.  This means we won't leverage
any information in maple_big_node and it is safe to clear the whole
structure.

In maple_big_node, we define slot and padding/gap in a union.  And based
on current definition of MAPLE_BIG_NODE_SLOTS/GAPS, padding is always less
than slot and part of the gap is overlapped by slot.

For example on 64bit system:

  MAPLE_BIG_NODE_SLOT is 34
  MAPLE_BIG_NODE_GAP  is 21

With this knowledge, current code may clear some space by twice. And
this could be avoid by clearing the structure as a whole.

Link: https://lkml.kernel.org/r/20240908140554.20378-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/lib/maple_tree.c~maple_tree-memset-maple_big_node-as-a-whole
+++ a/lib/maple_tree.c
@@ -3155,10 +3155,7 @@ static inline void mast_fill_bnode(struc
 	bool cp = true;
 	unsigned char split;
 
-	memset(mast->bn->gap, 0, sizeof(unsigned long) * ARRAY_SIZE(mast->bn->gap));
-	memset(mast->bn->slot, 0, sizeof(unsigned long) * ARRAY_SIZE(mast->bn->slot));
-	memset(mast->bn->pivot, 0, sizeof(unsigned long) * ARRAY_SIZE(mast->bn->pivot));
-	mast->bn->b_end = 0;
+	memset(mast->bn, 0, sizeof(struct maple_big_node));
 
 	if (mte_is_root(mas->node)) {
 		cp = false;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

maple_tree-i-is-always-less-than-or-equal-to-mas_end.patch
maple_tree-goto-complete-directly-on-a-pivot-of-0.patch
maple_tree-remove-maple_big_nodeparent.patch
maple_tree-memset-maple_big_node-as-a-whole.patch

