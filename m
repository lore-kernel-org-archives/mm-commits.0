Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B576C1EEE6
	for <mm-commits@vger.kernel.org>; Sun,  8 Feb 2026 08:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770538212; cv=none; b=m734zQ1cU8vOXK/jLnyWTYZp85BxNTBkVV0KHijCQOBK1WdIBKyVbWxYU7wpzv8QMoc5gIyjFQmLfiSEocvp7ulX4LYMan05xij7O4xcufwwKmmzhhxLGAFnL31HPLnlU4j7K8XYH8Gd51O5r0YCoE8P354SHE29jLa1UuDbCDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770538212; c=relaxed/simple;
	bh=3L6/uSInER9LnB3x9644QUxHmvK0Hxc6Vl7BNVum9/g=;
	h=Date:To:From:Subject:Message-Id; b=m0HYk9RfwfLG4O6m60kyoZSQ9VKc1TtiLXwHhdpAS0F87RUF68ks3DLBGkD8xIWVcr/4BW4BS18HBcCbn23UxOUJC2HqTX9Hq6O2kpF6d6S43Owv8Qg/gA1p4nx0GJ+emn+H02Y4qqzISCvUbKg+9p6JyP265gEF2RistSw+xd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zoQ4lMM+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zoQ4lMM+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDA2C4CEF7;
	Sun,  8 Feb 2026 08:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770538212;
	bh=3L6/uSInER9LnB3x9644QUxHmvK0Hxc6Vl7BNVum9/g=;
	h=Date:To:From:Subject:From;
	b=zoQ4lMM+gOGjTkiIGnZH20dR6Obs96oYrHGVW7f/k4aAi3lU1ggK16mNtN2tUlSpF
	 td0w1Bv4TzZ3sn1x3F8yp0ySDsB0uGPD48O/ujyCmUOf4Va+35NycbDtsXsmpEVZeH
	 Cya5TpiSxxLor82CIIWAMz0Q4ZXer8GMjikQtoR4=
Date: Sun, 08 Feb 2026 00:10:11 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,bingjiao@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmscan-select-the-closest-perferred-node-in-demote_folio_list-fix.patch removed from -mm tree
Message-Id: <20260208081012.2EDA2C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-vmscan-select-the-closest-perferred-node-in-demote_folio_list-fix
has been removed from the -mm tree.  Its filename was
     mm-vmscan-select-the-closest-perferred-node-in-demote_folio_list-fix.patch

This patch was dropped because it was folded into mm-vmscan-select-the-closest-perferred-node-in-demote_folio_list.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmscan-select-the-closest-perferred-node-in-demote_folio_list-fix
Date: Fri Feb  6 12:00:18 PM PST 2026

fix comment typo, per Shakeel

Cc: Bing Jiao <bingjiao@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-tiers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-tiers.c~mm-vmscan-select-the-closest-perferred-node-in-demote_folio_list-fix
+++ a/mm/memory-tiers.c
@@ -365,7 +365,7 @@ int next_demotion_node(int node, const n
 		return node_random(&mask);
 
 	/*
-	 * Preferred nodes are not in allowed_mask. Filp bits in
+	 * Preferred nodes are not in allowed_mask. Flip bits in
 	 * allowed_mask as used node mask. Then, use it to get the
 	 * closest demotion target.
 	 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-select-the-closest-perferred-node-in-demote_folio_list.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
maple_tree-add-cp_is_new_root-helper-fix-fix.patch

