Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B6D4B128
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BGRAMAgH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DFAC433C7;
	Wed, 20 Dec 2023 22:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703112537;
	bh=eQgdJCBK91xAzEMi+NoIiPQpfYGk7kibcFmvrDF1Efs=;
	h=Date:To:From:Subject:From;
	b=BGRAMAgHJo4PxkxgtpMIZrYu7L+BnM+FlmdBsdzqwbUl9h2Nzig84MTu0mNgCcm7r
	 girk1Fbul2AroKgDKgm2NZMm+3K7hq0OMyj5HpBNo/QC78QF6aGfpybT8h543hkO/Y
	 Vxep7y0ziA95zuY5LIJo0mwmTjIT3W1KwxoLNv4Q=
Date: Wed, 20 Dec 2023 14:48:56 -0800
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-maple_treec-fix-build-error-due-to-hotfix-alteration.patch removed from -mm tree
Message-Id: <20231220224857.03DFAC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/maple_tree.c: fix build error due to hotfix alteration
has been removed from the -mm tree.  Its filename was
     lib-maple_treec-fix-build-error-due-to-hotfix-alteration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

maintainers-remove-hugetlb-maintainer-mike-kravetz-fix.patch
mips-fix-r3k_cache_init-build-regression-fix.patch

