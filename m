Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4498D1741CB
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854810; cv=none; b=ZSG9Yqn65WtkICdgVfQgpvgOVPp1XXqsA/GM1M04pnrWgL02pAOHE2Y0MNwAvpO/ld3Y2doVdM81oQ6gnHl6QdFOcXGChOrT397BUMe677Gw1G3D6eGtBAjHfImLoLwqKQunb75a5cdr5E1zId91iMFu4nnCJKNSUPGy9o0aBAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854810; c=relaxed/simple;
	bh=EeA+BgjHtTuBa+X+AmWeZRAKHKs8gVmWVzhcOpKWsMA=;
	h=Date:To:From:Subject:Message-Id; b=ThqTOr3XWmUG+OF/JCS53umhukmZsgjrnQUOlfHlbnpFsj5HukPBptPAoyjhkTUwVusVVkwjDjfqkKOLLqpcRHauGiW7dFIOuI4BYLKNe3A01UdFSh9JW4Eqdm66QfNLy8cnXUlwc/hWges/MBo8CFvR4wf7+fMJJSXe2FG3lR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yhHXgy3f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yhHXgy3f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBAF5C4CECF;
	Wed,  6 Nov 2024 01:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854809;
	bh=EeA+BgjHtTuBa+X+AmWeZRAKHKs8gVmWVzhcOpKWsMA=;
	h=Date:To:From:Subject:From;
	b=yhHXgy3f2/vHwqwbleX2NifC8YAtqBRxZlbbzcoK9HEsIeq9f2NhWvPQZkuIP4cLQ
	 nRmephP6ONwzZ7M9bQ45DO56XXdWOZ0xIkIMOCn9a19sNFSwQ5OwTqhsuJBMT793fE
	 w8gr0bVs7DlSPMB0VlvwjeOV5H1SdgxyT4W0WAl4=
Date: Tue, 05 Nov 2024 17:00:09 -0800
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-total-is-not-changed-for-nomem_one-case.patch removed from -mm tree
Message-Id: <20241106010009.BBAF5C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: total is not changed for nomem_one case
has been removed from the -mm tree.  Its filename was
     maple_tree-total-is-not-changed-for-nomem_one-case.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: total is not changed for nomem_one case
Date: Tue, 15 Oct 2024 12:07:45 +0000

If it jumps to nomem_one, the total allocated number is not changed.  So
we don't need to adjust it.

For the nomem_bulk case, we know there is a valid mas->alloc.  So we don't
need to do the check.

Link: https://lkml.kernel.org/r/20241015120746.15850-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-total-is-not-changed-for-nomem_one-case
+++ a/lib/maple_tree.c
@@ -1297,10 +1297,9 @@ static inline void mas_alloc_nodes(struc
 nomem_bulk:
 	/* Clean up potential freed allocations on bulk failure */
 	memset(slots, 0, max_req * sizeof(unsigned long));
+	mas->alloc->total = allocated;
 nomem_one:
 	mas_set_alloc_req(mas, requested);
-	if (mas->alloc && !(((unsigned long)mas->alloc & 0x1)))
-		mas->alloc->total = allocated;
 	mas_set_err(mas, -ENOMEM);
 }
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-mlock-set-the-correct-prev-on-failure.patch
maple_tree-print-empty-for-an-empty-tree-on-mt_dump.patch
maple_tree-the-return-value-of-mas_root_expand-is-not-used.patch
maple_tree-not-necessary-to-check-index-last-again.patch
maple_tree-refine-mas_store_root-on-storing-null.patch
maple_tree-add-a-test-checking-storing-null.patch

