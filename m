Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991441DB55D
	for <mm-commits@vger.kernel.org>; Wed, 15 Jan 2025 23:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736982304; cv=none; b=YM0HKfYyTKeHmjaeT4Gu41Xd8vRaarbc73uqtMwxo0dh0d0nEyb03QFGDxK+zwIrGU+vBaRqM8+MHA6yQ2dMlzu5dlye2E4tvhqaEP3Ik4Q3qpFvos0qWVVaDNeHDSpLNaRXFU34mE/YicDSJFHNdhGhqgOb6QUQ/2SbgNDtPJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736982304; c=relaxed/simple;
	bh=3b1mwmewFgNFmqAPwqLEiA4X3m2f+fEU8zXT9ZBKxmc=;
	h=Date:To:From:Subject:Message-Id; b=k0rEHaCFd2QGkyhEZNf1urF9gnAXPhOCAzG36bo1QTyTwWFU2i4lDtQ2YbKidGO89k1TUcgFEKg5e8YXG/klctsF9toGIyELLq6JmTNnc8hjFGxsEUvQSFU4vJDvWtXxUZYHsWd87UjdlVhmlrLjDeTQMGA4Dxbav04tsh3I2KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YraGGCV4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YraGGCV4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08EA6C4CED1;
	Wed, 15 Jan 2025 23:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736982304;
	bh=3b1mwmewFgNFmqAPwqLEiA4X3m2f+fEU8zXT9ZBKxmc=;
	h=Date:To:From:Subject:From;
	b=YraGGCV4hPk1j38MfFMVM8NgHd2WcRPZHyL1PfAqEuinu4KWj+Rs+QEPtKBZHpcsZ
	 LsTWeOnEyQboJgrP7Z9A8nWaT5H7IzN7Da6HKtWhmwrHsM5TNnDaXDuAgzaE2n/sAa
	 974wz3ettLGuyFFxmiExqsf4bL9AUkYVErGSYI9I=
Date: Wed, 15 Jan 2025 15:05:03 -0800
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-use-a-global-swap-cluster-for-non-rotation-devices-fix.patch added to mm-unstable branch
Message-Id: <20250115230504.08EA6C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-swap-use-a-global-swap-cluster-for-non-rotation-devices-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-use-a-global-swap-cluster-for-non-rotation-devices-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-use-a-global-swap-cluster-for-non-rotation-devices-fix.patch

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

mm-swap-use-a-global-swap-cluster-for-non-rotation-devices-fix.patch

