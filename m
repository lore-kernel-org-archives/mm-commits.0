Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C17A929
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560107; cv=none; b=FEVIV+u96QzTXI148qQpICNZGd7h8u1I46lahw78KMbNTTwyjCT5e/3cHQJCvuNVsAfyVLM5YIeMOUk3jJ6dF7P2qoZ031efwTYzyBoP4sktbwrmAHWTwp7oEtLpjui+UelO+0+6+9VHGQjcmGnETxuzAC+nknarBePfWV2qGfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560107; c=relaxed/simple;
	bh=xNK/JcTU4pJzS4+7qDHi+rYcs8LF+UN450fE3No8vo8=;
	h=Date:To:From:Subject:Message-Id; b=c5UprwATVSN8U+zP03SQ1/HCRmS0K7JJrPTe5zjHbMimkMR9//oq8nxlaS1TrdqFuBY07GPiW3nzWYltR2OqZ5GiL3tZ3XxA6Q7VghG4nQsNQ2NhQ8VGp8YD5YWHfXL8KxE0xFXraa4835xuMWyNG+EUU1ZdwyRqwT+V0szDs6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cwiWVrDy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cwiWVrDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 770B3C43394;
	Thu, 22 Feb 2024 00:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560107;
	bh=xNK/JcTU4pJzS4+7qDHi+rYcs8LF+UN450fE3No8vo8=;
	h=Date:To:From:Subject:From;
	b=cwiWVrDyXNozQ/d/xRAd30YqsdmX8EXh9rEJuN1PXzdddCVWGyIM8gDqS/51u7FTl
	 LzD8vaHgiRcpd2pdTmBaipRjPLhRI9PIL8Oc6PZO6MAYcCkzJO40EGbIn3OXJ/N1sN
	 PCyba4fuZb+pfLx9uqRK866gN70lrFlrspnc3kIw=
Date: Wed, 21 Feb 2024 16:01:46 -0800
To: mm-commits@vger.kernel.org,ppbuk5246@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kswapd-replace-try_to_freeze-to-kthread_freezable_should_stop.patch removed from -mm tree
Message-Id: <20240222000147.770B3C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kswapd: replace try_to_freeze() with kthread_freezable_should_stop()
has been removed from the -mm tree.  Its filename was
     kswapd-replace-try_to_freeze-to-kthread_freezable_should_stop.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


