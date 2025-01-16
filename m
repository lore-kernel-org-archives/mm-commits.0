Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A131487C8
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737005810; cv=none; b=cIjVYZQEaS/lQhxA3hzkR4oQQ1SxKJC0RfYFxb2nw+eNhtz+oKw1YK3nSnETYa1eG8p0m3E4bkN7TBDm/OjE0Hu63QB8WeT6jNJwCikPNAPJ/ywOS7hEbk+l5EUYctDbQSR+sWDv1PFkSgxrI7K9iyJKvOWVtoZ/kTpHUMn2vtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737005810; c=relaxed/simple;
	bh=KWS9sO8deR0X686fUhH3JFx+aNPU+Nx1urH54G/HD2c=;
	h=Date:To:From:Subject:Message-Id; b=gbm5BtLXE3pRPf8bNRFJXbFIGgVEUgl1g+m80pVFmhSr4ITT6EQFvr6UXJxOmTUgV5LMvq2jDB5VTFx0UCVS3/hs9ZKtzACErxjCJJkKS4jh9WcIpa1MrM2VjUpWRBSwG1xWEULP2X4oGY4tG6iKEG77llJRVgTQIZy+3vyKcWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gmBxkYB3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gmBxkYB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9011EC4CED6;
	Thu, 16 Jan 2025 05:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737005809;
	bh=KWS9sO8deR0X686fUhH3JFx+aNPU+Nx1urH54G/HD2c=;
	h=Date:To:From:Subject:From;
	b=gmBxkYB3Vd/7Yb/aoJsFLo/yw25pt2TY9T1aTJWn3e207a5oGLkxgZMkwQF2yVAQ6
	 v9G4Cf1HtRUB5Cj9uak/iF0+Fph5ltSsuS6rsa3iZQ45g3EEWlSSfTLJuFJ7xy8lhc
	 Ro1Q9dql2jMRVCo790Dix/0+ll4kPKNqYguGME6Q=
Date: Wed, 15 Jan 2025 21:36:49 -0800
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-use-a-global-swap-cluster-for-non-rotation-devices-fix.patch removed from -mm tree
Message-Id: <20250116053649.9011EC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-swap-use-a-global-swap-cluster-for-non-rotation-devices-fix
has been removed from the -mm tree.  Its filename was
     mm-swap-use-a-global-swap-cluster-for-non-rotation-devices-fix.patch

This patch was dropped because it was folded into mm-swap-use-a-global-swap-cluster-for-non-rotation-devices.patch

------------------------------------------------------
From: Kairui Song <ryncsn@gmail.com>
Subject: mm-swap-use-a-global-swap-cluster-for-non-rotation-devices-fix
Date: Wed, 15 Jan 2025 18:51:57 +0800

check kmalloc() return in setup_clusters

Link: https://lkml.kernel.org/r/CAMgjq7Au+o04ckHyT=iU-wVx9az=t0B-ZiC5E0bDqNrAtNOP-g@mail.gmail.com
Signed-off-by: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-use-a-global-swap-cluster-for-non-rotation-devices-fix
+++ a/mm/swapfile.c
@@ -3217,7 +3217,10 @@ static struct swap_cluster_info *setup_c
 			local_lock_init(&cluster->lock);
 		}
 	} else {
-		si->global_cluster = kmalloc(sizeof(*si->global_cluster), GFP_KERNEL);
+		si->global_cluster = kmalloc(sizeof(*si->global_cluster),
+				     GFP_KERNEL);
+		if (!si->global_cluster)
+			goto err_free;
 		for (i = 0; i < SWAP_NR_ORDERS; i++)
 			si->global_cluster->next[i] = SWAP_ENTRY_INVALID;
 		spin_lock_init(&si->global_cluster_lock);
_

Patches currently in -mm which might be from ryncsn@gmail.com are

mm-swap-use-a-global-swap-cluster-for-non-rotation-devices.patch

