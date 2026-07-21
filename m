Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82FD845DF5F
	for <mm-commits@vger.kernel.org>; Tue, 21 Jul 2026 23:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784678280; cv=none; b=BtZPgdPWqqTbdpGEDWdG+30IPgevxJqeizvEIUDhB5OLOw+Ej7R1IllRgOl5myCvzVZCcSPw1U3Sg9ZRoOTdC/0Rfsd6oRuaf32uq9F4ZBbTLZj6TI69W3vXT7gh76SRnokpdQQgjbAw18/EZEpkNUJJHJgT3tILW9hSyuSpP3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784678280; c=relaxed/simple;
	bh=+h03zDxl/3ElDvshBg1zUHzXwJb+RTe4RTWiLLq2nmI=;
	h=Date:To:From:Subject:Message-Id; b=eOpW8Ys6lhC0Qbk+UI+TsJLfdwE7XI0MsbxqWnPAYSVPs+GhElYCGXDPWTIuol4L8/l3h2dL5ZcikhNW/q9pOoGZ+a/tLJe5j2wVWfyn1y/2jybnP+/wTzQqC52zneqCgotfclhAbNamrP1/tomRP+Kwe7WOfsCyhBXwT5zb1/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WMWtiJik; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WMWtiJik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1471F000E9;
	Tue, 21 Jul 2026 23:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784678278;
	bh=ZYK6Rwr0s9SllQNpRih8MyKastT3HTMemLWKka70d7s=;
	h=Date:To:From:Subject;
	b=WMWtiJikK71oreDAtlE87t8hTr6/UMjV/V+V9WaPOwJ61xP3HFRganNMdL7PbmxQR
	 qpRKLAbzIbM7L7nhKZybRHVQslOWVlTmMvquMs5Kq1iwchNBXzIX/gT0KphAzJqC9y
	 hhSXRQMTTnivNyVk33dsHkYpmciJxvDA3IrOUWTM=
Date: Tue, 21 Jul 2026 16:57:58 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,tjmercier@google.com,surenb@google.com,shakeel.butt@linux.dev,oleg@redhat.com,minchan@kernel.org,mhocko@suse.com,ljs@kernel.org,liumartin@google.com,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,richardycc@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-abort-proactive-reclaim-early-when-freezing-for-suspend.patch added to mm-hotfixes-unstable branch
Message-Id: <20260721235758.DC1471F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: abort proactive reclaim early when freezing for suspend
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmscan-abort-proactive-reclaim-early-when-freezing-for-suspend.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-abort-proactive-reclaim-early-when-freezing-for-suspend.patch

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
From: Richard Chang <richardycc@google.com>
Subject: mm: vmscan: abort proactive reclaim early when freezing for suspend
Date: Mon, 20 Jul 2026 04:41:03 +0000

Proactive reclaim (triggered via memory.reclaim or node sysfs) checks for
pending signals in its outer loop in user_proactive_reclaim().  However,
the inner reclaim loops—specifically scanning cgroups in shrink_many()
and evicting/aging folios in try_to_shrink_lruvec()—can run for a long
time before returning to the outer loop, especially on systems with many
cgroups or large memory sizes.

During system suspend, the PM freezer attempts to freeze all tasks by
sending fake signals (setting TIF_SIGPENDING).  Because the inner loops do
not check for pending signals, the proactive reclaim task can remain stuck
in kernel space for seconds, failing to enter the refrigerator in a timely
manner.  This leads to suspend failures due to freeze timeouts, a behavior
observed on Android devices.

This latency issue is specific to proactive reclaim because of its large,
user-defined reclaim targets (could be gigabytes).  Since commit
287d5fedb377 ("mm: memcg: use larger batches for proactive reclaim"),
proactive reclaim uses larger decaying batch sizes (starting at 1/4 of the
remaining target) to maintain throughput.  This keeps the task in the
inner reclaim loop for extended periods.  In contrast, reactive reclaim
(global/memcg) uses small targets (SWAP_CLUSTER_MAX, typically 32 pages),
allowing it to return to the outer loop and check signals frequently.

To fix this, add a signal_pending() check to should_abort_scan() for
proactive reclaim paths.  Since should_abort_scan() is called within the
inner scanning and eviction loops, this allows proactive reclaim to abort
early and return to the outer loop in user_proactive_reclaim().

Additionally, return -ERESTARTSYS instead of -EINTR in
user_proactive_reclaim().  When interrupted by system suspend, returning
-ERESTARTSYS allows the task to enter the refrigerator and automatically
restart the syscall upon resume, making the freezer transparent to
userspace.  For real signals, the signal layer will either restart the
syscall (if SA_RESTART is set) or return -EINTR to userspace.

This fix specifically targets Multi-Gen LRU (MGLRU).  Classic LRU's scan
targets per iteration are strictly bounded by get_scan_count(), which
ensures it returns to the outer loop more frequently.

The check in should_abort_scan() is limited to proactive reclaim
(sc->proactive) to avoid inadvertently affecting reactive reclaim paths,
and is wrapped in unlikely() as it is a slow path.

Link: https://lore.kernel.org/20260720044103.905191-1-richardycc@google.com
Fixes: 287d5fedb377 ("mm: memcg: use larger batches for proactive reclaim")
Fixes: 94968384dde1 ("memcg: introduce per-memcg reclaim interface")
Suggested-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Richard Chang <richardycc@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Martin Liu <liumartin@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: T.J. Mercier <tjmercier@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-abort-proactive-reclaim-early-when-freezing-for-suspend
+++ a/mm/vmscan.c
@@ -4926,6 +4926,9 @@ static bool should_abort_scan(struct lru
 	int i;
 	enum zone_watermarks mark;
 
+	if (unlikely(sc->proactive && signal_pending(current)))
+		return true;
+
 	if (sc->nr_reclaimed >= max(sc->nr_to_reclaim, compact_gap(sc->order)))
 		return true;
 
@@ -7906,8 +7909,15 @@ int user_proactive_reclaim(char *buf,
 		unsigned long batch_size = (nr_to_reclaim - nr_reclaimed) / 4;
 		unsigned long reclaimed;
 
+		/*
+		 * Return -ERESTARTSYS to allow the freezer to interrupt the
+		 * task. The syscall will be transparently restarted upon
+		 * resume. For real signals, it either restarts the syscall
+		 * (if SA_RESTART is set) or is converted to -EINTR by the
+		 * signal layer.
+		 */
 		if (signal_pending(current))
-			return -EINTR;
+			return -ERESTARTSYS;
 
 		/*
 		 * This is the final attempt, drain percpu lru caches in the
_

Patches currently in -mm which might be from richardycc@google.com are

mm-vmscan-abort-proactive-reclaim-early-when-freezing-for-suspend.patch

