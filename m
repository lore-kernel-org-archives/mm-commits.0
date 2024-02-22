Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185142904
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560120; cv=none; b=KHV1PpF3dSkpoh9x1yI5+obGltV0iS/UVaM0QR5kOUXjsTWXaax3wpDJa/3+MrR7bRPVhZYwihfuBGLNSiteULLZFUcfCZg8DSGXjzMUvvAHtCPUC6RzvA2BcndN3TQ9ss63w9Hx1gr2/h6V/h9gIrZzoHzg7/qsISCI7w35fBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560120; c=relaxed/simple;
	bh=AV/0ZVtQeqlimJD/XPY49FA9LHRF9UrElO2sSuc5ngM=;
	h=Date:To:From:Subject:Message-Id; b=CSLQddC4TCAJDO6/YfWgW/3EP2Rdf9f6GxB9qKTszSKGDOVoFGNvzx1HnZD4jQcQBiWf+8VNW9c0C+hk35QPl5cwMT3QGtu7/2nh3HdKKWpKLrFmu4cVqETvMmwFS2rWXhjiGtp5glvbKiX0chA15u4ZmIoAI6Eml/MxVCyam4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b6d0BoGF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b6d0BoGF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF354C43390;
	Thu, 22 Feb 2024 00:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560120;
	bh=AV/0ZVtQeqlimJD/XPY49FA9LHRF9UrElO2sSuc5ngM=;
	h=Date:To:From:Subject:From;
	b=b6d0BoGFOF6n2RaT0qDt56CpPYjlIazmZoC2C5Usz/vGvKIWZ+pl7qubw324BrN+0
	 ONBMZzA1bqEV3t4O95NwTAUxXijCnkxdBwoHqMhgbuHDsf29Z0rElsylePmPeZ2g1Q
	 4sfW3rMJ6tmPN2boxxoEiRnIxkY+i3iDvJomYOZQ=
Date: Wed, 21 Feb 2024 16:01:59 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-simplify-zswap_invalidate.patch removed from -mm tree
Message-Id: <20240222000159.DF354C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: simplify zswap_invalidate()
has been removed from the -mm tree.  Its filename was
     mm-zswap-simplify-zswap_invalidate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: simplify zswap_invalidate()
Date: Mon, 29 Jan 2024 20:36:45 -0500

The branching is awkward and duplicates code. The comment about
writeback is also misleading: yes, the entry might have been written
back. Or it might have never been stored in zswap to begin with due to
a rejection - zswap_invalidate() is called on all exiting swap entries.

Link: https://lkml.kernel.org/r/20240130014208.565554-10-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/mm/zswap.c~mm-zswap-simplify-zswap_invalidate
+++ a/mm/zswap.c
@@ -1739,15 +1739,10 @@ void zswap_invalidate(int type, pgoff_t
 	struct zswap_tree *tree = swap_zswap_tree(swp_entry(type, offset));
 	struct zswap_entry *entry;
 
-	/* find */
 	spin_lock(&tree->lock);
 	entry = zswap_rb_search(&tree->rbroot, offset);
-	if (!entry) {
-		/* entry was written back */
-		spin_unlock(&tree->lock);
-		return;
-	}
-	zswap_invalidate_entry(tree, entry);
+	if (entry)
+		zswap_invalidate_entry(tree, entry);
 	spin_unlock(&tree->lock);
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


