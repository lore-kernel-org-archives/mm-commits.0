Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCEE173357
	for <mm-commits@vger.kernel.org>; Tue, 15 Oct 2024 23:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729033689; cv=none; b=clb7X6cMn2oMlSOGLGlt7z6WfIkdJVwZxCbP0sF2ONtN+2J4wH8kKVK6dmHoQ6tkjGBDS9FV2/hPmrCkYBLjimgT/U0x4c3f3MRm3jH76iT4axlWpJ6HqY4R/9+eyxRWO/ib9/2ucDDw8pm8TZimPbSOvXOoQaJRIGAFy6h122g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729033689; c=relaxed/simple;
	bh=SqNAnb/+1CiMoQmO7y9v7A17lCkD9qtoECZBZmOVuko=;
	h=Date:To:From:Subject:Message-Id; b=ABFsXN+oUPl/ap6DS/X7CHhSHPuPocCRvFSlO0MTiOxKVymd2rWyKrZVY3iq1hxceWJ96CBUrc11sPsdYZD6bcZtr1Xp6mKxYuFx6yEi6ZbzNC1p+15Elsie77X39j3A+6a3lL6HVxJeO9QnIQwzTN/+tIMDbdXOJQFx+NMf0qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EyikBolU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EyikBolU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342A9C4CEC6;
	Tue, 15 Oct 2024 23:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729033689;
	bh=SqNAnb/+1CiMoQmO7y9v7A17lCkD9qtoECZBZmOVuko=;
	h=Date:To:From:Subject:From;
	b=EyikBolUBbQe1TTvG+rGMmi6J5yT7X1BXf+7KPFLYi3GZBteYA9nBEXcZU4Thpox5
	 pJz7DIInQm5GPZI5ZKdEpCiURcIc6OZYVivwcYhWmlOHKTg9vpfx0T0eJWG+z8Fy83
	 aDg4I2LSsEcoteNhG311iAVqu39jfn4A+6oc7kbk=
Date: Tue, 15 Oct 2024 16:08:08 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-total-is-not-changed-for-nomem_one-case.patch added to mm-unstable branch
Message-Id: <20241015230809.342A9C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: total is not changed for nomem_one case
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-total-is-not-changed-for-nomem_one-case.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-total-is-not-changed-for-nomem_one-case.patch

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

maple_tree-i-is-always-less-than-or-equal-to-mas_end.patch
maple_tree-goto-complete-directly-on-a-pivot-of-0.patch
maple_tree-remove-maple_big_nodeparent.patch
maple_tree-memset-maple_big_node-as-a-whole.patch
maple_tree-root-node-could-be-handled-by-p_slot-too.patch
maple_tree-clear-request_count-for-new-allocated-one.patch
maple_tree-total-is-not-changed-for-nomem_one-case.patch
maple_tree-simplify-mas_push_node.patch

