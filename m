Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00121352C2C;
	Thu, 27 Aug 2026 04:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787804742; cv=none; b=idzh5MCjwhcnKLrO1DAiWARIlXb4oLg0i4qIEGjV9eruQv22Fl+KpwzKQBvSaoOq0cAFE6yJU+5F3OrwzxslS79BHPKKplBQaYxQP1M+OqiZkWVxh5YA4Jo17mWl0loIiTT/jPOTKZWBu1+klDLEwdv10afvJVP6Pt9I6Uku4Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787804742; c=relaxed/simple;
	bh=S4gIC7u/uzmZLmpF2n5rI4ZBaxdETUjdIl2flvKmpts=;
	h=Date:To:From:Subject:Message-Id; b=g4Rw9qGn6wAJh46jDg0j5n3iD/e0ROm9AbaDdhDp03bz0aGEjbUxBuBmAyg24rdtBih2rNlTRvyPSGzlIQNNn/xcwe9HBZMfK7nF4LkPflglgbkWvJaM/6MiEzTHvjdF9fRU8y8T8nM0b8sK7ODJzPYX2vXRL8s5Bbd05p3ZWGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UFdD+MDG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UFdD+MDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7443C1F000E9;
	Thu, 27 Aug 2026 04:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787804740;
	bh=S/IhDVHuOTwId84+kS4Q8mhDt0VodsSuMZHgvXkNMyE=;
	h=Date:To:From:Subject;
	b=UFdD+MDGfOvtUgOS2Es6/F0/W8Oko5f440lkkmCzypCoTVXyp9OOTbb/mp8aFHAYZ
	 fFPDtTTiHxBlZXs2zeTpA1JawEt9UZmyLieJBKw17e8TSuNEZhuiL8cpV4CCThSZcX
	 pELWPB1M1mpENbL7quis+3FApuSYAaTwW2W2Iao4=
Date: Wed, 26 Aug 2026 21:25:40 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,jack@suse.cz,hannes@cmpxchg.org,chrisl@kernel.org,axboe@kernel.dk,jiayuan.chen@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-fix-data-race-on-reading-jiffies_64.patch added to mm-new branch
Message-Id: <20260827042540.7443C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memcontrol: fix data-race on reading jiffies_64
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-fix-data-race-on-reading-jiffies_64.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-fix-data-race-on-reading-jiffies_64.patch

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
From: Jiayuan Chen <jiayuan.chen@linux.dev>
Subject: mm/memcontrol: fix data-race on reading jiffies_64
Date: Thu, 27 Aug 2026 10:54:56 +0800

KCSAN reported a data-race between tick_do_update_jiffies64() updating
jiffies_64 and mem_cgroup_flush_stats_ratelimited() reading it directly.

Unlike jiffies, jiffies_64 is not volatile, so raw reads are plain
accesses and can even be torn on 32-bit.  Use get_jiffies_64() instead,
and fix the same pattern in mem_cgroup_flush_foreign().

Link: https://lore.kernel.org/20260827025457.116191-1-jiayuan.chen@linux.dev
Fixes: 508bed884767 ("mm: memcg: change flush_next_time to flush_last_time")
Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reported-by: syzbot+ced4d9a8cadb5ef3adae@syzkaller.appspotmail.com
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-data-race-on-reading-jiffies_64
+++ a/mm/memcontrol.c
@@ -757,7 +757,7 @@ static void __mem_cgroup_flush_stats(str
 		return;
 
 	if (mem_cgroup_is_root(memcg))
-		WRITE_ONCE(flush_last_time, jiffies_64);
+		WRITE_ONCE(flush_last_time, get_jiffies_64());
 
 	css_rstat_flush(&memcg->css);
 }
@@ -785,7 +785,7 @@ void mem_cgroup_flush_stats(struct mem_c
 void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg)
 {
 	/* Only flush if the periodic flusher is one full cycle late */
-	if (time_after64(jiffies_64, READ_ONCE(flush_last_time) + 2*FLUSH_TIME))
+	if (time_after64(get_jiffies_64(), READ_ONCE(flush_last_time) + 2 * FLUSH_TIME))
 		mem_cgroup_flush_stats(memcg);
 }
 
@@ -3945,7 +3945,7 @@ void mem_cgroup_flush_foreign(struct bdi
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
 	unsigned long intv = msecs_to_jiffies(dirty_expire_interval * 10);
-	u64 now = jiffies_64;
+	u64 now = get_jiffies_64();
 	int i;
 
 	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
_

Patches currently in -mm which might be from jiayuan.chen@linux.dev are

mm-memcontrol-fix-data-race-on-reading-jiffies_64.patch

