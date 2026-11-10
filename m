Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794293105;
	b=COyRds/3fAElQ8A8XgujWgOAEqxuQ0OtcDbgf//HTczlzok/9Iv7yB5PbdAsx00bJosh
	 AxBlf6a50jmfWC94i16AIS6cnd033EKnwkFoHrxWYkT5wQtJpbUWmugQxG8DRh/8tqaOg
	 uultZt4m8YdW9Rvx3+Cf3h3oxxSQwrbFdjP7nwlaxJya9T3xo/kY1QzJZmOwmgCzy6eWH
	 oGJbL/MbNoKM6Pk5KICyNvWdENJzTai0TeVAy7ZFzGw/m9wQhp0FWDx3eDwIFsHNgo/G7
	 3cZe2air0SJ+rlIms9yLIwAvVrNTwudbM3iAy7LddIb58/s6cguoyhEObQAws3D4hdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794293105;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=S58tf/jAxFi+VXZl7vSQovGhIoE4bWl4uFVFcrKkgJE=;
	b=ovKGK5IQosQMHVFCsCEZ2GRw5ekAMMRInUnxbpVkhvnqPVwWr/vAhdJU2SAhixDJfhXr
	 XaRAbkCuJrrhqWEvWgXWU3VFLyFBYy0NaMwSo9o0hEHvv+M2Etmmlvo4RlGG9HUqDmTrq
	 +rBKVm79yqUMoa2Oj1hNWVVuFgQcrdXG6E1inivBlbH9EFvl7wyzb7+rwtF9qgqSqXBoM
	 pp6vBvMN2KJ0zVoMYw/DAPnXUUlQCdNyWGifwNWPUCZTCxTYYfXBwhfSGmWFLEq9FFE+5
	 9xoVqk3ig0xwyXEzjoofjOQw061fqJbFgNX+wth/lZsmiSkyKVe/HTaLWbumExBH9wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=i+ekGCXv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89632606BD58;
	Tue, 10 Nov 2026 06:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=i+ekGCXv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51DBD1F008A5;
	Tue, 10 Nov 2026 06:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794293105;
	bh=S58tf/jAxFi+VXZl7vSQovGhIoE4bWl4uFVFcrKkgJE=;
	h=Date:To:From:Subject;
	b=i+ekGCXvd3cPayxkc7yueIB5n6nPm/c46Enp/tGPdCOFQa6DngOWnjfqw5rCRowcO
	 /H1T+Po54UZ13y3KFs8a0T4G2szKo3Euc4VyThzcKcayO0Xh+P/mbb+vTYTQPxEubm
	 GkFj9DYY4vYgBxLz9eiwDLh6fkfg5cG7esjUMDaY=
Date: Mon, 09 Nov 2026 22:45:04 -0800
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,tz2294@columbia.edu,
	stable@vger.kernel.org,shikemeng@huaweicloud.com,ryncsn@gmail.com,
	nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,
	baohua@kernel.org,mt4022@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-swap-stop-cluster-list-scans-once-swapoff-clears-swp_writeok.patch removed from -mm tree
Message-Id: <20261110064505.51DBD1F008A5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm, swap: stop cluster list scans once swapoff clears SWP_WRITEOK
has been removed from the -mm tree.  Its filename was
     mm-swap-stop-cluster-list-scans-once-swapoff-clears-swp_writeok.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mani Tofigh <mt4022@columbia.edu>
Subject: mm, swap: stop cluster list scans once swapoff clears SWP_WRITEOK
Date: Mon, 26 Oct 2026 11:19:22 -0400

SWP_WRITEOK is cleared under si->lock when swapoff starts so that no
new swap entries are allocated from the device, and try_to_unuse()
then waits for writeback of the folios that still use the device.

However, an order-0 allocation that chose the device can race with
swapoff clearing the flag and then loop forever.  It takes a cluster
from the fragment cluster list of a higher order with
isolate_lock_cluster(), the allocation from that cluster fails because
SWP_WRITEOK is clear, and relocate_cluster() puts the cluster back on
the same list, so the loop keeps finding clusters on it.

The looping task is in reclaim, and it may have set writeback on a
folio whose write has been queued but not yet submitted.  swapoff then
waits for that folio, while the reclaiming task, stuck in the loop,
never reaches the point where it submits the write:

  CPU0 (reclaim)                          CPU1 (swapoff)
  --------------                          --------------
  shrink_folio_list()
    pageout(F)
      /* F under writeback,
         write not submitted */
    folio_alloc_swap(G)  /* order 0 */
      swap_alloc_slow()
                                          del_from_avail_list(si, true)
                                            si->flags &= ~SWP_WRITEOK
                                          try_to_unuse()
                                            folio_wait_writeback(F)
        cluster_alloc_swap_entry()
          isolate_lock_cluster()
          /* allocation fails:
             !SWP_WRITEOK */
          relocate_cluster()
          /* repeats forever */
    swap_write_submit()
    /* never reached */

This results in a soft lockup on CPU0 and a swapoff that never returns.

isolate_lock_cluster() used to check SWP_WRITEOK under si->lock until
commit 07adc4cf1ecd ("mm, swap: implement dynamic allocation of swap
table") removed that check.  Restore the check.  Since swapoff clears
the flag under the same lock, isolate_lock_cluster() then returns NULL,
which ends the scan; the swap slot allocation for G fails, and reclaim
goes on to submit the write of F.

Given that this is a race, its reproducibility is non-deterministic.
We reproduce it by using a non-rotational swap device that is not
synchronous, with 64K mTHP enabled, where one CPU repeatedly pages out
two 64K folios and a 4K page with madvise(MADV_PAGEOUT), while other
CPUs run swapoff and swapon on the same device.  In my tests it
triggers within 20s in each run, and with the fix applied, it runs for
300s without any hang/kernel report.  This bug was found and
reproduced deterministically using a deterministic hypervisor that is
currently under development.

Link: https://lore.kernel.org/20261026-swapoff-writeok-v1-1-4f4cd420aa33@columbia.edu
Fixes: 07adc4cf1ecd ("mm, swap: implement dynamic allocation of swap table")
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Kairui Song <kasong@tencent.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Tal Zussman <tz2294@columbia.edu>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/swapfile.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/swapfile.c~mm-swap-stop-cluster-list-scans-once-swapoff-clears-swp_writeok
+++ a/mm/swapfile.c
@@ -635,6 +635,10 @@ static struct swap_cluster_info *isolate
 	u8 flags = CLUSTER_FLAG_NONE;
 
 	spin_lock(&si->lock);
+
+	if (unlikely(!(si->flags & SWP_WRITEOK)))
+		goto out;
+
 	list_for_each_entry(ci, list, list) {
 		if (!spin_trylock(&ci->lock))
 			continue;
@@ -650,6 +654,7 @@ static struct swap_cluster_info *isolate
 		found = ci;
 		break;
 	}
+out:
 	spin_unlock(&si->lock);
 
 	/* Cluster's table is freed when and only when it's on the free list. */
_

Patches currently in -mm which might be from mt4022@columbia.edu are

mm-shmem-fix-swapin-livelock-on-a-mismatched-large-swap-cache-folio.patch
mm-swapfile-drop-a-large-unmapped-swap-in-folio-in-unuse_pte.patch

