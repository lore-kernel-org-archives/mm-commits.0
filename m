Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5ACDF4D
	for <mm-commits@vger.kernel.org>; Sun, 28 Jan 2024 08:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706430272; cv=none; b=WW/G6EdvPxOZiGxIwcUFfCg1pe8jHcBr94gPgPbnvq2LHRRnEUuQ99SvREf3hDomksdhkyrzu1ZASKNimTYPtuX4WNNGO2TWHmrc3d9RDZv8eYhC9VwV9dvOjzKkjsfj+9eHGAa8WaIXFhhTAMSd5H1rK+qp3L5hYNGNFYW2mjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706430272; c=relaxed/simple;
	bh=27i3sVyWNXX+BUhQUCYMNM9tPDF0C+EbHTYSarP2ckw=;
	h=Date:To:From:Subject:Message-Id; b=aQRtkDp8pJ/gnyrCYFN/OXvNUXJifp6dZt/QC/nFB4d3zjz4zzHUcXGaM5TtkT/nTelzIBOROoV1dkj9OzB7ndEH0X4XaHGs+37e8qYS55fQ+ZvC9oNmV9LxCNd6dSHkuX15lQujHciB+JhxNxXFuRYteZXPd7jKhPz0fCiuLEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fMadehBf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fMadehBf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8936BC433C7;
	Sun, 28 Jan 2024 08:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706430272;
	bh=27i3sVyWNXX+BUhQUCYMNM9tPDF0C+EbHTYSarP2ckw=;
	h=Date:To:From:Subject:From;
	b=fMadehBfWdxpIjmHE8GmOIH9mcUVMnXDYdFiZdwj5TRA8TxeXzFNs6FcX71wZGm/f
	 tu63LRYX9X270S0bas+Z9GMm1l+3OdGCy4Uwm0KFKvGcY2zTuk2j39t6pnlT7zHqV+
	 rBJsSBKQ1vdHiq6ANgjzrBfpPgMgYcWWrFfIy5eY=
Date: Sun, 28 Jan 2024 00:24:28 -0800
To: mm-commits@vger.kernel.org,ppbuk5246@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kswapd-replace-try_to_freeze-to-kthread_freezable_should_stop.patch added to mm-unstable branch
Message-Id: <20240128082431.8936BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kswapd: replace try_to_freeze() with kthread_freezable_should_stop()
has been added to the -mm mm-unstable branch.  Its filename is
     kswapd-replace-try_to_freeze-to-kthread_freezable_should_stop.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kswapd-replace-try_to_freeze-to-kthread_freezable_should_stop.patch

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
From: Levi Yun <ppbuk5246@gmail.com>
Subject: kswapd: replace try_to_freeze() with kthread_freezable_should_stop()
Date: Fri, 26 Jan 2024 15:25:54 +0000

Instead of using try_to_freeze, use kthread_freezable_should_stop in
kswapd.  By this, we can avoid unnecessary freezing when kswapd should
stop.

Link: https://lkml.kernel.org/r/20240126152556.58791-1-ppbuk5246@gmail.com
Signed-off-by: Levi Yun <ppbuk5246@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/vmscan.c~kswapd-replace-try_to_freeze-to-kthread_freezable_should_stop
+++ a/mm/vmscan.c
@@ -6796,6 +6796,7 @@ restart:
 		bool raise_priority = true;
 		bool balanced;
 		bool ret;
+		bool was_frozen;
 
 		sc.reclaim_idx = highest_zoneidx;
 
@@ -6894,9 +6895,9 @@ restart:
 
 		/* Check if kswapd should be suspending */
 		__fs_reclaim_release(_THIS_IP_);
-		ret = try_to_freeze();
+		ret = kthread_freezable_should_stop(&was_frozen);
 		__fs_reclaim_acquire(_THIS_IP_);
-		if (ret || kthread_should_stop())
+		if (was_frozen || ret)
 			break;
 
 		/*
@@ -7102,7 +7103,7 @@ static int kswapd(void *p)
 	WRITE_ONCE(pgdat->kswapd_highest_zoneidx, MAX_NR_ZONES);
 	atomic_set(&pgdat->nr_writeback_throttled, 0);
 	for ( ; ; ) {
-		bool ret;
+		bool was_frozen;
 
 		alloc_order = reclaim_order = READ_ONCE(pgdat->kswapd_order);
 		highest_zoneidx = kswapd_highest_zoneidx(pgdat,
@@ -7119,15 +7120,14 @@ kswapd_try_sleep:
 		WRITE_ONCE(pgdat->kswapd_order, 0);
 		WRITE_ONCE(pgdat->kswapd_highest_zoneidx, MAX_NR_ZONES);
 
-		ret = try_to_freeze();
-		if (kthread_should_stop())
+		if (kthread_freezable_should_stop(&was_frozen))
 			break;
 
 		/*
 		 * We can speed up thawing tasks if we don't call balance_pgdat
 		 * after returning from the refrigerator
 		 */
-		if (ret)
+		if (was_frozen)
 			continue;
 
 		/*
_

Patches currently in -mm which might be from ppbuk5246@gmail.com are

kswapd-replace-try_to_freeze-to-kthread_freezable_should_stop.patch

