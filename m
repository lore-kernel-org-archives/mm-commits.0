Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF715BAFC;
	Tue, 23 Jan 2024 00:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970475; cv=none; b=cNkh2PlQUtghhHzLScYszT93Qbp0NR8X0BOPWtkqqE++BsTSOPfMXyxWVzk+DE5dzkUP8nAXp5GtZVzU9qBZnkZyaZPmH3k8AGCT+VYg+c8iYBuQBcQa5YszO9rJW4X8niSgAeMRXyEwOGEGR67lIzTW910PalAEJ2ekMRu3BRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970475; c=relaxed/simple;
	bh=mTM28tfU7sJ6G7/wpfJjg6i8xRSAKb06EWY2zBt7bes=;
	h=Date:To:From:Subject:Message-Id; b=SPeDSw5E1VCCOaGaI+JL8tEtOwejpfR7cFlGhJxrCZJJm6z4mMiKam08vsg5WDq4iHtTYfqeaB0ncKoBRjj6QuVM3Kx/d9ua2J5ezTR6lDxQzsVSOZU9+0HACy+3d88UdxJ8pH4Vn+zgYhHP2+mslpWJ3/zOFEaGzQDgzMYaNRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hq1NIcDe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hq1NIcDe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E63C433F1;
	Tue, 23 Jan 2024 00:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970474;
	bh=mTM28tfU7sJ6G7/wpfJjg6i8xRSAKb06EWY2zBt7bes=;
	h=Date:To:From:Subject:From;
	b=Hq1NIcDeodBZLWtDI0+wh/BN1lvNmX8VEhIQ46EJtAww86H5Z8cH+PodXjtiP2tTi
	 3jGGI+ZhwIV/9453pCf4Bws0ujrq8fdKCcotrz858K49c9qtZTtxuIfShUH7UU2utO
	 jc0t6Dn3ssWPXv7Lck0VQILQUDaEmoWnaXCGasPs=
Date: Mon, 22 Jan 2024 16:41:10 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yangyifei03@kuaishou.com,stable@vger.kernel.org,shakeelb@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,tjmercier@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-mm-vmscan-fix-inaccurate-reclaim-during-proactive-reclaim.patch added to mm-hotfixes-unstable branch
Message-Id: <20240123004113.D0E63C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Revert "mm:vmscan: fix inaccurate reclaim during proactive reclaim"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     revert-mm-vmscan-fix-inaccurate-reclaim-during-proactive-reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-mm-vmscan-fix-inaccurate-reclaim-during-proactive-reclaim.patch

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
From: "T.J. Mercier" <tjmercier@google.com>
Subject: Revert "mm:vmscan: fix inaccurate reclaim during proactive reclaim"
Date: Sun, 21 Jan 2024 21:44:12 +0000

This reverts commit 0388536ac29104a478c79b3869541524caec28eb.

Proactive reclaim on the root cgroup is 10x slower after this patch when
MGLRU is enabled, and completion times for proactive reclaim on much
smaller non-root cgroups take ~30% longer (with or without MGLRU).  With
root reclaim before the patch, I observe average reclaim rates of ~70k
pages/sec before try_to_free_mem_cgroup_pages starts to fail and the
nr_retries counter starts to decrement, eventually ending the proactive
reclaim attempt.  After the patch the reclaim rate is consistently ~6.6k
pages/sec due to the reduced nr_pages value causing scan aborts as soon as
SWAP_CLUSTER_MAX pages are reclaimed.  The proactive reclaim doesn't
complete after several minutes because try_to_free_mem_cgroup_pages is
still capable of reclaiming pages in tiny SWAP_CLUSTER_MAX page chunks and
nr_retries is never decremented.

The docs for memory.reclaim say, "the kernel can over or under reclaim
from the target cgroup" which this patch was trying to fix.  Revert it
until a less costly solution is found.

Link: https://lkml.kernel.org/r/20240121214413.833776-1-tjmercier@google.com
Fixes: 0388536ac291 ("mm:vmscan: fix inaccurate reclaim during proactive reclaim")
Signed-off-by: T.J. Mercier <tjmercier@google.com>
Cc: Efly Young <yangyifei03@kuaishou.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: T.J. Mercier <tjmercier@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~revert-mm-vmscan-fix-inaccurate-reclaim-during-proactive-reclaim
+++ a/mm/memcontrol.c
@@ -6977,8 +6977,8 @@ static ssize_t memory_reclaim(struct ker
 			lru_add_drain_all();
 
 		reclaimed = try_to_free_mem_cgroup_pages(memcg,
-					min(nr_to_reclaim - nr_reclaimed, SWAP_CLUSTER_MAX),
-					GFP_KERNEL, reclaim_options);
+						nr_to_reclaim - nr_reclaimed,
+						GFP_KERNEL, reclaim_options);
 
 		if (!reclaimed && !nr_retries--)
 			return -EAGAIN;
_

Patches currently in -mm which might be from tjmercier@google.com are

revert-mm-vmscan-fix-inaccurate-reclaim-during-proactive-reclaim.patch

