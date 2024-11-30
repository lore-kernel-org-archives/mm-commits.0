Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EAB29B0
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 04:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732941142; cv=none; b=F8sSbX1lgk17uVfI640UZdSuUABbQaDfpbo8hjFtJdRPOmgn2LVEzPcWkkQFCWq1rj9zZZmjQMdYhFuAaPCpW0GLbfMJcDTvRFnsAHNWMNEslPmdBiPvypqmsFRFZPam2nkLR421WIVYdyXejUNHwxItqMuqFCdSvl6pSlZa07s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732941142; c=relaxed/simple;
	bh=TsATt84l1LsIMCVJ+0maVj5kHGliFIeaMZmJs19ILU0=;
	h=Date:To:From:Subject:Message-Id; b=acsZu8ynZmfDyibm7hvMmkCKy3E8+krNdbGEzydrH+DEoNiQ4/M71t5xBqCVixdSyQYRORW0lxEnju+EiHhU5um07voDW1HpsgtD4vtq6Hi3ioM7P0Q3ZVCqNuFD4MDKZudV13K+nyotOoF2gXpyOyjSci4B+SI4q2vd0EIKdDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XhOwzCan; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XhOwzCan"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20783C4CECC;
	Sat, 30 Nov 2024 04:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732941142;
	bh=TsATt84l1LsIMCVJ+0maVj5kHGliFIeaMZmJs19ILU0=;
	h=Date:To:From:Subject:From;
	b=XhOwzCanzmCykGARCX1PN9+ClSZnDvxDDmvb5E14nJaw5xsYY5kiA4tHUZUZVX6tl
	 hlBIA3m8Xb8CMc/20cY04SBlA2LME7rwZVLL3vSaZX9zAqTkA1qz6wE7Ui6wFnY8tz
	 HYBSyUJhO1KjvyqxkuU7wAwZPb76GCZOIwnhEEx4=
Date: Fri, 29 Nov 2024 20:32:21 -0800
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-only-root-node-could-be-deficient.patch added to mm-unstable branch
Message-Id: <20241130043222.20783C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: only root node could be deficient
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-only-root-node-could-be-deficient.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-only-root-node-could-be-deficient.patch

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
Subject: maple_tree: only root node could be deficient
Date: Wed, 13 Nov 2024 03:16:16 +0000

Each level's rightmost node should have (max == ULONG_MAX).  This means
current validation skips the right most node on each level.

Only the root node may be below the minimum data threshold.

Link: https://lkml.kernel.org/r/20241113031616.10530-4-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-only-root-node-could-be-deficient
+++ a/lib/maple_tree.c
@@ -7555,7 +7555,7 @@ void mt_validate(struct maple_tree *mt)
 		MAS_WARN_ON(&mas, mte_dead_node(mas.node));
 		end = mas_data_end(&mas);
 		if (MAS_WARN_ON(&mas, (end < mt_min_slot_count(mas.node)) &&
-				(mas.max != ULONG_MAX))) {
+				(!mte_is_root(mas.node)))) {
 			pr_err("Invalid size %u of " PTR_FMT "\n",
 			       end, mas_mn(&mas));
 		}
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

maple_tree-use-mas_next_slot-directly.patch
maple_tree-index-has-been-checked-to-be-smaller-than-pivot.patch
maple_tree-not-possible-to-be-a-root-node-after-loop.patch
maple_tree-we-dont-set-offset-to-maple_node_slots-on-error.patch
maple_tree-simplify-split-calculation.patch
maple_tree-add-a-test-check-deficient-node.patch
maple_tree-only-root-node-could-be-deficient.patch

