Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFB62207D
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 21:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h1/IzvZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0D7C433C9;
	Wed, 13 Dec 2023 21:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702501767;
	bh=xhGOgVvwp5NtBV8+ZEWRnhdo6UfU9Htq/63Xv91ABPw=;
	h=Date:To:From:Subject:From;
	b=h1/IzvZhPL86CGj46+mWV9GxDZlpZjN0N7p0rx9Kn4GPlfepUzrqTaYZrzjOCG8Yy
	 K1Ldq6IMv3pgyFnZIg8EP795cQ+SBN1Az7ybLPB9Iy4ZFJTjyVDu2ourC5CjO0hu4M
	 iEVBeSvGsObvyt9c3ZvF1UP4qmaUsuqpd5dcW2l0=
Date: Wed, 13 Dec 2023 13:09:26 -0800
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-maple_treec-fix-build-error-due-to-hotfix-alteration.patch added to mm-unstable branch
Message-Id: <20231213210927.1F0D7C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/maple_tree.c: fix build error due to hotfix alteration
has been added to the -mm mm-unstable branch.  Its filename is
     lib-maple_treec-fix-build-error-due-to-hotfix-alteration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-maple_treec-fix-build-error-due-to-hotfix-alteration.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib/maple_tree.c: fix build error due to hotfix alteration
Date: Wed Dec 13 12:59:49 PM PST 2023

Commit 0de56e38b307 ("maple_tree: use maple state end for write
operations") was broken by a later patch "maple_tree: do not preallocate
nodes for slot stores".  But the later patch was scheduled ahead of
0de56e38b307, for 6.7-rc.

This fixlet undoes the damage.

Fixes: 0de56e38b307 ("maple_tree: use maple state end for write operations")
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~lib-maple_treec-fix-build-error-due-to-hotfix-alteration
+++ a/lib/maple_tree.c
@@ -5477,7 +5477,7 @@ int mas_preallocate(struct ma_state *mas
 	node_size = mas_wr_new_end(&wr_mas);
 
 	/* Slot store, does not require additional nodes */
-	if (node_size == wr_mas.node_end) {
+	if (node_size == mas->end) {
 		/* reuse node */
 		if (!mt_in_rcu(mas->tree))
 			return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-maple_treec-fix-build-error-due-to-hotfix-alteration.patch
mm-memcg-restore-subtree-stats-flushing-fix.patch

