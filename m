Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2196E43ACB
	for <mm-commits@vger.kernel.org>; Tue, 15 Oct 2024 04:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728967097; cv=none; b=Ylvlf4TxTPQK42USmDp8+vFqWuBwVhRFoOAmkTOng5+A/wiJndI+ga/AJtQWUoofdMkwML+8Pq/LWGljVCWsT2vVmDkhnj+LW2PXK0d9T7pdvrpnDcolBvoCtACw3zKxRVujy5qJAmQnizmnrkbDDjSA5NNw6QKC03sXrr/vVxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728967097; c=relaxed/simple;
	bh=mJyUqUF4o3H6xSfNp+ULj3aXlHrnarQ600NlFgsSirk=;
	h=Date:To:From:Subject:Message-Id; b=CMX0XWxmMSKRwOgHFWbJS/jAcLxRsFXq7jak0y1AbMPIA81IqUdgnsnnBKgpb31OnQNON9SN8W6hGH3tvHOouhXyxAovPpYCcMiXblmy/625JWwex8PCnKZT9jRe5LThWKa6sicmr7jBlqCT3ctCdVlur52sryDtc/yjf7TIA7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JZCaBL9y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JZCaBL9y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE389C4CEC7;
	Tue, 15 Oct 2024 04:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728967096;
	bh=mJyUqUF4o3H6xSfNp+ULj3aXlHrnarQ600NlFgsSirk=;
	h=Date:To:From:Subject:From;
	b=JZCaBL9yK1yBdmjlKJirerPUooRXl743OVr1cRYFHTLaTNRUOiQVMKlVwNmvchxto
	 JPJEj99Dh7kxxPlD1xlLGHsu6xAeXnZLXbO9ED0ZaXms59Pmo8IqoZiM2hpLrv4A61
	 sp33QP/mkF+VFyeZoxdn0fgqggSNZ1rayiFOFAek=
Date: Mon, 14 Oct 2024 21:38:16 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,Liam.Howlett@oracle.com,jqqlijiazi@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-some-alloc-node-test-case.patch added to mm-unstable branch
Message-Id: <20241015043816.AE389C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: Add some alloc node test case
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-add-some-alloc-node-test-case.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-some-alloc-node-test-case.patch

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
From: Jiazi Li <jqqlijiazi@gmail.com>
Subject: maple_tree: Add some alloc node test case
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

maple_tree-fix-alloc-node-fail-issue.patch
maple_tree-add-some-alloc-node-test-case.patch

