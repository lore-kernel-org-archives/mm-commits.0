Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793322953;
	b=5i6esp0gFO5Vj6jjFgrG6nXCrMaltd6rR2dtfLuV3RkrZy+ZcU0J5geZj5DhCf4nlQqO
	 aD96HhAGlrymJSpXXoFvd+ZWQJ+nqGKs6YXTlh3Dd9R6z3zUxg3FabOn8xvk/rbu54uUi
	 tY1ohCFUP+Aye2Ea9WGE7BQRV4QDyANahrIIMN/e5LDjXtbkorOBQnXweVSqzCL5OsHrT
	 5n2omhFeJoLglghySQVH7eJbhERwVgHqs8H3q8zAmKLOLvdc5VVlBMIi64+4rzHIO4TIB
	 WE4+s+fS8WLymrHWiQzEw6xJFIDJOEf88dG87STepQdlikM8z9c78R24QIOLA+kqApw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793322953;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=HRHzK34BRXV7rBKOPEgJ6hE2eKk3q4OrZtvOz+9Ps9o=;
	b=XgfOIyH2lZ09QfOPkthEmQdLhuh/pC5WKDFKStvW5tr5de5WuqOmX3dayvKiUKsO0+2g
	 SO6JQ1SBT63C4A57hD/JKbOeGyixiOVEGQxcIrOW7w+UN2Pbl6b3snv0dy+9HwfvlFZ8O
	 L5HmQbdnQiGzB5ZsfSi20pACjAhsBmgy3CW8C77/fSNkx+w/8hya57yPjviFQloLZv9SI
	 zNRWr+5/jK7J9X1TUvWKzFkYZ8vk1KhUTAecWiUb2g8cSQMDTLyrQnVgovEoNvsJICovY
	 IY0LzbBC9XMzWKHsUTfkty1aPpw+7Z2dWbRrpojaizQP9sNWUncQ+Z+sFminQCX6SyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=TxY85s89;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB62606A31A;
	Fri, 30 Oct 2026 01:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=TxY85s89
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2B11F000C1;
	Fri, 30 Oct 2026 01:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793322952;
	bh=HRHzK34BRXV7rBKOPEgJ6hE2eKk3q4OrZtvOz+9Ps9o=;
	h=Date:To:From:Subject;
	b=TxY85s89DMRZpjRn+kkgqvNEBXIoyRt3V6wtEZCCMLfxOI4BrCbw4rET7enx/uDGi
	 rvY+wb6+neIv0UB3GnMsQ+g8UwLV5KjbpTG1suYtjgO6W6CTTKENFtT+4gIqMn5zq5
	 HG9rAxhfeeERF8fL/iflwilkut6CGB+UkN2n1fJs=
Date: Thu, 29 Oct 2026 18:15:52 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,tz2294@columbia.edu,
	stable@vger.kernel.org,shikemeng@huaweicloud.com,ryncsn@gmail.com,
	nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,
	baohua@kernel.org,mt4022@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-stop-cluster-list-scans-once-swapoff-clears-swp_writeok.patch added to mm-hotfixes-unstable branch
Message-Id: <20261030011552.AF2B11F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm, swap: stop cluster list scans once swapoff clears SWP_WRITEOK
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swap-stop-cluster-list-scans-once-swapoff-clears-swp_writeok.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-stop-cluster-list-scans-once-swapoff-clears-swp_writeok.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-swap-stop-cluster-list-scans-once-swapoff-clears-swp_writeok.patch

