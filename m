Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7FC145329
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810149; cv=none; b=PFpE1YPqKWz3Ch316+zekQWatHpDGfqQXIp3YPXVJW8oNPY/x672LCsl7K92k4gB21NimwdbaiAIGvKNpxroz8T2KaJuEJe/pq0HQfp8xcMXoPe9SXaQfryoIF4VJ4NQaaGZlDuVjZKWrNW7tXmjsl7qdbpwTExIp/IRtz4ESxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810149; c=relaxed/simple;
	bh=h8qGHyrJyBLtaKtGt97w77y25sokZq268NvCNeixyPY=;
	h=Date:To:From:Subject:Message-Id; b=FiYrYOOm1diWkwdXa7Mgbe6Gmoj7gcgpDDn0LqA/pC3WohUI9upcXvVgMZr8iss+Gr374M16YXegnJKBxPxNsBr0plHYF+MD5JBnHSSnCtztrp73kGGmVlVH1ADK1M7XmvRBcJ8pnfi7RiyoOQRJ82T0UoSKN5FU4EzfxJnR3aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NtSnOzkF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NtSnOzkF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB1ABC4CEEB;
	Sun, 14 Sep 2025 00:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810149;
	bh=h8qGHyrJyBLtaKtGt97w77y25sokZq268NvCNeixyPY=;
	h=Date:To:From:Subject:From;
	b=NtSnOzkFE2bDAzTrcJpRzJxxVBofmYWmjJBtyqOieiIlWGNYNsJ+zOfxuSw5QEnxg
	 a8n7gujelEmY+WxdLr3uMpKlY/PXVQfl8mtrwAmVBaFJ060X2UMJIey104InaREPm/
	 Y4Hp4Pd7iKboJGAoq8hCIkLLCXUdrIyogCfhttDY=
Date: Sat, 13 Sep 2025 17:35:48 -0700
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,409411716@gms.tku.edu.tw,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] btree-simplify-merge-logic-by-using-btree_last-return-value.patch removed from -mm tree
Message-Id: <20250914003548.EB1ABC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: btree: simplify merge logic by using btree_last() return value
has been removed from the -mm tree.  Its filename was
     btree-simplify-merge-logic-by-using-btree_last-return-value.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Subject: btree: simplify merge logic by using btree_last() return value
Date: Wed, 27 Aug 2025 00:17:41 +0800

Previously btree_merge() called btree_last() only to test existence, then
performed an extra btree_lookup() to fetch the value.  This patch changes
it to directly use the value returned by btree_last(), avoiding redundant
lookups and simplifying the merge loop.

Link: https://lkml.kernel.org/r/20250826161741.686704-1-409411716@gms.tku.edu.tw
Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/btree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/btree.c~btree-simplify-merge-logic-by-using-btree_last-return-value
+++ a/lib/btree.c
@@ -653,9 +653,9 @@ int btree_merge(struct btree_head *targe
 	 * walks to remove a single object from the victim.
 	 */
 	for (;;) {
-		if (!btree_last(victim, geo, key))
+		val = btree_last(victim, geo, key);
+		if (!val)
 			break;
-		val = btree_lookup(victim, geo, key);
 		err = btree_insert(target, geo, key, val, gfp);
 		if (err)
 			return err;
_

Patches currently in -mm which might be from 409411716@gms.tku.edu.tw are


