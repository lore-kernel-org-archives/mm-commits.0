Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DC531B80D;
	Thu, 30 Jul 2026 00:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785371081; cv=none; b=jtTeB4zK30d+ZOn2IVZ0DBo0hurw07tv4VMFS8cTWWoaP84SK6jIjlbGEMKRN0tAjv7+1VHw7o8kquxBpEu9ALejEZcMMnwjp+dTsqPbEpp/ax3eSA8jWDxEDXFIYcdIFk29IJ68qxV7Onm8QMFlSLAAC2UAv5/L578mrWhEypc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785371081; c=relaxed/simple;
	bh=bJ5ZW7xrKA9uNAr4sK2vTeKV/lGiAcfAf0LRTWr8r6A=;
	h=Date:To:From:Subject:Message-Id; b=W4GzDzwNNyyn9oIzXl/NlV5bdr0kQ+GFtxgvQR6k6sDswxKAn4QXzDsiHXu8gSd25SLvBnDAS8bv0pd0LscgabatLKgydgsXOt30aWfGZVRRUz01wsGNo2T5F9x8NCWCbuehsJnl8KPfNn6hVHmliFlTqEtq7UrPubLlEB8JNHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QuFJPmZk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QuFJPmZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EF81F000E9;
	Thu, 30 Jul 2026 00:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785371078;
	bh=rRv/S3Sbj0opclt0+XhfzbdSKG4TFazMdJynnbsH9P4=;
	h=Date:To:From:Subject;
	b=QuFJPmZkLgfx3/0FVl3pVKTtZYjZ/hq+NR2gLU851uuNgjaz1+2aGjmMnMDNwM6x/
	 asXlQ7jSELBTpDOr+eBYvRZLrk/CIXsjDf4arM1VPkrVsTkGAzInr50SmH+VntIDQY
	 fUmgsM05y70h6z5Z5TB/Y6YSYm8+XpncvL9P3Ztc=
Date: Wed, 29 Jul 2026 17:24:37 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,cuitao@kylinos.cn,zhangguopeng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-memcg-stop-reclaim-when-a-limit-update-is-superseded.patch removed from -mm tree
Message-Id: <20260730002437.E3EF81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: stop reclaim when a limit update is superseded
has been removed from the -mm tree.  Its filename was
     mm-memcg-stop-reclaim-when-a-limit-update-is-superseded.patch

This patch was dropped because it was nacked

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
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/memcontrol.c~mm-memcg-stop-reclaim-when-a-limit-update-is-superseded
+++ a/mm/memcontrol.c
@@ -4837,6 +4837,9 @@ static ssize_t memory_high_write(struct
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
 		unsigned long reclaimed;
 
+		if (high != READ_ONCE(memcg->memory.high))
+			break;
+
 		if (nr_pages <= high)
 			break;
 
@@ -4892,6 +4895,9 @@ static ssize_t memory_max_write(struct k
 	for (;;) {
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
 
+		if (max != READ_ONCE(memcg->memory.max))
+			break;
+
 		if (nr_pages <= max)
 			break;
 
_

Patches currently in -mm which might be from zhangguopeng@kylinos.cn are

mm-memcontrol-update-state_local-when-flushing-nmi-stats.patch
mm-memcg-v1-account-vmpressure-event-allocations.patch
mm-memcg-v1-fix-wrong-linux-mm-list-address-in-deprecation-warnings.patch
mm-memcontrol-drop-unused-cpu-argument-from-flush_nmi_stats.patch
mm-memcontrol-factor-out-memcg-kmem-uncharge-sequence.patch
mm-memcg-v1-make-mem_cgroup_oom_notify_cb-return-void.patch

