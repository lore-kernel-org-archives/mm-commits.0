Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F97318139;
	Fri,  8 May 2026 21:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778275752; cv=none; b=Jk26V2ZDdue4eR+/kgVAvYMmZTXcpOjXxPVS8EZMf/G34E/QV/nAh4AUxjMXCJeYSRKaZnLBqBLLWqj2c/GQpf/BMgGUlXmfaG4ZM16u69kT377kc06W90nVc2X5+0VA3pwAzF8PNjwcCFqqtLgpYH6uU0meg00+c1Pn6upSnsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778275752; c=relaxed/simple;
	bh=IOVcrk9REVLC/7YFQYwiNnSAENEwg1JIY8dDdJKSs9E=;
	h=Date:To:From:Subject:Message-Id; b=YK5HcgoRMGr9av9gQJwQouxjxUwsM6RRu8BunSqk/3aQpKWWI/bd70sqU0uZARtPMb5XFd+hQ832B23QkugJoNIcDbJVm1gpwFpAoY0SsOGMfu9KmrLRBXBeIy7lEskhPuDhKi3awkzJ5pSsUqDCmytWL7fsfXnZgiguK26+MzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L118ten7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L118ten7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 101BEC2BCB0;
	Fri,  8 May 2026 21:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778275752;
	bh=IOVcrk9REVLC/7YFQYwiNnSAENEwg1JIY8dDdJKSs9E=;
	h=Date:To:From:Subject:From;
	b=L118ten7lulb7j9iDO9BtH2YD8oEAuM7ttGyA3uw14njaNziaXsyEG7FlM/Wg606N
	 BJC3LceVXSmptKkPUm0xUxZENkQL2JQ9ETGn6M7ARVIQyWKjF/2n0kAl1rduX7E8mX
	 wLhEaizkzLeBSpf/BK8+17LbfMseGkOOBz/D6rsY=
Date: Fri, 08 May 2026 14:29:11 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,stable@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kerayhuang@tencent.com,kasong@tencent.com,flyingpeng@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,albinwyang@tencent.com,huangzjsmile@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-add-cond_resched-in-swap_reclaim_full_clusters-to-prevent-softlockup.patch added to mm-new branch
Message-Id: <20260508212912.101BEC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: add cond_resched() in swap_reclaim_full_clusters to prevent softlockup
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-add-cond_resched-in-swap_reclaim_full_clusters-to-prevent-softlockup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-add-cond_resched-in-swap_reclaim_full_clusters-to-prevent-softlockup.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Zijiang Huang <huangzjsmile@gmail.com>
Subject: mm/swap: add cond_resched() in swap_reclaim_full_clusters to prevent softlockup
Date: Wed, 6 May 2026 21:09:19 +0800

We hit a real softlockup in an internal stress test environment.  The
workload was LTP memory/swap stress on a large arm64 machine, with 320
CPUs, about 1TB memory and an 8.6GB swap device.  The system was under
heavy load and the swap device had a large number of full clusters.  The
softlockup was triggered during a stress test after about 3 days.

So, add periodic cond_resched() calls during large full_clusters
reclaim operations to prevent softlockup issues.

Detailed call trace as follow:

PID: 3817773  TASK: ffff0883bb28b780  CPU: 48   COMMAND: "kworker/48:7"
   #0 [ffff800080183d10] __crash_kexec at ffffa4c1361e5de4
   #1 [ffff800080183d90] panic at ffffa4c1360d5e9c
   #2 [ffff800080183e20] watchdog_timer_fn at ffffa4c136231fa8
   ...
  #16 [ffff8000c4ad3cb0] swap_cache_del_folio at ffffa4c1363e1614
  #17 [ffff8000c4ad3ce0] __try_to_reclaim_swap at ffffa4c1363e4bfc
  #18 [ffff8000c4ad3d40] swap_reclaim_full_clusters at ffffa4c1363e5474
  #19 [ffff8000c4ad3da0] swap_reclaim_work at ffffa4c1363e550c
  #20 [ffff8000c4ad3dc0] process_one_work at ffffa4c136102edc
  #21 [ffff8000c4ad3e10] worker_thread at ffffa4c136103398
  #22 [ffff8000c4ad3e70] kthread at ffffa4c13610d95c

Link: https://lore.kernel.org/20260506130919.2298807-1-kerayhuang@tencent.com
Fixes: 5168a68eb78f ("mm, swap: avoid over reclaim of full clusters")
Signed-off-by: Zijiang Huang <kerayhuang@tencent.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Reviewed-by: albinwyang <albinwyang@tencent.com>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/swapfile.c~mm-swap-add-cond_resched-in-swap_reclaim_full_clusters-to-prevent-softlockup
+++ a/mm/swapfile.c
@@ -1054,6 +1054,7 @@ static void swap_reclaim_full_clusters(s
 		swap_cluster_unlock(ci);
 		if (to_scan <= 0)
 			break;
+		cond_resched();
 	}
 }
 
_

Patches currently in -mm which might be from huangzjsmile@gmail.com are

mm-swap-add-cond_resched-in-swap_reclaim_full_clusters-to-prevent-softlockup.patch

