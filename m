Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41590214813;
	Tue, 25 Aug 2026 01:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622323; cv=none; b=upCAngsEUD1IVIkwy/HG8MIxKEiVREFZMPE5Knq9J20VXCZ4PvXheL6rjp/LdS0ndykQLC9iJfFj2GcA5z4/RC3frjFgXvSX8pmVzQox9HzzxSLiOy0plRFqW/XKZ+olnkNLhpEQHSqbtnNFIeN2hAokC90ODMLfEuC2ULN3CmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622323; c=relaxed/simple;
	bh=16TrJwsrvWqTb+tVZzikgtmkhERQ/vK9smVELzUhb04=;
	h=Date:To:From:Subject:Message-Id; b=Wc3O4XAP3Y19wqDwX02HaXsWZELPzHskIxoVXD4kpMg/oqLBi+2WnOkG0KdEv5uvg0Y5JaLHUM69CGIeu47y647AOr/IstV2XcRulS6MvN9KKwf1xT7bHHmETlQqyobXWS3LwnsKce/bA0fh71tlyq6JkfQhMUDddUTZhFBajuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gz5b68he; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gz5b68he"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145291F000E9;
	Tue, 25 Aug 2026 01:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622322;
	bh=x+g6HcVZ/Qlt7O6WMXmsWafdffGbw8D52gp1I9qrmKk=;
	h=Date:To:From:Subject;
	b=gz5b68heghe87F8yEftKEqn/np/EF1i70EakCnFQLaiGQuelPks46ODbf4TKlHT5K
	 SetfVu4U1m8uw0WUTwI2sdIaCYNLEAb1oy6WjigtsigiHcYlTHcdOCrhtOaVUrPOcV
	 ceT05M+B+k2h6yLCg3kdJBxeMGginLdQWM2uiGus=
Date: Mon, 24 Aug 2026 18:45:21 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,cuitao@kylinos.cn,zhangguopeng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-stop-reclaim-when-a-limit-update-is-superseded.patch removed from -mm tree
Message-Id: <20260825014522.145291F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: stop reclaim when a limit update is superseded
has been removed from the -mm tree.  Its filename was
     mm-memcg-stop-reclaim-when-a-limit-update-is-superseded.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: mm: memcg: stop reclaim when a limit update is superseded
Date: Fri, 24 Jul 2026 10:18:05 +0800

kernfs serializes file operations only per open file, so separate open
files can update the same memory.high or memory.max file concurrently. 
Both handlers store the new limit before synchronous reclaim, but continue
to use the writer's local target in the reclaim loop.  If another writer
raises or removes the limit, the first writer can continue reclaiming
toward a stale target.

For memory.max, this can leave the writer looping indefinitely once
reclaim retries are exhausted.  The OOM path sees sufficient margin under
the current limit and returns true without killing, while the writer still
compares usage against its stale target and records another OOM event.

Check the current limit at the start of each reclaim iteration and stop if
it no longer matches the writer's target.

Reproducer:

Populate a cgroup with anonymous memory and disable swapping.  Lower
memory.max from one open file, then restore it to "max" through another
open file after the new limit becomes visible.

Without the patch, the first writer remains blocked and repeatedly
increments the OOM event counter.  With the patch, it returns normally.

This was not motivated by a reported production workload.  We found it
through automated randomized testing for our cgroup observability work
and reduced it to the reproducer above.

Link: https://lore.kernel.org/20260724021805.1234583-1-guopeng.zhang@linux.dev
Fixes: 8c8c383c04f6 ("mm: memcontrol: try harder to set a new memory.high")
Fixes: b6e6edcfa405 ("mm: memcontrol: reclaim and OOM kill when shrinking memory.max below usage")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Acked-by: Tao Cui <cuitao@kylinos.cn>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/memcontrol.c~mm-memcg-stop-reclaim-when-a-limit-update-is-superseded
+++ a/mm/memcontrol.c
@@ -4839,6 +4839,9 @@ static ssize_t memory_high_write(struct
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
 		unsigned long reclaimed;
 
+		if (high != READ_ONCE(memcg->memory.high))
+			break;
+
 		if (nr_pages <= high)
 			break;
 
@@ -4894,6 +4897,9 @@ static ssize_t memory_max_write(struct k
 	for (;;) {
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
 
+		if (max != READ_ONCE(memcg->memory.max))
+			break;
+
 		if (nr_pages <= max)
 			break;
 
_

Patches currently in -mm which might be from zhangguopeng@kylinos.cn are


