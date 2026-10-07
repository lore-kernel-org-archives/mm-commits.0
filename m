Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01747259C80;
	Wed,  7 Oct 2026 00:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334137; cv=none; b=igxyDSDwyxfVYCQVSsc9WIKH9fRz2yrBRP/IZpEi1tf8anpmRnoXPc7nAW+H7IARLkmkaWOEf17ANQQc7Do6Q840nBAItmWONjqYCRCbYkf/NQqnDglSB3ALjhQDAnFqj6S5/trETeRRFHmpKCm7O9WbSIE1O4yVh9JbG9yXqdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334137; c=relaxed/simple;
	bh=chJQHlZKZv86zmFTUOk2yKe9FTvcZ898ws4Nu00r+w8=;
	h=Date:To:From:Subject:Message-Id; b=LyiN3iqpY7Ucp8xbuTfKp4O18fqLD8viwixptHOV4aPBBbD0tFycbsAfECy6pUR4wybLEdErGf8Ev9igzCqSh9Mo9/qzAmxwgRboR0vQ5aGHXszEY12onn/7myR4cl9q9IXNI0VzbyGY+d8+tK9tYcfPiMdDhzBpgzb3rPfJlEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=edj/DvTY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="edj/DvTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEE11F0089C;
	Wed,  7 Oct 2026 00:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334135;
	bh=0zKJTE/PCntDl2522lC1eoccwMHY1JLkvwt020qlx7I=;
	h=Date:To:From:Subject;
	b=edj/DvTY/k+sASlmUyX4OybtdLNZiJh/C04rdbUHFXDPFchIl3EmQNX5SYXkK0R8y
	 LmAIUX7BfaIH8L6knRZuqw9H2giIfd/OJq3LJ39Ntl3Y86rB6Cc4uFe16VRiYdQ3QI
	 QIc58VgZ5lIRsVUXvgSehvYrtTsb9TuhtfxIANbA=
Date: Tue, 06 Oct 2026 17:48:55 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,syzbot+ced4d9a8cadb5ef3adae@syzkaller.appspotmail.com,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,jack@suse.cz,hannes@cmpxchg.org,chrisl@kernel.org,axboe@kernel.dk,jiayuan.chen@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-fix-data-race-on-reading-jiffies_64.patch removed from -mm tree
Message-Id: <20261007004855.8CEE11F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memcontrol: fix data-race on reading jiffies_64
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-data-race-on-reading-jiffies_64.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: syzbot+ced4d9a8cadb5ef3adae@syzkaller.appspotmail.com
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
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
 
@@ -3946,7 +3946,7 @@ void mem_cgroup_flush_foreign(struct bdi
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
 	unsigned long intv = msecs_to_jiffies(dirty_expire_interval * 10);
-	u64 now = jiffies_64;
+	u64 now = get_jiffies_64();
 	int i;
 
 	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
_

Patches currently in -mm which might be from jiayuan.chen@linux.dev are


