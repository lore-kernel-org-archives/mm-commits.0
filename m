Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463841C683;
	Fri, 10 Jan 2025 00:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736470290; cv=none; b=DrOplfcuu6vGRTzaJietJK9YQi2zYewLe0UOAGBUR20hewFaToOaN9fQE0t9PPR2KBUAwu4Hgn6wtwPYJfDfBGFOTJD/EljQjlyHJ2Jd8T0CZa+rXX+MrQEGdKLXqxirZK/IbO23metSB8seZnXCxiQdy2OQge1ZkloUGb/VXkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736470290; c=relaxed/simple;
	bh=5WDyKzA9a1kFVJ2d4N6Loo/bX4Lg8NURQ4VuI4zRmFo=;
	h=Date:To:From:Subject:Message-Id; b=D9dmVxmjPUoshcfyAc5yefLgLjwgFPAtqTdRI6wApN20ca5KQ1M3gaFjZ/I5uxHV6XSQNfaWaMhWZ3MsPj/41UwtxynAQl8u0P+bGHINH7uc2H8Ey10EE19d0kL8J+MF1SRHxo49ZfWNDIiunVNjkoav0ffJHG4Mtp51DxYvgcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZIoaJB+8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZIoaJB+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB181C4CED2;
	Fri, 10 Jan 2025 00:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736470289;
	bh=5WDyKzA9a1kFVJ2d4N6Loo/bX4Lg8NURQ4VuI4zRmFo=;
	h=Date:To:From:Subject:From;
	b=ZIoaJB+8k2xTuVyVYBay288R9uXbCrxNcJysnNtNQxHWxC0O5Hkg2gKLHFDvCJX3k
	 wBwg4T2LvDx6KbshyAQ1bf60WquIsKfdo4VIn75l6SdyqhyQWfBL/MZSwMMen0MbLL
	 8CpHa01EzXXVXJxO9QBd4UrcnOKM8GXMkPdVmOcs=
Date: Thu, 09 Jan 2025 16:51:29 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,weixugc@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,ritesh.list@gmail.com,rientjes@google.com,muchun.song@linux.dev,mhocko@kernel.org,kaiyang2@cs.cmu.edu,hannes@cmpxchg.org,aneesh.kumar@kernel.org,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-pgdemote-vmstat-is-not-getting-updated-when-mglru-is-enabled.patch added to mm-hotfixes-unstable branch
Message-Id: <20250110005129.AB181C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan : pgdemote vmstat is not getting updated when MGLRU is enabled.
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmscan-pgdemote-vmstat-is-not-getting-updated-when-mglru-is-enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-pgdemote-vmstat-is-not-getting-updated-when-mglru-is-enabled.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Donet Tom <donettom@linux.ibm.com>
Subject: mm: vmscan : pgdemote vmstat is not getting updated when MGLRU is enabled.
Date: Thu, 9 Jan 2025 00:05:39 -0600

When MGLRU is enabled, the pgdemote_kswapd, pgdemote_direct, and
pgdemote_khugepaged stats in vmstat are not being updated.

Commit f77f0c751478 ("mm,memcg: provide per-cgroup counters for NUMA
balancing operations") moved the pgdemote vmstat update from
demote_folio_list() to shrink_inactive_list(), which is in the normal LRU
path.  As a result, the pgdemote stats are updated correctly for the
normal LRU but not for MGLRU.

To address this, we have added the pgdemote stat update in the
evict_folios() function, which is in the MGLRU path.  With this patch, the
pgdemote stats will now be updated correctly when MGLRU is enabled.

Without this patch vmstat output when MGLRU is enabled
======================================================
pgdemote_kswapd 0
pgdemote_direct 0
pgdemote_khugepaged 0

With this patch vmstat output when MGLRU is enabled
===================================================
pgdemote_kswapd 43234
pgdemote_direct 4691
pgdemote_khugepaged 0

Link: https://lkml.kernel.org/r/20250109060540.451261-1-donettom@linux.ibm.com
Fixes: f77f0c751478 ("mm,memcg: provide per-cgroup counters for NUMA balancing operations")
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Acked-by: Yu Zhao <yuzhao@google.com>
Cc: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/vmscan.c~mm-vmscan-pgdemote-vmstat-is-not-getting-updated-when-mglru-is-enabled
+++ a/mm/vmscan.c
@@ -4646,6 +4646,9 @@ retry:
 		reset_batch_size(walk);
 	}
 
+	__mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(),
+					stat.nr_demoted);
+
 	item = PGSTEAL_KSWAPD + reclaimer_offset();
 	if (!cgroup_reclaim(sc))
 		__count_vm_events(item, reclaimed);
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

mm-vmscan-pgdemote-vmstat-is-not-getting-updated-when-mglru-is-enabled.patch
mm-migrate-removed-unused-argument-vma-from-migrate_misplaced_folio.patch
selftests-mm-added-new-test-cases-to-the-migration-test.patch

