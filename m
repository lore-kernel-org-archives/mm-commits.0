Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E8A7F55D
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rnjSnnKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6F6C433C8;
	Tue, 12 Dec 2023 18:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407544;
	bh=JQFOX0Hi6t6JgYOkK8GLE4hGebTrgfgcLkBkSfQ+wp8=;
	h=Date:To:From:Subject:From;
	b=rnjSnnKZaF/oKxBy3O9GL/Q2x0aLX4h/1ohvp0x3w16J0COoFm7FkJwtDVUU52mi1
	 g04WRL/LApcKtvtN4K0i/+ILVDwBrsipi0MY8pbHhM8KoJUHn052+AulwZ+BfbFiFO
	 bFbXlpPuT2+d7FZdiEM7ienorQim1+1RXVKaZ93M=
Date: Tue, 12 Dec 2023 10:59:03 -0800
To: mm-commits@vger.kernel.org,zhangpeng.00@bytedance.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-use-cached-node-end-in-mas_destroy.patch removed from -mm tree
Message-Id: <20231212185904.5D6F6C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: use cached node end in mas_destroy()
has been removed from the -mm tree.  Its filename was
     maple_tree-use-cached-node-end-in-mas_destroy.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: use cached node end in mas_destroy()
Date: Wed, 1 Nov 2023 13:16:23 -0400

The node end is set during the walk, so use the resulting end instead of
re-fetching it.

Link: https://lkml.kernel.org/r/20231101171629.3612299-7-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-use-cached-node-end-in-mas_destroy
+++ a/lib/maple_tree.c
@@ -5576,7 +5576,7 @@ void mas_destroy(struct ma_state *mas)
 
 		mas_start(mas);
 		mtree_range_walk(mas);
-		end = mas_data_end(mas) + 1;
+		end = mas->end + 1;
 		if (end < mt_min_slot_count(mas->node) - 1)
 			mas_destroy_rebalance(mas, end);
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


