Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281FD154444
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854715; cv=none; b=TXuLx5N+msTQIJrH1wFBpOD6JCkEs78XQJOcEP567cE/ngJdwc3IFusiW9jTkJLqGnIFXaIlxTm6LGW1lYLT0Az9WUdl4fE5vaI9EPzVLyP3zAqqn6Gef2ixQmzdyvQUiTaJW8PVRTtlTzh1biLRPqISq0X4pbT92ANSxwOUWkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854715; c=relaxed/simple;
	bh=4/nK5PkSfsKugp5BEMiXypv5+sPByPUpdWj/bge8MhE=;
	h=Date:To:From:Subject:Message-Id; b=EeWVbDXRy1UOMd0stXLZWCkHl/ITVY+PiqfkasAXM56qcp+9mTMBQdAi67mgH1CCXMHHMY5kQv0UDR4z/heulpdIE8PWGG77/DaDQS795GZbnFYCXg9onIkK/QdK9KNfyz0ME7Q/JTN+SmciRA8UCbpVAz9GaropdB4ldDTfCy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KNnR7ZmF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KNnR7ZmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2910C4CED1;
	Wed,  6 Nov 2024 00:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854715;
	bh=4/nK5PkSfsKugp5BEMiXypv5+sPByPUpdWj/bge8MhE=;
	h=Date:To:From:Subject:From;
	b=KNnR7ZmF85ezWNhb4K7EzuSNjzKNv8LWPybjeeguSa+IHhO0LjBbRP67BRcJumnB9
	 FWGABfPl0/TLQwvc7x077VFQR7HFkzwtewWQHolMTbh7Ebt+6tmDEAPhOYP5uWwSkR
	 2eiQWG7pwlRF/iVvzp2+NVPOMBcF1I/Z23tRlOzY=
Date: Tue, 05 Nov 2024 16:58:34 -0800
To: mm-commits@vger.kernel.org,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-remove-maple_big_nodeparent.patch removed from -mm tree
Message-Id: <20241106005834.F2910C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: remove maple_big_node.parent
has been removed from the -mm tree.  Its filename was
     maple_tree-remove-maple_big_nodeparent.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: remove maple_big_node.parent
Date: Sun, 8 Sep 2024 14:05:53 +0000

Patch series "Reduce the space to be cleared for maple_big_node", v2.

Found current code may clear maple_big_node redundantly.

First we define a field parent, which is never used.  After removing this,
we reduce the size of memory to be cleared by memset.

Then mast_fill_bnode() clears part of the structure twice, since slot and
gap share some space.  By clearing the whole structure, we can avoid this.


This patch (of 2):

The member parent of maple_big_node is never used.

Let's remove it which could reduce the number of space to be cleared on
memset.

Link: https://lkml.kernel.org/r/20240908140554.20378-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20240908140554.20378-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    1 -
 1 file changed, 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-remove-maple_big_nodeparent
+++ a/lib/maple_tree.c
@@ -120,7 +120,6 @@ static const unsigned char mt_min_slots[
 #define MAPLE_BIG_NODE_GAPS	(MAPLE_ARANGE64_SLOTS * 2 + 1)
 
 struct maple_big_node {
-	struct maple_pnode *parent;
 	unsigned long pivot[MAPLE_BIG_NODE_SLOTS - 1];
 	union {
 		struct maple_enode *slot[MAPLE_BIG_NODE_SLOTS];
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-mlock-set-the-correct-prev-on-failure.patch
maple_tree-print-empty-for-an-empty-tree-on-mt_dump.patch
maple_tree-the-return-value-of-mas_root_expand-is-not-used.patch
maple_tree-not-necessary-to-check-index-last-again.patch
maple_tree-refine-mas_store_root-on-storing-null.patch
maple_tree-add-a-test-checking-storing-null.patch

