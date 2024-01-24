Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36AD18658
	for <mm-commits@vger.kernel.org>; Wed, 24 Jan 2024 10:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706091420; cv=none; b=elF3nRFASAd6sngY5P/eUZ2htIkOmYbRREohbBgnNT3jacxQUrGiOcQ16MUQsFEZv4llWR+FtCZDmkXMGPD++o9dTWdJb1hIlEbj9sZRpkTDaPP4eMVnQFcCc7MkxLCobOG1KNxSWpfNBTtCp/e0Q89Q3tROkfbvpdkPA7mTxUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706091420; c=relaxed/simple;
	bh=bCcispOPqSdY07uiv4TwhlNfDHwHRT1IqhM3huUHVRw=;
	h=Date:To:From:Subject:Message-Id; b=eNsdnVwSLP2PD8iV6M3YLhgRZRy6wE+U9w8c+bs/l/lZCZOGxK36adm9CzU3JidK42yoF5Abm85SZEAU9DzP0FKXkrKKvyheCYNYfYkt99WgpBP3L8FhwzBu2c3MQvXumrT94y4bXTQpA6tqA8aUFRYlgviFYh2GoNLDGP055Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UOeik249; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UOeik249"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88757C433F1;
	Wed, 24 Jan 2024 10:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706091420;
	bh=bCcispOPqSdY07uiv4TwhlNfDHwHRT1IqhM3huUHVRw=;
	h=Date:To:From:Subject:From;
	b=UOeik249MdlN7gNtat26iRmUkywz+1N6qjb/8hZTm1U6c/34MjfQUMRIBDdjD5TpT
	 Q+DlQ/b0wWGV6B+/g/DoMQf6/mrdrgVLcaihy2ZgskYrRiq2cXWHYXmYWl90QeGX3G
	 27qFdsOV6gh9mi29EWMIpxLxnf7uTB95Xe+gw4i0=
Date: Wed, 24 Jan 2024 02:16:57 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,ying.huang@intel.com,nphamcs@gmail.com,hannes@cmpxchg.org,chrisl@kernel.org,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-remove-unnecessary-trees-cleanups-in-zswap_swapoff.patch added to mm-unstable branch
Message-Id: <20240124101659.88757C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: remove unnecessary trees cleanups in zswap_swapoff()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-remove-unnecessary-trees-cleanups-in-zswap_swapoff.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-remove-unnecessary-trees-cleanups-in-zswap_swapoff.patch

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
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: zswap: remove unnecessary trees cleanups in zswap_swapoff()
Date: Wed, 24 Jan 2024 04:51:12 +0000

During swapoff, try_to_unuse() makes sure that zswap_invalidate() is
called for all swap entries before zswap_swapoff() is called.  This means
that all zswap entries should already be removed from the tree.  Simplify
zswap_swapoff() by removing the trees cleanup code, and leave an assertion
in its place.

Link: https://lkml.kernel.org/r/20240124045113.415378-3-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

--- a/mm/zswap.c~mm-zswap-remove-unnecessary-trees-cleanups-in-zswap_swapoff
+++ a/mm/zswap.c
@@ -1808,19 +1808,9 @@ void zswap_swapoff(int type)
 	if (!trees)
 		return;
 
-	for (i = 0; i < nr_zswap_trees[type]; i++) {
-		struct zswap_tree *tree = trees + i;
-		struct zswap_entry *entry, *n;
-
-		/* walk the tree and free everything */
-		spin_lock(&tree->lock);
-		rbtree_postorder_for_each_entry_safe(entry, n,
-						     &tree->rbroot,
-						     rbnode)
-			zswap_free_entry(entry);
-		tree->rbroot = RB_ROOT;
-		spin_unlock(&tree->lock);
-	}
+	/* try_to_unuse() invalidated all the entries already */
+	for (i = 0; i < nr_zswap_trees[type]; i++)
+		WARN_ON_ONCE(!RB_EMPTY_ROOT(&trees[i].rbroot));
 
 	kvfree(trees);
 	nr_zswap_trees[type] = 0;
_

Patches currently in -mm which might be from yosryahmed@google.com are

maintainers-supplement-of-zswap-maintainers-update.patch
mm-swap-enforce-updating-inuse_pages-at-the-end-of-swap_range_free.patch
mm-zswap-remove-unnecessary-trees-cleanups-in-zswap_swapoff.patch

