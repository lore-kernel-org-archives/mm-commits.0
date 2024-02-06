Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE70E1772D
	for <mm-commits@vger.kernel.org>; Tue,  6 Feb 2024 20:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707250555; cv=none; b=nM5qaY9wOrqjGpcOVERQIDtxIjf49cepeUeDAeGP9OX/ufwIrHymgqihCUd1ooWBX3Hz0hbvRy5TWB/MRhtf/A0CkM1ZLZq058zd/566i1/lMuJJrY6oOIrOXVD1C6eGVYslFi9UAu7ZGh05fogUSNvpch0+8iUzWyynt6VhHCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707250555; c=relaxed/simple;
	bh=1HbTqRVFufFLHRDsRYZmWOMRpWsxPjWJdx5u84C9q3w=;
	h=Date:To:From:Subject:Message-Id; b=AdMFbCQJv24fw9voIpZazrBrzTZIma2gTqJqNiA3GFsMwE9QpPXfsfwFH3c4XG+k78tqLBkoGmk8i83/IOeMVIyxFbvTR4h4rjEgMhyiy7j2f+ovfWosrZWm7XYnNw8iojl1mTy8SHmME5QgcXFOk2fTaXR0lzdx8ib0fxCMRyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IhbVVnqR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IhbVVnqR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243D0C433C7;
	Tue,  6 Feb 2024 20:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707250555;
	bh=1HbTqRVFufFLHRDsRYZmWOMRpWsxPjWJdx5u84C9q3w=;
	h=Date:To:From:Subject:From;
	b=IhbVVnqRu6JSJ70CCxlvb8tBmpMbyzkNq8aB0tS94l/e4V7O6yDWSGDnuFDlwxs/l
	 Qkyv13rnTikLz6pknR1Kycdb5MO+SYBhe5qSnVxNWXNnbi5d5+RzhltGuf3bPu82pX
	 cQY+vtjtT9/AHgX3bStS8Z7ovgvUaMhyYwnVH2vs=
Date: Tue, 06 Feb 2024 12:15:54 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,sthanneeru.opensrc@micron.com,ravis.opensrc@micron.com,rakie.kim@sk.com,mhocko@kernel.org,hyeongtak.ji@sk.com,honggyu.kim@sk.com,Hasan.Maruf@amd.com,hannes@cmpxchg.org,gregory.price@memverge.com,dan.j.williams@intel.com,corbet@lwn.net,gourry.memverge@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-protect-task-interleave-functions-with-tsk-mems_allowed_seq-fix.patch added to mm-unstable branch
Message-Id: <20240206201555.243D0C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: weighted interleave checks wrong parameter
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-protect-task-interleave-functions-with-tsk-mems_allowed_seq-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-protect-task-interleave-functions-with-tsk-mems_allowed_seq-fix.patch

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
From: Gregory Price <gourry.memverge@gmail.com>
Subject: mm/mempolicy: weighted interleave checks wrong parameter
Date: Tue, 6 Feb 2024 14:28:53 -0500

weighted interleave presently checks (!node) when it should check
(!il_weight).  This causes a wrong distribution of memory.

Link: https://lkml.kernel.org/r/20240206192853.3589-1-gregory.price@memverge.com
Signed-off-by: Gregory Price <gregory.price@memverge.com>
Reported-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hasan Al Maruf <Hasan.Maruf@amd.com>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: Hyeongtak Ji <hyeongtak.ji@sk.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ravi Jonnalagadda <ravis.opensrc@micron.com>
Cc: Srinivasulu Thanneeru <sthanneeru.opensrc@micron.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-protect-task-interleave-functions-with-tsk-mems_allowed_seq-fix
+++ a/mm/mempolicy.c
@@ -1881,7 +1881,7 @@ retry:
 	/* to prevent miscount use tsk->mems_allowed_seq to detect rebind */
 	cpuset_mems_cookie = read_mems_allowed_begin();
 	node = current->il_prev;
-	if (!node || !node_isset(node, policy->nodes)) {
+	if (!current->il_weight || !node_isset(node, policy->nodes)) {
 		node = next_node_in(node, policy->nodes);
 		if (read_mems_allowed_retry(cpuset_mems_cookie))
 			goto retry;
_

Patches currently in -mm which might be from gourry.memverge@gmail.com are

mm-mempolicy-refactor-a-read-once-mechanism-into-a-function-for-re-use.patch
mm-mempolicy-introduce-mpol_weighted_interleave-for-weighted-interleaving.patch
mm-mempolicy-protect-task-interleave-functions-with-tsk-mems_allowed_seq.patch
mm-mempolicy-protect-task-interleave-functions-with-tsk-mems_allowed_seq-fix.patch

