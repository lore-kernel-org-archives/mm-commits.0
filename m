Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C95E535D4
	for <mm-commits@vger.kernel.org>; Thu, 23 May 2024 20:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716495208; cv=none; b=XyG8INLpr/vSHu7Oc2W1xnzs06Az4DiftreIrcxnOzG73zWE2N2akashgoPyqLW2R6/3FiON+dEDTZQzTorBujlTbXNYA3Mc5MYCJd8vRcXDegfuF2+XF1ay9PvCrz3+jJHnyNSKdRHZvjVVs+hj9oJbapAPHNOhq81QkYtJjrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716495208; c=relaxed/simple;
	bh=c0xAp/te0DIShlEeszFF522eQubpRfDX/fxRUyu2W8c=;
	h=Date:To:From:Subject:Message-Id; b=ApNAH3EsmhnaZrDiMc9Z/tF4lo2LaH516V40KRwzFNrySwv71Q2fB0LoPDS4/U/WHwx69mCwPdsuRcrei8tT70mAU0T2Ea9l9i+4GD76wvpIMZP5ZlKzq4WGbcgbVY0GqpJns9alfJkrvyxhD2nj9PJUEAz9X9Rg0Bd1QDPtySQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sx1gMwvi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sx1gMwvi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C26C2BD10;
	Thu, 23 May 2024 20:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716495208;
	bh=c0xAp/te0DIShlEeszFF522eQubpRfDX/fxRUyu2W8c=;
	h=Date:To:From:Subject:From;
	b=sx1gMwviAJbZT5HsxyUlvVBaYSi/zYM6Y0j4ptg1FvC3+UebEqm6NdBuhC7xr7P60
	 ppRbtTNnVSVy4dE7pJLcjmBP+nNX3sNr2tOD3ObzSK3AI1VCbDVOmHy0V25C8AOxbu
	 +hQa2uvVBlqVqWrS/WRYEEe+aw9bdcnjgYbmBRPs=
Date: Thu, 23 May 2024 13:13:27 -0700
To: mm-commits@vger.kernel.org,shr@devkernel.io,hughd@google.com,david@redhat.com,aarcange@redhat.com,chengming.zhou@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-fix-possible-uaf-of-stable_node.patch added to mm-hotfixes-unstable branch
Message-Id: <20240523201328.07C26C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: fix possible UAF of stable_node
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-ksm-fix-possible-uaf-of-stable_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-fix-possible-uaf-of-stable_node.patch

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
From: Chengming Zhou <chengming.zhou@linux.dev>
Subject: mm/ksm: fix possible UAF of stable_node
Date: Mon, 13 May 2024 11:07:56 +0800

The commit 2c653d0ee2ae ("ksm: introduce ksm_max_page_sharing per page
deduplication limit") introduced a possible failure case in the
stable_tree_insert(), where we may free the new allocated stable_node_dup
if we fail to prepare the missing chain node.

Then that kfolio return and unlock with a freed stable_node set...  And
any MM activities can come in to access kfolio->mapping, so UAF.

Fix it by moving folio_set_stable_node() to the end after stable_node
is inserted successfully.

Link: https://lkml.kernel.org/r/20240513-b4-ksm-stable-node-uaf-v1-1-f687de76f452@linux.dev
Fixes: 2c653d0ee2ae ("ksm: introduce ksm_max_page_sharing per page deduplication limit")
Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/ksm.c~mm-ksm-fix-possible-uaf-of-stable_node
+++ a/mm/ksm.c
@@ -2153,7 +2153,6 @@ again:
 
 	INIT_HLIST_HEAD(&stable_node_dup->hlist);
 	stable_node_dup->kpfn = kpfn;
-	folio_set_stable_node(kfolio, stable_node_dup);
 	stable_node_dup->rmap_hlist_len = 0;
 	DO_NUMA(stable_node_dup->nid = nid);
 	if (!need_chain) {
@@ -2172,6 +2171,8 @@ again:
 		stable_node_chain_add_dup(stable_node_dup, stable_node);
 	}
 
+	folio_set_stable_node(kfolio, stable_node_dup);
+
 	return stable_node_dup;
 }
 
_

Patches currently in -mm which might be from chengming.zhou@linux.dev are

mm-ksm-fix-possible-uaf-of-stable_node.patch

