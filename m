Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143B623BD1B;
	Tue, 24 Jun 2025 20:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750796093; cv=none; b=nAxtxlYMTX9uBuVL+gyHzZsApeY1a6Qin5UTrjOqMCDIVkCtMAqJj1ddk+5+F0/dxlgEJPW10GpCTKh9vhhThc9bU6tOfL/EsScKbMymQ9fBfMQ1W/kdsO5ooLjVDumVE23/QUm8cAwL68AdgM89aIwybm/tbpV49l9nHWQGZ7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750796093; c=relaxed/simple;
	bh=3mLbQ2qUIOgstvLbkauKCkC52AIBZ/fwP5i6EL/iUFI=;
	h=Date:To:From:Subject:Message-Id; b=kErGqbvN864ZpjVIsRL6sU6xDtRdpUYVNAqtyk+ZnLEyBjn5wjdB5FuaMEAOT5gssR5BS+Y6mf4XW18DbSZAftXg11xKV65P7a6btwYAXN1EmYDN1744C2QmGB4Aizu6GrSKKySShNrvcPJ9tNm49ATOM2GTm/UMWQT/aF06UGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hG1unU4/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hG1unU4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944BCC4CEE3;
	Tue, 24 Jun 2025 20:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750796092;
	bh=3mLbQ2qUIOgstvLbkauKCkC52AIBZ/fwP5i6EL/iUFI=;
	h=Date:To:From:Subject:From;
	b=hG1unU4/IcYz9k/2clapu6Dptihlt8RxjMogTFmb1OPM4KhNEh3F0qHVPJPuiLo6b
	 bKxc8FTkPRjNbOEtVo3tyxxSeJQGsIiJhBulKwNUtCJMS9Di71djQb4Wo91V9wktDq
	 fEOwXAig27XYFTa/W7IV926+qis6IuwQrYgRxSE4=
Date: Tue, 24 Jun 2025 13:14:51 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,Liam.Howlett@oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-mt_destroy_walk-on-root-leaf-node.patch added to mm-hotfixes-unstable branch
Message-Id: <20250624201452.944BCC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: fix mt_destroy_walk() on root leaf node
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maple_tree-fix-mt_destroy_walk-on-root-leaf-node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-mt_destroy_walk-on-root-leaf-node.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: maple_tree: fix mt_destroy_walk() on root leaf node
Date: Tue, 24 Jun 2025 15:18:40 -0400

On destroy, we should set each node dead.  But current code miss this when
the maple tree has only the root node.

The reason is mt_destroy_walk() leverage mte_destroy_descend() to set node
dead, but this is skipped since the only root node is a leaf.

Fixes this by setting the node dead if it is a leaf.

Link: https://lore.kernel.org/all/20250407231354.11771-1-richard.weiyang@gmail.com/
Link: https://lkml.kernel.org/r/20250624191841.64682-1-Liam.Howlett@oracle.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/maple_tree.c~maple_tree-fix-mt_destroy_walk-on-root-leaf-node
+++ a/lib/maple_tree.c
@@ -5319,6 +5319,7 @@ static void mt_destroy_walk(struct maple
 	struct maple_enode *start;
 
 	if (mte_is_leaf(enode)) {
+		mte_set_node_dead(enode);
 		node->type = mte_node_type(enode);
 		goto free_leaf;
 	}
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

maple_tree-fix-mt_destroy_walk-on-root-leaf-node.patch
maple_tree-assert-retrieving-new-value-on-a-tree-containing-just-a-leaf-node.patch

