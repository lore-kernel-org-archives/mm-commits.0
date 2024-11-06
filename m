Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17D0188CAD
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854806; cv=none; b=sIzCj2RFYobRLP3SvGGfudX1zhhti/gAA2P+QFGwBFsErpmhmof02J+PnRWUbuBloJ/rjARTqTva6EUb6Lj8liRsknfEiqka0jicIFtZAlAbs0n2eRoW3M2n8WBzuBWKfmSlSZmrAqJPmwrI/M2zoZNyL/Jve06/fLEWwEY+nLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854806; c=relaxed/simple;
	bh=Ug2bz0V7V8IKh4oocDAomd4xVyuHk2d7GCZc7IkUUJI=;
	h=Date:To:From:Subject:Message-Id; b=j1S/ix3gcB6v5DlW5oEec45T2HNc55ur6Kfkhgd3jNvhjfJ8QhG1yEfk8ixCLUfkeVHmZv/7kXsfp4xCmGW14lv8Uf8heFh4Zb2lt9nmzaO6tPwSRPilLJtTb3rbdEgudfPVr+rP2kx1w0gg95qATQGl/dB91cEN7iiy7EOPzbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qljgeHCU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qljgeHCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8624CC4CED1;
	Wed,  6 Nov 2024 01:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854806;
	bh=Ug2bz0V7V8IKh4oocDAomd4xVyuHk2d7GCZc7IkUUJI=;
	h=Date:To:From:Subject:From;
	b=qljgeHCU03btbKthBsnJ4+51Ex2cx2GWGeemymKdz6tEgo+xVuLtYCBPNC85STu0S
	 rJHz28kn9/gCybAFYYzWRP/4xKQVPbcJlq2GC30PQSu03NC9s2r3yEckUoGufqm/8n
	 enb8I5YDAN8U0x8sELis7B03Dw8zJEmYPfXac+fc=
Date: Tue, 05 Nov 2024 17:00:06 -0800
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,Liam.Howlett@oracle.com,jqqlijiazi@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-add-some-alloc-node-test-case.patch removed from -mm tree
Message-Id: <20241106010006.8624CC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: add some alloc node test case
has been removed from the -mm tree.  Its filename was
     maple_tree-add-some-alloc-node-test-case.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiazi Li <jqqlijiazi@gmail.com>
Subject: maple_tree: add some alloc node test case
Date: Wed, 26 Jun 2024 12:06:31 -0400

Add some maple_tree alloc node tese case.

Link: https://lkml.kernel.org/r/20240626160631.3636515-2-Liam.Howlett@oracle.com
Signed-off-by: Jiazi Li <jqqlijiazi@gmail.com>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Suggested-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/maple.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/tools/testing/radix-tree/maple.c~maple_tree-add-some-alloc-node-test-case
+++ a/tools/testing/radix-tree/maple.c
@@ -462,6 +462,28 @@ static noinline void __init check_new_no
 	MT_BUG_ON(mt, mas_allocated(&mas) != 10 + MAPLE_ALLOC_SLOTS - 1);
 	mas_destroy(&mas);
 
+	mas.node = MA_ERROR(-ENOMEM);
+	mas_node_count(&mas, MAPLE_ALLOC_SLOTS + 1); /* Request */
+	mas_nomem(&mas, GFP_KERNEL); /* Fill request */
+	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS + 1);
+	mas.node = MA_ERROR(-ENOMEM);
+	mas_node_count(&mas, MAPLE_ALLOC_SLOTS * 2 + 2); /* Request */
+	mas_nomem(&mas, GFP_KERNEL); /* Fill request */
+	mas.status = ma_start;
+	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS * 2 + 2);
+	mas_destroy(&mas);
+
+	mas.node = MA_ERROR(-ENOMEM);
+	mas_node_count(&mas, MAPLE_ALLOC_SLOTS * 2 + 1); /* Request */
+	mas_nomem(&mas, GFP_KERNEL); /* Fill request */
+	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS * 2 + 1);
+	mas.node = MA_ERROR(-ENOMEM);
+	mas_node_count(&mas, MAPLE_ALLOC_SLOTS * 3 + 2); /* Request */
+	mas_nomem(&mas, GFP_KERNEL); /* Fill request */
+	mas.status = ma_start;
+	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS * 3 + 2);
+	mas_destroy(&mas);
+
 	mtree_unlock(mt);
 }
 
_

Patches currently in -mm which might be from jqqlijiazi@gmail.com are


