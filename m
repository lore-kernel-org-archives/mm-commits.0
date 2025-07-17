Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508261D5CE8
	for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2025 23:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752793538; cv=none; b=SazEEZeZSgta4H3bHs9YSP4ezcQUObei0NXq/D8tYR2WOT0yZnydHFHee2F4yvQUYwVy11kJsicaMcU0NzCvSvnvpbq1PFaYgqF14vlJpsIQoGr9EUB37AXSlIFSWPOT9E91oY6R6QPoVE8wB/zbWhD0hecUfllbxrehfnmnvOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752793538; c=relaxed/simple;
	bh=ItAJrTRaoOLv52ZcW1UfDZ5BAKrB6yMfU6jOUU145hE=;
	h=Date:To:From:Subject:Message-Id; b=PKLMtDktEhFzHMVwCDKYPTekde4gEJx+b//QS5muqtIhsoX1j46VULNARa6+qJfnhVZneanKtPW8+8X9DuFqOtKklQOki7diZSGUID3yNxK3TyqO7gzu8lxv3zQnhMFpcb0XsZWAuVfOkzJJLEXi6hTg4hxFfxg63wSgkE72of0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jX5bWNMR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jX5bWNMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A439BC4CEE3;
	Thu, 17 Jul 2025 23:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752793536;
	bh=ItAJrTRaoOLv52ZcW1UfDZ5BAKrB6yMfU6jOUU145hE=;
	h=Date:To:From:Subject:From;
	b=jX5bWNMRgenddQ8w2geYuybo9tFpOCAfYR6oGuQZx+Faj1MYrJIgPS8ND4Tukc991
	 TzqKekXNQu+e6XywIeSExTowFXDPn1ZEkQO3IzCbcc2l1yvr7jXd+9Y5i8VrERN0WZ
	 hiEWmyfQA9LbZ7m0Buk4X7uV6Frc6eVCqJHXgSkI=
Date: Thu, 17 Jul 2025 16:05:36 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuzhao@google.com,yuanchu@google.com,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,kinseyho@google.com,hannes@cmpxchg.org,gthelen@google.com,david@redhat.com,axelrasmussen@google.com,jiahao1@lixiang.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-update-mg-lru-proactive-reclaim-statistics-only-to-memcg.patch added to mm-new branch
Message-Id: <20250717230536.A439BC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: update MG-LRU proactive reclaim statistics only to memcg
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-update-mg-lru-proactive-reclaim-statistics-only-to-memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-update-mg-lru-proactive-reclaim-statistics-only-to-memcg.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Hao Jia <jiahao1@lixiang.com>
Subject: mm/mglru: update MG-LRU proactive reclaim statistics only to memcg
Date: Thu, 17 Jul 2025 16:28:45 +0800

Users can use /sys/kernel/debug/lru_gen to trigger proactive memory
reclaim of a specified memcg.  Currently, statistics such as pgrefill,
pgscan and pgsteal will be updated to the /proc/vmstat system memory
statistics.

This will confuse some system memory pressure monitoring tools, making it
difficult to determine whether pgscan and pgsteal are caused by
system-level pressure or by proactive memory reclaim of some specific
memory cgroup.

Therefore, make this interface behave similarly to memory.reclaim.  Update
proactive memory reclaim statistics only to its memory cgroup.

Link: https://lkml.kernel.org/r/20250717082845.34673-1-jiahao.kernel@gmail.com
Signed-off-by: Hao Jia <jiahao1@lixiang.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kinsey Ho <kinseyho@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/vmscan.c~mm-mglru-update-mg-lru-proactive-reclaim-statistics-only-to-memcg
+++ a/mm/vmscan.c
@@ -5561,6 +5561,7 @@ static int run_cmd(char cmd, int memcg_i
 	if (memcg_id != mem_cgroup_id(memcg))
 		goto done;
 
+	sc->target_mem_cgroup = memcg;
 	lruvec = get_lruvec(memcg, nid);
 
 	if (swappiness < MIN_SWAPPINESS)
@@ -5597,6 +5598,7 @@ static ssize_t lru_gen_seq_write(struct
 		.may_swap = true,
 		.reclaim_idx = MAX_NR_ZONES - 1,
 		.gfp_mask = GFP_KERNEL,
+		.proactive = true,
 	};
 
 	buf = kvmalloc(len + 1, GFP_KERNEL);
_

Patches currently in -mm which might be from jiahao1@lixiang.com are

mm-mglru-stop-try_to_inc_min_seq-if-min_seq-has-not-increased.patch
mm-mglru-update-mg-lru-proactive-reclaim-statistics-only-to-memcg.patch

